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

#import <Foundation/Foundation.h>
#import "CommonController.h"
#import <ShortcutRecorder/SRRecorderControl.h>

@class PTHotKey;

@interface ShortcutController : CommonController {

    IBOutlet id delegate;
    
    IBOutlet SRRecorderControl* muteRecorder;
    IBOutlet SRRecorderControl* startRecorder;
    IBOutlet SRRecorderControl* finishRecorder;
    IBOutlet SRRecorderControl* resetRecorder;
    IBOutlet SRRecorderControl* interruptRecorder;
    IBOutlet SRRecorderControl* internalInterruptRecorder;
    IBOutlet SRRecorderControl* resumeRecorder;
    IBOutlet SRRecorderControl* quickStatsRecorder;
	
	PTHotKey *muteKey;
	PTHotKey *startKey;
    PTHotKey *finishKey;
	PTHotKey *resetKey;
	PTHotKey *interruptKey;
	PTHotKey *internalInterruptKey;
	PTHotKey *resumeKey;
	PTHotKey *quickStatsKey;
	
	KeyCombo muteKeyCombo;
	KeyCombo startKeyCombo;
    KeyCombo finishKeyCombo;
	KeyCombo resetKeyCombo;
	KeyCombo interruptKeyCombo;
	KeyCombo internalInterruptKeyCombo;
	KeyCombo resumeKeyCombo;
	KeyCombo quickStatsKeyCombo;
}

@property (assign) IBOutlet id delegate;

@property (assign) IBOutlet SRRecorderControl* muteRecorder;
@property (assign) IBOutlet SRRecorderControl* startRecorder;
@property (assign) IBOutlet SRRecorderControl* finishRecorder;
@property (assign) IBOutlet SRRecorderControl* resetRecorder;
@property (assign) IBOutlet SRRecorderControl* interruptRecorder;
@property (assign) IBOutlet SRRecorderControl* internalInterruptRecorder;
@property (assign) IBOutlet SRRecorderControl* resumeRecorder;
@property (assign) IBOutlet SRRecorderControl* quickStatsRecorder;

- (void) updateShortcuts;

@end
