//
//  SCXcodeTabSwitcher.m
//  SCXcodeTabSwitcher
//
//  Created by Stefan Ceriu on 5/27/15.
//  Copyright (c) 2015 Stefan Ceriu. All rights reserved.
//

#import "SCXcodeTabSwitcher.h"

#import "IDESourceCodeEditor.h"
#import "IDEWorkspaceWindowController.h"

@interface SCXcodeTabSwitcher ()

@end

@implementation SCXcodeTabSwitcher

+ (void)pluginDidLoad:(NSBundle *)plugin
{
	static SCXcodeTabSwitcher *sharedPlugin;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedPlugin = [[self alloc] init];
	});
}

- (id)init
{
	if (self = [super init]) {
		
		static NSDictionary *keysToTabsMapping;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			keysToTabsMapping = @{@(18) : @(0),
								  @(19) : @(1),
								  @(20) : @(2),
								  @(21) : @(3),
								  @(23) : @(4),
								  @(22) : @(5),
								  @(26) : @(6),
								  @(28) : @(7),
								  @(25) : @(8)};
		});
		
		[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *event) {
			
			NSEventModifierFlags flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
			if(flags == NSCommandKeyMask) {
				
				NSNumber *tabNumber = keysToTabsMapping[@([event keyCode])];
				if(!tabNumber) {
					return event;
				} else {
					[self selectTabNumber:[tabNumber unsignedIntegerValue]];
					return nil;
				}
			}
			
			return event;
		}];
	}
	
	return self;
}

- (void)selectTabNumber:(NSUInteger)tabNumber
{
	NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
	IDEWorkspaceWindowController *workspaceWindowController = [IDEWorkspaceWindowController workspaceWindowControllerForWindow:keyWindow];
	
	if(tabNumber >= workspaceWindowController.tabView.numberOfTabViewItems) {
		return;
	}
	
	[workspaceWindowController _showTab:[workspaceWindowController.tabView tabViewItemAtIndex:tabNumber]];
}

@end
