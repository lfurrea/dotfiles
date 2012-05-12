## test for an existing bus daemon, just to be safe
#if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
#    eval 'dbus-launch --sh-syntax --exit-with-session'
#    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
#fi

#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

xrandr -s 0

xrdb $HOME/.Xresources
xsetroot -cursor_name left_ptr
xsetroot -solid '#0F8790'

# if we have private ssh key(s), start ssh-agent and add the key(s)
id1=$HOME/.ssh/identity
id2=$HOME/.ssh/id_dsa
id3=$HOME/.ssh/id_rsa

if [ -x /usr/bin/ssh-agent ] && [ -f $id1 -o -f $id2 -o -f $id3 ];
then
	eval `ssh-agent -s`
	ssh-add < /dev/null
fi

xset fp+ /usr/share/fonts/X11/artwiz/
xset fp+ /usr/share/fonts/X11/Type1/
xset fp+ /usr/share/fonts/X11/misc/
xset fp+ /usr/share/fonts/X11/mac4lin/
xset fp+ /usr/local/share/fonts/terminus/

# xset fp rehash
xset b 100 0 0
xset r rate 250 100

xmodmap -e "keycode 233 = Page_Down"
xmodmap -e "keycode 234 = Page_Up"
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

setxkbmap -option grp:switch,grp:shift_toggle,grp_led:scroll us,es

PATH=/home/lfurrea/bin:$PATH

# launch the external 60 second clock, and launch the workspace status bar
FG='#a8a3f7' 
BG='#3f3c6d' 
#xmonad-clock | dzen2 -e '' -x 400 -w 1200 -ta r -fg $FG -bg $BG &
exec ck-launch-session xmonad &

# wait for xmonad
wait $!
#pkill -HUP dzen2
#pkill -HUP -f xmonad-clock
wait
