//
//  DBSafeMutableDictionary.m
//  iOSTools
//
//  Created by deng on 2021/1/29.
//

#import "DBSafeMutableDictionary.h"
#import <pthread.h>

@implementation DBSafeMutableDictionary
{
    NSMutableDictionary * _dictionary;            // 内部存储数据字典
    pthread_rwlock_t _dict_lock;                 // 字典操作读写锁
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_dict_lock);
}

- (void)setupLock
{
    pthread_rwlock_init(&_dict_lock, NULL);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    }
    return self;
}

- (instancetype)initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag {
    self = [super init];
    if (self) {
        [self setupLock];
        _dictionary = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary copyItems:flag];
    }
    return self;
}


#pragma mark - method

- (NSUInteger)count {
    pthread_rwlock_rdlock(&_dict_lock);
    NSUInteger count = _dictionary.count;
    pthread_rwlock_unlock(&_dict_lock);
    
    return count;
}

- (id)objectForKey:(id)aKey {
    pthread_rwlock_rdlock(&_dict_lock);
    id obj = [_dictionary objectForKey:aKey];
    pthread_rwlock_unlock(&_dict_lock);
    
    return obj;
}

- (id)valueForKey:(NSString *)key
{
    pthread_rwlock_rdlock(&_dict_lock);
    id value = [_dictionary valueForKey:key];
    pthread_rwlock_unlock(&_dict_lock);
    
    return value;
}

- (NSEnumerator *)keyEnumerator {
    pthread_rwlock_rdlock(&_dict_lock);
    id enumerator = [_dictionary keyEnumerator];
    pthread_rwlock_unlock(&_dict_lock);
    
    return enumerator;
}

- (NSArray *)allKeys {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary allKeys];
    pthread_rwlock_unlock(&_dict_lock);

    return keys;
}

- (NSArray *)allKeysForObject:(id)anObject {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary allKeysForObject:anObject];
    pthread_rwlock_unlock(&_dict_lock);

    return keys;
}

- (NSArray *)allValues {
    pthread_rwlock_rdlock(&_dict_lock);
    id values = [_dictionary allValues];
    pthread_rwlock_unlock(&_dict_lock);

    return values;
}

- (NSString *)description {
    pthread_rwlock_rdlock(&_dict_lock);
    id desc = [_dictionary description];
    pthread_rwlock_unlock(&_dict_lock);

    return desc;
}

- (NSString *)descriptionInStringsFileFormat {
    pthread_rwlock_rdlock(&_dict_lock);
    id desc = [_dictionary descriptionInStringsFileFormat];
    pthread_rwlock_unlock(&_dict_lock);

    return desc;
}

- (NSString *)descriptionWithLocale:(id)locale {
    pthread_rwlock_rdlock(&_dict_lock);
    id desc = [_dictionary descriptionWithLocale:locale];
    pthread_rwlock_unlock(&_dict_lock);

    return desc;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    pthread_rwlock_rdlock(&_dict_lock);
    id desc = [_dictionary descriptionWithLocale:locale indent:level];
    pthread_rwlock_unlock(&_dict_lock);

    return desc;
}

- (BOOL)isEqualToDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary == self) return YES;
    
    if ([otherDictionary isKindOfClass:DBSafeMutableDictionary.class]) {
        DBSafeMutableDictionary *other = (id)otherDictionary;
        BOOL isEqual;
        pthread_rwlock_rdlock(&_dict_lock);
        pthread_rwlock_rdlock(&other->_dict_lock);
        isEqual = [_dictionary isEqual:other->_dictionary];
        pthread_rwlock_unlock(&other->_dict_lock);
        pthread_rwlock_unlock(&_dict_lock);
        return isEqual;
    }
    return NO;
}

- (NSEnumerator *)objectEnumerator {
    pthread_rwlock_rdlock(&_dict_lock);
    id enumerator = [_dictionary objectEnumerator];
    pthread_rwlock_unlock(&_dict_lock);
    
    return enumerator;
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker {
    pthread_rwlock_rdlock(&_dict_lock);
    id objects = [_dictionary objectsForKeys:keys notFoundMarker:marker];
    pthread_rwlock_unlock(&_dict_lock);
    
    return objects;
}

- (NSArray *)keysSortedByValueUsingSelector:(SEL)comparator {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary keysSortedByValueUsingSelector:comparator];
    pthread_rwlock_unlock(&_dict_lock);
    
    return keys;
}

