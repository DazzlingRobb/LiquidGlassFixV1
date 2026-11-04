#import <UIKit/UIKit.h>

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    NSString *className = NSStringFromClass(self.class);
    // 只匹配微信原生业务控制器（类名均以 WC 开头），跳过所有系统类
    if (![className hasPrefix:@"WC"]) return;
    
    // 跳过导航栏、标签栏等容器类，只显示真正的内容页面
    if ([className containsString:@"Nav"] || 
        [className containsString:@"TabBar"] ||
        [className containsString:@"Container"]) return;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"页面控制器类名" message:className preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
