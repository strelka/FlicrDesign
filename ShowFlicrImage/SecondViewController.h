//
//  SecondViewController.h
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 27.05.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPFCoreDataService;
@interface SecondViewController : UIViewController

- (instancetype) initWithStorageService:(SPFCoreDataService *) service;
@end

