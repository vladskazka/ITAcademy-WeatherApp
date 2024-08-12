//
//  ViewController.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 27.06.2024.
//

import UIKit
import SnapKit

protocol IWeatherViewController: AnyObject {
    
    func switchForecast(height: CGFloat)
    func buttonSwitch(threeBool: Bool, sevenBool: Bool)
    func updateCurrentWeather(with weather: FormattedCurrentWeather?)
    func updateLocationData(with data: FormattedForecastWeather?)
    func updateDataSources(with forecast: Forecast)
    func resetTextField()
    func reloadCollections()
}

enum ForecastType: Int {
    case three = 3
    case seven = 7
}

// MARK: - WeatherViewController

class WeatherViewController: UIViewController {
    
    // MARK: - Properties: Presenters

    private let presenter: IWeatherViewControllerPresenter
    private let collectionCellPresenter: IWeatherConditionCellPresenter
    private let tableViewCellPresenter: ITableViewCellPresenter
    
    // MARK: - Properties: Containers
        
    private let scrollView = UIScrollView()
    private let searchContainer = UIView()
    private let cityNameContainer = UIView()
    private let currentDateContainer = UIView()
    private let weatherIconContainer = UIView()
    private let currentWeatherContainer = UIView()
    private let weatherDetailsContainer = UIView()
    private let forecastSelectorContainer = UIView()
    private let forecastContainer = UIView()
    private let copyrightContainer = UIView()
    
    // MARK: - Properties: TextField
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .white.withAlphaComponent(0.8)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 25
        textField.clipsToBounds = true
        return textField
    }()
    
    // MARK: - Properties: Buttons

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: K.images.search)?.withPalette([.white, .systemGray6]), for: .normal)
        button.imageView?.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private let threeDaysButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.label.threeDays.uppercased(), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.contentHorizontalAlignment = .fill
        button.isSelected = true
        return button
    }()
    
    private let sevenDaysButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.label.sevenDays.uppercased(), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.contentHorizontalAlignment = .fill
        button.isSelected = false
        return button
    }()
    
    // MARK: - Properties: Labels

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = K.label.noConnection
        label.textColor = .black
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: K.size.text.city, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = K.label.somethingWrong
        label.textColor = .gray
        label.font = .systemFont(ofSize: K.size.text.date, weight: .thin)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "\(K.label.dashes)°"
        label.textColor = .black
        label.font = .systemFont(ofSize: K.size.text.temp, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = K.label.copyrights
        label.textColor = .gray
        label.font = .systemFont(ofSize: K.size.text.copyright, weight: .thin)
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties: Images

    private let blurImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .blur
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: K.images.connectivityIssue)?.withPalette(K.palette.error)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowRadius = 3
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Properties: Collections

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(WeatherConditionCell.self, forCellWithReuseIdentifier: WeatherConditionCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - Initializer
    
    init(presenter: IWeatherViewControllerPresenter, collectionCellPresenter: IWeatherConditionCellPresenter, tableViewCellPresenter: ITableViewCellPresenter) {
        self.presenter = presenter
        self.collectionCellPresenter = collectionCellPresenter
        self.tableViewCellPresenter = tableViewCellPresenter
        
        super.init(nibName: nil, bundle: nil)
        
        presenter.delegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindBackgroundColor()
        
        setupUI()
        setupActions()
        
        presenter.loadWeather(for: K.label.defaultCity)
    }
    
    // MARK: - Flow Functions
    
    private func setupUI() {
        
        view.addSubview(blurImageView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(searchContainer)
        scrollView.addSubview(cityNameContainer)
        scrollView.addSubview(currentDateContainer)
        scrollView.addSubview(weatherIconContainer)
        scrollView.addSubview(currentWeatherContainer)
        scrollView.addSubview(weatherDetailsContainer)
        scrollView.addSubview(forecastSelectorContainer)
        scrollView.addSubview(forecastContainer)
        scrollView.addSubview(copyrightContainer)
        
        searchContainer.addSubview(textField)
        searchContainer.addSubview(searchButton)
        
        cityNameContainer.addSubview(cityNameLabel)
        
        currentDateContainer.addSubview(dateLabel)
        
        weatherIconContainer.addSubview(weatherConditionImageView)
        
        currentWeatherContainer.addSubview(temperatureLabel)
        
        weatherDetailsContainer.addSubview(collectionView)
        
        forecastSelectorContainer.addSubview(threeDaysButton)
        forecastSelectorContainer.addSubview(sevenDaysButton)
        
        forecastContainer.addSubview(tableView)
        
        copyrightContainer.addSubview(copyrightLabel)
        
        blurImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchContainer.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(K.size.height.searchContainer)
            make.width.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(K.offsets.regular)
            make.right.equalTo(searchButton.snp.left).offset(K.offsets.textFieldRight)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(K.offsets.searchButtonRight)
            make.width.equalTo(searchButton.snp.height)
        }
        
        cityNameContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchContainer.snp.bottom)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(K.offsets.regular)
            make.top.equalToSuperview().inset(K.offsets.cityLabelTop)
            make.bottom.equalToSuperview()
        }
        
        currentDateContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cityNameContainer.snp.bottom)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(K.offsets.regular)
            make.top.bottom.equalToSuperview()
        }
        
        weatherIconContainer.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(currentDateContainer.snp.bottom)
            make.height.equalTo(K.size.height.weatherIconContainer)
            make.width.equalTo(view.frame.width / 2)
        }
        
        weatherConditionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(K.offsets.regular)
        }
        
        currentWeatherContainer.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(currentDateContainer.snp.bottom)
            make.left.equalTo(weatherIconContainer.snp.right)
            make.height.equalTo(K.size.height.currentWeatherContainer)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weatherDetailsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(weatherIconContainer.snp.bottom)
            make.height.equalTo(K.size.height.weatherDetailsContainer)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(K.offsets.regular)
        }
        
        forecastSelectorContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(K.offsets.forecastSide)
            make.top.equalTo(weatherDetailsContainer.snp.bottom)
            make.height.equalTo(K.size.height.forecastSelectorContainer)
        }
        
        threeDaysButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(K.offsets.regular)
            make.width.equalTo(K.size.height.forecastButton)
        }
        
        sevenDaysButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(threeDaysButton.snp.right).offset(K.offsets.regular)
            make.width.equalTo(K.size.height.forecastButton)
        }
        
        forecastContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(forecastSelectorContainer.snp.bottom)
            make.height.equalTo(K.size.height.forecastCollapsed)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(K.offsets.regular)
            make.top.bottom.equalToSuperview()
        }
        
        copyrightContainer.snp.makeConstraints { make in
            make.top.equalTo(forecastContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        copyrightLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(K.offsets.regular)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(recognizer)
        
        let searchAction = UIAction { [weak self] _ in
            self?.searchCity()
        }
        
        searchButton.addAction(searchAction, for: .touchUpInside)
        
        let threeAction = UIAction { [weak self] _ in
            self?.presenter.switchForecast(for: .three)
        }
        
        threeDaysButton.addAction(threeAction, for: .touchUpInside)
     
        let sevenAction = UIAction { [weak self] _ in
            self?.presenter.switchForecast(for: .seven)
        }
        
        sevenDaysButton.addAction(sevenAction, for: .touchUpInside)
    }
    
    private func searchCity() {
        
        if textField.text == "" {
            textField.placeholder = K.label.textFieldPlaceholder
        } else {
            presenter.loadWeather(for: textField.text?.edited())
        }
        
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegate Functions

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionCellPresenter.getWeatherArrayCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionCell.id, for: indexPath) as? WeatherConditionCell else { return UICollectionViewCell() }
        
        cell.configure(viewModel: collectionCellPresenter.getWeatherCondition(at: indexPath.item))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        K.offsets.regular
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - K.offsets.regular) / 2
        
        return CGSize(width: side, height: K.size.height.collectionCellHeight)
    }
}

