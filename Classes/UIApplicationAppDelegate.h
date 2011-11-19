//
//  UIApplicationAppDelegate.h
//  UIApplication
//
//  Created by 大森 智史 on 08/09/02.
//  Copyright Satoshi Oomori 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplicationAppDelegate : NSObject <UIApplicationDelegate> {
	
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;

	IBOutlet UIDatePicker *aPicker;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) UIDatePicker *aPicker;

@end

