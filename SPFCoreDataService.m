//
//  SPFCoreDataService.m
//  ShowFlicrImage
//
//  Created by Jullia Sharaeva on 06.07.17.
//  Copyright © 2017 Julia Sharaeva. All rights reserved.
//

#import "SPFCoreDataService.h"
#import "SPFCoreDataStack.h"
#import "SPFPicture.h"
#import "NSURL+Caching.h"

#import "SPFPictureModel.h"
@interface SPFCoreDataService()
@property (nonatomic, strong) SPFCoreDataStack *coreDataStack;
@property (nonatomic, strong) NSFetchRequest *request;
@property (nonatomic, strong) NSEntityDescription *pictureEntity;


@end
@implementation SPFCoreDataService
- (instancetype) init{
    self = [super init];
    if (self){
        _coreDataStack = [SPFCoreDataStack new];
    }
    return self;
}

- (NSEntityDescription *)pictureEntity{
    if (!_pictureEntity){
        _pictureEntity = [NSEntityDescription entityForName:@"SPFPictureModel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    }
    return _pictureEntity;
}

- (NSString *)getPathForSavingImage:(NSString *)imgId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imgFileName = [imgId stringByAppendingFormat:@"%@.png", imgId];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imgFileName];
    return imagePath;
}

- (void) savePictureImageToDocuments:(SPFPicture *)picture{
    if (picture.imageState == Downloaded){
        UIImage *image = [picture.imgURL getImageFromCache];
        NSData *data = UIImagePNGRepresentation(image);
        NSString *imagePath = [self getPathForSavingImage:picture.idImg];
        if (![data writeToFile:imagePath atomically:NO]){
            NSLog(@"Failed to cache image data to disk");
            imagePath = @"";
        } else {
            NSLog(@"the cachedImagePath is %@", imagePath);
        }
    }
}

- (void) setPictureToFavorite:(SPFPicture *)picture{
    if (![self isPictureFavorite:picture]){
        SPFPictureModel *model = [[SPFPictureModel alloc] initWithEntity:self.pictureEntity
                                          insertIntoManagedObjectContext:self.coreDataStack.managedObjectContext];
        
        [self mapPicture:picture ToPictureModel:model];
        [self savePictureImageToDocuments:picture];
        NSError *error = nil;
        if (![self.coreDataStack.managedObjectContext save:&error]){
            NSLog(@"Unresolved error: %@, %@", error, [error userInfo]);
        }
    }
}

- (void)mapPicture:(SPFPicture *)picture ToPictureModel:(SPFPictureModel *)model{
    model.idImg = picture.idImg;
    model.imgURL = [[NSString alloc] initWithFormat:@"%@", picture.imgURL];
    model.desc = picture.desc;
    model.locality = picture.locality;
    model.countLikes = @(picture.countLikes);
    model.countViews = @(picture.countViews);
    model.countComments = @(picture.countComments);
    model.saveTimeInterval = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}


- (void)getFavoritePicturesWithCompletionBlock:(block) block{
 
    NSManagedObjectContext *context = self.coreDataStack.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.pictureEntity.name];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"saveTimeInterval" ascending:NO];
    request.sortDescriptors = @[descriptor];

    NSPersistentStoreAsynchronousFetchResultCompletionBlock resultBlock = ^(NSAsynchronousFetchResult *result){
        dispatch_async(dispatch_get_main_queue(), ^{
            block(result.finalResult);
        });
    };
    
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:resultBlock];
    
    [context performBlock:^{
        NSError *executeError;
        NSAsynchronousFetchResult *result = (NSAsynchronousFetchResult *)
        [context executeRequest:asyncRequest error:&executeError];
    }];
}

- (BOOL) isPictureFavorite:(SPFPicture *)picture{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.pictureEntity.name];
    request.predicate = [NSPredicate predicateWithFormat:@"idImg = %@", picture.idImg];
    
    NSError *error = nil;
    NSArray *results = [self.coreDataStack.managedObjectContext executeFetchRequest:request
                                                                              error:&error];
    return !(results.count == 0);
}

@end
