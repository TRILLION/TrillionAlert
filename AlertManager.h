//
//  AlertManager.h
//
//  本类用于管理提示窗口 是alert的管理层 开放调用接口 如下
//
//  Created by TRILLION on 16/8/10.
//  Copyright © 2016年 TRILLION. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

/**
 *  默认提示窗接口 调用该方法 传入相应信息 弹出提示框
 *
 *  @param sourceVC    弹窗页面Controller
 *  @param title       弹窗标题
 *  @param message     弹窗提示信息
 *  @param quitAction 确定按钮功能Block
 */
void defaultAlert(UIViewController * sourceVC , NSString * title, NSString * message, void(^quitAction)());

void defaultDoneAlert(NSString * title, NSString * message, void(^doneBlock)(UIAlertAction * _Nonnull action));

/**
 *  模态弹出提示 调用方法同上 @see defaultAlert
 *
 *  @param sourceVC    弹窗页面Controller
 *  @param title       弹窗标题
 *  @param message     弹窗提示信息
 *  @param quitAction 确定按钮功能Block
 */
void actionSheetAlert(UIViewController * sourceVC , NSString * title, NSString * message, void(^quitAction)());

@end
