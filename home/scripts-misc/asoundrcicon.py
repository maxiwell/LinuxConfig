#!/usr/bin/python
# -*- coding: utf-8 -*-
# asoundrc tray icon and sound tester
import gtk, subprocess
from subprocess import call 
import alsaaudio as alsa



class SystrayIconApp:
 def __init__(self):
  self.tray = gtk.StatusIcon()
  self.tray.set_from_icon_name('audio-volume-medium') 
  self.tray.connect('popup-menu', self.on_right_click)

 def on_right_click(self, icon, event_button, event_time):
  self.make_menu(event_button, event_time)

 def make_menu(self, event_button, event_time):
  menu = gtk.Menu()
  x= len(self.get())
  null= gtk.MenuItem(self.get()[0][22:45])
  null.show()
  menu.append(null)
  null.connect('activate',self.wechsel,self.get()[0][1],self.get()[0][22:55])
  if x > 1:
   null= gtk.MenuItem(self.get()[1][22:45])
   null.show()
   menu.append(null)
   null.connect('activate',self.wechsel,self.get()[1][1],self.get()[1][22:55])
  if x > 2:
   null= gtk.MenuItem(self.get()[2][22:45])
   null.show()
   menu.append(null)
   null.connect('activate',self.wechsel,self.get()[2][1],self.get()[2][22:55])
  if x > 3:
   null= gtk.MenuItem(self.get()[3][22:45])
   null.show()
   menu.append(null)
   null.connect('activate',self.wechsel,self.get()[3][1],self.get()[3][22:55])
  if x > 4:
   null= gtk.MenuItem(self.get()[4][22:45])
   null.show()
   menu.append(null)
   null.connect('activate',self.wechsel,self.get()[4][1],self.get()[5][22:55])
  hdmi = gtk.MenuItem("HDMI Set Audio")
  hdmi.show()
  menu.append(hdmi)
  hdmi.connect('activate', self.hdmi_sound)
  about = gtk.MenuItem("About")
  about.show()
  menu.append(about)
  about.connect('activate', self.show_about_dialog)
  quit = gtk.MenuItem("Quit")
  quit.show()
  menu.append(quit)
  quit.connect('activate', gtk.main_quit)
  menu.popup(None, None, gtk.status_icon_position_menu,
             event_button, event_time, self.tray)

 def hdmi_sound(self, bone):
     call('echo "defaults.ctl.card 1\ndefaults.pcm.card 1\ndefaults.timer.card 1" > /home/$USER/.asoundrc', shell=True)
     call('hdmisoundtoggle -c', shell=True)

 def wechsel(self ,bone ,nr,name):
  call('echo "defaults.ctl.card '+nr+'\ndefaults.pcm.card '+nr+'\ndefaults.timer.card '+nr+'" > /home/$USER/.asoundrc', shell=True)
  self.tray.set_tooltip((name))

 def  show_about_dialog(self, widget):
  about_dialog = gtk.AboutDialog()
  about_dialog.set_destroy_with_parent (True)
  about_dialog.set_name('aSoundSwitcher')
  about_dialog.set_version('version 0.01')
  about_dialog.set_copyright("by Maxiwell")
  about_dialog.set_authors(['what exacty are you looking for here?'])
  about_dialog.run()
  about_dialog.destroy()

 def get(x):
  list= open('/proc/asound/cards', 'r')
  bla=list.readlines()
  bla.insert(0,'')
  for x in bla:
   bla.remove(x)
  return(bla)

if __name__ == "__main__":
 SystrayIconApp()
 gtk.main()
