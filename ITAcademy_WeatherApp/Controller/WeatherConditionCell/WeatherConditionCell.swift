//
//  DetailCollectionViewCell.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 28.06.2024.
//

import UIKit

class WeatherConditionCell: UICollectionViewCell {
    
    static var id: String { "\(Self.self)" }
        
    private let weatherConditionContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.7)
        label.textAlignment = .right
        label.font = .italicSystemFont(ofSize: K.size.text.weather)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white.withAlphaComponent(0.8)
        contentView.layer.cornerRadius = 20
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherLabel.text = nil
        weatherConditionImageView.image = nil
        
    }
    
    private func setupUI() {
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        contentView.layer.shadowRadius = 3
        
        contentView.addSubview(weatherConditionContainer)
        contentView.addSubview(weatherLabel)
        
        weatherConditionContainer.addSubview(weatherConditionImageView)
        
        weatherConditionContainer.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(K.offsets.collectionViewRegular)
            make.width.equalTo(weatherConditionContainer.snp.height)
        }
        
        weatherConditionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(K.offsets.collectionViewImage)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(K.offsets.collectionViewRegular)
            make.right.equalToSuperview().inset(K.offsets.collectionViewLabel)
            make.left.equalTo(weatherConditionContainer).offset(K.offsets.collectionViewRegular)
        }
    }
    
    func configure(viewModel: WeatherCondition) {
        
        let config = UIImage.SymbolConfiguration(paletteColors: viewModel.imageColors)
        
        weatherConditionImageView.image = UIImage(systemName: viewModel.imageName)?.applyingSymbolConfiguration(config)
        weatherLabel.text = viewModel.description
        
    }
    
    
    
}
