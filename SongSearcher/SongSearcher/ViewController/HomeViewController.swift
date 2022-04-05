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
            setTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        fetchAccessToken()
        setNavigationBar()
        setSearchBar()
        setSegmentedControl()
        view.backgroundColor = .BG
    }

    func bindViewModel() {
        viewModel.trackViewModels.bind { [weak self] _ in
            self?.viewModel.onRefresh()
        }
        viewModel.refreshView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchAccessToken() {
        viewModel.fetchKKBOXAccessToken()
        viewModel.fetchSpotifyAccessToken()
    }

    @IBAction func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
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
            return viewModel.trackViewModels.value.count
        case .album:
            return 0 // not using for current version
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

extension HomeViewController {
    func setSegmentedControl() {
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }

    func setNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "有沒有這首歌？"
        navigationBar?.backgroundColor = .Major
        navigationBar?.barTintColor = .Major
    }

    func setSearchBar() {
        let searchBar = searchController.searchBar
        searchBar.tintColor = .BG
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "搜搜看", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BG])
    }

    func setTableView() {
        tableView.register(SwiftUICell<TrackCell>.self, forCellReuseIdentifier: "TrackCell")
        tableView.dataSource = self
        tableView.backgroundColor = .BG
        tableView.separatorStyle = .none
    }
}
