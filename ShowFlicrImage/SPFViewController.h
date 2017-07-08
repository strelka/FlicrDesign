//
//  SPFViewController.h
//  ShowPictureFromFlickr
//
//  Created by Jullia Sharaeva on 20.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPFCoreDataService;

@interface SPFViewController : UIViewController
- (instancetype) initWithStorageService:(SPFCoreDataService *) service;
@end
