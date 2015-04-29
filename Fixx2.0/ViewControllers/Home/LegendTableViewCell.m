//
//  LegendTableViewCell.m
//  Fixx2.0
//
//  Created by Randall Spence on 4/14/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "LegendTableViewCell.h"

@implementation LegendTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LegendTableViewCell" owner:self options:nil];
    return nib[0];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
