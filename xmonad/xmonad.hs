{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (when)
import Data.List (isInfixOf)
import qualified Data.Map as M
import System.Exit

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.Search
import XMonad.Actions.WindowGo
import XMonad.Actions.WindowBringer
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import qualified XMonad.Hooks.ManageHelpers as MH
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Layout.Fullscreen (fullscreenManageHook, fullscreenFloat, fullscreenFocus, fullscreenFull)
import XMonad.Layout.DwmStyle
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Magnifier
import XMonad.Layout.Dishes
import XMonad.Layout.Accordion
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Minimize
import qualified XMonad.StackSet as W
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.XSelection
import XMonad.Util.Themes
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window

myMod = mod4Mask
myTerm = "st"

myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#ff0000"

-- helper function for doing a simple string match on window titles
(~?) :: (Eq a, Functor f) => f [a] -> [a] -> f Bool
q ~? x  = fmap (x `isInfixOf`) q

myManageHook :: ManageHook
myManageHook = composeAll [ className =? "Firefox"      --> doShift "web",
                            className =? "Vimb"         --> doShift "web",
                            className =? "chromium"     --> doShift "web",
                            className =? "Emacs"        --> doShift "code",
                            className =? "mpv"          --> doShift "media",
                            className =? "Franz"        --> doShift "im",
                            className =? "telegram"     --> doShift "im",
                            className =? "Mattermost"   --> doShift "im",
                            className =? "vlc"          --> doShift "media",
                            className =? "jetbrains-phpstorm" --> doShift "code",
                            className =? "jetbrains-idea" --> doShift "code",
                            -- title =? "Iceweasel"        --> doShift "web",
                            -- title ~? "Iceweasel"        --> doShift "web",
                            className =? "MPlayer"        --> doFloat <+> doShift "media",
                            className =? "Gimp"           --> doFloat,
                            className =? "hl_linux"       --> doFloat <+> doShift "games",
                            className =? "Steam"          --> doFloat <+> doShift "games",
                            className =? "Civ5XP"         --> doFloat <+> doShift "games",
                            className =? "openttd"        --> doFloat <+> doShift "games",
                            className =? "qemu-system-x86_64" --> doShift "VM",
                            className =? "virt-manager"   --> doShift "VM",
                            className =? "Terraria.bin.x86" --> doFloat <+> doShift "games",
                            className =? "Gvbam"          --> doFloat <+> doShift "games",
                            className =? "desmume"        --> doFloat <+> doShift "games",
                            className =? "dosbox"         --> doFloat <+> doShift "games",
                            appName   ~? "Minecraft 1."     --> doFloat <+> doShift "games",
                            appName   ~? "Minecraft Launcher 1." --> doFloat <+> doShift "games",
                            appName   ~? "Red Alert 2"    --> doFloat <+> doShift "games",
                            title =? "Kerbal Space Program" --> doFloat <+> doShift "games",
                            resource  =? "desktop_window" --> doIgnore,
                            resource  =? "kdesktop"       --> doIgnore,
                            MH.isFullscreen                  --> doF W.focusDown <+> MH.doFullFloat]

--              , ((modm,               xK_t     ), withFocused $ windows . W.sink)
--              , ((modm              , xK_b     ), sendMessage ToggleStruts)
--              ] ++ [ ((m .|. modm, k), windows $ f i)
--                   | (i, k) <- zip (XMonad.workspaces settings) [xK_1 .. xK_9]
--                   , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--     --
--     -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
--     -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--     --
--     -- ++ [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
--     --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
--     --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- myXPConfig = Prompt.def

myXPConfig :: XPConfig
myXPConfig = XMonad.Prompt.def {
  font = "6x12",
  bgColor = "#282a36",
  fgColor = "#f8f8f2",
  fgHLight = "#ccccc7",
  bgHLight = "#464752",
  borderColor = "#373844",
  promptBorderWidth = 1,
  position = Bottom,
  historySize = 15
  }

myKeys :: XConfig t -> M.Map (KeyMask, KeySym) (X ())
myKeys (XConfig {XMonad.modMask = modMask, XMonad.terminal = term}) = M.fromList [
  ((modMask .|. shiftMask  , xK_space ), sendMessage ToggleLayout),
  ((modMask                , xK_Right ), nextWS),
  ((modMask                , xK_Left  ), prevWS),
  ((modMask .|. shiftMask  , xK_Right ), shiftToNext),
  ((modMask .|. shiftMask  , xK_Left  ), shiftToPrev),
  ((modMask                , xK_Insert), pasteSelection),
  ((modMask .|. shiftMask  , xK_Tab   ), toggleWS),
  ((modMask                , xK_Print ), unsafeSpawn "maim -s --hidecursor $(date \"+%FT%T\").png"),
  ((modMask .|. shiftMask  , xK_Print ), unsafeSpawn "maim --hidecursor $(date \"+%FT%T\").png"),
  ((modMask                , xK_comma ), sendMessage (IncMasterN 1)),
  ((modMask                , xK_period), sendMessage (IncMasterN (-1))),
  ((modMask                , xK_n     ), refresh),
  ((modMask                , xK_m     ), withFocused minimizeWindow),
  ((modMask .|. shiftMask  , xK_m     ), sendMessage RestoreNextMinimizedWin),
  ((modMask                , xK_p     ), unsafeSpawn "rofi -show run"),
  ((modMask .|. shiftMask  , xK_d     ), kill),
  ((modMask                , xK_j     ), windows W.focusDown),
  ((modMask                , xK_k     ), windows W.focusUp),
  ((modMask .|. shiftMask  , xK_j     ), windows W.swapDown),
  ((modMask .|. shiftMask  , xK_k     ), windows W.swapUp),
  ((modMask .|. controlMask, xK_k     ), sendMessage MirrorExpand),
  ((modMask .|. controlMask, xK_j     ), sendMessage MirrorShrink),
  ((modMask .|. controlMask, xK_h     ), sendMessage Shrink),
  ((modMask .|. controlMask, xK_l     ), sendMessage Expand),
  ((modMask                , xK_z     ), withFocused $ windows . W.sink), -- unfloat
  ((modMask                , xK_g     ), gotoMenuArgs' "rofi" ["-dmenu", "-p", "goto> "]),
  ((modMask                , xK_b     ), bringMenuArgs' "rofi" ["-dmenu", "-p", "bring> "]),
  ((modMask                , xK_F1    ), manPrompt myXPConfig)
--  ((modMask                , xK_F2    ), sshPrompt myXPConfig),
--  ((modMask                , xK_g     ), gotoMenuArgs myDmenuGotoArgs),
--  ((modMask                , xK_b     ), bringMenuArgs myDmenuBringArgs),
--  ((m              , xK_b     ), windowPromptBring myXPConfig),
  ]
  where
    myDmenuArgs = ["-b", "-i", "-fn", "Terminus-9"] :: [String]
    myDmenuGotoArgs = myDmenuArgs ++ ["-p", "goto>"] :: [String]
    myDmenuBringArgs = myDmenuArgs ++ ["-p", "bring>"] :: [String]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [ ((modMask, button1), (\w -> focus w >> ifFloating w mouseMoveWindow))
  , ((modMask, button2), (\w -> focus w >> ifFloating w mouseResizeWindow))
  , ((modMask, button3), (\w -> focus w >> windows W.swapMaster))
  ]
  where
    ifFloating w f = withWindowSet $ \ws -> when (M.member w $ W.floating ws) (f w)

  -- , ((m,              xK_i), raiseMaybe (runInTerm "-title Irssi" "sh -c 'screen -r irssi'") (title ~? "Irssi"))
  -- , ((m .|. shiftMask,xK_i), spawn "xclip -o|tr '\n' ' '|sed -e 's/- //' -e 's/^ *//' -e 's/ *$//' -e 's/  / /' > /tmp/z.txt && screen -S 'irssi' -X readbuf /tmp/z.txt && screen -S 'irssi' -X paste .;rm /tmp/z.txt")
  -- , ((m,              xK_m), runOrRaise "mnemosyne" (className =? "Mnemosyne"))
  -- , ((m,              xK_r), raiseMaybe (runInTerm "-title rtorrent" "sh -c 'screen -r rtorrent'") (title =? "rtorrent"))
  -- , ((m,              xK_v), spawn "/home/gwern/bin/bin/logprompt.sh /home/gwern/doc/2015/log.txt")
  -- , ((m .|. shiftMask,xK_v), spawn "/home/gwern/bin/bin/logprompt.sh /home/gwern/doc/2015/log-media.txt")]

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "rotate-wallpaper"
  -- spawnOnce "/usr/local/bin/xmobar -f6x12"
  spawnOnce myTerm
  spawnOnce "firefox"
  spawnOnce "emacs"
  -- spawnOnce "franz"
  startupHook desktopConfig
  setWMName "LG3D"

myLayout = avoidStruts $ toggleLayouts Full $ perWS
  where
    windowSpacing = 0
    layout l = smartSpacing windowSpacing $ l
    renamedLayout name l = renamed [Replace name] $ layout l
    magnifyRatio = 1.3
    tallLayout = renamedLayout "Tall" $ ResizableTall nmaster delta ratio slaves
      where nmaster = 1
            delta = 3/100
            ratio = 1/2
            slaves = []

    magnifiedTallLayout = renamedLayout "Magnified Tall" $ magnifiercz' magnifyRatio $ tallLayout
    wideLayout = renamedLayout "Wide" $ Mirror $ tallLayout
    magnifiedWideLayout = renamedLayout "Magnified Wide" $ magnifiercz' magnifyRatio $ wideLayout
        
    dishLayout = renamedLayout "Dishes" $ Dishes nmaster ratio
      where nmaster = 1
            ratio = 1/5

    fullLayout = renamedLayout "Full" $ noBorders Full
    gridLayout = renamedLayout "Grid" $ Grid
    magnifiedGridLayout = renamedLayout "Magnified Grid" $ gridLayout
    accordionLayout = renamedLayout "Accordion" $ Accordion
    floatLayout = renamedLayout "Float" $ simplestFloat
    
    mainWS = onWorkspace "main" (magnifiedTallLayout ||| magnifiedWideLayout ||| tallLayout ||| wideLayout ||| accordionLayout)
    codeWS = onWorkspace "code" (magnifiedWideLayout ||| magnifiedTallLayout ||| wideLayout ||| tallLayout)
    webWS = onWorkspace "web" (fullLayout ||| tallLayout ||| wideLayout)
    imWS = onWorkspace "im" (fullLayout ||| gridLayout ||| accordionLayout)
    vmWS = onWorkspace "VM" (fullLayout ||| gridLayout)
    mediaWS = onWorkspace "media" $ minimize (fullLayout ||| gridLayout ||| wideLayout ||| tallLayout ||| magnifiedWideLayout ||| magnifiedTallLayout)
    gamesWS = onWorkspace "games" $ fullscreenFloat (floatLayout ||| fullLayout ||| tallLayout ||| wideLayout)
    restWS = magnifiedTallLayout ||| magnifiedWideLayout ||| tallLayout ||| wideLayout ||| accordionLayout ||| gridLayout
    perWS = mainWS $ codeWS $ webWS $ imWS $ vmWS $ mediaWS $ gamesWS $ restWS

settings = desktopConfig {
  terminal           = myTerm,
  focusFollowsMouse  = False,
  borderWidth        = 1,
  modMask            = mod4Mask,
  workspaces         = ["main", "code", "web", "im", "vm", "media", "games"],
  normalBorderColor  = "#373844",
  focusedBorderColor = myFocusedBorderColor,
  keys               = \c -> myKeys c `M.union` XMonad.keys desktopConfig c,
  --   mouseBindings      = mouseBindings settings,
  layoutHook         = myLayout,
  manageHook         = manageDocks <+> fullscreenManageHook <+> myManageHook <+> manageHook desktopConfig,
  startupHook        = myStartupHook,
  handleEventHook    = fullscreenEventHook
  }

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar -f6x12"
  xmonad $ ewmh settings {
    logHook = dynamicLogWithPP xmobarPP {
        ppOutput = hPutStrLn xmproc,
        ppCurrent = xmobarColor "#f8f8f2" "#44475a" . shorten 8,
        ppTitle = xmobarColor "#50fa7b" "" . shorten 40,
        ppUrgent = xmobarColor "#ff5555" "" . shorten 8,
        ppSep = " | "
        }
    }
