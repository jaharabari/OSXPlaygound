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
#import <Quartz/Quartz.h>
#import "NSImage+Extras.h"

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

#pragma mark - VC Method(s)

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
    _bugRating.editable = YES;
    _bugRating.displayMode = EDStarRatingDisplayFull;
    
    self.bugRating.rating= 0.0;
}

#pragma mark - TableView DataSource And Delegate Method(s)

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

#pragma mark - Button Action(s)

- (IBAction)removeButtonPressed:(id)sender {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc) {
        [self.bugs removeObject:selectedDoc];

        [_bugTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_bugTableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];

        [self setDetailInfo:nil];
    }
}

- (IBAction)addButtonPressed:(id)sender {
    ScaryBugDoc *newDoc = [[ScaryBugDoc alloc] initWithTitle:@"New Bug" rating:0.0 thumbImage:nil fullImage:nil];
    
    [self.bugs addObject:newDoc];
    NSInteger newRowIndex = self.bugs.count-1;
    
    [_bugTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    
    [_bugTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [_bugTableView scrollRowToVisible:newRowIndex];
}

- (IBAction)bugTitleDidEndEditing:(id)sender {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc) {
        // 2. Get the new name from the text field
        selectedDoc.data.title = [self.bugTitleView stringValue];
        // 3. Update the cell
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedDoc]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [_bugTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}

- (IBAction)changePicture:(id)sender {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if(selectedDoc) {
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

#pragma mark - Instance Method(s)

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

#pragma mark - Rating Delegate method(s)

-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating {
    ScaryBugDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc) {
        selectedDoc.data.rating = self.bugRating.rating;
    }
}

#pragma mark - PictureTaker Delegate

- (void) pictureTakerDidEnd:(IKPictureTaker *) picker
                 returnCode:(NSInteger) code
                contextInfo:(void*) contextInfo
{
    NSImage *image = [picker outputImage];
    if(image !=nil && (code == NSOKButton)) {
        [self.bugImageView setImage:image];
        ScaryBugDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc )
        {
            selectedBugDoc.fullImage = image;
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [_bugTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}

@end
