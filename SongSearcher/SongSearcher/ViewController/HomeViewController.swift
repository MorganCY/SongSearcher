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
    var isSearching = false {
        didSet {
            setHintTextLabel(isHidden: isSearching)
            if isSearching == false {
                viewModel.trackViewModels.value = []
            }
        }
    }
    var isPlaying = false {
        didSet {
            playerBar?.isHidden = !isPlaying
        }
    }
    let searchController = UISearchController()
    let hintTextLabel = UILabel()
    var playerBar: PlayerBar?

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setTableView()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
             return .lightContent
          } else {
             return .default
          }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        fetchAccessToken()
        setNavigationBar()
        setSearchBar()
        setSegmentedControl()
        setHintTextLabel(isHidden: false)
        setPlayerBar(playerBar: playerBar)
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
        viewModel.loadView = {
            ToastDisplayer.shared.showToast(type: .loading, text: .loading)
        }
        viewModel.errorView = {
            ToastDisplayer.shared.showToast(type: .error, text: .error)
        }
        viewModel.dismissReminder = {
            ToastDisplayer.shared.hud.dismiss()
        }
    }

    func fetchAccessToken() {
        viewModel.do {
            $0.fetchSpotifyAccessToken()
            $0.fetchKKBOXAccessToken()
        }
    }

    @IBAction func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        searchController.do {
            $0.searchBar.searchTextField.resignFirstResponder()
            $0.searchResultsUpdater?.updateSearchResults(for: searchController)
        }
    }

    private func resetPlayerBar(trackViewModel: TrackViewModel) {
        playerBar?.do {
            $0.removeFromSuperview()
            $0.willMove(toSuperview: nil)
        }
        playerBar = PlayerBar(viewModel: trackViewModel)
        setPlayerBar(playerBar: playerBar)
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

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackViewModel = viewModel.trackViewModels.value[indexPath.row]
        resetPlayerBar(trackViewModel: trackViewModel)
        isPlaying = true
        playerBar?.isPlaying = isPlaying
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              searchText.isNotEmpty else {
                  isSearching = false
                  return
              }
        isSearching = false
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.fetchTracks(library: .Spotify(query: searchText, type: "track"))
        case 1:
            viewModel.fetchTracks(library: .AppleMusic(query: searchText, type: "songs"))
        case 2:
            viewModel.fetchTracks(library: .KKBOX(query: searchText, type: "track"))
        default:
            break
        }
        isSearching = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
    }
}

extension HomeViewController {
    func setSegmentedControl() {
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }

    func setNavigationBar() {
        navigationController?.navigationBar.do {
            $0.backgroundColor = .Major
            $0.barTintColor = .Major
        }
        navigationItem.do {
            $0.searchController = searchController
            $0.hidesSearchBarWhenScrolling = false
            $0.title = "有沒有這首歌？"
        }
        searchController.searchResultsUpdater = self
        navigationController?.setStatusBar(backgroundColor: .Major)
    }

    func setSearchBar() {
        searchController.searchBar.do {
            $0.delegate = self
            $0.tintColor = .BG
            $0.searchTextField.textColor = .white
            $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "搜搜看", attributes: [NSAttributedString.Key.foregroundColor : UIColor.BG])
        }
    }

    func setTableView() {
        tableView.do {
            $0.register(SwiftUICell<TrackCell>.self, forCellReuseIdentifier: "TrackCell")
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .BG
            $0.separatorStyle = .none
        }
    }

    func setHintTextLabel(isHidden: Bool) {
        hintTextLabel.do {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
            $0.text = "輸入想搜尋的歌曲，結果會出現在這裡"
            $0.font = UIFont(name: "PingfangTC-Regular", size: 16)
            $0.textColor = .Major
            $0.isHidden = isHidden
        }
    }

    func setPlayerBar(playerBar: PlayerBar?) {
        playerBar?.do {
            view.addSubview($0)
            $0.isHidden = !isPlaying
            $0.setup()
        }
    }
}
