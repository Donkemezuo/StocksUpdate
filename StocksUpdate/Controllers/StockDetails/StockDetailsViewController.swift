//
//  StockDetailsViewController.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/21/21.
//

import UIKit

class StockDetailsViewController: UIViewController {
    @IBOutlet weak var stockSymbolNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var openingPriceLabel: UILabel!
    @IBOutlet weak var closingPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    let appManager = AppDataManager()
    
    var viewModel: StockDetailsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoreData()
        setupUI()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        let coreDataModel = CoreDataModel(symbolName: viewModel.symbolName, low: viewModel.low, id: viewModel.date, open: viewModel.open, close: viewModel.close, high: viewModel.high, favoritedDate: Date().formattedDateString_mmmddyyyy)
        appManager.saveStockSymbolInCoreData(stock: coreDataModel)
        self.viewModel?.isFavorited = true
        DispatchQueue.main.async {
            self.setupButtonUI()
        }
    }
    
    private func fetchCoreData() {
        guard let viewModel = viewModel else { return }
        guard appManager.fetchFavoriteFromCoreData(id: viewModel.date) != nil else { return }
        self.viewModel?.isFavorited = true
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        stockSymbolNameLabel.text = viewModel.symbolName
        openingPriceLabel.text = viewModel.openingPrice
        closingPriceLabel.text = viewModel.closingPrice
        lowPriceLabel.text = viewModel.lowPrice
        highPriceLabel.text = viewModel.highPrice
        dateLabel.text = viewModel.date
        setupButtonUI()
    }
    
    private func setupButtonUI() {
        guard let viewModel = viewModel else {
            return
        }
        favoriteButton.setTitle(viewModel.isFavorited ? "Favorited" : "Favorite", for: .normal)
        favoriteButton.setTitleColor(viewModel.isFavorited ? UIColor.systemGray4 : UIColor.systemBackground, for: .normal)
        favoriteButton.backgroundColor = viewModel.isFavorited ? .systemGray3 : .systemBrown
    }
}
