//
//  UIApplicationAppDelegate.m
//  UIApplication
//
//  Created by 大森 智史 on 08/09/02.
//  Copyright Satoshi Oomori 2008. All rights reserved.
//

#import "UIApplicationAppDelegate.h"
#import "RootViewController.h"


@implementation UIApplicationAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize aPicker;


- (id)init {
	if (self == [super init]) {
		// 
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    /*	
	//日付ピッカーはUIPickerViewのサブクラスではない。
	aPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320,80)];
*/
  //  [window addSubview:aPicker];
    [window makeKeyAndVisible];
	
	
	//NSLog(@"%@",[[application keyWindow] description]);
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
