//
//  NetworkManager.m
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

#import "NetworkManager.h"
#import "Movies-Swift.h"

NSString * const MovieCategorySearch = @"search/movie";
NSString * const MovieCategoryNowPlaying = @"movie/now_playing";
NSString * const MovieCategoryPopular = @"movie/popular";
NSString * const MovieCategoryTopRated = @"movie/top_rated";
NSString * const MovieCategoryUpcoming = @"movie/upcoming";

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchMoviesForCategory:(NSString *)category withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *urlString = [self urlStringForCategory:category];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMjFkMmRjNzI3ZDgyZmIwYWI1ODkwNzcyNTdiZDZlMSIsInN1YiI6IjY1NWViYmJjODNlZTY3MDFmNjI1OTcyNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.tr7hmR8OjjOOn3Byu6LG8ykJPvtddeN5F6DJC3MpoGU" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }

        completion(data, nil);
    }];

    [task resume];
}

- (NSString *)urlStringForCategory:(NSString *)category {
    if ([category isEqualToString:MovieCategorySearch]) {
        return @"https://api.themoviedb.org/3/search/movie?query=asd&include_adult=false&language=en-US&page=1";
    } else if ([category isEqualToString:MovieCategoryNowPlaying]) {
        return @"https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1";
    } else if ([category isEqualToString:MovieCategoryPopular]) {
        return @"https://api.themoviedb.org/3/movie/popular?language=en-US&page=1";
    } else if ([category isEqualToString:MovieCategoryTopRated]) {
        return @"https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1";
    } else if ([category isEqualToString:MovieCategoryUpcoming]) {
        return @"https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1";
    } else {
        return @"";
    }
}

@end
