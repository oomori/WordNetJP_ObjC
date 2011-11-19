//
//  Controll.h
//  UIApplication
//
//  Created by 大森 智史 on 08/09/17.
//  Copyright 2008 Satoshi Oomori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIApplicationAppDelegate.h"

@interface Controll : NSObject {
	IBOutlet UITextField *theField;
	IBOutlet UILabel *theLabel;
	IBOutlet UIApplicationAppDelegate *appDelegate;

}
-(IBAction)sliderAction:(id)sender;
-(IBAction)buttonAction:(id)sender;
@end
