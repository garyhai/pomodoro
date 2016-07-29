tell application "Reminders"
		tell list "Inbox"
	make new reminder with properties {name:"%@", remind me date:(current date) + 1 * days}
		end tell
end tell
