//
//  NLTravelCarView.m
//  NikolaLenivets
//
//  Created by Yuri Karabatov on 24.09.14.
//  Copyright (c) 2014 Semyon Novikov. All rights reserved.
//

#import "NLTravelCarView.h"
#import "NLBorderedLabel.h"
#import "NSAttributedString+Kerning.h"
#import "NLCircleLabel.h"

#define kNLCarSlider1Offset 379.f
#define kNLCarMap1Offset 439.5f

@interface NLTravelCarView ()

/**
 Offset of the map header slider.
 */
@property (strong, nonatomic) NSLayoutConstraint *slider1Offset;

/**
 Map header pointer arrow.
 */
@property (strong, nonatomic) UIImageView *arrow1;

/**
 Offset of the map image.
 */
@property (strong, nonatomic) NSLayoutConstraint *map1Offset;

@end

@implementation NLTravelCarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIColor *textColor = [UIColor colorWithRed:37.f/255.f green:37.f/255.f blue:37.f/255.f alpha:1.f];
    UIColor *dashBgColor = [UIColor colorWithRed:244.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.f];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 0.1f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5.f;

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleLabel.attributedText = [NSAttributedString kernedStringForString:@"НА АВТОМОБИЛЕ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-car-220km.png"]];
    [image1 setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *dash1 = [[UIView alloc] init];
    [dash1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash1 setBackgroundColor:dashBgColor];

    UILabel *header1 = [[UILabel alloc] init];
    [header1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    header1.attributedText = [NSAttributedString kernedStringForString:@"РАСЧЕТНОЕ ВРЕМЯ В ПУТИ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    NLBorderedLabel *bordered1 = [[NLBorderedLabel alloc] initWithAttributedText:[NSAttributedString kernedStringForString:@"3,5 ЧАСА" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor]];

    UIView *dash2 = [[UIView alloc] init];
    [dash2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash2 setBackgroundColor:dashBgColor];

    UILabel *header2 = [[UILabel alloc] init];
    [header2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    header2.attributedText = [NSAttributedString kernedStringForString:@"ДЕРЕВНИ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"Звизжи\nНикола-Ленивец\nКольцово" withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text1 length])];

    UILabel *content1 = [[UILabel alloc] init];
    [content1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content1.numberOfLines = 0;
    content1.attributedText = text1;

    UIView *dash3 = [[UIView alloc] init];
    [dash3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash3 setBackgroundColor:dashBgColor];

    UILabel *header3 = [[UILabel alloc] init];
    [header3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    header3.attributedText = [NSAttributedString kernedStringForString:@"GPS КООРДИНАТЫ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-car-gps.png"]];
    [image2 setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *slider1 = [[UIView alloc] init];
    [slider1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [slider1 setBackgroundColor:[UIColor whiteColor]];

    UIView *dash4 = [[UIView alloc] init];
    [dash4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash4 setBackgroundColor:dashBgColor];

    UILabel *header4 = [[UILabel alloc] init];
    [header4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    header4.attributedText = [NSAttributedString kernedStringForString:@"КАРТА" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    self.arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-car-arrow.png"]];
    [self.arrow1 setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIImageView *map1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"travel-car-map.png"]];
    [map1 setTranslatesAutoresizingMaskIntoConstraints:NO];

    NLCircleLabel *circle1 = [[NLCircleLabel alloc] initWithNumber:1];

    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"С Киевского шоссе поворот направо, на\u00a0Медынь.\n174\u00a0км от\u00a0МКАД, пост ДПС с\u00a0огромными буквами «Калуга»." withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text2 length])];

    UILabel *content2 = [[UILabel alloc] init];
    [content2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content2.numberOfLines = 0;
    content2.attributedText = text2;

    UIView *dash5 = [[UIView alloc] init];
    [dash5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash5 setBackgroundColor:dashBgColor];

    NLCircleLabel *circle2 = [[NLCircleLabel alloc] initWithNumber:2];

    NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"В Кондрово поворот налево: на\u00a0Сени, Острожное." withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text3 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text3 length])];

    UILabel *content3 = [[UILabel alloc] init];
    [content3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content3.numberOfLines = 0;
    content3.attributedText = text3;

    UIView *dash6 = [[UIView alloc] init];
    [dash6 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash6 setBackgroundColor:dashBgColor];

    NLCircleLabel *circle3 = [[NLCircleLabel alloc] initWithNumber:3];

    NSMutableAttributedString *text4 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"На T-образном перекрёстке поворот налево. На\u00a0горбатый мост через ж/д\u00a0пути." withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text4 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text4 length])];

    UILabel *content4 = [[UILabel alloc] init];
    [content4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content4.numberOfLines = 0;
    content4.attributedText = text4;

    UIView *dash7 = [[UIView alloc] init];
    [dash7 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash7 setBackgroundColor:dashBgColor];

    NLCircleLabel *circle4 = [[NLCircleLabel alloc] initWithNumber:4];

    NSMutableAttributedString *text5 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"В Острожном на\u00a0большом перекрёстке налево." withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text5 length])];

    UILabel *content5 = [[UILabel alloc] init];
    [content5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content5.numberOfLines = 0;
    content5.attributedText = text5;

    UIView *dash8 = [[UIView alloc] init];
    [dash8 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash8 setBackgroundColor:dashBgColor];

    NLCircleLabel *circle5 = [[NLCircleLabel alloc] initWithNumber:5];

    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString kernedStringForString:@"Не доезжая несколько метров до\u00a0Звизжей, поворот направо на\u00a0грунтовую дорогу. После поворота спуск с\u00a0крутой горки." withFontName:NLSerifFont fontSize:18.f kerning:0.2f andColor:textColor]];
    [text6 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text6 length])];

    UILabel *content6 = [[UILabel alloc] init];
    [content6 setTranslatesAutoresizingMaskIntoConstraints:NO];
    content6.numberOfLines = 0;
    content6.attributedText = text6;

    UIView *dash9 = [[UIView alloc] init];
    [dash9 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dash9 setBackgroundColor:dashBgColor];

    UILabel *header5 = [[UILabel alloc] init];
    [header5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    header5.attributedText = [NSAttributedString kernedStringForString:@"ВЫ НА МЕСТЕ" withFontName:NLMonospacedFont fontSize:12.f kerning:0.7f andColor:textColor];

    [self addSubview:titleLabel];
    [self addSubview:image1];
    [self addSubview:dash1];
    [self addSubview:header1];
    [self addSubview:bordered1];
    [self addSubview:dash2];
    [self addSubview:header2];
    [self addSubview:content1];
    [self addSubview:dash3];
    [self addSubview:header3];
    [self addSubview:image2];
    [self addSubview:circle1];
    [self addSubview:content2];
    [self addSubview:dash5];
    [self addSubview:circle2];
    [self addSubview:content3];
    [self addSubview:dash6];
    [self addSubview:circle3];
    [self addSubview:content4];
    [self addSubview:dash7];
    [self addSubview:circle4];
    [self addSubview:content5];
    [self addSubview:dash8];
    [self addSubview:circle5];
    [self addSubview:content6];
    [self addSubview:dash9];
    [self addSubview:header5];
    [self addSubview:map1];
    [self addSubview:slider1];
    [slider1 addSubview:dash4];
    [slider1 addSubview:header4];
    [slider1 addSubview:self.arrow1];

    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, image1, dash1, header1, bordered1, dash2, header2, content1, dash3, header3, image2, slider1, dash4, header4, _arrow1, map1, circle1, content2, dash5, circle2, content3, dash6, circle3, content4, dash7, circle4, content5, dash8, circle5, content6, dash9, header5);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[titleLabel]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[image1(163)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash1]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[header1]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[bordered1]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash2]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[header2]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content1]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash3]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[header3]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(11)-[image2(297.5)]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[slider1]|" options:kNilOptions metrics:nil views:views]];
    [slider1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash4]|" options:kNilOptions metrics:nil views:views]];
    [slider1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[header4]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [slider1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[_arrow1]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[map1]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[circle1]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content2]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash5]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[circle2]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content3]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash6]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[circle3]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content4]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash7]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[circle4]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content5]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash8]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[circle5]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(16.5)-[content6]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dash9]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=1)-[header5]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.5-[titleLabel]-37.5-[image1(20)]-14.5-[dash1(0.5)]-15-[header1]-17.5-[bordered1]-20.5-[dash2(0.5)]-15-[header2]-16.5-[content1]-15-[dash3(0.5)]-14.5-[header3]-14.5-[image2(20)]-539.5-[circle1]-18-[content2]-15.5-[dash5(0.5)]-19-[circle2]-18-[content3]-15.5-[dash6(0.5)]-19-[circle3]-18-[content4]-15.5-[dash7(0.5)]-19-[circle4]-18-[content5]-15.5-[dash8(0.5)]-19-[circle5]-18-[content6]-15.5-[dash9(0.5)]-14-[header5]-52-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[slider1(52.5)]" options:kNilOptions metrics:nil views:views]];
    [slider1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[dash4(0.5)]-14.5-[header4]-(>=1)-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[map1(448)]" options:kNilOptions metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:[UIScreen mainScreen].bounds.size.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:header1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bordered1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:dash2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:header2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:header3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    self.slider1Offset = [NSLayoutConstraint constraintWithItem:slider1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:kNLCarSlider1Offset];
    [self addConstraint:self.slider1Offset];
    [slider1 addConstraint:[NSLayoutConstraint constraintWithItem:header4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:slider1 attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [slider1 addConstraint:[NSLayoutConstraint constraintWithItem:self.arrow1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:slider1 attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [slider1 addConstraint:[NSLayoutConstraint constraintWithItem:self.arrow1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:slider1 attribute:NSLayoutAttributeTop multiplier:1.f constant:13.f]];
    self.map1Offset = [NSLayoutConstraint constraintWithItem:map1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:kNLCarMap1Offset];
    [self addConstraint:self.map1Offset];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle4 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:circle5 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:header5 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
}

#pragma mark - UIScrollViewDelegate protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.slider1Offset.constant = MAX(kNLCarSlider1Offset, scrollView.contentOffset.y - 4.5f);
    if (scrollView.contentOffset.y > kNLCarSlider1Offset - 6.f) {
        self.arrow1.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.arrow1.transform = CGAffineTransformIdentity;
    }
    self.map1Offset.constant = MAX(kNLCarMap1Offset, scrollView.contentOffset.y - 309.5f);
}

@end
