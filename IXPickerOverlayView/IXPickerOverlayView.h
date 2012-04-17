#import <UIKit/UIKit.h>

@interface IXPickerOverlayView : UIView
@property (strong, nonatomic) IBOutlet UIView* hostPickerView;
- (UIImage*)imageForLeftPane;
- (UIImage*)imageForRightPane;
- (UIImage*)imageForSectionWheel;
- (UIImage*)imageForSectionsSeparator;
- (UIImage*)imageForTexture;
- (UIImage*)imageForGlass;
+ (UIPickerView*)findPickerInView:(UIView*)view;
@end
