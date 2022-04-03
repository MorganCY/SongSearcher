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

    var viewModel = SearchResultViewModel()
    var sections = Section.allCases
    var isSearching = false
    let searchController = UISearchController()

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(SwiftUICell<TrackCell>.self, forCellReuseIdentifier: "TrackCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel(library: .KKBOX(query: nil, type: nil))
        tableView.dataSource = self
        setNavigationBar()
    }

    func bindViewModel(library: Library) {
        switch library {
        case .KKBOX(_, _):
            viewModel.fetchAccessToken()
        default:
            break
        }
        viewModel.trackViewModels.bind { [weak self] _ in
            self?.viewModel.onRefresh()
        }
        viewModel.refreshView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }

    func setNavigationBar() {
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

        if viewModel.trackViewModels.value.count > 6 {
            switch sectionType {
            case .tracks:
                return 6
            case .album:
                return 1
            }
        } else {
            return viewModel.trackViewModels.value.count
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
        guard let searchText = searchController.searchBar.text,
              searchText.isNotEmpty else {
                  return
              }
        isSearching = false
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.fetchTracks(library: .KKBOX(query: searchText, type: "track"))
        case 1:
            viewModel.fetchTracks(library: .AppleMusic(query: searchText, type: "songs"))
        default:
            viewModel.fetchTracks(library: .Spotify(query: searchText, type: "track"))
        }
        isSearching = true
    }
}
