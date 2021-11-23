//
//  TabBarUpdateProtocol.h
//  volunteers
//
//  Created by jauyou on 2015/1/28.
//  Copyright (c) 2015年 taiwanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol definition starts here
@protocol TabBarUpdateProtocol <NSObject>
@required
- (void) reloadData;
- (void) reloadFocus;
@end
// Protocol Definition ends here
@interface TabBarUpdateProtocol : NSObject

{
    // Delegate to respond back
    id <TabBarUpdateProtocol> _delegate;
    
}
@property (nonatomic,strong) id delegate;

@end
