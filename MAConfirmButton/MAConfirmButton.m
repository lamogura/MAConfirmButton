//
//  MAConfirmButton.m
//
//  Created by Mike on 11-03-28.
//  Copyright 2011 Mike Ahmarani. All rights reserved.
//

#import "MAConfirmButton.h"
#import "UIColor-Expanded.h"

#define kHeight 26.0
#define kPadding 20.0
#define kFontSize 14.0
#define kTint [UIColor colorWithRed:0.220 green:0.357 blue:0.608 alpha:1]
#define kTintDisabled [UIColor colorWithWhite:0.85 alpha:1]

@interface MAConfirmButton ()
@property (nonatomic, retain) CALayer *colorLayer;
@property (nonatomic, retain) CALayer *darkenLayer;
@property (nonatomic, retain) UIButton *cancelOverlay;

- (void)toggle;
- (void)setupLayers;
- (void)cancel;
- (void)lighten;
- (void)darken;

@end

@implementation MAConfirmButton
+ (instancetype)buttonWithTitle:(NSString *)titleString confirm:(NSString *)confirmString {
//    MAConfirmButton *button = [[super alloc] initWithTitle:titleString confirm:confirmString];
    
    CGSize size = [titleString sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
    
    CGRect r = CGRectZero;
    r.size.height = kHeight;
    r.size.width = size.width+kPadding;
    
    MAConfirmButton *button = [[MAConfirmButton alloc] initWithFrame:r];
    button.maTitle = titleString;
    button.maConfirmTitle = confirmString;
//    [button setTitle:button.maTitle forState:UIControlStateNormal];
    button.maTint = kTint;
    
    return button;
}

+ (instancetype)buttonWithDisabledTitle:(NSString *)disabledString {
//    MAConfirmButton *button = [[super alloc] initWithDisabledTitle:disabledString];
    CGSize size = [disabledString sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
    
    CGRect r = CGRectZero;
    r.size.height = kHeight;
    r.size.width = size.width + kPadding;
    
    MAConfirmButton *button = [[MAConfirmButton alloc] initWithFrame:r];
    button.maDisabledTitle = disabledString;
//    [button setTitle:button.maDisabledTitle forState:UIControlStateNormal];
    button.maTint = kTintDisabled;
    button.disabled = YES;
    
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton];
    }
    return self;
}

//- (id)initWithDisabledTitle:(NSString *)disabledString {
//    self = [super initWithFrame:CGRectZero];
//    if (self != nil) {
//        _maDisabledTitle = disabledString;
//
//        _toggleAnimation = MAConfirmButtonToggleAnimationLeft;
//
//        self.layer.needsDisplayOnBoundsChange = YES;
//        self.maTint = [UIColor colorWithWhite:0.85 alpha:1];
//
//        CGSize size = [self.maDisabledTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
//
//        CGRect r = self.frame;
//        r.size.height = kHeight;
//        r.size.width = size.width+kPadding;
//        self.frame = r;
//
//        [self setTitle:self.maDisabledTitle forState:UIControlStateNormal];
//        [self setTitleColor:self.maTint forState:UIControlStateNormal];
//        
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
//        
//        [self setupLayers];
//    }
//    return self;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initButton];
}

- (void) initButton
{
    _toggleAnimation = MAConfirmButtonToggleAnimationLeft;
    self.layer.needsDisplayOnBoundsChange = YES;
    
    [self setTitleColor:self.maTint forState:UIControlStateNormal];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
    
    [self setupLayers];
    
    [self addObserver:self forKeyPath:@"maTint" options:0 context:nil];
    [self addObserver:self forKeyPath:@"confirmed" options:NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"maDisabledTitle" options:0 context:nil];
    [self addObserver:self forKeyPath:@"maTitle" options:0 context:nil];
    [self addObserver:self forKeyPath:@"maConfirmTitle" options:0 context:nil];
    [self addObserver:self forKeyPath:@"disabled" options:0 context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"maTint"];
    [self removeObserver:self forKeyPath:@"confirmed"];
    [self removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"maDisabledTitle"];
    [self removeObserver:self forKeyPath:@"maConfirmTitle"];
    [self removeObserver:self forKeyPath:@"disabled"];
}

//- (id)initWithTitle:(NSString *)titleString confirm:(NSString *)confirmString {
//    self = [super initWithFrame:CGRectZero];
//    if (self != nil) {
//        _maTitle = titleString;
//        _maConfirmTitle = confirmString;
//
//        _toggleAnimation = MAConfirmButtonToggleAnimationLeft;
//        _maTint = [UIColor colorWithRed:0.220 green:0.357 blue:0.608 alpha:1];
//
//        self.layer.needsDisplayOnBoundsChange = YES;
//
//        CGSize size = [self.maTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
//
//        CGRect r = self.frame;
//        r.size.height = kHeight;
//        r.size.width = size.width+kPadding;
//        self.frame = r;
//
//        [self setTitle:self.maTitle forState:UIControlStateNormal];
//        [self setTitleColor:self.maTint forState:UIControlStateNormal];
//        
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
//        
//        [self setupLayers];
//    }
//    return self;
//}

