import Data.List (isInfixOf)
import qualified Data.Map as M
import System.Exit

import XMonad
import XMonad.Actions.Search
import XMonad.Actions.WindowGo
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.DwmStyle
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import qualified XMonad.StackSet as W
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.XSelection
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window

myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#ff0000"

-- helper function for doing a simple string match on window titles
(~?) :: (Eq a, Functor f) => f [a] -> [a] -> f Bool
q ~? x  = fmap (x `isInfixOf`) q

myManageHook :: ManageHook
myManageHook = composeAll [ className =? "Firefox"      --> doShift "web",
                            className =? "Vimb"         --> doShift "web",
                            className =? "Emacs"        --> doShift "code",
                            className =? "mpv"          --> doShift "media",
                            -- title =? "Iceweasel"        --> doShift "web",
                            -- title ~? "Iceweasel"        --> doShift "web",
                            className =? "MPlayer"        --> doFloat,
                            className =? "Gimp"           --> doFloat,
                            resource  =? "desktop_window" --> doIgnore,
                            resource  =? "kdesktop"       --> doIgnore ]

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
myXPConfig = defaultXPConfig {
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
myKeys (XConfig {modMask = m, terminal = term}) = M.fromList [
  ((m              , xK_Insert), pasteSelection),
  ((m              , xK_Print) , unsafeSpawn "maim -s --hidecursor $(date \"+%FT%T\").png"),
  ((m .|. shiftMask, xK_Print) , unsafeSpawn "maim --hidecursor $(date \"+%FT%T\").png"),
  ((m              , xK_comma) , sendMessage (IncMasterN 1)),
  ((m              , xK_period), sendMessage (IncMasterN (-1))),
  ((m              , xK_n)     , refresh),
  ((m              , xK_m)     , windows W.focusMaster  ),
--              , ((m,               xK_t     ), withFocused $ windows . W.sink)
  ((m              , xK_p), shellPrompt myXPConfig),
  ((m .|. shiftMask, xK_d), kill),
  ((m              , xK_j), windows W.focusDown),
  ((m              , xK_k), windows W.focusUp),
  ((m .|. shiftMask, xK_j), windows W.swapDown),
  ((m .|. shiftMask, xK_k), windows W.swapUp),
  ((m              , xK_h), sendMessage Shrink),
  ((m              , xK_l), sendMessage Expand),
  ((m              , xK_z), withFocused $ windows . W.sink), -- unfloat
  ((m              , xK_w), raiseBrowser),
  ((m              , xK_e), raiseEditor),
--  ((m              , xK_F1), manPrompt myXPConfig),
  ((m              , xK_F2), sshPrompt myXPConfig),
--  ((m              , xK_F3), promptSearch myXPConfig google),
--  ((m .|. shiftMask, xK_F3), selectSearch google),
--  ((m              , xK_F4), promptSearch myXPConfig wikipedia),
--  ((m .|. shiftMask, xK_F4), selectSearch wikipedia),
  ((m              , xK_g     ), windowPromptGoto  myXPConfig),
  ((m              , xK_b     ), windowPromptBring myXPConfig)]

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
  spawnOnce "urxvtc"
  startupHook desktopConfig
 
settings = desktopConfig {
  terminal           = "urxvtc",
  focusFollowsMouse  = False,
  borderWidth        = 1,
  modMask            = mod4Mask,
  workspaces         = ["main", "code", "web", "im", "media"] ++ Prelude.map show [6..9],
  normalBorderColor  = "#373844",
  focusedBorderColor = myFocusedBorderColor,
  keys               = \c -> myKeys c `M.union` XMonad.keys desktopConfig c,
  --   mouseBindings      = mouseBindings settings,
  layoutHook         = avoidStruts $ smartBorders $ Full ||| spir ||| tiled,
  manageHook         = manageDocks <+> myManageHook <+> manageHook desktopConfig,
  startupHook        = myStartupHook
  }
  where spir = spiralWithDir direction rotation sratio
        direction = South -- East, South, West, North
        rotation = CW -- CW, CCW
        sratio = 6/7
        tiled = Tall nmaster delta ratio
        nmaster = 1
        delta = 3/100
        ratio = 1/2


main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar -f6x12"
  xmonad $ settings {
    logHook = dynamicLogWithPP xmobarPP {
        ppOutput = hPutStrLn xmproc,
        ppCurrent = xmobarColor "#f8f8f2" "#44475a" . shorten 8,
        ppTitle = xmobarColor "#50fa7b" "" . shorten 30,
        ppUrgent = xmobarColor "#ff5555" "" . shorten 8,
        ppSep = " | "
        }
    }
