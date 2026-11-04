#import <UIKit/UIKit.h>

%hook WCProfileInfoViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"补丁命中" message:@"成功进入我页面控制器" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [(UIViewController *)self presentViewController:alert animated:YES completion:nil];
}

%end
