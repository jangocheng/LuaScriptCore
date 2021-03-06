//
//  LSCCallSession.m
//  LuaScriptCore
//
//  Created by 冯鸿杰 on 2017/7/3.
//  Copyright © 2017年 vimfung. All rights reserved.
//

#import "LSCSession.h"
#import "LSCSession_Private.h"
#import "LSCValue_Private.h"
#import "LSCTuple_Private.h"
#import "LSCContext_Private.h"
#import "LSCEngineAdapter.h"

@implementation LSCSession

- (instancetype)initWithState:(lua_State *)state context:(LSCContext *)context
{
    if (self = [super init])
    {
        _state = state;
        _context = context;
    }
    
    return self;
}

- (void)dealloc
{
    //释放内存
    [self.context gc];
}

- (NSArray *)parseArguments
{
    return [self _parseArgumentsFromIndex:1];
}

- (NSArray *)parseArgumentsWithoutTheFirst
{
    return [self _parseArgumentsFromIndex:2];
}

- (int)setReturnValue:(LSCValue *)value
{
    int count = 0;
    if (value)
    {
        if (value.valueType == LSCValueTypeTuple)
        {
            count = (int)[value toTuple].count;
        }
        else
        {
            count = 1;
        }
        
        [value pushWithContext:self.context];
    }
    else
    {
        [LSCEngineAdapter pushNil:self.state];
    }
    
    return count;
}

#pragma mark - Private


/**
 解析参数

 @param index 开始索引
 @return 参数集合
 */
- (NSArray *)_parseArgumentsFromIndex:(int)index
{
    int top = [LSCEngineAdapter getTop:self.state];
    if (top >= index)
    {
        NSMutableArray *arguments = [NSMutableArray array];
        for (int i = index; i <= top; i++)
        {
            LSCValue *value = [LSCValue valueWithContext:self.context atIndex:i];
            [arguments addObject:value];
        }
        
        return arguments;
    }
    
    return nil;
}

@end
