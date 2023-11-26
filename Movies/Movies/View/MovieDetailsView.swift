//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Alejandro Villalobos on 25-11-23.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    @State private var imageOpacity: Double = 0
    @State private var posterImageOpacity = 0.0

    var body: some View {
        ScrollView {
            VStack {
                if let backdropPath = viewModel.movie.backdropPath, !backdropPath.isEmpty,
                   let url = URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)") {
                    GeometryReader { geometry in
                        ZStack {
                            KFImage(url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: self.getHeaderHeight(for: geometry))
                                .clipped()
                                .opacity(imageOpacity)
                                .onAppear {
                                    imageOpacity = 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            imageOpacity = 1
                                        }
                                    }
                                }
                        }
                    }
                    .frame(height: 300) // Allocate space for the backdrop image if it exists
                } else {
                    // If there is no backdropPath, dynamically adjust the padding
                    Spacer().frame(height: 100)
                }
                
                // Horizontal stack for the poster image and movie title
                HStack(alignment: .top, spacing: 16) {
                    // Poster Image
                    if let posterPath = viewModel.movie.posterPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        ZStack {
                            KFImage(url)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120) // Adjust width as needed
                                .cornerRadius(8)
                                .shadow(radius: 8)
                                .opacity(posterImageOpacity) // Apply opacity
                                .onAppear {
                                    posterImageOpacity = 0 // Start with an opacity of 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 2)) {
                                            posterImageOpacity = 1 // Animate to full opacity
                                        }
                                    }
                                }
                        }
                        .padding(.top, ((viewModel.movie.backdropPath?.isEmpty) != nil) ? -120 : 0)
                    }
                    
                    // Movie Title and Genre Buttons
                    VStack(alignment: .leading, spacing: 8) {
                        // Movie Title
                        Text(viewModel.movie.title ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                // Movie Overview and Details
                VStack(alignment: .leading, spacing: 12) {
                    // Genre Buttons
                    if let genres = viewModel.movie.genres, !genres.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(genres, id: \.id) { genre in
                                    GenreButton(genre: genre)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    Picker("Options", selection: $viewModel.selectedTab) {
                        ForEach(DetailsTab.allCases, id: \.self) { tab in
                            Text(tab.title).tag(tab)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                    .onChange(of: viewModel.selectedTab) { newValue in
                        if newValue == .reviews && !viewModel.reviewsLoaded {
                            // Trigger the service call to fetch reviews here
                            viewModel.fetchReviews(movieId: viewModel.movie.id ?? 0, page: viewModel.currentPage)
                        }
                    }
                    
                    Group {
                        switch viewModel.selectedTab {
                        case .about:
                            aboutMovieView()
                        case .reviews:
                            reviewsView()
                        }
                    }
                    .animation(.default, value: viewModel.selectedTab)
                }
                .padding()
            }
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.toggleFavorite()
        }) {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.isFavorite ? .red : .gray)
        })
        .background(Color("backgroundColor"))
        .edgesIgnoringSafeArea(.top)
    }
    
    private func aboutMovieView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.isLoading {
                Spacer()
            } else {
                Text("Overview:")
                    .font(.headline)
                
                Text(viewModel.movie.overview ?? "No over")
                    .font(.subheadline)
                
                HStack {
                    VStack(alignment: .leading) {
                        DetailItem(title: "Release Date:", value: viewModel.movie.releaseDate ?? "N/A")
                        DetailItem(title: "Average Rating:", value: viewModel.movie.voteAverage?.description ?? "N/A")
                    }
                    
                    VStack(alignment: .leading) {
                        DetailItem(title: "Rate Count:", value: viewModel.movie.voteCount?.description ?? "N/A")
                        DetailItem(title: "Popularity:", value: viewModel.movie.popularity?.description ?? "N/A")
                    }
                }
            }
        }
    }
    
    // Helper function for the Reviews View
    private func reviewsView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    if viewModel.reviews.isEmpty {
                        if let movieTitle = viewModel.movie.title {
                            Text("\(movieTitle) has no reviews.")
                        }
                    } else {
                        ForEach(viewModel.reviews, id: \.id) { review in
                            reviewEntry(review)
                        }

                        // "Load More" button
                        if viewModel.reviews.count > 20 {
                            Button(action: {
                                viewModel.currentPage += 1
                                viewModel.fetchReviews(movieId: viewModel.movie.id ?? 0, page: viewModel.currentPage)
                            }) {
                                Text("Load More")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    private func reviewEntry(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let avatarPath = review.authorDetails?.avatarPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(avatarPath)") {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author ?? "Unknown Author")
                        .font(.headline)
                    if let rating = review.authorDetails?.rating {
                        Text("Rating: \(rating)/10")
                            .font(.subheadline)
                    }
                }
            }
            
            Text(review.content ?? "")
                .font(.body)
                .padding(.top, 8)
            
            Divider()
        }
    }
    
    func getHeaderHeight(for geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        return max(0, 300 + offset) // This ensures that the header height doesn't go below 0
    }
    
    func getHeaderOffset(for geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        return offset > 0 ? -offset : 0
    }
}


// Genre button view
struct GenreButton: View {
    let genre: Genre
    
    var body: some View {
        Button(action: {
            // Action for genre button tap
        }) {
            Text(genre.name ?? "N/A")
                .padding(.vertical, 4)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color("secondaryAccentColor"))
                .cornerRadius(16)
        }
    }
}

// Detail item view
struct DetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
            Text(value)
        }
    }
}

enum DetailsTab: CaseIterable {
    case about
    case reviews
    
    var title: String {
        switch self {
        case .about:
            return "About Movie"
        case .reviews:
            return "Reviews"
        }
    }
}

/*
 struct MovieDetailsView_Previews: PreviewProvider {
 static var previews: some View {
 
 let sampleMovie = Result(
 adult: false,
 backdropPath: "placeholder_image", // Example backdrop path
 genreIDS: [28, 12],
 id: 123456,
 originalLanguage: "en",
 originalTitle: "Sample Movie",
 overview: "This is a sample overview of the movie.",
 popularity: 8.9,
 posterPath: "/pathToPoster.jpg",
 releaseDate: "2022-01-01",
 title: "Sample Movie",
 video: false,
 voteAverage: 7.5,
 voteCount: 200
 )
 
 // Previewing the MovieDetailsView with the sample movie
 MovieDetailsView(movie: sampleMovie)
 }
 }
 */
