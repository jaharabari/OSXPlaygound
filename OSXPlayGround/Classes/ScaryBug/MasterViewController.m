//
//  MasterViewController.m
//  OSXPlayGround
//
//  Created by Jenei Viktor on 31/01/14.
//  Copyright (c) 2014 victo. All rights reserved.
//

#import "MasterViewController.h"
#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "EDStarRating.h"

@interface MasterViewController () {
    __weak NSTableView *_bugTableView;
    __weak EDStarRating *_bugRating;
    __weak NSTextField *_bugTitleView;
    __weak NSImageView *_bugImageView;
}

@property (strong) NSMutableArray *bugs;

@property (weak) IBOutlet NSTableView *bugTableView;
@property (weak) IBOutlet NSTextField *bugTitleView;
@property (weak) IBOutlet NSImageView *bugImageView;
@property (weak) IBOutlet EDStarRating *bugRating;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ScaryBugDoc *bug1 = [[ScaryBugDoc alloc] initWithTitle:@"Potato Bug" rating:4 thumbImage:[NSImage imageNamed:@"potatoBugThumb.jpg"] fullImage:[NSImage imageNamed:@"potatoBug.jpg"]];
        ScaryBugDoc *bug2 = [[ScaryBugDoc alloc] initWithTitle:@"House Centipede" rating:3 thumbImage:[NSImage imageNamed:@"centipedeThumb.jpg"] fullImage:[NSImage imageNamed:@"centipede.jpg"]];
        ScaryBugDoc *bug3 = [[ScaryBugDoc alloc] initWithTitle:@"Wolf Spider" rating:5 thumbImage:[NSImage imageNamed:@"wolfSpiderThumb.jpg"] fullImage:[NSImage imageNamed:@"wolfSpider.jpg"]];
        ScaryBugDoc *bug4 = [[ScaryBugDoc alloc] initWithTitle:@"Lady Bug" rating:1 thumbImage:[NSImage imageNamed:@"ladybugThumb.jpg"] fullImage:[NSImage imageNamed:@"ladybug.jpg"]];
        _bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
    _bugRating.starImage = [NSImage imageNamed:@"star.png"];
    _bugRating.starHighlightedImage = [NSImage imageNamed:@"shockedface2_full.png"];
    _bugRating.starImage = [NSImage imageNamed:@"shockedface2_empty.png"];
    _bugRating.maxRating = 5.0;
    _bugRating.delegate = (id<EDStarRatingProtocol>) self;
    _bugRating.horizontalMargin = 12;
    _bugRating.editable=YES;
    _bugRating.displayMode=EDStarRatingDisplayFull;
    
    self.bugRating.rating= 0.0;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Since this is a single-column table view, this would not be necessary.
    // But it's a good practice to do it in order by remember it when a table is multicolumn.
    if( [tableColumn.identifier isEqualToString:@"BugColumn"] )
    {
        ScaryBugDoc *bugDoc = [self.bugs objectAtIndex:row];
        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = bugDoc.data.title;
        return cellView;
    }
    return cellView;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.bugs count];
}

-(ScaryBugDoc*)selectedBugDoc {
    NSInteger selectedRow = [_bugTableView selectedRow];
    if(selectedRow >=0 && self.bugs.count > selectedRow) {
        ScaryBugDoc *selectedBug = [self.bugs objectAtIndex:selectedRow];
        return selectedBug;
    }
    return nil;
    
}

-(void)setDetailInfo:(ScaryBugDoc*)doc {
    NSString    *title = @"";
    NSImage     *image = nil;
    float rating=0.0;
    if( doc != nil ) {
        title = doc.data.title;
        image = doc.fullImage;
        rating = doc.data.rating;
    }
    [_bugTitleView setStringValue:title];
    [_bugImageView setImage:image];
    [_bugRating setRating:rating];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    
    // Update info
    [self setDetailInfo:selectedDoc];
}
@end
