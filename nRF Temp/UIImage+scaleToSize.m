//
//  UIImage+scaleToSize.m
//  nRF Temp
//
//  Created by Monster on 14-6-17.
//
//

#import "UIImage+scaleToSize.h"

@implementation UIImage (scaleToSize)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return scaledImage;
        }
@end
