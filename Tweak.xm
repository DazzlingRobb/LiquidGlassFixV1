#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static UIView* findGlassViewInView(UIView *superview) {
    if (!superview) return nil;

    NSString *name = NSStringFromClass(superview.class);
    if ([name containsString:@"CCLiquidGlass"] ||
        [name containsString:@"LiquidGlass"] ||
        [name containsString:@"GlassView"]) {
        return superview;
    }

    for (UIView *subview in superview.subviews) {
        UIView *result = findGlassViewInView(subview);
        if (result) return result;
    }
    return nil;
}

@interface UIViewController (LiquidGlassFix)
- (void)fixGlassViewIfNeeded;
@end

@implementation UIViewController (LiquidGlassFix)

- (void)fixGlassViewIfNeeded {
    BOOL masterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"WCLiquidGlassMasterEnabled"];
    if (!masterEnabled) return;

    UIView *glassView = findGlassViewInView(self.view);
    if (!glassView) return;

    glassView.frame = self.view.bounds;
    glassView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    glassView.clipsToBounds = NO;
    glassView.layer.masksToBounds = NO;
    glassView.layer.contentsScale = UIScreen.mainScreen.scale;
    glassView.layer.rasterizationScale = UIScreen.mainScreen.scale;
    glassView.layer.shouldRasterize = NO;

    if (glassView.superview) {
        glassView.superview.clipsToBounds = NO;
        glassView.superview.layer.masksToBounds = NO;
    }

    [self.view sendSubviewToBack:glassView];
}

@end

%hook WCProfileInfoViewController

- (void)viewDidLayoutSubviews {
    %orig;
    [self fixGlassViewIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [self fixGlassViewIfNeeded];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    %orig;
    [self fixGlassViewIfNeeded];
}

%end
