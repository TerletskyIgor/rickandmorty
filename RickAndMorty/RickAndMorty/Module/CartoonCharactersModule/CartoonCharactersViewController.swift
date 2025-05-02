//
//  CartoonCharacters.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import UIKit

protocol CartoonCharactersDisplayLogic: AnyObject {
    func displayCharacters(character: [Character])
    func showError(title: String, message: String)
}

final class CartoonCharactersViewController: UIViewController {
    var interactor: CartoonCharactersBusinessLogic?
    var router: CartoonCharactersRoutingLogic?

    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, Character>!
    private let paginator = Paginator()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private enum Section: Int, CaseIterable {
        case characters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIP()
        setupUI()
        fetchCharacters(currentIndex: 0)
        title = "Characters"
        view.backgroundColor = .systemBackground
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupVIP() {
        let viewController = self
        let interactor = CartoonCharactersInteractor()
        let presenter = CartoonCharactersPresenter()
        let router = CartoonCharactersRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
    }

    private func setupUI() {
        setupRefreshControl()
        setupTableView()
        configureTableView()
        setupActivityIndicator()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc
    private func handleRefresh() {
        paginator.reset()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.characters])
        dataSource.apply(snapshot, animatingDifferences: false)
        
        fetchCharacters(currentIndex: 0) { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseID)
        
        dataSource = UITableViewDiffableDataSource<Section, Character>(tableView: tableView) { tableView, indexPath, character in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseID, for: indexPath) as? CharacterCell else {
                return UITableViewCell()
            }
            cell.configure(with: character)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.characters])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private  func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    private func fetchCharacters(currentIndex: Int, callback: (() -> Void)? = nil) {
        paginator.loadIfNeeded(currentIndex: currentIndex,
                               totalCount: dataSource.snapshot().numberOfItems) { [weak self] page, done in
            self?.showActivityIndicator()
            self?.interactor?.fetchCharacters(page: page) { [weak self] hasMorePages in
                self?.hideActivityIndicator()
                done(hasMorePages)
                callback?()
            }
        }
    }
}

// MARK: - CartoonCharactersDisplayLogic
extension CartoonCharactersViewController: CartoonCharactersDisplayLogic {
    func displayCharacters(character: [Character]) {
        let existingIDs = Set(dataSource.snapshot().itemIdentifiers.map { $0.id })
        let newUniqueCharacters = character.filter { !existingIDs.contains($0.id) }
        
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(newUniqueCharacters, toSection: .characters)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate
extension CartoonCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchCharacters(currentIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail(for: dataSource.itemIdentifier(for: indexPath)!)
    }
}
