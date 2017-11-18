//
//  PTSiriView.m
//  SpeechToText
//
//  Created by webwerks on 11/18/17.
//  Copyright © 2017 PT. All rights reserved.
//

#import "PTSiriView.h"

@implementation PTSiriView
{
    SFSpeechRecognizer *speechRecognizer;
    AVAudioEngine *audioEngine;
    SFSpeechAudioBufferRecognitionRequest *bufferRecognitionRequest;
    SFSpeechRecognitionTask *speechRecognitionTask;
    AVAudioInputNode *inputNode;
    NSMutableArray *aryData;

}
-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupSiriView];
}

-(void) setupSiriView {
    
    // Initialize Speech Recognizer
    if(!speechRecognizer) {
        speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        speechRecognizer.delegate = self;
    }
}

+(void) checkAndRequestPermissionForSiri {
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }];
}

-(void) startRecordingWithArrat:(NSArray*)ary {
    
    [aryData removeAllObjects];
    aryData = nil;
    aryData = [[NSMutableArray alloc] initWithArray:ary];
    
    [self stopSiri];
    // Initialise an Audio Engine
    if(!audioEngine) {
    audioEngine = [[AVAudioEngine alloc] init];
    }
    if (bufferRecognitionRequest) {
        [speechRecognitionTask cancel];
        speechRecognitionTask = nil;
    }
    
    // Starts an Audio Session
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    // Starts a recognition process.
    bufferRecognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    inputNode = audioEngine.inputNode;
    bufferRecognitionRequest.shouldReportPartialResults = YES;
    speechRecognitionTask = [speechRecognizer recognitionTaskWithRequest:bufferRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result) {
            isFinal = !result.isFinal;
            [self checkString:[[result.bestTranscription.segments valueForKey:@"substring"] lastObject]];
        }
        if (error) {
            [audioEngine stop];
            [inputNode removeTapOnBus:0];
            bufferRecognitionRequest = nil;
            speechRecognitionTask = nil;
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [bufferRecognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [audioEngine prepare];
    [audioEngine startAndReturnError:&error];
    NSLog(@"Say Something, I'm listening");
    
    
}

-(void) stopSiri {
    [audioEngine stop];
    [inputNode removeTapOnBus:0];
    [bufferRecognitionRequest endAudio];
    [speechRecognitionTask cancel];
    bufferRecognitionRequest = nil;
    speechRecognitionTask = nil;
}

- (IBAction) btnStartSiriTapped {
    
    [self stopSiri];
    self.alpha = 0.0f;
}

#pragma mark - SFSpeechRecognizerDelegate Delegate Methods

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"Availability:%d",available);
    
}

-(void) checkString:(NSString *)str {
    
    self.lblName.text = str;
    self.lblName.textColor = [UIColor redColor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"alternative contains[cd] %@", str];
    NSArray *result = [aryData filteredArrayUsingPredicate:predicate];

    if(result.count){
        self.lblName.text = [NSString stringWithFormat:@"Alternative name for %@ is %@",str, [[result firstObject] valueForKey:@"name"]];
        self.lblName.textColor = [UIColor greenColor];

    }
}


@end
