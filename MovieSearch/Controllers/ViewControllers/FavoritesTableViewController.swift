//
//  FavoritesTableViewController.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var favoriteMovies = [Movie]()
    static let shared = FavoritesTableViewController()
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    // MARK: - Helpers
    
    func fetchFavorites() {
        MovieController.fetchFavouriteMovies { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favouriteMovies):
                    self.favoriteMovies = favouriteMovies
                    self.tableView.reloadData()
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        cell.textLabel?.text = "\(favoriteMovies[indexPath.row].title)"
        cell.detailTextLabel?.text = "Ranking: \(favoriteMovies[indexPath.row].voteAverage)"
        return cell
    }
}
