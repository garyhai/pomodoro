--------
Timer
--------

Timer is an antiprocrastination application that helps in Getting Things Done. 
It is a simple but effective way to manage your time and to boost your productivity to higher levels. 
Can be used for programming, studying, writing, cooking or simply concentrating on something important.
 
It's inspired by the Pomodoro Technique (http://www.pomodorotechnique.com/)

Updates, source code, new releases, manual and fixes on http://martakostova.github.io/timer

----------
Examples of scripts
----------

## Predefined variables in scriple

* $timerName : Name of pomodoro.
* $duration : Current pomodoro duration.
* $dailyPomodoroDone : How many pomodoros finished today.
* $globalPomodoroDone : Count of finished pomodoros in all time.

## Cowork with Reminders

Fill pomodoro todo list from Reminders' Inbox list:
in script "Get Todo List":

```
tell application "Reminders"
    tell list "Inbox"
        get name of every reminder whose completed is false
    end tell
end tell
```

Save new todo from pomodoro to Reminders' Inbox list:
in script "Save Todo"

```
tell application "Reminders"
    tell list "Inbox"
        make new reminder with properties {name:"$timerName", remind me date:(current date) + 1 * days}
    end tell
end tell
```

## Cowork with Evernote

in script "Start":

```
tell application id "com.evernote.Evernote"
    set myNote to find note "Evernote Note classic link to log pomodors, right click the note with options key down then copy it"
    try
        append myNote html "<br>"
    on error
        set HTML content of myNote to HTML content of myNote
        append myNote html "<br>"
    end try
    set textToAdd to "<ul><li>" & (current date) & "</li></ul>" & "<dl><dt>$timerName</dt></dl>"
    append myNote html textToAdd
end tell
```

in script "End":

```
set resAlert to display alert "All work and no play makes Jack a dull boy" buttons {"Close", "Memo"} giving up after 10
if button returned of resAlert is "Memo" then
    set resDlg to display dialog "Take a note:" buttons {"Close", "Submit"} default answer "" default button "Submit" with title "$timerName"
    set memo to text returned of resDlg
    if button returned of resDlg is "Submit" and memo is not "" then
        tell application id "com.evernote.Evernote"
            set noteLink to "evernote note classic link"
            set myNote to find note noteLink
            set textToAdd to "&nbsp;&nbsp;Memo: " & memo
            set noteContents to HTML content of myNote
            set fullHtmlContent to noteContents & textToAdd
            set HTML content of myNote to fullHtmlContent
        end tell
    end if
end if

```

----------
Developers
----------

Maintaining Developer: Gary Hai
Maintaining Developer: Marta Kostova
Developed by Ugo Landini and Pascal Bihler
 
-------
License
-------
This code is released under BSD license (see License.txt for details) and contains other OSS BSD licensed code:

BGHud Appkit: http://code.google.com/p/bghudappkit/

This software contains Waffle Software licensed code:
Shortcut Recorder: http://wafflesoftware.net/shortcut/

Sound samples come from http://www.freesound.org and are licensed under Creative Commons http://creativecommons.org/licenses/sampling+/1.0/

--------------
Building notes
--------------

Open Timer.xcodeproj once with XCode, then run "make clean no-sig timer" from the command line.

OR

1) Remove Code signing identity if present (should not, but sometimes I push it back)

Xcode 4.3+ (tips from @sashalaundy):	
1) Product > Edit Scheme
2) At top set Scheme to "Pomodoro" and Destination to "My Mac __-bit"
3) On left select Archive
4) Type in Archive Name "Pomodoro"
5) Hit OK
6) Product > Archive - Xcode builds and then opens Organizer with archive selected
7) Hit Distribute
8) Choose Export as "Application"

Xcode 4:
1) Build a copy for archiving: Product menu -> Build for -> Build for Archiving
2) Open the organizer: Window menu -> Organizer
3) Create a copy of the application: Hit the Share button in the Organizer
4) Choose "Application" from the drop-down menu, and then save it to your Applications folder. 

Xcode 3: (not actively maintained)
1) Should work, but I don't maintain it anymore.


------------------------------
Thanks, in no particular order
------------------------------
Everaldo for the gorgeous new icons
Pedro Murillo
Michael Bedward
Dieter Vermandere
Paul Schmidt
Sina Samangooei <sinjax@gmail.com> for debugging (and fixing!)
Alexander Klimetschek
Konrad Mitchell Lawson
Stefano Linguerri for the initial graphic design 
Giulio Cesare Solaroli for the old icons
Luca Ceppelli
Roberto Turchetti
Sergio Bossa 
Andrew Rimmer
Timothy Davis
Simone Gentilini
Francesco Mondora
Michele Mondora
Andy Palmer
Brandon Murray
Valiev Omar
Alexander Willner 
C.Kuehne 
R.Altimari
P.Bihler
