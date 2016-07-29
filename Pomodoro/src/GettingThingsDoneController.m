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

#import "GettingThingsDoneController.h"
#import "PomoNotifications.h"
#import "Pomodoro.h"
#import "Scripter.h"


@implementation GettingThingsDoneController

@synthesize namesCombo, scripter, dateFormatter;

#pragma mark ---- Pomodoro helper methods ----

- (void) addListToCombo:(NSString*)action {
	
	NSAppleEventDescriptor* result = [scripter executeScript:action];			
	NSInteger howMany = [result numberOfItems];
	for (int i=1; i<= howMany; i++) {
		[namesCombo addItemWithObjectValue:[[result descriptorAtIndex:i] stringValue]];		
	}
	
}

#pragma mark ---- Pomodoro notifications methods ----

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
        [scripter executeScript:@"addToReminders" withParameter:name];
    }
}

-(void) pomodoroWillStart:(NSNotification*) notification {

    [namesCombo removeAllItems];
    
    [self addListToCombo:@"getFromReminders"];
}

-(void) pomodoroStarted:(NSNotification*) notification {
        
//    NSString* moodMessage = _timerName;
    
//	[scripter executeScript:@"setStatusToPomodoro" withParameter:moodMessage];

}

- (void) setStatusToAvailable:(Pomodoro*) pomo {
    
//    NSString* moodMessage = _timerName;

//    [scripter executeScript:@"setStatusToAvailable" withParameter:moodMessage];
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
    
    [self setStatusToAvailable:[notification object]];

}

-(void) pomodoroReset:(NSNotification*) notification {
    
    [self setStatusToAvailable:[notification object]];
	
}

-(void) pomodoroFinished:(NSNotification*) notification {    
    
    [self setStatusToAvailable:[notification object]];

}


#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self registerForPomodoro:_PMPomoStarted method:@selector(pomodoroStarted:)];
    [self registerForPomodoro:_PMPomoInterruptionMaxTimeIsOver method:@selector(pomodoroInterruptionMaxTimeIsOver:)];
    [self registerForPomodoro:_PMPomoReset method:@selector(pomodoroReset:)];
    [self registerForPomodoro:_PMPomoFinished method:@selector(pomodoroFinished:)];
    [self registerForPomodoro:_PMPomoNameCanceled method:@selector(setPomodoroNametoLastBeforeCancel:)];
    [self registerForPomodoro:_PMPomoNameGiven method:@selector(pomodoroNameGiven:)];
    [self registerForPomodoro:_PMPomoWillStart method:@selector(pomodoroWillStart:)];    
   
}

- (void)dealloc {
    
    [super dealloc];
    
}

@end
