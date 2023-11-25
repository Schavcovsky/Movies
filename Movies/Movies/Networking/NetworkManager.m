//
//  NetworkManager.m
//  Movies
//
//  Created by Alejandro Villalobos on 24-11-23.
//

#import "NetworkManager.h"
#import "Movies-Swift.h"

NSString * const MovieSearch = @"search/movie";
NSString * const MovieCategoryNowPlaying = @"movie/now_playing";
NSString * const MovieCategoryPopular = @"movie/popular";
NSString * const MovieCategoryTopRated = @"movie/top_rated";
NSString * const MovieCategoryUpcoming = @"movie/upcoming";
NSString * const MovieDetails = @"movie/details";
NSString * const MovieRatings = @"movie/ratings";

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchMoviesForCategory:(NSString *)category query:(nullable NSString *)query page:(NSInteger)page withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *urlString;
    if ([category isEqualToString:MovieSearch]) {
        urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/movie?query=%@&page=%ld", encodedQuery, (long)page];
    } else {
        urlString = [self urlStringForCategory:category page:page];
    }

    [self performNetworkRequestWithURLString:urlString withCompletion:completion];
}

- (void)fetchMovieDetailsForId:(NSInteger)movieId withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *urlString = [self urlStringForCategory:MovieDetails movieId:movieId page:0];
    [self performNetworkRequestWithURLString:urlString withCompletion:completion];
}

- (void)fetchMovieRatingsForId:(NSInteger)movieId page:(NSInteger)page withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *urlString = [self urlStringForCategory:MovieRatings movieId:movieId page:page];
    [self performNetworkRequestWithURLString:urlString withCompletion:completion];
}

// Update urlStringForCategory: method to handle new categories
- (NSString *)urlStringForCategory:(NSString *)category movieId:(NSInteger)movieId page:(NSInteger)page {
    NSString *baseUrl;
    if ([category isEqualToString:MovieDetails]) {
        baseUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%ld?language=en-US", (long)movieId];
    } else if ([category isEqualToString:MovieRatings]) { // Fixed here
        baseUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%ld/reviews?language=en-US&page=%ld", (long)movieId, (long)page];
    } else {
        baseUrl = [self baseUrlForCategory:category];
    }
    return baseUrl;
}

// Extract common network request code
- (void)performNetworkRequestWithURLString:(NSString *)urlString withCompletion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSLog(@"URL being accessed: %@", urlString); // Log for debugging
    
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

- (NSString *)urlStringForCategory:(NSString *)category page:(NSInteger)page {
    NSString *baseUrl = [self baseUrlForCategory:category];
    if (![baseUrl isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@&page=%ld", baseUrl, (long)page];
    } else {
        NSLog(@"Base URL is empty for category: %@", category);
        return @"";
    }
}

- (NSString *)baseUrlForCategory:(NSString *)category {
    if ([category isEqualToString:MovieSearch]) {
        return @"https://api.themoviedb.org/3/search/movie?query=";
    } else if ([category isEqualToString:MovieCategoryPopular]) {
        return @"https://api.themoviedb.org/3/movie/popular?language=en-US&page=";
    } else if ([category isEqualToString:MovieCategoryNowPlaying]) {
        return @"https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=";
    } else if ([category isEqualToString:MovieCategoryTopRated]) {
        return @"https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=";
    } else if ([category isEqualToString:MovieCategoryUpcoming]) {
        return @"https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=";
    } else {
        return @"";
    }
}

@end