// MARK: - UITableViewDelegate Functions

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getDayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        
        cell.configure(viewModel: tableViewCellPresenter.getForecast(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.size.height.tableViewCellHeight
    }
}
// MARK: - UITextFieldDelegate Functions

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            textField.placeholder = K.label.textFieldAngryPlaceholder
            return false
        } else {
            searchCity()
            dismissKeyboard()
            return true
        }
    }
}

// MARK: - IWeatherViewController Functions

extension WeatherViewController: IWeatherViewController {
    
    func updateCurrentWeather(with weather: FormattedCurrentWeather?) {
        
        guard let weather else { return }
        
        temperatureLabel.text = weather.temp
        weatherConditionImageView.image = UIImage(systemName: weather.imageName)?.withPalette(weather.colors)
    }
    
    func updateLocationData(with data: FormattedForecastWeather?) {
        
        guard let data else { return }
        
        cityNameLabel.text = data.cityName
        dateLabel.text = data.date
    }
    
    func updateDataSources(with forecast: Forecast) {
        collectionCellPresenter.updateArray(with: forecast.data.first)
        tableViewCellPresenter.updateForecastArray(for: forecast)
    }
    
    func resetTextField() {
        textField.text = ""
        textField.placeholder = ""
    }
    
    func reloadCollections() {
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func buttonSwitch(threeBool: Bool, sevenBool: Bool) {
        threeDaysButton.isSelected = threeBool
        sevenDaysButton.isSelected = sevenBool
    }
    
    func switchForecast(height: CGFloat) {
        
        forecastContainer.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - Bindable

extension WeatherViewController {
    
    func bindBackgroundColor() {
        presenter.backgroundColor.bind { color in
            UIView.animate(withDuration: 1) {
                self.view.backgroundColor = color
            }
        }
    }
}

