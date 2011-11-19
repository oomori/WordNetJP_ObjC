//
//  main.m
//  UIApplication
//
//  Created by 大森 智史 on 08/09/02.
//  Copyright Satoshi Oomori 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	return retVal;
}
