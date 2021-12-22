//
//  FavoritesListViewController.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/22/21.
//

import UIKit

class FavoritesListViewController: UIViewController {
    @IBOutlet weak var favoritesTableView: UITableView!
    private let appDataManager = AppDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        fetchData()
    }
    
    /// - TAG: A function to fetch Data
    private func fetchData() {
        appDataManager.fetchAllFavoritesFromCoreData { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Unexpected encountered", message: error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self?.favoritesTableView.reloadData()
                }
            }
        }
    }
    
    /// - TAG: A function to register table view
    private func registerTableView() {
        favoritesTableView.register(UINib(nibName: SymbolTableviewCell.cellID, bundle: nil), forCellReuseIdentifier: SymbolTableviewCell.cellID)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return appDataManager.stocksFavoritedDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = appDataManager.stocksFavoritedDates[section]
        return appDataManager.fetchAllStocksFavoritedInADate(dateString: date).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = appDataManager.stocksFavoritedDates[indexPath.section]
        guard let stockCell = tableView.dequeueReusableCell(withIdentifier: SymbolTableviewCell.cellID, for: indexPath) as? SymbolTableviewCell else { return UITableViewCell() }
        let stock = appDataManager.fetchAllStocksFavoritedInADate(dateString: date)[indexPath.row]
        let cellViewModel = SymbolTableviewCellViewModel(open: stock.open ?? "", close: stock.close ?? "''", high: stock.high ?? "", low: stock.low ?? "", symbolName: stock.symbolName ?? "")
        stockCell.viewModel = cellViewModel
        return stockCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appDataManager.stocksFavoritedDates[section]
    }
    
    
}
