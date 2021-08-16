//
//  DetailViewController.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    // MARK: - Properties
    var movie: Movie?
    var trailerURL = ""
    var trailer: Trailer?
    
 
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
       
        
        fetchVideoURL()
    }
    
    // MARK: - Helpers
    
    func fetchVideoURL() {
        
        guard let movie = movie else { return }
        MovieController.fetchMovieTrailers(for: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trailer):
                    let trailerPath = "https://www.youtube.com/watch?v=" + "\(String(describing: trailer.key))"
                    self.trailerURL = trailerPath
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func playPressed(_ sender: UIBarButtonItem) {
        print("somyhb")
        
        guard let videoURL = URL(string: trailerURL) else { return }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
        
//        guard let trailerURL = trailerURL else { return }
//        guard let url = URL(string: trailerURL) else { return }
//        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//        let player = AVPlayer(url: url)
//
//        // Create a new AVPlayerViewController and pass it a reference to the player.
//        let controller = AVPlayerViewController()
//        controller.player = player
//
//        // Modally present the player and call the player's play() method when complete.
//        present(controller, animated: true) {
//            player.play()
//        }
    }
    
    func updateViews() {
        guard let movie = movie else { return }
        nameLabel.text = "Movie: \(movie.originalTitle)"
        descriptionLabel.text = "Overview: \(movie.overview)"
        releaseDateLabel.text =  "Release date: \(movie.releaseDate ?? "Unknown")"
        languageLabel.text = "Language: \(movie.originalLanguage)"
        
        containerView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        containerView.layer.borderWidth =  1
        containerView.layer.cornerRadius = 25
        containerView.backgroundColor = .clear
        backdropImageView.contentMode = .scaleAspectFit
        backdropImageView.layer.cornerRadius = 25
        descriptionLabel.textAlignment = .justified
        
        MovieController.fetchMovieBackdropImages(for: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.backdropImageView.image = image
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}
