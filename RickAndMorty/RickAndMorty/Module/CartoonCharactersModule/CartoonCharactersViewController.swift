//
//  CartoonCharacters.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import UIKit
import Kingfisher

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
    
    private enum Section: Int, CaseIterable {
        case characters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIP()
        setupUI()
        fetchCharacters()
        title = "Rick and Morty characters"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageCache.default.clearMemoryCache()
    }

    private func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        configureTableView()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        tableView.delegate = self
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

    private func fetchCharacters() {
        paginator.loadIfNeeded(currentIndex: 0,
                               totalCount: dataSource.snapshot().numberOfItems) { [weak self] page, done in
            self?.showActivityIndicator()
            self?.interactor?.fetchCharacters(page: page) { [weak self] hasMorePages in
                self?.hideActivityIndicator()
                done(hasMorePages)
            }
        }
    }
}

// MARK: - CartoonCharactersDisplayLogic
extension CartoonCharactersViewController: CartoonCharactersDisplayLogic {
    func displayCharacters(character: [Character]) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(character, toSection: .characters)
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
        paginator.loadIfNeeded(currentIndex: indexPath.row,
                               totalCount: dataSource.snapshot().numberOfItems) { [weak self] page, done in
            self?.showActivityIndicator()
            self?.interactor?.fetchCharacters(page: page) { [weak self] hasMorePages in
                self?.hideActivityIndicator()
                done(hasMorePages)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail(for: dataSource.itemIdentifier(for: indexPath)!)
    }
}
