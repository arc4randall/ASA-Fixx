//
//  EditEventTitleCell.m
//  Fixx2.0
//
//  Created by Oliver Weng on 5/6/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "EditEventTitleCell.h"

@implementation EditEventTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditEventTitleCell" owner:self options:nil];
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
