// Pomodoro Desktop - Copyright (c) 2009-2011, Ugo Landini (ugol@computer.org)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// * Neither the name of the <organization> nor the
// names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDERS ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ApplescriptController.h"
#import <OSAKit/OSAScriptView.h>
//#import <OSAKit/OSAScriptController.h>
#import "PomoNotifications.h"


@implementation ApplescriptController

@synthesize scriptView, scriptPanel, scriptEveryCombo, namesCombo;

#pragma mark ---- Scripting panel delegate methods ----

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel 
             returnCode:(int)returnCode 
            contextInfo:(void *)x 
{ 
    if (returnCode == NSModalResponseOK) {
        NSURL *url = [openPanel URL];
        NSString *filename = [[url path] lastPathComponent];
        NSError *error;
        NSStringEncoding encoding = 0;
		NSString *script = [[NSString alloc] initWithContentsOfFile:filename encoding:encoding error:&error];
		[scriptView setSource:script];
		[script release];				
    } 
} 


- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename {
    if ([[filename pathExtension] isEqualTo:@"pomo"] || [[filename pathExtension] isEqualTo:@"applescript"])
        return YES;
    return NO;
}

- (IBAction)showOpenPanel:(id)sender 
{ 
    NSOpenPanel *panel = [NSOpenPanel openPanel]; 
	[panel setDelegate:self];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"pomo", @"applescript", nil]];
    [panel beginSheetModalForWindow:scriptPanel completionHandler:0];
    /*[panel beginSheetForDirectory:nil
                             file:nil 
							types: [NSArray arrayWithObjects:@"pomo", @"applescript",nil]
                   modalForWindow:scriptPanel 
                    modalDelegate:self 
                   didEndSelector: 
	 @selector(openPanelDidEnd:returnCode:contextInfo:) 
                      contextInfo:sender]; 
     */
} 

- (IBAction)showScriptingPanel:(id)sender {
    
    [scriptView unbind:@"data"];
    NSString* scriptToShow = [NSString stringWithFormat:@"values.script%@", [scriptNames objectAtIndex:[sender tag]]];
    [scriptView bind:@"data" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:scriptToShow options:nil];
    
    [scriptPanel makeKeyAndOrderFront:self];
    
}

#pragma mark ---- Window delegate methods ----


- (void)windowDidResignKey:(NSNotification *)notification {
    
    // Commit Editing still in place when closing a panel or losing focus
    [notification.object makeFirstResponder:nil];
    
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {
    
	if ([self checkDefault:@"scriptAtStartEnabled"]) {	
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptStart"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
}

- (void) interrupted {
    
    NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	
	if ([self checkDefault:@"scriptAtInterruptEnabled"]) {		
		NSString* scriptString = [[self bindCommonVariables:@"scriptInterrupt"] stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString];
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:scriptString] autorelease];
		[playScript executeAndReturnError:nil];
	}

}

-(void) pomodoroExternallyInterrupted:(NSNotification*) notification {

    [self interrupted];
    
}

-(void) pomodoroInternallyInterrupted:(NSNotification*) notification {
    
    [self interrupted];
    
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {

    if ([self checkDefault:@"scriptAtInterruptOverEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptInterruptOver"]] autorelease];
		[playScript executeAndReturnError:nil];
	}

}

-(void) pomodoroReset:(NSNotification*) notification {
    
    if ([self checkDefault:@"scriptAtResetEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptReset"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
    
}

-(void) pomodoroResumed:(NSNotification*) notification {
    
	if ([self checkDefault:@"scriptAtResumeEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptResume"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
}

-(void) breakStarted:(NSNotification*) notification {
}

-(void) breakFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"scriptAtBreakFinishedEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptBreakFinished"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
}

-(void) pomodoroFinished:(NSNotification*) notification {    
    
    if ([self checkDefault:@"scriptAtEndEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptEnd"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
    
}

- (void) oncePerSecondBreak:(NSNotification*) notification {
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
    NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%ld", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%ld", time/60];
	
	if (timePassed%(60 * _scriptEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"scriptAtEveryEnabled"]) {		
			NSString* msg = [[self bindCommonVariables:@"scriptEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:msg] autorelease];
			[playScript executeAndReturnError:nil];
		}
	}

}

- (void) addListToCombo:(NSAppleEventDescriptor*)result {
    
    NSInteger howMany = [result numberOfItems];
    for (int i=1; i<= howMany; i++) {
        [namesCombo addItemWithObjectValue:[[result descriptorAtIndex:i] stringValue]];
    }
}

-(void) setPomodoroNametoLastBeforeCancel:(NSNotification*)notification {
	   
    NSInteger howMany = [namesCombo numberOfItems];
    if (howMany > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[namesCombo itemObjectValueAtIndex:howMany-1] forKey:@"timerName"];
    }
    
}

-(void) pomodoroNameGiven:(NSNotification*) notification {
    
    NSInteger howMany = [namesCombo numberOfItems];
    NSString* name = _timerName;
    BOOL isNewName = YES;
    NSInteger i = 0;
    while ((isNewName) && (i<howMany)) {
        isNewName = ![name isEqualToString:[namesCombo itemObjectValueAtIndex:i]];
        i++;
    }
    if (isNewName) {
        if (howMany>25) {
            [namesCombo removeItemAtIndex:0];
        }
        [namesCombo addItemWithObjectValue:name];
        
        if ([self checkDefault:@"scriptSaveTodoEnabled"]) {
            NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptSaveTodo"]] autorelease];
            
            [playScript executeAndReturnError:nil];
        }
    }
}

-(void) pomodoroWillStart:(NSNotification*) notification {
    
    if ([self checkDefault:@"scriptGetTodoListEnabled"]) {
        [namesCombo removeAllItems];

        NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptGetTodoList"]] autorelease];
        
        NSAppleEventDescriptor* result = [playScript executeAndReturnError:nil];
        [self addListToCombo: result];
    }

}



#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self registerForAllPomodoroEvents];
    [self registerForPomodoro:_PMPomoNameCanceled method:@selector(setPomodoroNametoLastBeforeCancel:)];
    [self registerForPomodoro:_PMPomoNameGiven method:@selector(pomodoroNameGiven:)];
    [self registerForPomodoro:_PMPomoWillStart method:@selector(pomodoroWillStart:)];

    
    scriptNames = [[NSArray arrayWithObjects:@"GetTodoList", @"SaveTodo", @"Start",@"Interrupt",@"InterruptOver", @"Reset", @"Resume", @"End", @"BreakFinished", @"Every", nil] retain];
    
    [scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
    [scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
    [scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
    
}

- (void)dealloc {
    
    [scriptNames release];
    [super dealloc];
    
}

@end
