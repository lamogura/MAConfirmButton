//
//  MAConfirmButton.h
//
//  Created by Mike on 11-03-28.
//  Copyright 2011 Mike Ahmarani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
  MAConfirmButtonToggleAnimationLeft = 0,
  MAConfirmButtonToggleAnimationRight = 1,
  MAConfirmButtonToggleAnimationCenter =2

} MAConfirmButtonToggleAnimation;

@interface MAConfirmButton : UIButton

@property MAConfirmButtonToggleAnimation toggleAnimation;
@property NSString *maTitle;
@property NSString *maConfirmTitle;
@property NSString *maDisabledTitle;
@property UIColor *maTint;
//@property BOOL buttonSelected;
@property BOOL confirmed;

+ (MAConfirmButton *)buttonWithTitle:(NSString *)titleString confirm:(NSString *)confirmString;
+ (MAConfirmButton *)buttonWithDisabledTitle:(NSString *)disabledString;
//- (id)initWithTitle:(NSString *)titleString confirm:(NSString *)confirmString;
//- (id)initWithDisabledTitle:(NSString *)disabledString;
- (void)disableWithTitle:(NSString *)disabledString;
- (void)setTitle:(NSString *)title andConfirm:(NSString*)confirm;

- (void)setAnchor:(CGPoint)anchor;
//- (void)setMaTint:(UIColor *)color;
- (void)setTitle:(NSString *)title andConfirm:(NSString*)confirm;
//- (void)setConfirmed:(BOOL)isConfirmed;
- (void)cancel;
//- (void)setButtonSelected:(BOOL)newButtonSelected;

@end
