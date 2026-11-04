#import <UIKit/UIKit.h>

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // 只处理当前最顶层控制器，避免子控制器重复弹窗
    UIViewController *topVC = self;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if (topVC != self) return;
    
    NSString *className = NSStringFromClass(self.class);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前控制器类名" message:className preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
