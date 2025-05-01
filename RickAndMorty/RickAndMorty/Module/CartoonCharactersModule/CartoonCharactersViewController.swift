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
    
    private enum Section: Int, CaseIterable {
        case characters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIP()
        setupUI()
        fetchCharacters()
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
        view.backgroundColor = .white
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource = UITableViewDiffableDataSource<Section, Character>(
            tableView: tableView
        ) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.species
//            if let url = item.image {
                // MARK: Only for test
                // TODO: - ADd Kingfisher
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: url),
//                       let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            cell.imageView?.image = image
//                            cell.setNeedsLayout()
//                        }
//                    }
//                }
//            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.characters])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func fetchCharacters() {
        paginator.loadIfNeeded(currentIndex: 0,
                               totalCount: dataSource.snapshot().numberOfItems) { [weak self] page, done in
            self?.interactor?.fetchCharacters(page: page) { hasMorePages in
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
            self?.interactor?.fetchCharacters(page: page) { hasMorePages in
                done(hasMorePages)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail(for: dataSource.itemIdentifier(for: indexPath)!)
    }
}
