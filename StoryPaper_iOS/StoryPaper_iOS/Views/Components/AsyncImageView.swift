//
//  AsyncImageView.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/21/22.
//

import UIKit
import SPDataCacheStore
import SPError
import SPLogger

@MainActor
final class AsyncImageView: UIImageView {
    private var activityIndicatorView: UIActivityIndicatorView!
    private let dataCacheStore: SPDataCacheStore = .shared
    private var currentImageURL: URL?
    
    override var image: UIImage? {
        get {
            super.image
        }
        set {
            currentImageURL = nil
            super.image = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureActivityIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureActivityIndicatorView()
    }
    
    nonisolated func loadAyncImage(from url: URL) async throws {
        guard await url != currentImageURL else {
            return
        }
        
        await MainActor.run { [weak self] in
            self?.image = nil
            self?.activityIndicatorView.startAnimating()
        }
        
        if
            let dataCache: SPDataCache = try await dataCacheStore.fetchDataCache(with: url.absoluteString).last,
            let image: UIImage = .init(data: dataCache.data)
        {
            await MainActor.run { [weak self] in
                self?.image = image
                self?.currentImageURL = currentImageURL
                self?.activityIndicatorView.stopAnimating()
            }
        } else {
            let configuration: URLSessionConfiguration = .ephemeral
            let session: URLSession = URLSession(configuration: configuration)
            
            log.debug(url)
            
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            
            let (data, response): (Data, URLResponse) = try await session.data(for: request)
            
            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                throw SPError.typeMismatch
            }
            
            guard httpResponse.statusCode == 200 else {
                throw SPError.invalidHTTPResponseCode(httpResponse.statusCode)
            }
            
            guard let image: UIImage = .init(data: data) else {
                throw SPError.unexpectedNil
            }
            
            await MainActor.run { [weak self] in
                self?.image = image
                self?.currentImageURL = currentImageURL
                self?.activityIndicatorView.stopAnimating()
            }
            
            let dataCache: SPDataCache = try await dataCacheStore.newDataCache()
            dataCache.identity = url.absoluteString
            dataCache.data = data
            
            try await dataCacheStore.saveChanges()
        }
    }
    
    private func configureActivityIndicatorView() {
        let activityIndicatorView: UIActivityIndicatorView = .init(frame: bounds)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        self.activityIndicatorView = activityIndicatorView
    }
}