- (void)toggle {
    if (self.userInteractionEnabled) {
        self.userInteractionEnabled = NO;
        self.titleLabel.alpha = 0;
        UIColor *tintColor = self.tintColor;
        self.tintColor = [UIColor clearColor];
        
        CGSize size;

        if (self.disabled) {
            [self setTitle:self.maDisabledTitle forState:UIControlStateNormal];
            [self setTitleColor:self.maTint forState:UIControlStateNormal];
            size = [self.maDisabledTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
        } else if (self.selected) {
            [self setTitle:self.maConfirmTitle forState:UIControlStateNormal];
            size = [self.maConfirmTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
        } else {
            [self setTitle:self.maTitle forState:UIControlStateNormal];
            size = [self.maTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
        }
        
        size.width += kPadding;
        float offset = size.width - self.frame.size.width;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.25];
        [CATransaction setCompletionBlock:^{
            //Readjust button frame for new touch area, move layers back now that animation is done
            
            CGRect frameRect = self.frame;
            switch(self.toggleAnimation) {
                case MAConfirmButtonToggleAnimationLeft:
                    frameRect.origin.x = frameRect.origin.x - offset;
                    break;
                case MAConfirmButtonToggleAnimationRight:
                    break;
                case MAConfirmButtonToggleAnimationCenter:
                    frameRect.origin.x = frameRect.origin.x - offset/2.0;
                    break;
                default:
                    break;
            }
            frameRect.size.width = frameRect.size.width + offset;
            self.frame = frameRect;
            
            [CATransaction setDisableActions:YES];
            [CATransaction setCompletionBlock:^{
                self.userInteractionEnabled = YES;
            }];
            for (CALayer *layer in self.layer.sublayers) {
                CGRect rect = layer.frame;
                switch(self.toggleAnimation) {
                    case MAConfirmButtonToggleAnimationLeft:
                        rect.origin.x = rect.origin.x+offset;
                        break;
                    case MAConfirmButtonToggleAnimationRight:
                        break;
                    case MAConfirmButtonToggleAnimationCenter:
                        rect.origin.x = rect.origin.x+offset/2.0;
                        break;
                    default:
                        break;
                }
                
                layer.frame = rect;
            }
            [CATransaction commit];
            
            self.titleLabel.alpha = 1;
            self.tintColor = tintColor;
            [self setNeedsLayout];
        }];
        
        UIColor *greenColor = [UIColor colorWithRed:0.439 green:0.741 blue:0.314 alpha:1.];
        
        //Animate color change
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        colorAnimation.removedOnCompletion = NO;
        colorAnimation.fillMode = kCAFillModeForwards;
        
        UIColor* titleColor;
        
        if (self.disabled) {
            colorAnimation.fromValue = (id)greenColor.CGColor;
            colorAnimation.toValue = (id)[UIColor colorWithWhite:0.85 alpha:1].CGColor;
            titleColor = [UIColor colorWithWhite:0.85 alpha:1];
        } else {
            colorAnimation.fromValue = self.selected ? (id)self.maTint.CGColor : (id)greenColor.CGColor;
            colorAnimation.toValue = self.selected ? (id)greenColor.CGColor : (id)self.maTint.CGColor;
            titleColor = self.selected ? greenColor : self.maTint;
        }
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        
        [self.colorLayer addAnimation:colorAnimation forKey:@"colorAnimation"];

        //Animate layer scaling
        for (CALayer *layer in self.layer.sublayers) {
            CGRect rect = layer.frame;
            
            switch(self.toggleAnimation) {
                case MAConfirmButtonToggleAnimationLeft:
                    rect.origin.x = rect.origin.x-offset;
                    break;
                case MAConfirmButtonToggleAnimationRight:
                    break;
                case MAConfirmButtonToggleAnimationCenter:
                    rect.origin.x = rect.origin.x-offset/2.0;
                    break;
                default:
                    break;
            }
            rect.size.width = rect.size.width+offset;
            layer.frame = rect;
        }
        
        [CATransaction commit];
        [self setNeedsDisplay];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setupLayers {
  
    self.colorLayer = [CALayer layer];
    self.colorLayer.backgroundColor = [[UIColor clearColor] CGColor];
    self.colorLayer.frame = CGRectMake(0, 1, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-2);
    self.colorLayer.borderColor = self.maTint.CGColor;
    self.colorLayer.borderWidth = 1.0;
    self.colorLayer.cornerRadius = 4.0;
    self.colorLayer.needsDisplayOnBoundsChange = YES;

    [self.layer addSublayer:self.colorLayer];
    [self bringSubviewToFront:self.titleLabel];
}

//- (void)setButtonSelected:(BOOL)buttonSelected
//{
//    _buttonSelected = buttonSelected;
//    self.selected = buttonSelected;
//    [self toggle];
//}

- (void)disableWithTitle:(NSString *)disabledString {
    self.maDisabledTitle = disabledString;
    [self toggle];
}

- (void)setAnchor:(CGPoint)anchor {
    //Top-right point of the view (MUST BE SET LAST)
    CGRect rect = self.frame;
    rect.origin = CGPointMake(anchor.x - rect.size.width, anchor.y);
    self.frame = rect;
}

//- (void)setMaTint:(UIColor *)color {
//    if (_maTint != color) {
//        _maTint = color;
//        _colorLayer.borderColor = _maTint.CGColor;
//        [self setTitleColor:_maTint forState:UIControlStateNormal];
//        [self setNeedsDisplay];
//        [self setNeedsUpdateConstraints];
//    }
//}

- (void)setTitle:(NSString *)newtitle andConfirm:(NSString *)newConfirm {
    self.maTitle = newtitle;
    self.maConfirmTitle = newConfirm;
    if (!self.colorLayer) {
        [self setupLayers];
    }
    
    CGSize size = [newtitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kFontSize]}];
    CGRect r = self.frame;
    r.size.height = kHeight;
    r.size.width = size.width+kPadding;
    self.frame = r;
    
    [self setTitle:newtitle forState:UIControlStateNormal];
    [self setTitleColor:self.maTint forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
    [self setNeedsUpdateConstraints];
}

- (void)darken {
    self.darkenLayer = [CALayer layer];
    self.darkenLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.darkenLayer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.darkenLayer.cornerRadius = 4.0;
    self.darkenLayer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:self.darkenLayer];
}

- (void)lighten {
    if (self.darkenLayer) {
        [self.darkenLayer removeFromSuperlayer];
        self.darkenLayer = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (!self.disabled && !self.confirmed && self.userInteractionEnabled) {
        [self darken];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
    if (!self.disabled && !self.confirmed && self.userInteractionEnabled) {
        if (!CGRectContainsPoint(self.frame, [[touches anyObject] locationInView:self.superview])) { //TouchUpOutside (Cancelled Touch)
            [self lighten];
            [super touchesCancelled:touches withEvent:event];
//        } else if (self.selected) {
//            [self buttonDidConfirm];
//            [super touchesEnded:touches withEvent:event];
        } else {
            [self lighten];		
            self.selected = YES;
            if (!self.cancelOverlay) {
                UIApplication *app = [UIApplication sharedApplication];
                _cancelOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
                [_cancelOverlay setFrame:app.keyWindow.bounds];
                [_cancelOverlay addTarget:self action:@selector(handleCancelOverlayTouch:event:) forControlEvents:UIControlEventTouchDown];
                [app.keyWindow addSubview:_cancelOverlay];
            }
        }
    }
}

- (void) buttonDidConfirm
{
    [self lighten];
    self.confirmed = YES;
    [self.cancelOverlay removeFromSuperview];
    self.cancelOverlay = nil;
}

- (void)handleCancelOverlayTouch:(id)sender event:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt)) {
        [self buttonDidConfirm];    // change to confirmed state first
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self cancel];
    }
}

