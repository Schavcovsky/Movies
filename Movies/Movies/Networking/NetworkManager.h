//
//  NetworkManager.swift
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MovieSearch;
extern NSString * const MovieCategoryNowPlaying;
extern NSString * const MovieCategoryPopular;
extern NSString * const MovieCategoryTopRated;
extern NSString * const MovieCategoryUpcoming;
extern NSString * const MovieDetails;
extern NSString * const MovieRatings;

@interface NetworkManager : NSObject

+ (instancetype)sharedManager;
- (void)fetchMoviesForCategory:(NSString *)category query:(nullable NSString *)query page:(NSInteger)page withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;
- (void)fetchMovieDetailsForId:(NSInteger)movieId withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;
- (void)fetchMovieRatingsForId:(NSInteger)movieId page:(NSInteger)page withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
