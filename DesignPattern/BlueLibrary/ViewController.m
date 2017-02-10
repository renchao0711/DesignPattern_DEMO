//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "AlbumView.h"
#import "HorizontalScroller.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,HorizontalScrollerDelegate>

@end

@implementation ViewController
{
    UITableView *dataTable;
    
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    
    HorizontalScroller *scroller;
    
    UIToolbar *toolBar;
    NSMutableArray *undoStack;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    currentAlbumIndex = 0;
    
    allAlbums = [[LibraryAPI shareInstance] getAlbums];
    
    dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self loadPreviousState];
    scroller = [[HorizontalScroller alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 130)];
    scroller.backgroundColor = [UIColor darkGrayColor];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    [self reloadScroller];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    toolBar = [[UIToolbar alloc]init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self   action:@selector(deleteAlbum)];
    [toolBar setItems:@[undoItem,space,delete]];
    [self.view addSubview:toolBar];
    undoStack = [[NSMutableArray alloc]init];
}

-(void)viewWillLayoutSubviews{
    toolBar.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    dataTable.frame = CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-120);
}

-(void)showDataForAlbumAtIndex:(int)albumIndex{
    if (albumIndex < allAlbums.count) {
        Album *album = allAlbums[albumIndex];
        currentAlbumData = [album tr_tableRepresentation];
    }
    else{
        currentAlbumData = nil;
    }
    [dataTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [currentAlbumData[@"titles"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    return cell;
}

#pragma Horizontal代理
-(NSInteger)numberOfViewForHorizontalScroller:(HorizontalScroller *)scroller{
    return allAlbums.count;
}

-(UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index{
    Album *album = allAlbums[index];
    return [[AlbumView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
    
}

-(void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index{
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

-(void)reloadScroller{
    allAlbums = [[LibraryAPI shareInstance] getAlbums];
    if (currentAlbumIndex < 0) {
        currentAlbumIndex = 0;
    }
    else if (currentAlbumIndex >= allAlbums.count){
        currentAlbumIndex = (int)allAlbums.count-1;
    }
    [scroller reload];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

-(void)saveCurrentState{
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI shareInstance] saveAlbums];
}

-(void)loadPreviousState{
    currentAlbumIndex = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller{
    return currentAlbumIndex;
}

//增加专辑
-(void)addAlbum:(Album *)album atIndex:(int)index{
    [[LibraryAPI shareInstance] addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroller];
}
//删除专辑
-(void)deleteAlbum{
    Album *deleteAlbum = allAlbums[currentAlbumIndex];
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addAlbum:atIndex:)];
    [undoAction setArgument:&deleteAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    [undoStack addObject:undoAction];
    
    [[LibraryAPI shareInstance]deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    
    [toolBar.items[0] setEnabled:YES];
}
//撤销操作
-(void)undoAction{
    if (undoStack.count > 0) {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
    }
    if (undoStack.count == 0) {
        [toolBar.items[0] setEnabled:NO];
    }
}

@end
