/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */


@class DVTStackBacktrace, IDESourceCodeEditor, IDEViewController;

@interface IDESourceCodeEditorContainerView : NSView
{
	IDESourceCodeEditor *_editor;
	IDEViewController *_toolbarViewController;
}

+ (void)initialize;
@property(retain) IDESourceCodeEditor *editor; // @synthesize editor=_editor;
- (void)primitiveInvalidate;
- (void)showToolbarWithViewController:(id)arg1;
- (void)didCompleteLayout;

// Remaining properties
@property(retain) DVTStackBacktrace *creationBacktrace;
@property(readonly) DVTStackBacktrace *invalidationBacktrace;
@property(readonly, nonatomic, getter=isValid) BOOL valid;

@end