- (void)getObjects:(id __unsafe_unretained[])objects andKeys:(id __unsafe_unretained[])keys {
    pthread_rwlock_rdlock(&_dict_lock);
    [_dictionary getObjects:objects andKeys:keys];
    pthread_rwlock_unlock(&_dict_lock);
}

- (id)objectForKeyedSubscript:(id)key {
    pthread_rwlock_rdlock(&_dict_lock);
    id obj = [_dictionary objectForKeyedSubscript:key];
    pthread_rwlock_unlock(&_dict_lock);

    return obj;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block {
    pthread_rwlock_rdlock(&_dict_lock);
    [_dictionary enumerateKeysAndObjectsUsingBlock:block];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block {
    pthread_rwlock_rdlock(&_dict_lock);
    [_dictionary enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
    pthread_rwlock_unlock(&_dict_lock);
}

- (NSArray *)keysSortedByValueUsingComparator:(NS_NOESCAPE NSComparator)cmptr {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary keysSortedByValueUsingComparator:cmptr];
    pthread_rwlock_unlock(&_dict_lock);
    return keys;
}

- (NSArray *)keysSortedByValueWithOptions:(NSSortOptions)opts usingComparator:(NS_NOESCAPE NSComparator)cmptr {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary keysSortedByValueWithOptions:opts usingComparator:cmptr];
    pthread_rwlock_unlock(&_dict_lock);
    return keys;
}

- (NSSet *)keysOfEntriesPassingTest:(BOOL (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))predicate {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary keysOfEntriesPassingTest:predicate];
    pthread_rwlock_unlock(&_dict_lock);
    return keys;
}

- (NSSet *)keysOfEntriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))predicate {
    pthread_rwlock_rdlock(&_dict_lock);
    id keys = [_dictionary keysOfEntriesWithOptions:opts passingTest:predicate];
    pthread_rwlock_unlock(&_dict_lock);
    return keys;
}

#pragma mark - mutable

- (void)removeObjectForKey:(id)aKey {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary removeObjectForKey:aKey];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)setObject:(id)anObject forKey:(id <NSCopying> )aKey {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary setObject:anObject forKey:aKey];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)setValue:(id)value forKey:(NSString *)key {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary setValue:value forKey:key];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary addEntriesFromDictionary:otherDictionary];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)removeAllObjects {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary removeAllObjects];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary removeObjectsForKeys:keyArray];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)setDictionary:(NSDictionary *)otherDictionary {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary setDictionary:otherDictionary];
    pthread_rwlock_unlock(&_dict_lock);
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying> )key {
    pthread_rwlock_wrlock(&_dict_lock);
    [_dictionary setObject:obj forKeyedSubscript:key];
    pthread_rwlock_unlock(&_dict_lock);
}

#pragma mark - protocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    pthread_rwlock_rdlock(&_dict_lock);
    id dict = [[self.class allocWithZone:zone] initWithDictionary:_dictionary];
    pthread_rwlock_unlock(&_dict_lock);
    return dict;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])stackbuf
                                    count:(NSUInteger)len {
    pthread_rwlock_rdlock(&_dict_lock);
    NSUInteger count = [_dictionary countByEnumeratingWithState:state objects:stackbuf count:len];
    pthread_rwlock_unlock(&_dict_lock);
    return count;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if ([object isKindOfClass:DBSafeMutableDictionary.class]) {
        DBSafeMutableDictionary *other = object;
        BOOL isEqual;
        pthread_rwlock_rdlock(&_dict_lock);
        pthread_rwlock_rdlock(&other->_dict_lock);
        isEqual = [_dictionary isEqual:other->_dictionary];
        pthread_rwlock_unlock(&other->_dict_lock);
        pthread_rwlock_unlock(&_dict_lock);
        return isEqual;
    }
    return NO;
}

- (NSUInteger)hash {
    pthread_rwlock_rdlock(&_dict_lock);
    NSUInteger hash = [_dictionary hash];
    pthread_rwlock_unlock(&_dict_lock);
    return hash;
}
@end
