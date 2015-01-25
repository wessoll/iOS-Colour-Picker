//
//  ViewController.m
//  ColourPicker
//
//  Created by Wesley Scheper on 25/01/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Wesley Scheper
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ViewController.h"
#import "HueColour.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinGestureRecognizer;

@property (weak, nonatomic) IBOutlet UILabel *lblHue;
@property (weak, nonatomic) IBOutlet UILabel *lblSaturation;
@property (weak, nonatomic) IBOutlet UILabel *lblBrightness;

@property (strong, nonatomic) HueColour *topColour;
@property (strong, nonatomic) HueColour *bottomColour;

@end

@implementation ViewController

const double GRADIENT_INTERVAL = 20;
const double HUE_INTERVAL = 1;
const double SATURATION_INTERVAL = 0.02;
const double BRIGHTNESS_INTERVAL = 0.02;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Initial colours
    float hue = 1;
    float brightness = 1.0;
    float saturation = 1.0;
    
    self.topColour = [[HueColour alloc] colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    self.bottomColour = [[HueColour alloc] colorWithHue:(hue + GRADIENT_INTERVAL) saturation:saturation brightness:brightness alpha:1.0];
    
    [self addGradientLayer];
}

// Adds a new Layer to the View
- (void)addGradientLayer {
    // Construct UIColors
    UIColor *topColour = [UIColor colorWithHue:self.topColour.hue/365.0f saturation:self.topColour.saturation brightness:self.topColour.brightness alpha:self.topColour.alpha];
    UIColor *bottomColour = [UIColor colorWithHue:self.bottomColour.hue/365.0f saturation:self.bottomColour.saturation brightness:self.bottomColour.brightness alpha:self.bottomColour.alpha];
    
    // Add gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.name = @"Gradient";
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColour CGColor], (id)[bottomColour CGColor], nil];
    
    for (CALayer *layer in self.view.layer.sublayers) { // Remove old layer
        if ([layer.name isEqualToString:@"Gradient"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [self getSelectedColour];
}

- (void)getSelectedColour {
    // Get average of both Colours
    double avgHue = 0;
    double saturation = self.bottomColour.saturation;
    double brightness = self.bottomColour.brightness;
    
    if (self.bottomColour.hue < self.topColour.hue) { // Bottom reached boundary
        avgHue = ((self.bottomColour.hue + HUE_MAX) + self.topColour.hue) / 2;
    } else { // Default case
        avgHue = (self.topColour.hue + self.bottomColour.hue) / 2;
    }
    
    // This is the currently selected colour
    UIColor *selectedColour = [UIColor colorWithHue:avgHue saturation:saturation brightness:brightness alpha:1.0];
    
    [self.lblHue setText:[NSString stringWithFormat:@"%.2lf", avgHue]];
    [self.lblSaturation setText:[NSString stringWithFormat:@"%.2lf", saturation]];
    [self.lblBrightness setText:[NSString stringWithFormat:@"%.2lf", brightness]];
    
    
}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (velocity.y > 10 || velocity.y < -10) { // If gesture is significant for this action
        self.topColour.hue = (velocity.y > 0) ? self.topColour.hue - HUE_INTERVAL  : self.topColour.hue + HUE_INTERVAL;
        self.bottomColour.hue = (velocity.y > 0) ? self.bottomColour.hue - HUE_INTERVAL  : self.bottomColour.hue + HUE_INTERVAL;
    }
    
    if (velocity.x > 10 || velocity.x < -10) { // If gesture is significant for this action
        self.topColour.saturation = (velocity.x > 0) ? self.topColour.saturation + SATURATION_INTERVAL : self.topColour.saturation - SATURATION_INTERVAL;
        self.bottomColour.saturation = (velocity.x > 0) ? self.bottomColour.saturation + SATURATION_INTERVAL : self.bottomColour.saturation - SATURATION_INTERVAL;
    }
    
    [self addGradientLayer];
}

- (IBAction)didPinch:(UIPinchGestureRecognizer *)sender {
    
    self.topColour.brightness = (sender.scale > 1) ? self.topColour.brightness + BRIGHTNESS_INTERVAL : self.topColour.brightness - BRIGHTNESS_INTERVAL;
    self.bottomColour.brightness = (sender.scale > 1) ? self.bottomColour.brightness + BRIGHTNESS_INTERVAL : self.bottomColour.brightness - BRIGHTNESS_INTERVAL;
    
    [self addGradientLayer];
    
    sender.scale = 1.0;
}

@end
