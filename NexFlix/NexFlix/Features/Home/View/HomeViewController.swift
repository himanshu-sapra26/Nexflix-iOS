//
//  HomeViewController.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = HomeViewModel(service: MovieService())
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchTextField = UITextField()
    private var debounceWorkItem: DispatchWorkItem?
    private let debounceDelay: TimeInterval = 0.5
    private enum Section { case main }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchTextField()
        configureCollectionView()
        configureDataSource()
        bindViewModel()

        Task {
            await viewModel.loadInitialMovies()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debounceWorkItem?.cancel()
    }


}

// MARK: - UI Setup
private extension HomeViewController {
    
    func configureUI() {
        title = "NexFlix"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        definesPresentationContext = true
        
    }
    
    func configureSearchTextField() {

        searchTextField.placeholder = "Search Movies"
        searchTextField.backgroundColor = .secondarySystemBackground
        searchTextField.layer.cornerRadius = 12
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        searchTextField.tintColor = .black
        searchTextField.delegate = self

        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)

        // MARK: - Left icon
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .secondaryLabel
        icon.contentMode = .center

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        icon.frame = CGRect(x: 10, y: 0, width: 24, height: 44)
        containerView.addSubview(icon)

        searchTextField.leftView = containerView
        searchTextField.leftViewMode = .always

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseId)
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            // MARK: - Small Item
            let smallItem = NSCollectionLayoutItem( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0) ) )
            smallItem.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // MARK: - Big Item
            let bigItem = NSCollectionLayoutItem( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0) ) )
            bigItem.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // MARK: - Small Vertical Group (2 rows)
            let smallVerticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalHeight(1.0) ), subitem: smallItem, count: 2 )
            
            // MARK: - Big Vertical Group (takes 2 rows)
            let bigVerticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalHeight(1.0) ), subitem: bigItem, count: 1 )
            
            // MARK: - Final Horizontal Group (3 columns)
            let isBigOnLeft = sectionIndex % 2 == 0
            
            let mainGroup = NSCollectionLayoutGroup.horizontal( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300) ), subitems: isBigOnLeft ? [bigVerticalGroup, smallVerticalGroup, smallVerticalGroup] : [smallVerticalGroup, smallVerticalGroup, bigVerticalGroup] )
            
            let section = NSCollectionLayoutSection(group: mainGroup)
            section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            return section
        }
        
        return layout
    }
    
    
}

// MARK: - ViewModel Binding & Snapshot
private extension HomeViewController {
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .idle, .loading:
                break
            case .loaded(let movies):
                applySnapshot(movies)
            case .error(let message):
                showError(message)
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell( withReuseIdentifier: MovieCell.reuseId, for: indexPath ) as! MovieCell
            cell.configure(with: movie)
            return cell
        }
    }
    
    func applySnapshot(_ movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task {
            await viewModel.loadMoreIfNeeded(currentIndex: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = MovieDetailViewController(viewModel: MovieDetailViewModel(movie: movie))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString)
            .replacingCharacters(in: range, with: string)

        // MARK: - Cancel previous pending search
        debounceWorkItem?.cancel()

        // MARK: - Create new debounce task
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }

            Task {
                if updatedText.trimmingCharacters(in: .whitespaces).isEmpty {
                    await self.viewModel.loadInitialMovies()
                } else {
                    await self.viewModel.searchMovies(query: updatedText)
                }
            }
        }

        debounceWorkItem = workItem

        // MARK: - Execute after delay
        DispatchQueue.main.asyncAfter(
            deadline: .now() + debounceDelay,
            execute: workItem
        )

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
