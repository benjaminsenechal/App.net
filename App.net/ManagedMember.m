//
//  ManagedMember.m
//  App.net
//
//  Created by Benjamin SENECHAL on 22/12/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedMember.h"

@implementation ManagedMember
+(void)loadDataFromWebService{
    [self persistMember];
}

+(void)persistMember{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://alpha-api.app.net/stream/0/posts/stream/global" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *members = [[NSMutableArray alloc]init];
        members = responseObject;
        
        for (int i = 0; i < [[members valueForKey:@"data"] count]; i++) {
            NSMutableArray *members = [[responseObject objectForKey:@"data"]objectAtIndex:i];
            
            UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[members valueForKey:@"user"] valueForKey:@"avatar_image"] valueForKey:@"url"]]]];
            NSData *avatarD  = UIImageJPEGRepresentation(avatar, 1.0);
            NSString *created_at = [members valueForKey:@"created_at"];
            NSString *text = [members valueForKey:@"text"];
            NSString *ids = [members valueForKey:@"id"];
            NSString *name = [[members valueForKey:@"user"] valueForKey:@"username"];
            
            Member *existingEntity = [Member findFirstByAttribute:@"idMember" withValue:ids];
            
            if (!existingEntity)
            {
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                Member *newMember = [Member createInContext:localContext];
                newMember.avatar = avatarD;
                newMember.idMember = ids;
                newMember.created_at = created_at;
                newMember.name = name;
                newMember.text = text;
                [localContext saveToPersistentStoreAndWait];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notificationLoadMembersNewsFinished" object:nil]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
