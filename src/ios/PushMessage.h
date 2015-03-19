//
//  PushMessage.h
//  PushNotification
//
//  Created by Debanjan on 19/03/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PushMessage : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * flag;

@end
