--IMPORTS

import XMonad
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


--DEFAULT SOFTWARE
myTerminal      = "kitty"
myBrowser       = "brave"
myFileGUI       = "thunar"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

myModMask       = mod4Mask -- Use the "windows" key

myWorkspaces    = ["term", "www", "work", "chat", "game", "music", "email"]


--SCRATCHPADS
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "calculator" spawnCalc findCalc manageCalc
					 , NS "notes" spawnNotes findNotes manageNotes
					 , NS "pavucontrol" spawnPavucontrol findPavucontrol managePavucontrol
                ]
  where
    spawnTerm  = myTerminal ++ " --title scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.5
                 t = 0.1
                 l = 0.9 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.2
                 t = 0.1
                 l = 0.9 -w
    spawnNotes  = myTerminal ++ " --title notes -- nvim ~/notes.md"
    findNotes   = title =? "notes"
    manageNotes = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.5
                 t = 0.1
                 l = 0.95 -w
    spawnPavucontrol  = "pavucontrol"
    findPavucontrol   = className =? "Pavucontrol"
    managePavucontrol = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.5
                 t = 0.1
                 l = 0.95 -w

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#282a36"
myFocusedBorderColor = "#ff5555"

------------------------------------------------------------------------
-- BINDINGS
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm,               xK_b), spawn myBrowser)

	 , ((modm,               xK_f), spawn myFileGUI)

	 , ((modm,               xK_c), namedScratchpadAction myScratchPads "calculator")

	 , ((modm .|. shiftMask, xK_t), namedScratchpadAction myScratchPads "terminal")

	 , ((modm,               xK_n), namedScratchpadAction myScratchPads "notes")

	 , ((modm,               xK_a), namedScratchpadAction myScratchPads "pavucontrol") -- Audio mixer

	 , ((modm,               xK_m), sendMessage ToggleStruts >> sendMessage ToggleLayout) -- Maximises current window

    -- launch dmenu
    , ((modm,               xK_r     ), spawn "rofi -show run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm,               xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Move focused window to other screen and follow it
    , ((modm,               xK_o), shiftNextScreen >> nextScreen)

    -- Move focus to other screens
	 , ((modm .|. controlMask, xK_j), prevScreen)
	 , ((modm .|. controlMask, xK_k), nextScreen)

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

    , ((0, xF86XK_AudioLowerVolume      ), spawn "pamixer -d 2")
    , ((0, xF86XK_AudioRaiseVolume      ), spawn "pamixer -i 2")
    , ((0, xF86XK_AudioMute             ), spawn "pamixer -t")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
--MOUSE BINDINGS

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts( toggleLayouts (noBorders Full) (tiled) ||| toggleLayouts Full (Mirror tiled) ||| noBorders Full)
		where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
	 , className =? "Steam"          --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook = do
			spawn "feh --bg-fill ~/wallpapers/custom/gimp.png &"
			spawnOnce "conky &"
			spawnOnce "dunst &"
			spawnOnce "trayer --edge top --align right --width 5 --monitor 1 --transparent true --alpha 256 --expand false"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
	xmproc0 <- spawnPipe "xmobar -x 0 /home/dw/.config/xmobar/xmobarrc0"
	xmproc1 <- spawnPipe "xmobar -x 1 /home/dw/.config/xmobar/xmobarrc1"
	xmonad $ docks def{
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> namedScratchpadManageHook myScratchPads,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $ def
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x
				                  >> hPutStrLn xmproc1 x
				  , ppCurrent = xmobarColor "#50fa7b" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#50fa7b" ""
              , ppHidden = xmobarColor "#ff79c6" "" . wrap "" ""
              , ppHiddenNoWindows = xmobarColor "#f1fa8c" ""
              , ppUrgent = xmobarColor "#ff5555" "" . wrap "!" "!"            -- Urgent workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws]
				  },
        startupHook        = myStartupHook
    }

