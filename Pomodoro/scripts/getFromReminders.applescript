tell application "Reminders"
	tell list "Inbox"
		get name of every reminder whose completed is false
	end tell
end tell
