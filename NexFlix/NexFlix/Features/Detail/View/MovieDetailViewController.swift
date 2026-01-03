//
//  MovieDetailViewController.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import Foundation
import UIKit

final class MovieDetailViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: MovieDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropImageView = UIImageView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()

    // MARK: - Init

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureScrollView()
        configureViews()
        setupLayout()
        configureData()
    }
}

// MARK: - UI Setup

private extension MovieDetailViewController {

    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func configureViews() {

        view.backgroundColor = .systemBackground

        // MARK: - Backdrop Image
        backdropImageView.contentMode = .scaleAspectFill
        view.addSubview(backdropImageView)

        // MARK: - Back Button
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .white.withAlphaComponent(0.3)
        backButton.layer.cornerRadius = 25
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(tapOnBack), for: .touchUpInside)

        // MARK: - Labels
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)

        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        contentView.addSubview(overviewLabel)

        ratingLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(ratingLabel)

        releaseDateLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(releaseDateLabel)
    }


    func setupLayout() {
        [backdropImageView, titleLabel, ratingLabel, releaseDateLabel, overviewLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 300),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

    }

    func configureData() {
        titleLabel.text = viewModel.titleText
        overviewLabel.text = viewModel.overviewText
        ratingLabel.text = viewModel.userRatingText
        releaseDateLabel.text = viewModel.releaseDateText

        // MARK: - Load backdrop image
        if let url = viewModel.posterURL {
            Task {
                let image = try? await ImageLoader.shared.loadImage(from: url)
                backdropImageView.image = image
            }
        }
    }
    
    @objc private func tapOnBack() {
        navigationController?.popViewController(animated: true)
    }
}
