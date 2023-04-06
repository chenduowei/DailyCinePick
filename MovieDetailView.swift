//
//  MovieDetailView.swift
//  MovieRecommender
//
//  Created by chenduowei on 2023/4/7.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: movie.posterURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                .clipped()
                .padding(.bottom)

                Text(movie.displayTitle) // 使用 displayTitle 代替 title
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                
                HStack {
                    Text("评分: \(movie.rating, specifier: "%.1f")")
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Button("观看链接") {
                        openURL(URL(string: movie.watchLink)!)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Text(movie.review) // 使用 review 代替 overview
                    .font(.body)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(id: 1, title: "Movie 1", name: nil, poster_path: "/path/to/poster1.jpg", overview: "Great movie!", vote_average: 8.0, media_type: "movie"))
    }
}
