//
//  NetworkManager.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MovieCategorySearch;
extern NSString * const MovieCategoryNowPlaying;
extern NSString * const MovieCategoryPopular;
extern NSString * const MovieCategoryTopRated;
extern NSString * const MovieCategoryUpcoming;

@interface NetworkManager : NSObject

+ (instancetype)sharedManager;
- (void)fetchMoviesForCategory:(NSString *)category withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
