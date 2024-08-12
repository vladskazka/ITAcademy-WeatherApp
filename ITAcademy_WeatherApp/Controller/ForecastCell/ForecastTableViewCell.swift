//
//  ForecastTableViewCell.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 28.06.2024.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    static var id: String { "\(Self.self)" }
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: K.size.text.day, weight: .regular)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .right
        label.font = .systemFont(ofSize: K.size.text.tempForecast, weight: .medium)
        return label
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = nil
        temperatureLabel.text = nil
        weatherConditionImageView.image = nil
    }
    
    private func setupUI() {
        
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .white.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        contentView.layer.shadowRadius = 3
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherConditionImageView)
        
        dayLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(K.offsets.tableViewRegular)
            make.right.equalTo(temperatureLabel.snp.left)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(K.offsets.tableViewRegular)
            make.width.equalTo(K.size.width.tableViewTempLabel)
            make.right.equalTo(weatherConditionImageView.snp.left).offset(K.offsets.tableViewLabelRight)
        }
        
        weatherConditionImageView.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(K.offsets.tableViewImage)
            make.width.equalTo(weatherConditionImageView.snp.height)
        }
    }
    
    func configure(viewModel: DailyForecast) {
        
        dayLabel.text = viewModel.dayOfWeek
        temperatureLabel.text = viewModel.temperature
        weatherConditionImageView.image = UIImage(systemName: viewModel.imageName)?.withPalette(viewModel.imageColors)
    }

}
