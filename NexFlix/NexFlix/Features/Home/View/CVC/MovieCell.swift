//
//  MovieCell.swift
//  NexFlix
//
//  Created by Himanshu Dev on 02/01/26.
//

import UIKit

final class MovieCell: UICollectionViewCell {

    static let reuseId = "MovieCell"

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        // MARK: - Reset image for reuse
        imageView.image = UIImage(systemName: "photo")
        guard let path = movie.posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
              return
        }

        Task {
            if let image = try? await ImageLoader.shared.loadImage(from: url) {
                imageView.image = image
            }
        }
    }

    private func configure() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
