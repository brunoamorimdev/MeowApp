//
//  ViewController.h
//  MeowApp
//
//  Created by Bruno Amorim on 13/04/24.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController {
    SystemSoundID meowSoundId;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *onPressCat;

- (IBAction)onPressCat:(id)sender;


@end

