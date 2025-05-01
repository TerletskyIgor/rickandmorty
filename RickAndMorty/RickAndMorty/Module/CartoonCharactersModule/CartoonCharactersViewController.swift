//
//  CartoonCharacters.swift
//  RickAndMorty
//
//  Created by Igor Terletskyi on 30.04.2025.
//

import UIKit

protocol CartoonCharactersDisplayLogic: AnyObject {
    func displayCharacters(viewModel: CartoonCharacters.Fetch.ViewModel)
}

final class CartoonCharactersViewController: UIViewController {
    var interactor: CartoonCharactersBusinessLogic?
    var router: CartoonCharactersRoutingLogic?

    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, CartoonCharacters.Fetch.ViewModel.DisplayCharacter>!
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
        
        dataSource = UITableViewDiffableDataSource<Section, CartoonCharacters.Fetch.ViewModel.DisplayCharacter>(
            tableView: tableView
        ) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.species
            
            if let url = item.imageURL {
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
            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CartoonCharacters.Fetch.ViewModel.DisplayCharacter>()
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
    func displayCharacters(viewModel: CartoonCharacters.Fetch.ViewModel) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(viewModel.characters, toSection: .characters)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

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
