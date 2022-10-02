//
//  GenresViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit

class GenresViewController: UIViewController {
    let genresViewModel = GenresViewModel()
    
    var genres: [Genre] = []
    @IBOutlet weak var genreTableView: UITableView! {
        didSet {
            genreTableView.dataSource = self
            genreTableView.register(UINib(nibName: "GenreTableViewCell", bundle: nil), forCellReuseIdentifier: "GenreViewCellId")
        }
    }
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    override func viewDidLoad() {

        super.viewDidLoad()
        genresViewModel.updateGenre {
            self.genreTableView.rowHeight = UITableView.automaticDimension
            self.genreTableView.estimatedRowHeight = 300
                self.genreTableView.reloadData()
        }

    }
    
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return genresViewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = genreTableView.dequeueReusableCell(withIdentifier: "GenreViewCellId", for: indexPath) as! GenreTableViewCell
        cell.configure(genresViewModel.genres[indexPath.row])
        return cell
    }
    
}
