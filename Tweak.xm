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

static void fixGlassViewForController(UIViewController *vc) {
    BOOL masterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"WCLiquidGlassMasterEnabled"];
    if (!masterEnabled) return;

    UIView *glassView = findGlassViewInView(vc.view);
    if (!glassView) return;

    glassView.frame = vc.view.bounds;
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

    [vc.view sendSubviewToBack:glassView];
}

%hook WCProfileInfoViewController

- (void)viewDidLayoutSubviews {
    %orig;
    fixGlassViewForController((UIViewController *)self);
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    fixGlassViewForController((UIViewController *)self);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    %orig;
    fixGlassViewForController((UIViewController *)self);
}

%end
