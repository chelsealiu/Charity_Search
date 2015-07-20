//
//  NewsListCell.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleDescription;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) NSURLSessionDataTask *task;

@end
