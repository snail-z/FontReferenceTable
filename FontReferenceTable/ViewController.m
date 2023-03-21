//
//  ViewController.m
//  FontReferenceTable
//
//  Created by zhanghao on 2018/7/8.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *styles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _styles = [NSMutableArray arrayWithArray:[self familyNames]];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.attributedText = [self makeTextWithIndex:indexPath.row];
    return cell;
}

- (NSAttributedString *)makeTextWithIndex:(NSInteger)index {
    NSString *number = @"12345.67890";
    NSString *mail = @"邮箱：haozhang0770@163.com";
    NSString *name = _styles[index];
    UIFont *font = [UIFont fontWithName:name size:17];
    UIFont *largeFont = [UIFont fontWithName:name size:19];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@", number, mail, name];
    NSRange textRange = [text rangeOfString:text];
    NSRange nameRange = [text rangeOfString:name];
    
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    [attriText addAttribute:NSFontAttributeName value:font range:textRange];
    [attriText addAttribute:NSFontAttributeName value:largeFont range:nameRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:textRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:nameRange];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 7;
    [attriText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
    return attriText;
}

- (NSArray<NSString *> *)familyNames {
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSString *family in [UIFont familyNames]) {
        for (NSString *name in [UIFont fontNamesForFamilyName:family]) {
            [fontNames addObject:name];
        }
    }
    return fontNames.copy;
}

@end
