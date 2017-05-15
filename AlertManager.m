#import "AlertManager.h"

#define ROOTVC [UIApplication sharedApplication].keyWindow.rootViewController

#define TOPVC topVC()

/**
 *  防止进行多次alert弹出 使用此变量进行容错判断
 */
BOOL presenting = NO;

@implementation AlertManager

void defaultDoneAlert(NSString * title, NSString * message, void(^doneBlock)(UIAlertAction * _Nonnull action)) {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];

    if (doneBlock) {
        
        UIAlertAction * defAction = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                   doneBlock(action);
                                                           }];
        
        [alert addAction:defAction];
        
    }

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //解放锁定弹出框状态
                                                              presenting = NO;
                                                          }];
    
    [alert addAction:cancelAction];
    
    
    
    [ROOTVC presentViewController:alert
                         animated:YES
                       completion:nil];

}

void ultimateAlert(NSString * title, NSString * message, UIAlertAction * doneAction) {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    //有确定按钮 则add之……
    if (doneAction) [alert addAction:doneAction];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //解放锁定弹出框状态
                                                              presenting = NO;
                                                          }];
    
    [alert addAction:cancelAction];
    
    [TOPVC presentViewController:alert animated:YES completion:nil];

}

UIViewController * topVC() {
    
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (topVC.presentedViewController) topVC = topVC.presentedViewController;
    
    return topVC;
}

void defaultAlert(UIViewController * sourceVC , NSString * title, NSString * message, void(^quitAction)()) {
    alert(sourceVC, UIAlertControllerStyleAlert, title, message, quitAction);
}

void actionSheetAlert(UIViewController * sourceVC , NSString * title, NSString * message, void(^quitAction)()) {
    alert(sourceVC, UIAlertControllerStyleActionSheet, title, message, quitAction);
}

/**
 *  该方法不开放 仅在Manager内部调用
 *
 *  @param sourceVC    弹窗页面Controller
 *  @param style       弹窗样式（目前只使用系统样式）
 *  @param title       弹窗标题
 *  @param message     弹窗提示信息
 *  @param quitAction 确定按钮功能Block
 */
void alert(UIViewController * sourceVC , UIAlertControllerStyle style, NSString * title, NSString * message,void(^quitAction)()) {
    
    //判断是否为多次弹出alert
    if (presenting) {
        printf("Oh shit ! you want me do what!!!?!!\n");
        return;
    }
    
    //锁定弹出框状态 规避重复present情况
    presenting = YES;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:style];
    
    UIAlertAction * defAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           //解放锁定弹出框状态
                                                           presenting = NO;
                                                           //判断block是否为空
                                                           if (quitAction)
                                                               quitAction();
                                                           
                                                       }];
    
    [alert addAction:defAction];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //解放锁定弹出框状态
                                                              presenting = NO;
                                                          }];
    
    [alert addAction:cancelAction];
    
    [sourceVC presentViewController:alert
                           animated:YES
                         completion:nil];
    
}

void test() {
    printf("Has been present!\n");
}

@end
