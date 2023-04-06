//
//  ContentView.swift
//  MovieRecommender
//
//  Created by chenduowei on 2023/4/7.
//

import SwiftUI

struct ContentView: View {
    @StateObject var movieViewModel = MovieViewModel()
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(movieViewModel.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                PosterView(movie: movie)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom)
                    .coordinateSpace(name: "movies")
                    .offset(y: -scrollOffset * 0.5)
                }
                .onAppear {
                    movieViewModel.fetchMoviesFromAPI(listID: 8247923)
                }
                .onReceive(movieViewModel.$movies) { _ in
                    DispatchQueue.main.async {
                        scrollOffset = 0
                    }
                }
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: ViewOffsetKey.self, value: -proxy.frame(in: .named("movies")).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) { offset in
                    scrollOffset = offset
                }
            }
            .navigationTitle("每日影视精选")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

private struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct PosterView: View {
    let movie: Movie

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    AsyncImage(url: URL(string: movie.posterURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .offset(y: (geometry.frame(in: .global).minY > 0 ? geometry.frame(in: .global).minY : 0) / 2)
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.65)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}
