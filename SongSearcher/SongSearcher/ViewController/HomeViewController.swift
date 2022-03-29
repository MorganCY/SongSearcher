//
//  ViewController.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case tracks
        case playlist
        case artists
    }

    var sections = Section.allCases

    let viewModel = KKBOXViewModel()

    var isSearching = false

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: TrackCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TrackCell.self))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchAccessToken()

        viewModel.trackViewModels.bind { [weak self] _ in
            self?.viewModel.onRefresh()
        }

        viewModel.refreshView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        tableView.dataSource = self
        searchBar.delegate = self
    }
}

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = sections[section]

        switch sectionType {
        case .tracks:
            return 3
        case .playlist, .artists:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackCell.self), for: indexPath)
        guard let trackCell = cell as? TrackCell else {
            return cell
        }

        if isSearching {
                let trackViewModel = viewModel.trackViewModels.value[indexPath.row]
            trackCell.layoutCell(viewModel: trackViewModel)
        } else {
            return UITableViewCell()
        }

        return trackCell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchTracks(query: searchText, type: "track")
        isSearching = true
//        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}
