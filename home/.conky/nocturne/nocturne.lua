--==============================================================================
--  nocturne.lua — painel de sistema para conky, desenhado em cairo
--
--  Lê quase tudo direto de /proc e /sys; o que é lento (IP externo, Wi-Fi,
--  df) vem do slow.sh, rodado em background. Só a lista de processos usa
--  conky_parse (${top ...}).
--==============================================================================

require 'cairo'
require 'cairo_xlib'

local DIR   = os.getenv('HOME') .. '/.conky/nocturne'
local STATE = '/tmp/conky-nocturne-' .. (os.getenv('USER') or 'user')

local W    = 340   -- largura do painel
local PAD  = 18    -- margem interna dos cards
local GAP  = 8     -- espaço entre cards
local HIST = 60    -- amostras (segundos) nos gráficos

------------------------------------------------------------------------------
-- Paleta e fontes
------------------------------------------------------------------------------
local function hex(s, a)
    local r, g, b = s:match('#(%x%x)(%x%x)(%x%x)')
    return { tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, a or 1 }
end

local C = {
    card   = hex('#101217'),
    border = hex('#1b1e25'),
    track  = hex('#1f232b'),
    grid   = hex('#262a33'),
    text1  = hex('#e8eaed'),
    text2  = hex('#a1a7b0'),
    text3  = hex('#626976'),
    cpu    = hex('#2dd4bf'),
    gpu    = hex('#e879f9'),
    mem    = hex('#a78bfa'),
    disk   = hex('#fbbf24'),
    down   = hex('#60a5fa'),
    up     = hex('#f472b6'),
    ok     = hex('#34d399'),
    warn   = hex('#fbbf24'),
    crit   = hex('#f87171'),
}

local F_THIN = 'Cantarell Thin'
local F_LIGHT = 'Ubuntu Light'
local F_REG = 'Ubuntu'
local F_MED = 'Ubuntu Medium'

------------------------------------------------------------------------------
-- Utilidades
------------------------------------------------------------------------------
local function clamp(v, lo, hi) return math.max(lo or 0, math.min(hi or 1, v)) end

local function slurp(path)
    local f = io.open(path)
    if not f then return nil end
    local s = f:read('a')
    f:close()
    return s
end

local function num(path) return tonumber((slurp(path) or ''):match('[%d%.%-]+')) end

local function trim(s) return (s or ''):match('^%s*(.-)%s*$') end

local function fmt_bytes(b, dec)
    local u = { 'B', 'KiB', 'MiB', 'GiB', 'TiB' }
    local i = 1
    while b >= 1024 and i < #u do b = b / 1024; i = i + 1 end
    if i == 1 then return string.format('%.0f B', b) end
    return string.format('%.' .. (dec or (b < 10 and 1 or 0)) .. 'f %s', b, u[i])
end

local function fmt_rate(b) return fmt_bytes(b) .. '/s' end

local function fmt_dur(h)
    local hh = math.floor(h)
    return string.format('%dh%02d', hh, math.floor((h - hh) * 60))
end

