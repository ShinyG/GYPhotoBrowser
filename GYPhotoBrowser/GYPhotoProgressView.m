//
//  GYPhotoProgressView.m
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/22.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "GYPhotoProgressView.h"

@interface GYPhotoProgressView()
@property (nonatomic , strong) UILabel *progressLabel;
@property (nonatomic , assign) BOOL autoFrame;
@property (nonatomic , assign) BOOL isFinished;
@property (nonatomic , copy) FinishedBlock block;
@end

@implementation GYPhotoProgressView

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont boldSystemFontOfSize:17];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _progressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.progressLabel];
        self.lineWidth = 5;
        self.circleColor = [UIColor whiteColor];
        self.doAnim = YES;
        self.autoFrame = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (!self.isFinished) {
        [self setNeedsDisplay];
    }
    if (progress == 1.0 && !self.isFinished) {
        
        if (self.block) {
            self.block(self);
        }
        
        if (self.doAnim) {
            CATransition *anim = [CATransition animation];
            anim.type = @"rippleEffect";
            anim.duration = 0.5;
            [self.progressLabel.layer addAnimation:anim forKey:nil];
        }
        
        self.isFinished = YES;
    }
}

- (void)setFinishedBlock:(FinishedBlock)finishedBlock
{
    self.block = finishedBlock;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.progressLabel.textColor = textColor;
}

- (void)setTextFontSize:(CGFloat)textFontSize
{
    _textFontSize= textFontSize;
    self.progressLabel.font = [UIFont boldSystemFontOfSize:textFontSize];
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - self.lineWidth;
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",self.progress*100];
    CGFloat endAngel = -M_PI_2 + M_PI * 2 * self.progress * 1.0;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
    bgPath.lineCapStyle = kCGLineCapRound;
    bgPath.lineJoinStyle = kCGLineJoinRound;
    bgPath.lineWidth = self.lineWidth;
    [[UIColor colorWithWhite:0.2 alpha:0.2] set];
    [bgPath stroke];
    
    UIBezierPath *strokPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:endAngel clockwise:YES];
    strokPath.lineCapStyle = kCGLineCapRound;
    strokPath.lineJoinStyle = kCGLineJoinRound;
    strokPath.lineWidth = self.lineWidth;
    [self.circleColor set];
    [strokPath stroke];

}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.autoFrame = NO;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    // 自动布局
    if (self.autoFrame) {
        self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width*0.5, newSuperview.bounds.size.height*0.5);
        self.center = newSuperview.center;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.progressLabel.frame = self.bounds;
    self.progressLabel.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
}

@end
