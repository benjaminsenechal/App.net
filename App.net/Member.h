//
//  Member.h
//  App.net
//
//  Created by Benjamin SENECHAL on 22/12/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Member : NSManagedObject

@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * idMember;

@end