local function push(buf, v)
    buf[#buf + 1] = v
    if #buf > HIST then table.remove(buf, 1) end
end

local function buf_max(...)
    local m = 0
    for _, b in ipairs({ ... }) do
        for _, v in ipairs(b) do if v > m then m = v end end
    end
    return m
end

-- cor por nível (0..1): normal → atenção → crítico
local function level_color(f, base, warn_at, crit_at)
    if f >= (crit_at or 0.9) then return C.crit end
    if f >= (warn_at or 0.75) then return C.warn end
    return base or C.text1
end

local function find_hwmon(name)
    for i = 0, 20 do
        local p = '/sys/class/hwmon/hwmon' .. i
        if trim(slurp(p .. '/name')) == name then return p end
    end
end

------------------------------------------------------------------------------
-- Coleta
------------------------------------------------------------------------------
local S = {
    cpu = 0, cores = {}, hist_cpu = {},
    gpu = 0, hist_gpu = {},
    hist_rd = {}, hist_wr = {},
    hist_dn = {}, hist_upl = {},
    slow = {},
}
local prev = { cpu = {} }
local hw = {}
local static = {}
local last_slow_run, last_slow_read = -100, -100

local function init_static()
    hw.cpu  = find_hwmon('k10temp')
    hw.gpu  = find_hwmon('amdgpu')
    hw.nvme = find_hwmon('nvme')
    static.host = trim(slurp('/proc/sys/kernel/hostname'))
    static.kernel = trim(slurp('/proc/sys/kernel/osrelease')):match('^[%d%.]+') or '?'
    local osr = slurp('/etc/os-release') or ''
    local name = osr:match('\nNAME="?([^"\n]+)') or osr:match('^NAME="?([^"\n]+)') or 'Linux'
    static.distro = name:gsub(' Linux', '') .. ' ' .. (osr:match('VERSION_ID="?([^"\n]+)') or '')
    static.gpu_dev = '/sys/class/drm/card1/device'
    for i = 0, 4 do
        if io.open('/sys/class/drm/card' .. i .. '/device/gpu_busy_percent') then
            static.gpu_dev = '/sys/class/drm/card' .. i .. '/device'
            break
        end
    end
    static.disk = 'nvme0n1'
end

local function read_cpu()
    local f = io.open('/proc/stat')
    if not f then return end
    for line in f:lines() do
        local name, rest = line:match('^(cpu%d*)%s+(.*)$')
        if not name then break end
        local v = {}
        for n in rest:gmatch('%d+') do v[#v + 1] = tonumber(n) end
        local idle, tot = v[4] + v[5], 0
        for i = 1, 8 do tot = tot + (v[i] or 0) end
        local p, pct = prev.cpu[name], 0
        if p and tot > p.tot then pct = 100 * (1 - (idle - p.idle) / (tot - p.tot)) end
        prev.cpu[name] = { idle = idle, tot = tot }
        if name == 'cpu' then S.cpu = pct else S.cores[tonumber(name:sub(4)) + 1] = pct end
    end
    f:close()
    push(S.hist_cpu, S.cpu)
end

local function read_mem()
    local m = {}
    for k, v in (slurp('/proc/meminfo') or ''):gmatch('(%w+):%s+(%d+)') do m[k] = tonumber(v) * 1024 end
    S.mem_total = m.MemTotal or 1
    S.mem_used  = S.mem_total - (m.MemAvailable or 0)
    S.mem_cache = math.max(0, (m.MemAvailable or 0) - (m.MemFree or 0))
    S.swap_total = m.SwapTotal or 0
    S.swap_used  = (m.SwapTotal or 0) - (m.SwapFree or 0)
end

local function read_misc()
    local l1, l5, l15 = (slurp('/proc/loadavg') or '0 0 0'):match('(%S+) (%S+) (%S+)')
    S.load = { tonumber(l1), tonumber(l5), tonumber(l15) }
    S.uptime = num('/proc/uptime') or 0

    local bat = '/sys/class/power_supply/BAT0/'
    S.bat = num(bat .. 'capacity')
    S.bat_status = trim(slurp(bat .. 'status'))
    local en, pw, ef = num(bat .. 'energy_now'), num(bat .. 'power_now'), num(bat .. 'energy_full')
    S.bat_hours = nil
    if pw and pw > 0 and en then
        if S.bat_status == 'Discharging' then S.bat_hours = en / pw
        elseif S.bat_status == 'Charging' and ef then S.bat_hours = (ef - en) / pw end
    end

    S.cpu_temp  = hw.cpu and (num(hw.cpu .. '/temp1_input') or 0) / 1000
    S.gpu_temp  = hw.gpu and (num(hw.gpu .. '/temp1_input') or 0) / 1000
    S.nvme_temp = hw.nvme and (num(hw.nvme .. '/temp1_input') or 0) / 1000

    local g = static.gpu_dev
    S.gpu = num(g .. '/gpu_busy_percent') or 0
    S.vram_used, S.vram_total = num(g .. '/mem_info_vram_used') or 0, num(g .. '/mem_info_vram_total') or 1
    S.gtt_used = num(g .. '/mem_info_gtt_used') or 0
    push(S.hist_gpu, S.gpu)
end

local function rate(key, value, dt)
    local p = prev[key]
    prev[key] = value
    if not p or dt <= 0 or value < p then return 0 end
    return (value - p) / dt
end

local function read_io(dt)
    local ds = slurp('/proc/diskstats') or ''
    local line = ds:match('%s' .. static.disk .. '%s+([^\n]+)')
    if line then
        local v = {}
        for n in line:gmatch('%d+') do v[#v + 1] = tonumber(n) end
        S.rd = rate('rd', v[3] * 512, dt)
        S.wr = rate('wr', v[7] * 512, dt)
    end
    push(S.hist_rd, S.rd or 0)
    push(S.hist_wr, S.wr or 0)

    -- interface da rota padrão
    S.iface = nil
    for line in (slurp('/proc/net/route') or ''):gmatch('[^\n]+') do
        local ifc, dst = line:match('^(%S+)%s+(%x+)')
        if dst == '00000000' then S.iface = ifc; break end
    end
    if S.iface then
        local rx, tx = (slurp('/proc/net/dev') or ''):match(S.iface .. ':%s*(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)')
        S.rx_total, S.tx_total = tonumber(rx) or 0, tonumber(tx) or 0
        S.dn = rate('rx_' .. S.iface, S.rx_total, dt)
        S.upl = rate('tx_' .. S.iface, S.tx_total, dt)
    end
    push(S.hist_dn, S.dn or 0)
    push(S.hist_upl, S.upl or 0)
end

local function read_slow(now)
    if now - last_slow_run >= 15 then
        last_slow_run = now
        os.execute(string.format('setsid %s/slow.sh %s >/dev/null 2>&1 </dev/null &', DIR, STATE))
    end
    if now - last_slow_read >= 3 then
        last_slow_read = now
        local s = slurp(STATE)
        if s then
            local t = {}
            for k, v in s:gmatch('([%w_]+)=([^\n]*)') do t[k] = v end
            S.slow = t
        end
    end
end

local function read_lan_ip()
    -- IPv4 da interface padrão, via /proc/net/fib_trie seria trabalhoso;
    -- conky já sabe fazer isso
    if S.iface then S.lan = trim(conky_parse('${addr ' .. S.iface .. '}')) end
end

local function read_top()
    S.top_cpu, S.top_mem = {}, {}
    for i = 1, 3 do
        S.top_cpu[i] = { trim(conky_parse('${top name ' .. i .. '}')), tonumber(trim(conky_parse('${top cpu ' .. i .. '}'))) or 0 }
        S.top_mem[i] = { trim(conky_parse('${top_mem name ' .. i .. '}')), trim(conky_parse('${top_mem mem_res ' .. i .. '}')) }
    end
end

local last_t
local function sample()
    local now = num('/proc/uptime') or 0
    local dt = last_t and (now - last_t) or 1
    last_t = now
    read_cpu()
    read_mem()
    read_misc()
    read_io(dt)
    read_slow(now)
    read_lan_ip()
    read_top()
end

------------------------------------------------------------------------------
-- Primitivas de desenho
------------------------------------------------------------------------------
local cr
local ext
local fopts

local function rgba(c, a) cairo_set_source_rgba(cr, c[1], c[2], c[3], a or c[4]) end

local function font(face, size)
    cairo_select_font_face(cr, face, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(cr, size)
end

local function tw(s)
    cairo_text_extents(cr, s, ext)
    return ext.x_advance
end

-- texto com alinhamento 'l' (padrão), 'r' ou 'c'; devolve a largura
local function text(x, y, s, color, align)
    s = tostring(s)
    local w = tw(s)
    if align == 'r' then x = x - w elseif align == 'c' then x = x - w / 2 end
    rgba(color)
    cairo_move_to(cr, x, y)
    cairo_show_text(cr, s)
    return w
end

-- texto com espaçamento entre letras
local function spaced(x, y, s, color, sp)
    rgba(color)
    for ch in s:gmatch(utf8.charpattern) do
        cairo_move_to(cr, x, y)
        cairo_show_text(cr, ch)
        x = x + tw(ch) + sp
    end
    return x
end

local function rrect(x, y, w, h, r)
    r = math.min(r, h / 2, w / 2)
    cairo_new_sub_path(cr)
    cairo_arc(cr, x + w - r, y + r, r, -math.pi / 2, 0)
    cairo_arc(cr, x + w - r, y + h - r, r, 0, math.pi / 2)
    cairo_arc(cr, x + r, y + h - r, r, math.pi / 2, math.pi)
    cairo_arc(cr, x + r, y + r, r, math.pi, 3 * math.pi / 2)
    cairo_close_path(cr)
end

local function dot(x, y, r, color)
    cairo_new_path(cr)
    cairo_arc(cr, x, y, r, 0, 2 * math.pi)
    rgba(color)
    cairo_fill(cr)
end

-- seta (triângulo) para cima/baixo
local function arrow(x, y, s, color, down)
    cairo_new_path(cr)
    if down then
        cairo_move_to(cr, x - s, y - s * 0.6); cairo_line_to(cr, x + s, y - s * 0.6); cairo_line_to(cr, x, y + s * 0.6)
    else
        cairo_move_to(cr, x - s, y + s * 0.6); cairo_line_to(cr, x + s, y + s * 0.6); cairo_line_to(cr, x, y - s * 0.6)
    end
    cairo_close_path(cr)
    rgba(color)
    cairo_fill(cr)
end

local function card(y, h, accent)
    rrect(0.5, y + 0.5, W - 1, h - 1, 12)
    rgba(C.card)
    cairo_fill_preserve(cr)
    rgba(C.border)
    cairo_set_line_width(cr, 1)
    cairo_stroke(cr)
    -- filete de cor no topo do card
    if accent then
        local pat = cairo_pattern_create_linear(PAD, 0, W - PAD, 0)
        cairo_pattern_add_color_stop_rgba(pat, 0, accent[1], accent[2], accent[3], 0.0)
        cairo_pattern_add_color_stop_rgba(pat, 0.5, accent[1], accent[2], accent[3], 0.55)
        cairo_pattern_add_color_stop_rgba(pat, 1, accent[1], accent[2], accent[3], 0.0)
        cairo_set_source(cr, pat)
        cairo_rectangle(cr, PAD, y, W - 2 * PAD, 1)
        cairo_fill(cr)
        cairo_pattern_destroy(pat)
    end
end

local function bar(x, y, w, h, frac, color, track)
    rrect(x, y, w, h, h / 2)
    rgba(track or C.track)
    cairo_fill(cr)
    frac = clamp(frac)
    if frac > 0 then
        rrect(x, y, math.max(h, w * frac), h, h / 2)
        rgba(color)
        cairo_fill(cr)
    end
end

-- gráfico de área; mirror = cresce para baixo a partir de y
local function spark(x, y, w, h, buf, color, maxv, mirror)
    local n = #buf
    if n < 2 then return end
    local step = w / (HIST - 1)
    local x0 = x + w - (n - 1) * step
    local base = mirror and y or y + h
    local function py(v)
        local f = clamp(v / maxv)
        return mirror and (y + f * h) or (y + h - f * h)
    end

    cairo_new_path(cr)
    cairo_move_to(cr, x0, base)
    for i = 1, n do cairo_line_to(cr, x0 + (i - 1) * step, py(buf[i])) end
    cairo_line_to(cr, x0 + (n - 1) * step, base)
    cairo_close_path(cr)
    local pat = cairo_pattern_create_linear(0, mirror and y + h or y, 0, base)
    cairo_pattern_add_color_stop_rgba(pat, 0, color[1], color[2], color[3], 0.38)
    cairo_pattern_add_color_stop_rgba(pat, 1, color[1], color[2], color[3], 0.03)
    cairo_set_source(cr, pat)
    cairo_fill(cr)
    cairo_pattern_destroy(pat)

    cairo_new_path(cr)
    for i = 1, n do
        local px, pv = x0 + (i - 1) * step, py(buf[i])
        if i == 1 then cairo_move_to(cr, px, pv) else cairo_line_to(cr, px, pv) end
    end
    rgba(color)
    cairo_set_line_width(cr, 1.4)
    cairo_set_line_join(cr, CAIRO_LINE_JOIN_ROUND)
    cairo_stroke(cr)

    -- ponto no valor atual
    dot(x0 + (n - 1) * step, py(buf[n]), 2.2, color)
end

local function hline(x, y, w, color)
    rgba(color)
    cairo_rectangle(cr, x, math.floor(y) + 0.5, w, 1)
    cairo_fill(cr)
end

-- cabeçalho de card: ponto colorido + título espaçado + info à direita
local function header(y, title, color, meta)
    dot(PAD + 3, y - 4, 3, color)
    font(F_MED, 10)
    spaced(PAD + 14, y, title, C.text2, 1.8)
    if meta then
        font(F_REG, 10)
        text(W - PAD, y, meta, C.text3, 'r')
    end
end

-- número grande com unidade menor ao lado
local function big(x, y, value, unit, color, size)
    font(F_LIGHT, size or 30)
    local w = text(x, y, value, color or C.text1)
    if unit then
        font(F_REG, (size or 30) * 0.42)
        w = w + 3 + text(x + w + 3, y, unit, C.text3)
    end
    return w
end

-- lista de processos (nome à esquerda, valor à direita)
local function procs(y, list, color)
    font(F_REG, 11)
    for i, p in ipairs(list) do
        local yy = y + (i - 1) * 18
        dot(PAD + 2, yy - 4, 1.8, i == 1 and color or C.grid)
        text(PAD + 12, yy, p[1] ~= '' and p[1] or '—', i == 1 and C.text1 or C.text2)
        text(W - PAD, yy, p[2], i == 1 and C.text1 or C.text3, 'r')
    end
end

------------------------------------------------------------------------------
-- Seções
------------------------------------------------------------------------------
local DIAS  = { 'domingo', 'segunda-feira', 'terça-feira', 'quarta-feira', 'quinta-feira', 'sexta-feira', 'sábado' }
local MESES = { 'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho',
                'agosto', 'setembro', 'outubro', 'novembro', 'dezembro' }

local function sec_header(y)
    local t = os.date('*t')
    font(F_THIN, 64)
    text(2, y + 52, os.date('%H:%M'), C.text1)
    font(F_REG, 13)
    text(W - 2, y + 22, DIAS[t.wday], C.text1, 'r')
    font(F_LIGHT, 13)
    text(W - 2, y + 41, string.format('%d de %s', t.day, MESES[t.month]), C.text2, 'r')
    font(F_REG, 10)
    local info = string.format('%s  ·  %s  ·  kernel %s', static.host, static.distro, static.kernel)
    text(4, y + 74, info, C.text3)
    return y + 82
end

local function sec_quick(y)
    local h = 72
    card(y, h)
    local cw = (W - 2 * PAD) / 3
    local cols = {}

    -- uptime
    local up = S.uptime
    local d, hh, mm = math.floor(up / 86400), math.floor(up % 86400 / 3600), math.floor(up % 3600 / 60)
    cols[1] = { 'UPTIME', d > 0 and string.format('%dd %dh', d, hh) or string.format('%dh %02dm', hh, mm),
                C.text1, os.date('desde %d/%m %H:%M', os.time() - math.floor(up)) }

    -- load
    local ncores = #S.cores > 0 and #S.cores or 1
    cols[2] = { 'LOAD', string.format('%.2f', S.load[1]), level_color(S.load[1] / ncores, C.text1, 0.7, 1.0),
                string.format('%.2f  %.2f', S.load[2], S.load[3]) }

    -- bateria
    local st = S.bat_status
    local sub = ({ Full = 'carregada', ['Not charging'] = 'na tomada', Charging = 'carregando',
                   Discharging = 'na bateria' })[st] or st:lower()
    if S.bat_hours then sub = sub .. ' · ' .. fmt_dur(S.bat_hours) end
    cols[3] = { 'BATERIA', (S.bat or 0) .. '%',
                (S.bat or 100) <= 15 and C.crit or (S.bat or 100) <= 30 and C.warn or C.text1, sub }

    for i, c in ipairs(cols) do
        local x = PAD + (i - 1) * cw
        font(F_MED, 8.5)
        spaced(x, y + 22, c[1], C.text3, 1.5)
        font(F_LIGHT, 19)
        local vw = text(x, y + 46, c[2], c[3])
        font(F_REG, 9.5)
        text(x, y + 61, c[4], C.text3)
        if i == 3 then
            -- ícone de bateria ao lado do valor
            local bx, by = x + vw + 8, y + 34
            rrect(bx, by, 22, 11, 2.5)
            rgba(C.text3)
            cairo_set_line_width(cr, 1)
            cairo_stroke(cr)
            rgba(C.text3)
            cairo_rectangle(cr, bx + 22.5, by + 3.5, 2, 4)
            cairo_fill(cr)
            local fc = st == 'Discharging' and c[3] or C.ok
            rrect(bx + 2, by + 2, 18 * clamp((S.bat or 0) / 100), 7, 1.5)
            rgba(fc)
            cairo_fill(cr)
        end
        if i > 1 then
            rgba(C.border)
            cairo_rectangle(cr, x - 10, y + 14, 1, h - 28)
            cairo_fill(cr)
        end
    end
    return y + h + GAP
end

local function sec_cpu(y)
    local h = 184
    card(y, h, C.cpu)
    local meta = #S.cores .. ' threads'
    if S.cpu_temp then meta = meta .. string.format('  ·  %.0f°C', S.cpu_temp) end
    header(y + 26, 'CPU', C.cpu, meta)

    big(PAD, y + 72, string.format('%.0f', S.cpu), '%', level_color(S.cpu / 100, C.text1))
    local sx = PAD + 92
    hline(sx, y + 76, W - PAD - sx, C.grid)
    spark(sx, y + 40, W - PAD - sx, 36, S.hist_cpu, C.cpu, 100)

    -- barras por núcleo
    local n = #S.cores
    local gap = 4
    local bw = (W - 2 * PAD - (n - 1) * gap) / n
    local by, bh = y + 92, 26
    for i = 1, n do
        local x = PAD + (i - 1) * (bw + gap)
        local f = clamp(S.cores[i] / 100)
        rrect(x, by, bw, bh, 2)
        rgba(C.track)
        cairo_fill(cr)
        if f > 0.01 then
            local fh = math.max(2, bh * f)
            rrect(x, by + bh - fh, bw, fh, 2)
            rgba(level_color(f, C.cpu, 0.75, 0.92), 0.35 + 0.65 * f)
            cairo_fill(cr)
        end
    end

    local list = {}
    for i, p in ipairs(S.top_cpu) do list[i] = { p[1], string.format('%.1f%%', p[2]) } end
    procs(y + 138, list, C.cpu)
    return y + h + GAP
end

local function sec_gpu(y)
    local h = 96
    card(y, h, C.gpu)
    local meta = 'Radeon Vega'
    if S.gpu_temp then meta = meta .. string.format('  ·  %.0f°C', S.gpu_temp) end
    header(y + 26, 'GPU', C.gpu, meta)

    big(PAD, y + 70, string.format('%.0f', S.gpu), '%', C.text1, 26)
    local sx = PAD + 80
    local half = (W - PAD - sx)
    hline(sx, y + 52, half, C.grid)
    spark(sx, y + 34, half, 18, S.hist_gpu, C.gpu, 100)

    font(F_REG, 9.5)
    local vf = S.vram_used / S.vram_total
    text(sx, y + 70, 'VRAM', C.text3)
    text(W - PAD, y + 70, fmt_bytes(S.vram_used) .. ' / ' .. fmt_bytes(S.vram_total) ..
        '   ·   GTT ' .. fmt_bytes(S.gtt_used), C.text2, 'r')
    bar(sx, y + 78, W - PAD - sx, 4, vf, level_color(vf, C.gpu, 0.97, 1.01))
    return y + h + GAP
end

local function sec_mem(y)
    local h = 178
    card(y, h, C.mem)
    header(y + 26, 'MEMÓRIA', C.mem, fmt_bytes(S.mem_total, 1) .. ' total')

    local uf = S.mem_used / S.mem_total
    local w = big(PAD, y + 70, string.format('%.1f', S.mem_used / 2 ^ 30), 'GiB', C.text1, 30)
    font(F_LIGHT, 16)
    text(W - PAD, y + 70, string.format('%.0f%%', uf * 100), level_color(uf, C.text2, 0.8, 0.92), 'r')

    -- barra empilhada: usada + cache
    local bx, bwid, byy = PAD, W - 2 * PAD, y + 80
    bar(bx, byy, bwid, 6, 0, C.mem)
    local cf = clamp(uf + S.mem_cache / S.mem_total)
    rrect(bx, byy, bwid * cf, 6, 3); rgba(C.mem, 0.28); cairo_fill(cr)
    rrect(bx, byy, math.max(6, bwid * uf), 6, 3); rgba(level_color(uf, C.mem, 0.8, 0.92)); cairo_fill(cr)

    -- legenda + swap
    font(F_REG, 9.5)
    local lx = PAD
    dot(lx + 3, y + 102, 3, C.mem)
    lx = lx + 10 + text(lx + 10, y + 105, 'em uso', C.text3) + 14
    dot(lx + 3, y + 102, 3, { C.mem[1], C.mem[2], C.mem[3], 0.35 })
    lx = lx + 10 + text(lx + 10, y + 105, 'cache ' .. fmt_bytes(S.mem_cache), C.text3)
    text(W - PAD, y + 105, 'swap ' .. fmt_bytes(S.swap_used) .. ' / ' .. fmt_bytes(S.swap_total), C.text3, 'r')

    hline(PAD, y + 116, W - 2 * PAD, C.border)
    procs(y + 134, S.top_mem, C.mem)
    return y + h + GAP
end

local function sec_disk(y)
    local h = 144
    local sl = S.slow
    card(y, h, C.disk)
    local meta = static.disk
    if S.nvme_temp then meta = meta .. string.format('  ·  %.0f°C', S.nvme_temp) end
    header(y + 26, 'DISCO', C.disk, meta)

    local size, used, avail = tonumber(sl.fs_size), tonumber(sl.fs_used), tonumber(sl.fs_avail)
    if size and size > 0 then
        local f = used / (used + avail)
        local col = level_color(f, C.text1, 0.85, 0.95)
        big(PAD, y + 66, string.format('%.0f', f * 100), '%', col, 26)
        font(F_REG, 10)
        text(W - PAD, y + 54, fmt_bytes(avail, 1) .. ' livres', f >= 0.95 and C.crit or C.text2, 'r')
        text(W - PAD, y + 67, 'raiz /  ·  ' .. fmt_bytes(size, 0), C.text3, 'r')
        bar(PAD, y + 76, W - 2 * PAD, 4, f, level_color(f, C.disk, 0.85, 0.95))
    end

    -- E/S: leitura para cima, escrita para baixo
    local gy, gh = y + 88, 22
    local m = math.max(buf_max(S.hist_rd, S.hist_wr), 1024 * 1024)
    local gx, gw = PAD + 96, W - 2 * PAD - 96
    hline(gx, gy + gh, gw, C.grid)
    spark(gx, gy, gw, gh, S.hist_rd, C.disk, m)
    spark(gx, gy + gh + 1, gw, gh, S.hist_wr, C.up, m, true)
    font(F_REG, 10)
    arrow(PAD + 4, gy + 12, 3.5, C.disk, false)
    text(PAD + 13, gy + 16, fmt_rate(S.rd or 0), C.text2)
    arrow(PAD + 4, gy + gh + 13, 3.5, C.up, true)
    text(PAD + 13, gy + gh + 17, fmt_rate(S.wr or 0), C.text2)
    return y + h + GAP
end

-- texto em sequência separado por '·'; cada item é { texto, cor }
local function chain(x, y, items)
    for i, it in ipairs(items) do
        if i > 1 then x = x + text(x, y, '  ·  ', C.grid) end
        x = x + text(x, y, it[1], it[2] or C.text2)
    end
    return x
end

local function sec_net(y)
    local sl = S.slow
    local freq = tonumber(sl.wfreq)
    local wifi = sl.ssid and sl.ssid ~= '' and freq
    local ex = wifi and 34 or 0   -- altura extra das linhas de Wi-Fi
    local h = 172 + ex
    local y0 = y
    card(y, h, C.down)
    local meta = S.iface or 'offline'
    if sl.ssid and sl.ssid ~= '' then meta = sl.ssid .. '  ·  ' .. (sl.signal or '?') .. '%' end
    header(y + 26, 'REDE', C.down, meta)

    if wifi then
        local band = freq < 3000 and '2,4 GHz' or freq < 5925 and '5 GHz' or '6 GHz'
        local wy = y + 48
        font(F_REG, 10)
        chain(PAD, wy, {
            { band, C.down },
            { freq .. ' MHz' },
            { 'canal ' .. (sl.wchan or '?') },
            { (sl.wwidth or '?') .. ' MHz' },
        })
        if sl.wstd and sl.wstd ~= '' then text(W - PAD, wy, sl.wstd, C.text2, 'r') end

        wy = wy + 16
        local dbm = tonumber(sl.wdbm)
        local qcol = not dbm and C.text3 or dbm >= -60 and C.ok or dbm >= -70 and C.warn or C.crit
        dot(PAD + 3, wy - 3.5, 3, qcol)
        text(PAD + 11, wy, dbm and (dbm .. ' dBm') or '— dBm', C.text3)
        if sl.wrx then
            local rx = W - PAD - text(W - PAD, wy, (sl.wtx or '?') .. ' Mbit/s', C.text3, 'r')
            arrow(rx - 7, wy - 3.5, 3, C.up, false)
            rx = rx - 16 - text(rx - 16, wy, sl.wrx, C.text3, 'r')
            arrow(rx - 7, wy - 3.5, 3, C.down, true)
            text(rx - 16, wy, 'enlace', C.text3, 'r')
        end
        y = y + ex
    end

    -- velocidades atuais
    font(F_LIGHT, 17)
    arrow(PAD + 5, y + 55, 4.5, C.down, true)
    text(PAD + 16, y + 61, fmt_rate(S.dn or 0), C.text1)
    local uw = text(W - PAD, y + 61, fmt_rate(S.upl or 0), C.text1, 'r')
    arrow(W - PAD - uw - 11, y + 55, 4.5, C.up, false)

    -- gráfico espelhado: download em cima, upload embaixo
    local gy, gh = y + 72, 26
    local m = math.max(buf_max(S.hist_dn, S.hist_upl), 64 * 1024)
    hline(PAD, gy + gh, W - 2 * PAD, C.grid)
    spark(PAD, gy, W - 2 * PAD, gh, S.hist_dn, C.down, m)
    spark(PAD, gy + gh + 1, W - 2 * PAD, gh, S.hist_upl, C.up, m, true)
    font(F_REG, 8.5)
    text(W - PAD, gy + 8, 'pico ' .. fmt_rate(m), C.text3, 'r')

    -- endereços
    local ry = y + 140
    local function kv(x, yy, k, v, vc)
        font(F_MED, 8.5)
        local kw = spaced(x, yy, k, C.text3, 1.3) - x
        font(F_REG, 10.5)
        return kw + 6 + text(x + kw + 6, yy, v, vc or C.text2)
    end
    kv(PAD, ry, 'LAN', S.lan or '—')
    font(F_REG, 10.5)
    local ev = (sl.extip and sl.extip ~= '') and sl.extip or '—'
    local evw = tw(ev)
    font(F_MED, 8.5)
    local ek = 0
    for ch in ('EXT'):gmatch('.') do ek = ek + tw(ch) + 1.3 end
    kv(W - PAD - evw - ek - 6, ry, 'EXT', ev)

    local vy = ry + 18
    local vpn = sl.vpn and sl.vpn ~= '' and sl.vpn or nil
    local vx = PAD
    dot(vx + 3, vy - 3.5, 3, vpn and C.ok or C.text3)
    font(F_REG, 10)
    text(vx + 11, vy, vpn and ('VPN ' .. vpn) or 'sem VPN', vpn and C.text2 or C.text3)
    local tx = W - PAD - text(W - PAD, vy, fmt_bytes(S.tx_total or 0), C.text3, 'r')
    arrow(tx - 7, vy - 3.5, 3, C.up, false)
    tx = tx - 18 - text(tx - 18, vy, fmt_bytes(S.rx_total or 0), C.text3, 'r')
    arrow(tx - 7, vy - 3.5, 3, C.down, true)
    text(tx - 16, vy, 'total', C.text3, 'r')
    return y0 + h
end

------------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------------
local ready = false

function conky_main()
    if conky_window == nil then return end
    if not ready then
        init_static()
        ready = true
    end
    sample()

    local updates = tonumber(conky_parse('${updates}')) or 0
    if updates < 2 then return end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
        conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    ext = ext or cairo_text_extents_t:create()
    cairo_set_antialias(cr, CAIRO_ANTIALIAS_BEST)
    if not fopts then
        fopts = cairo_font_options_create()
        cairo_font_options_set_antialias(fopts, CAIRO_ANTIALIAS_GRAY)
        cairo_font_options_set_hint_style(fopts, CAIRO_HINT_STYLE_SLIGHT)
    end
    cairo_set_font_options(cr, fopts)

    local y = 0
    y = sec_header(y)
    y = sec_quick(y)
    y = sec_cpu(y)
    y = sec_gpu(y)
    y = sec_mem(y)
    y = sec_disk(y)
    sec_net(y)

    -- depuração: `touch /tmp/conky-nocturne-$USER.snap` salva o quadro em .png
    if io.open(STATE .. '.snap') then
        os.remove(STATE .. '.snap')
        cairo_surface_flush(cs)
        cairo_surface_write_to_png(cs, STATE .. '.png')
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end
