//
//  HueColour.m
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

#import "HueColour.h"

@implementation HueColour

const double HUE_MIN = 1;
const double HUE_MAX = 365;
const double SATURATION_MIN = 0.0;
const double SATURATION_MAX = 1.0;
const double BRIGHTNESS_MIN = 0.0;
const double BRIGHTNESS_MAX = 1.0;

@synthesize hue = _hue;
@synthesize saturation = _saturation;
@synthesize brightness = _brightness;
@synthesize alpha = _alpha;

- (instancetype)colorWithHue:(double)hue saturation:(double)saturation brightness:(double)brightness alpha:(double)alpha {
    
    [self setHue:hue];
    [self setSaturation:saturation];
    [self setBrightness:brightness];
    [self setAlpha:alpha];
    
    return self;
}

- (void)setHue:(double)hue {
    _hue = hue;
    
    if (_hue < HUE_MIN) {
        _hue = HUE_MAX;
    } else if (_hue > HUE_MAX) {
        _hue = HUE_MIN;
    }
}

- (void)setSaturation:(double)saturation {
    _saturation = saturation;
    
    if (_saturation < SATURATION_MIN) {
        _saturation = SATURATION_MIN;
    } else if (_saturation > SATURATION_MAX) {
        _saturation = SATURATION_MAX;
    }
}

- (void)setBrightness:(double)brightness {
    _brightness = brightness;
    
    if (_brightness < BRIGHTNESS_MIN) {
        _brightness = BRIGHTNESS_MIN;
    } else if (_brightness > BRIGHTNESS_MAX) {
        _brightness = BRIGHTNESS_MAX;
    }
}


@end
