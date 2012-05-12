--
-- My xmonad.hs file, my first lines of haskell and some fun
--

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
               [ className =? "Gimp"  --> doFloat
               , className =? "Skype" --> doFloat
               ]

main = do
  xmproc <- spawnPipe "/usr/bin/dzen2 -ta l -bg '#AD2409' -fg '#E0C6C0' -fn -*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*"
  xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook 
                       <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP dzenPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = dzenColor "#F0EFD9" "" . shorten 50
                    }
        , borderWidth         = 1
        , terminal           = "aterm -e screen"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#cd8b00" }
        