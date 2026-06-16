/*
 * edge-resistance — "sticky edge" entre dois monitores no X11.
 *
 * Cria uma pointer barrier (XFixes) na fronteira vertical entre o
 * DisplayPort-1 (esquerda) e o eDP (direita) e só libera o ponteiro
 * depois que você empurra o mouse contra a borda por uma quantidade
 * acumulada de pixels (a "resistência"). Usa XInput2 para receber os
 * eventos de barreira e liberar o ponteiro (XIBarrierReleasePointer).
 *
 * Uso:  edge-resistance [resistencia_px] [x] [altura]
 * Padrao: 50 1920 1080  (fronteira em x=1920, de y=0 a y=1080)
 *
 * Build:
 *   cc -O2 -o edge-resistance edge-resistance.c \
 *      $(pkg-config --cflags --libs x11 xfixes xi) -lm
 */
#include <X11/Xlib.h>
#include <X11/extensions/Xfixes.h>
#include <X11/extensions/XInput2.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <signal.h>

static Display      *dpy;
static PointerBarrier barrier;

static void cleanup(int sig) {
    /* Xlib nao e async-signal-safe: chamar XCloseDisplay aqui da deadlock
     * com o XNextEvent da thread principal. Saimos direto — o servidor X
     * destroi a barreira sozinho quando o cliente desconecta. */
    (void)sig;
    _exit(0);
}

int main(int argc, char **argv) {
    double threshold = (argc > 1) ? atof(argv[1]) : 50.0;
    int    bx        = (argc > 2) ? atoi(argv[2]) : 1920;
    int    height    = (argc > 3) ? atoi(argv[3]) : 1080;

    dpy = XOpenDisplay(NULL);
    if (!dpy) { fprintf(stderr, "nao consegui abrir o display X\n"); return 1; }
    Window root = DefaultRootWindow(dpy);

    /* XFixes >= 5.0 para pointer barriers */
    int fxev, fxerr, fxmaj = 5, fxmin = 0;
    if (!XFixesQueryExtension(dpy, &fxev, &fxerr) ||
        !XFixesQueryVersion(dpy, &fxmaj, &fxmin) || fxmaj < 5) {
        fprintf(stderr, "XFixes 5.0+ necessario (tem %d.%d)\n", fxmaj, fxmin);
        return 1;
    }

    /* XInput 2.3 para eventos de barreira (BarrierHit/Leave) */
    int xi_opcode, xiev, xierr;
    if (!XQueryExtension(dpy, "XInputExtension", &xi_opcode, &xiev, &xierr)) {
        fprintf(stderr, "XInputExtension ausente\n"); return 1;
    }
    int ximaj = 2, ximin = 3;
    if (XIQueryVersion(dpy, &ximaj, &ximin) != Success ||
        ximaj * 10 + ximin < 23) {
        fprintf(stderr, "XInput 2.3+ necessario (tem %d.%d)\n", ximaj, ximin);
        return 1;
    }

    /* barreira vertical bloqueando AMBAS as direcoes (directions = 0) */
    barrier = XFixesCreatePointerBarrier(dpy, root, bx, 0, bx, height,
                                         0, 0, NULL);

    /* recebe BarrierHit/BarrierLeave de todos os ponteiros mestres */
    unsigned char m[XIMaskLen(XI_LASTEVENT)] = {0};
    XISetMask(m, XI_BarrierHit);
    XISetMask(m, XI_BarrierLeave);
    XIEventMask em = { .deviceid = XIAllMasterDevices,
                       .mask_len = sizeof(m), .mask = m };
    XISelectEvents(dpy, root, &em, 1);
    XFlush(dpy);

    signal(SIGINT,  cleanup);
    signal(SIGTERM, cleanup);

    fprintf(stderr, "edge-resistance ativo: x=%d altura=%d resistencia=%.0fpx\n",
            bx, height, threshold);

    double       accum = 0;       /* empurrao horizontal acumulado (px)   */
    unsigned int cur_id = 0;      /* eventid da sequencia de contato atual */

    for (;;) {
        XEvent ev;
        XNextEvent(dpy, &ev);
        XGenericEventCookie *c = &ev.xcookie;
        if (c->type != GenericEvent || c->extension != xi_opcode ||
            !XGetEventData(dpy, c))
            continue;

        if (c->evtype == XI_BarrierHit) {
            XIBarrierEvent *be = c->data;
            if (be->barrier == barrier) {
                if (be->eventid != cur_id) { cur_id = be->eventid; accum = 0; }
                if (be->flags & XIBarrierPointerReleased) {
                    accum = 0;                    /* ja passou */
                } else {
                    accum += be->dx;              /* componente horizontal */
                    if (fabs(accum) >= threshold) {
                        XIBarrierReleasePointer(dpy, be->deviceid,
                                                be->barrier, be->eventid);
                        XFlush(dpy);
                        accum = 0;
                    }
                }
            }
        } else if (c->evtype == XI_BarrierLeave) {
            accum = 0;
            cur_id = 0;
        }
        XFreeEventData(dpy, c);
    }
}
