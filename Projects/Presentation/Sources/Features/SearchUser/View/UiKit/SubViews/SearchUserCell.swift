//
//  SearchUserCell.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit
import Combine

final class SearchUserCell: UITableViewCell {
    // MARK: - Property
    static let identifier = String(describing: SearchUserCell.self)
    
    private var viewModel: SearchUserItemViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let imageSize: CGFloat = 55
    
    // MARK: - UI Component
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        
        return label
    }()
    
    private let urlLinkLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var imageLoadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.style = .medium
        view.startAnimating()
        view.color = .black
        view.isHidden = false
        
        return view
    }()
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse Cell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellables.removeAll()
        
        imageLoadingSpinner.isHidden = false
        posterImageView.image = nil
        nameLabel.text = ""
        urlLinkLabel.text = ""
        
        viewModel = nil
    }
    
    private func setupLayout() {
        [
            nameLabel,
            posterImageView,
            imageLoadingSpinner,
            urlLinkLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 8
            ),
            posterImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: imageSize),
            posterImageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            imageLoadingSpinner.centerXAnchor.constraint(
                equalTo: posterImageView.centerXAnchor
            ),
            imageLoadingSpinner.centerYAnchor.constraint(
                equalTo: posterImageView.centerYAnchor
            ),
            
            nameLabel.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: 16
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 6
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -16
            ),
            
            urlLinkLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 6
            ),
            urlLinkLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlLinkLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            urlLinkLabel.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -16
            )
        ])
    }
    
    private func setupAttribute() {
        self.backgroundColor = .white
        self.selectionStyle = .none
    }
    
    // MARK: - Binding
    func bind(with viewModel: SearchUserItemViewModel) {
        self.viewModel = viewModel
        
        self.nameLabel.text = viewModel.user.name
        self.urlLinkLabel.text = viewModel.user.url.absoluteString
        
        let output = viewModel.transform(
            input: SearchUserItemViewModelInput()
        )
        
        output.imageData
            .sink { [weak self] data in
                guard let self = self else { return }
                self.imageLoadingSpinner.isHidden = true
                
                if let image = UIImage(data: data) {
                    self.posterImageView.image = image
                } else {
                    self.posterImageView.backgroundColor = .lightGray
                }
            }
            .store(in: &cancellables)
        
        output.error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                self.imageLoadingSpinner.isHidden = true
                self.posterImageView.backgroundColor = .lightGray
            }
            .store(in: &cancellables)
        
        viewModel.fetchImage()
    }
    
    func getURL() -> URL {
        guard let url = viewModel?.user.url else {
            return URL(string: "https://github.com")!
        }
        
        return url
    }
}
