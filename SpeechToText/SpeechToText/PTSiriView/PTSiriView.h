//
//  PTSiriView.h
//  SpeechToText
//
//  Created by webwerks on 11/18/17.
//  Copyright © 2017 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

@interface PTSiriView : UIView <SFSpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnStartSiri;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

+(void) checkAndRequestPermissionForSiri;
- (IBAction) btnStartSiriTapped;
-(void) startRecordingWithArrat:(NSArray*)ary;
@end
