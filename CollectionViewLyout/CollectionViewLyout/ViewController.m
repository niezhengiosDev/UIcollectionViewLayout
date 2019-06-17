//
//  ViewController.m
//  CollectionViewLyout
//
//  Created by 聂政 on 2019/6/17.
//  Copyright © 2019 聂政. All rights reserved.
//

#import "ViewController.h"
#import "SDAutoLayout.h"
#import "NZCollectionViewFlowLayout.h"

#define ITEM_SPACE      10
#define ITEM_INSET      8
#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UICollectionView *listCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *widthArray;
@end

@implementation ViewController

-(NSMutableArray *)widthArray{
    if (_widthArray == nil) {
        _widthArray = [[NSMutableArray alloc] init];
    }
    return _widthArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:@[@"测试字符串",@"单词",@"长词长词长词长词长词长词长词"]];
    
    [self createUI];
    
    [self calTextWidth];
}

-(void)createUI{
    ;
    self.inputView = [[UITextField alloc] init];
    [self.view addSubview:self.inputView];
    self.inputView.sd_layout
    .leftSpaceToView(self.view, 20.0)
    .topSpaceToView(self.view, 100.0)
    .rightSpaceToView(self.view, 20.0)
    .heightIs(30.0);
    self.inputView.delegate = self;
    self.inputView.font = [UIFont systemFontOfSize:14.0];
    self.inputView.placeholder = @"请输入内容";
    self.inputView.returnKeyType = UIReturnKeyDone;
    
    NZCollectionViewFlowLayout *layout = [[NZCollectionViewFlowLayout alloc] init];
    self.listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [self.view addSubview:self.listCollectionView];
    self.listCollectionView.sd_layout
    .leftSpaceToView(self.view, 20.0)
    .topSpaceToView(self.inputView, 20.0)
    .rightSpaceToView(self.view, 20.0)
    .heightIs(150.0);
    self.listCollectionView.delegate = self;
    self.listCollectionView.dataSource = self;
    self.listCollectionView.backgroundColor = [UIColor whiteColor];
    [self.listCollectionView registerClass:[NZCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NZCollectionViewCell class])];
}


-(void)calTextWidth{

    [self.widthArray removeAllObjects];
    
    if (self.dataArray.count > 0) {
        ///计算文字长度
        for (int i = 0 ; i < self.dataArray.count; i++) {
            NSString *textStr  =self.dataArray[i];
            CGFloat textWidth = 0;
            CGRect textRect = [textStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
            textWidth = ceilf(textRect.size.width) + ITEM_INSET;
            
            textWidth = textWidth > (SCREENWIDTH-40)? SCREENWIDTH-40 : textWidth;
            [self.widthArray addObject:[NSNumber numberWithFloat:textWidth]];
        }
    }
    
    [self.listCollectionView reloadData];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NZCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.widthArray.count > 0) {
        ///根据计算出的文字长度赋值
        CGFloat width = [self.widthArray[indexPath.item] floatValue];
        return CGSizeMake(width, 30.0);
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *newStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (newStr && newStr.length > 0) {
        [self.dataArray addObject:newStr];
        [self calTextWidth];
    }
    textField.text = @"";
    return YES;
}


@end



@implementation NZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.sd_layout
        .leftSpaceToView(self.contentView, ITEM_INSET/2.0)
        .rightSpaceToView(self.contentView, ITEM_INSET/2.0)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.cornerRadius = 5.0;
    }
    return self;
}

@end
