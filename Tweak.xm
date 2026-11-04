#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define kGlassViewClassPrefix @"CCLiquidGlass"

static UIView* findGlassViewInView(UIView *superview) {
    if (!superview) return nil;
    if ([NSStringFromClass(superview.class) containsString:kGlassViewClassPrefix]) {
        return superview;
    }
    for (UIView *subview in superview.subviews) {
        UIView *result = findGlassViewInView(subview);
        if (result) return result;
    }
    return nil;
}

%hook WCProfileInfoViewController

- (void)viewDidLayoutSubviews {
    %orig;
    
    BOOL masterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"WCLiquidGlassMasterEnabled"];
    if (!masterEnabled) return;
    
    UIViewController *vc = (UIViewController *)self;
    UIView *glassView = findGlassViewInView(vc.view);
    if (!glassView) return;
    
    CGRect fixedFrame = vc.view.bounds;
    fixedFrame.origin.y = 0;
    fixedFrame.size.height = vc.view.bounds.size.height;
    
    if (!CGRectEqualToRect(glassView.frame, fixedFrame)) {
        glassView.frame = fixedFrame;
        [vc.view sendSubviewToBack:glassView];
    }
    
    glassView.superview.clipsToBounds = NO;
    glassView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    %orig;
    
    BOOL masterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"WCLiquidGlassMasterEnabled"];
    if (!masterEnabled) return;
    
    UIViewController *vc = (UIViewController *)self;
    UIView *glassView = findGlassViewInView(vc.view);
    if (!glassView) return;
    
    CGRect frame = glassView.frame;
    frame.origin.y = 0;
    frame.size.height = vc.view.bounds.size.height;
    glassView.frame = frame;
}

%end
