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
        case album
    }

    let viewModel = KKBOXViewModel()
    var sections = Section.allCases
    var isSearching = false

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(SwiftUICell<TrackCell>.self, forCellReuseIdentifier: "TrackCell")
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
        setNavigationBar()
    }

    func setNavigationBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "有沒有這首歌？"
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
        case .album:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        guard let trackCell = cell as? SwiftUICell<TrackCell> else {
            return cell
        }

        if isSearching {
            let trackViewModel = viewModel.trackViewModels.value[indexPath.row]
            trackCell.configure(TrackCell(viewModel: trackViewModel))
        } else {
            return UITableViewCell()
        }

        return trackCell
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isNotEmpty {
            viewModel.fetchTracks(query: searchText, type: "track")
            isSearching = true
        }
    }
}
