--
-- Xmonad config file by SzeligBalazs
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.SpawnOnce
import XMonad.Util.SpawnNamedPipe
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 3

myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm,               xK_d     ), spawn "rofi -show drun -theme /home/szeligbalazs/.config/rofi/launchers/colorful/style_7.rasi")

    
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    
    , ((modm .|. shiftMask, xK_c     ), kill)

     
    , ((modm,               xK_space ), sendMessage NextLayout)

    
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    
    , ((modm,               xK_n     ), refresh)

    
    , ((modm,               xK_Tab   ), windows W.focusDown)

    
    , ((modm,               xK_j     ), windows W.focusDown)

    
    , ((modm,               xK_k     ), windows W.focusUp  )

    
    , ((modm,               xK_m     ), windows W.focusMaster  )

    
    , ((modm,               xK_Return), windows W.swapMaster)

    
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    
    , ((modm,               xK_h     ), sendMessage Shrink)

    
    , ((modm,               xK_l     ), sendMessage Expand)

    
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    
    , ((modm              , xK_q     ), spawn "xmonad 

    
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++


    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
   
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    ]




myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     
     tiled   = smartSpacing 5 $ Tall nmaster delta ratio
   
     nmaster = 1
     
     ratio   = 1/2
     
     delta   = 3/100



myManageHook = composeAll
    [ className =? "MPlayer"        
    , className =? "Gimp"           
    , resource  =? "desktop_window" 
    , resource  =? "kdesktop"       



myEventHook = mempty


myLogHook = return ()


myStartupHook = do
	spawnOnce "nitrogen"
	spawnOnce "picom"



main = do
	xmproc <- spawnPipe "xmobar -x 0 /home/szeligbalazs/.xmobarrc"
	xmonad $ docks defaults



defaults = def {
      
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
