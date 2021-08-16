//
//  MovieController.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class MovieController {
    
    static let baseURL = URL(string: "https://api.themoviedb.org/3/")
    static let searchComponent = "search"
    static let movieComponent = "movie"
    
    static let searchTermKey = "query"
    static let apiKeyKey = "api_key"
    static let apiKeyValue = "2e86a3b1aa5101c905d9648bf50a71fc"
    
    //https://api.themoviedb.org/3/search/movie?api_key=2e86a3b1aa5101c905d9648bf50a71fc&query=Jack+Reacher/
    static func fetchMovies(with searchTerm: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let searchURL = baseURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let searchQuery = URLQueryItem(name: searchTermKey, value: searchTerm)
        
        components?.queryItems = [accessQuery, searchQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let movies = topLevelObject.results
                completion(.success(movies))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    static func fetchMovieImages(for movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: "https://image.tmdb.org/t/p/original") else { return completion (.failure(.invalidURL))}
        guard let imagePath = movie.posterPath else { return }
        let imageURL = baseURL.appendingPathComponent(imagePath)
        print(imageURL)
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage)) }
            completion(.success(image))
        }
        task.resume()
    }
    
    
    static func fetchMovieBackdropImages(for movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: "https://image.tmdb.org/t/p/original") else { return completion (.failure(.invalidURL))}
        guard let imagePath = movie.backdropPath else { return }
        let imageURL = baseURL.appendingPathComponent(imagePath)
        print(imageURL)
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage)) }
            completion(.success(image))
        }
        task.resume()
    }
    
    //https://api.themoviedb.org/3/trending/all/day?api_key=<<api_key>>
    static func fetchFavouriteMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let trendingURL = baseURL.appendingPathComponent("trending").appendingPathComponent("movie").appendingPathComponent("day")
        
        var components = URLComponents(url: trendingURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [accessQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let movies = topLevelObject.results
                completion(.success(movies))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    
    //https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>&language=en-US
    static func fetchMovieTrailers(for movie: Movie, completion: @escaping (Result<Trailer, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        guard let movieId = movie.id else { return completion(.failure(.noData)) }
        let videosURL = baseURL.appendingPathComponent(movieComponent).appendingPathComponent("\(movieId)").appendingPathComponent("videos")
        
        var components = URLComponents(url: videosURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [accessQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let trailer = try JSONDecoder().decode(Trailer.self, from: data)
                completion(.success(trailer))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }
    }
}
