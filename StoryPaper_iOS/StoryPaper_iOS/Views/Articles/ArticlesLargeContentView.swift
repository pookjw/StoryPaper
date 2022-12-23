//
//  ArticlesLargeContentView.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/23/22.
//

import UIKit
import SPLogger

@MainActor
final class ArticlesLargeContentView: UIView {
    private var imageView: AsyncImageView!
    private var contentStackView: UIStackView!
    private var gradientView: UIVisualEffectView!
    private var gradientViewGradientLayer: CAGradientLayer!
    private var primaryLabel: UILabel!
    private var secondaryLabel: UILabel!
    private var gradientViewBoundsObservationContext: Void?
    
    private var _configuration: ArticlesLargeContentConfiguration!
    private var asyncImageTask: Task<Void, Never>?
    
    convenience init(configuration: ArticlesLargeContentConfiguration) {
        self.init(frame: .null)
        configureImageView()
        configureContentStackView()
        configureGradientView()
        configureGradientViewGradientLayer()
        configurePrimaryLabel()
        configureSecondaryLabel()
        bind()
        
        self.configuration = configuration
    }
    
    deinit {
        asyncImageTask?.cancel()
        gradientView.removeObserver(
            self,
            forKeyPath: #keyPath(UIView.bounds),
            context: &gradientViewBoundsObservationContext
        )
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &gradientViewBoundsObservationContext {
            Task { @MainActor [weak self] in
                guard let self else { return }
                let bounds: CGRect = self.gradientView.bounds
                gradientViewGradientLayer.startPoint = .zero
                gradientViewGradientLayer.endPoint = .init(x: .zero, y: 300.0 / bounds.size.height)
                self.gradientViewGradientLayer.frame = bounds
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func configureImageView() {
        let imageView: AsyncImageView = .init(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.imageView = imageView
    }
    
    private func configureGradientView() {
        let gradientView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .dark))
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(gradientView)
        bringSubviewToFront(contentStackView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -320.0),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.gradientView = gradientView
    }
    
    private func configureGradientViewGradientLayer() {
        let gradientViewGradientLayer: CAGradientLayer = .init()
        gradientViewGradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor
        ]
        
        gradientView.layer.mask = gradientViewGradientLayer
        
        self.gradientViewGradientLayer = gradientViewGradientLayer
    }
    
    private func configureContentStackView() {
        let contentStackView: UIStackView = .init()
        contentStackView.axis = .vertical
        contentStackView.spacing = 8.0
        contentStackView.distribution = .fillProportionally
        contentStackView.backgroundColor = .clear
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)
        ])
        
        self.contentStackView = contentStackView
    }
    
    private func configurePrimaryLabel() {
        let primaryLabel: UILabel = .init()
        primaryLabel.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: nil)
        primaryLabel.numberOfLines = 1
        primaryLabel.textColor = .white
        primaryLabel.backgroundColor = .clear
        
        contentStackView.addArrangedSubview(primaryLabel)
        
        self.primaryLabel = primaryLabel
    }
    
    private func configureSecondaryLabel() {
        let secondaryLabel: UILabel = .init()
        secondaryLabel.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: nil)
        secondaryLabel.numberOfLines = 2
        secondaryLabel.textColor = .white
        secondaryLabel.backgroundColor = .clear
        
        contentStackView.addArrangedSubview(secondaryLabel)
        
        self.secondaryLabel = secondaryLabel
    }
    
    private func bind() {
        gradientView.addObserver(
            self,
            forKeyPath: #keyPath(UIVisualEffectView.bounds),
            options: [.initial, .new],
            context: &gradientViewBoundsObservationContext
        )
    }
    
    private func update(
        oldConfiguration: ArticlesLargeContentConfiguration?,
        newConfiguration: ArticlesLargeContentConfiguration
    ) {
        let itemModel: ArticlesItemModel = newConfiguration.itemModel
        
        //
        
        asyncImageTask?.cancel()
        if let thumbnailURL: URL = itemModel.thumbnailImageURL {
            asyncImageTask = .detached { [imageView] in
                do {
                    try? await imageView?.loadAyncImage(from: thumbnailURL)
                } catch {
                    log.error(error)
                }
            }
        } else {
            imageView.image = nil
        }
        
        //
        
        primaryLabel.text = itemModel.title
        
        if let description: String = itemModel.description {
            secondaryLabel.isHidden = false
            secondaryLabel.text = description
        } else {
            secondaryLabel.isHidden = true
            secondaryLabel.text = nil
        }
    }
}

extension ArticlesLargeContentView: UIContentView {
    var configuration: UIContentConfiguration {
        get {
            return _configuration
        }
        set {
            let oldConfiguration: ArticlesLargeContentConfiguration? = _configuration
            let newConfiguration: ArticlesLargeContentConfiguration = newValue as! ArticlesLargeContentConfiguration
            
            _configuration = newConfiguration
            update(oldConfiguration: oldConfiguration, newConfiguration: newConfiguration)
        }
    }
    
    func supports(_ configuration: UIContentConfiguration) -> Bool {
        configuration is ArticlesLargeContentConfiguration
    }
}
