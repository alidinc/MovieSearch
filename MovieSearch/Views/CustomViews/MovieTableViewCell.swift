//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var movie: Movie? {
        didSet {
            updateCellView()
        }
    }
    
    // MARK: - Helpers
    func updateCellView() {
        guard let movie = movie else { return }
        titleLabel.text = movie.originalTitle
        rankingLabel.text = "Rating: \(movie.voteAverage)"
        descriptionLabel.text = movie.overview

        MovieController.fetchMovieImages(for: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.posterImageView.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}
