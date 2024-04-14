//
//  ViewController.m
//  MeowApp
//
//  Created by Bruno Amorim on 13/04/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *meowSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Cat" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)meowSoundURL, &meowSoundId);
}


- (IBAction)onPressCat:(id)sender {
    self.onPressCat.enabled = NO;
    [self meowing];
}


- (void)meowing{
    [self removeAllLetterSublayers];
    [self waveAnimateLabel:self.label];
    AudioServicesPlaySystemSound(meowSoundId);
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(quiet) userInfo:nil repeats:NO];
}

- (void)quiet{
    self.onPressCat.enabled = YES;
    for (CALayer *sublayer in self.view.layer.sublayers) {
        if ([sublayer.name isEqualToString:@"AnimatedTextLayer"]) {
            sublayer.hidden = YES;
        }
    }

}

-(void)waveAnimateLabel:(UILabel*)label{
    NSString *text = label.text;
        
        // Calculate the width of each letter
        CGFloat letterWidth = label.frame.size.width / text.length;
    
        // Calculate the total width occupied by the letters
        CGFloat totalLettersWidth = text.length * letterWidth;
        
        // Calculate the available space for letter spacing
        CGFloat availableSpace = label.frame.size.width - totalLettersWidth;
        
        // Calculate the letter spacing based on available space and number of letters
        CGFloat letterSpacing = availableSpace / (text.length - 1);
        
        // Iterate through each character in the text
        for (NSUInteger i = 0; i < text.length; i++) {
            // Get the character at index i
            NSString *character = [text substringWithRange:NSMakeRange(i, 1)];
            
            // Create a CATextLayer for the character
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = character;
            textLayer.font = (__bridge CFTypeRef)label.font.fontName;
            textLayer.fontSize = label.font.pointSize;

            textLayer.shadowOffset = CGSizeMake(0, 5);
            textLayer.shadowColor = [UIColor blackColor].CGColor; // Set shadow color
            textLayer.shadowOpacity = 1.0; // Set shadow opacity
            textLayer.style = label.layer.style;
            
            CGFloat posX = label.frame.origin.x + (i * (letterWidth + letterSpacing)); // Adjust this line as needed based on actual layout
            CGFloat posY = label.frame.origin.y; // Adjust as per your layout
            
            // Adjust textLayer.frame to be in the view's coordinate system
            textLayer.frame = CGRectMake(posX, posY, letterWidth, label.frame.size.height);
            textLayer.name = @"AnimatedTextLayer";
            
            [self.view.layer addSublayer:textLayer]; // Add it to self.view.layer instead of self.label.layer
            
            // Create a CABasicAnimation for the rotation
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotationAnimation.fromValue = @(-M_PI / 64); // Start rotation angle
            rotationAnimation.toValue = @(M_PI / 64); // End rotation angle
            rotationAnimation.duration = 0.25; // Duration for each half of the wave
            rotationAnimation.autoreverses = YES; // Auto reverse animation
            rotationAnimation.repeatCount = HUGE_VALF; // Repeat indefinitely
            rotationAnimation.beginTime = CACurrentMediaTime() + 0.1 * i; // Apply delay to create a wave effect
            
            // Apply the animation to the textLayer
            [textLayer addAnimation:rotationAnimation forKey:@"waveAnimation"];
        }
}

- (void)removeAllLetterSublayers {
    NSMutableArray<CALayer *> *layersToRemove = [NSMutableArray array];
       
   // Assuming you've added them directly to self.view's layer.
   for (CALayer *sublayer in self.view.layer.sublayers) {
       if ([sublayer.name isEqualToString:@"AnimatedTextLayer"]) {
           [layersToRemove addObject:sublayer];
       }
   }
   
   for (CALayer *layer in layersToRemove) {
       [layer removeFromSuperlayer];
   }
}


@end