- (void)cancel {
    if (self.cancelOverlay && self.userInteractionEnabled) {
        [self.cancelOverlay removeFromSuperview];
        self.cancelOverlay = nil;
    }	
    self.selected = NO;
    self.disabled = NO;
    self.confirmed = NO;
    [self toggle];
}

//- (BOOL)isDisabled{
//    return _disabled;
//}

//- (void)setConfirmed:(BOOL)isConfirmed
//{
//    _confirmed = isConfirmed;
//    [self toggle];
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self == object) {
        if ([@"confirmed" isEqualToString:keyPath]) {
            if (![@(self.confirmed) isEqualToNumber:change[NSKeyValueChangeOldKey]]) {
                [self toggle];
            }
        }else if ([@"maTint"isEqualToString:keyPath]) {
            self.colorLayer.borderColor = self.maTint.CGColor;
            [self setTitleColor:self.maTint forState:UIControlStateNormal];
            [self setNeedsDisplay];
            [self setNeedsUpdateConstraints];
        }else if ([@"selected" isEqualToString:keyPath]) {
            if (![@(self.selected) isEqualToNumber:change[NSKeyValueChangeOldKey]]) {
                [self toggle];
            }
        }else if ([@"maDisabledTitle" isEqualToString:keyPath]) {
            if (self.disabled) {
                [self setTitle:self.maDisabledTitle forState:UIControlStateNormal];
            }
        }else if ([@"maTitle" isEqualToString:keyPath]) {
            if (!self.disabled && !self.confirmed) {
                [self setTitle:self.maTitle forState:UIControlStateNormal];
            }
        }else if ([@"maConfirmTitle" isEqualToString:keyPath]) {
            if (self.confirmed) {
                [self setTitle:self.maConfirmTitle forState:UIControlStateNormal];
            }
        }else if ([@"disabled" isEqualToString:keyPath]) {
            if (self.disabled) {
                [self setTitle:self.maDisabledTitle forState:UIControlStateNormal];
            }else if (self.confirmed) {
                [self setTitle:self.maConfirmTitle forState:UIControlStateNormal];
            }else {
                [self setTitle:self.maTitle forState:UIControlStateNormal];
            }
        }
    }
}
@end