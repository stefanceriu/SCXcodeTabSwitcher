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

NSString *const IDESourceCodeEditorDidFinishSetupNotification = @"IDESourceCodeEditorDidFinishSetup";

@interface SCXcodeTabSwitcher ()

@property (nonatomic, weak) IDEWorkspaceWindowController *workspaceWindowController;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditorDidFinishSetup:) name:IDESourceCodeEditorDidFinishSetupNotification object:nil];
        
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

- (void)onEditorDidFinishSetup:(NSNotification*)sender
{
	self.workspaceWindowController = [[IDEWorkspaceWindowController workspaceWindowControllers] firstObject];
}

- (void)selectTabNumber:(NSUInteger)tabNumber
{
    if(tabNumber >= self.workspaceWindowController.tabView.numberOfTabViewItems) {
        return;
    }
    
    [self.workspaceWindowController _showTab:[self.workspaceWindowController.tabView tabViewItemAtIndex:tabNumber]];
}

@end
