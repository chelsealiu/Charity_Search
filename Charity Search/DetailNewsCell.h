//
//  CustomCell.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNewsCell : UICollectionViewCell

@property (strong, nonatomic) NSURLSessionTask *task; 
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@end


