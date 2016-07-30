set pomo to "Timer"
set pathToPomodoro to POSIX path of (path to application pomo)
tell application "System Events"
	get the properties of every login item
	make new login item at end of login items with properties {name:"Timer", path:pathToPomodoro, hidden:false}
end tell
