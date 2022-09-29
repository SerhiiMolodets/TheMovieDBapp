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
            print(self.genresViewModel.genres.count)
                self.genreTableView.reloadData()
        }
        print(self.genresViewModel.genres.count)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
