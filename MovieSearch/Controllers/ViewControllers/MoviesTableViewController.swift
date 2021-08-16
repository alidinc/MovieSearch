//
//  MoviesTableViewController.swift
//  MovieSearch
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var movies = [Movie]()
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.title = "Movie Search"
    }
    
    // MARK: - Helpers
    func searchMovie(with searchTerm: String) {
        MovieController.fetchMovies(with: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        movies.removeAll()
        searchBar.endEditing(true)
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        navigationController?.navigationBar.sizeToFit()
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MoviesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
}
// MARK: - UISearchBarDelegate
extension MoviesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        searchMovie(with: searchTerm)
    }
}
// MARK: - Navigation
extension MoviesTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DetailViewController else { return }
            destination.movie = movies[indexPath.row]
        }
    }
}
