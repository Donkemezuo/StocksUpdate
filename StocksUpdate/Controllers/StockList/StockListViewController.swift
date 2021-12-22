//
//  ViewController.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/18/21.
//

import UIKit
import AuthenticationServices

class StockListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var favoritesBarButton: UIBarButtonItem!
    @IBOutlet weak var toggleSegmentedControl: UISegmentedControl!
    
    private let appDataManager = AppDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleSegmentedControl.selectedSegmentIndex = 0
        registerTableView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupBarButtonItemUI()
    }
    
    /// - TAG: A function to register table view
    private func registerTableView() {
        listTableView.register(UINib(nibName: SymbolTableviewCell.cellID, bundle: nil), forCellReuseIdentifier: SymbolTableviewCell.cellID)
        listTableView.dataSource = self
        listTableView.delegate = self
        searchBar.delegate = self
        setupBarButtonItemUI()
    }
    /// - TAG: A function to setup the UI of the favorite button
    private func setupBarButtonItemUI() {
        guard appDataManager.favoritesExist() else { return }
        favoritesBarButton.isEnabled = true
    }
    
    @IBAction func segmentedControlToggle(_ sender: UISegmentedControl) {
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty,
              searchTerm != " " else {
                  fetchData(searchedTerm: nil)
                  return;
              }
        fetchData(searchedTerm: searchTerm)
    }
    
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        showFavoritesList()
    }
    
    /// - TAG: A function to fetch data
    private func fetchData(searchedTerm: String? = nil){
        switch toggleSegmentedControl.selectedSegmentIndex {
        case 0:
            appDataManager.fetchDailySymbolRecords(searchedSymbol: searchedTerm) {[weak self] error in
                if let error = error {
                    self?.showAlert(title: "Unexpected encountered", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self?.title = self?.appDataManager.symbol
                        self?.listTableView.reloadData()
                    }
                }
            }
        case 1:
            appDataManager.fetchWeeklySymbolRecords(searchedSymbol: searchedTerm) { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Unexpected encountered", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self?.title = self?.appDataManager.symbol
                        self?.listTableView.reloadData()
                    }
                }
            }
        case 2:
            appDataManager.fetchMonthlySymbolRecords(searchedSymbol: searchedTerm) { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Unexpected encountered", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self?.title = self?.appDataManager.symbol
                        self?.listTableView.reloadData()
                    }
                }
            }
        default:
            return;
        }
    }
    
    /// - TAG: A function that handles the apple sign in configuration 
    //    private func handleAppleSignin() {
    //        let appleIDProvider = ASAuthorizationAppleIDProvider()
    //        let request = appleIDProvider.createRequest()
    //        request.requestedScopes = [.fullName, .email]
    //        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    //        authorizationController.delegate = self
    //        authorizationController.presentationContextProvider = self
    //        authorizationController.performRequests()
    //    }
}

extension StockListViewController {
    /// - TAG: A function that presents the favorites list view
    private func showFavoritesList() {
        guard appDataManager.favoritesExist() else { return }
        guard let favoritesListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesListViewController") as? FavoritesListViewController else {return }
        navigationController?.pushViewController(favoritesListViewController, animated: true)
    }
    
    /// - TAG: A function that presents the selected stocks details view
    private func showSelectStockDetails(indexPath: IndexPath) {
        let stockDetailsViewModel = createStockDetailsViewModel(indexPath: indexPath)
        guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StockDetailsViewController") as? StockDetailsViewController else {return }
        detailsViewController.viewModel = stockDetailsViewModel
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}

extension StockListViewController {
    /// - TAG: A function that takes a selected index and returns a symbolTableviewCellViewModel
    func createSymbolTableviewCellViewModel(indexPath: IndexPath) -> SymbolTableviewCellViewModel? {
        let sectionName = appDataManager.sectionNames[indexPath.section]
        switch toggleSegmentedControl.selectedSegmentIndex {
        case 0:
            let symbol = appDataManager.dailySymbolsData[sectionName]
            return SymbolTableviewCellViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "")
        case 1:
            let symbol = appDataManager.weeklySymbolsData[sectionName]
            return SymbolTableviewCellViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "")
        case 2:
            let symbol = appDataManager.monthlSymbolsData[sectionName]
            return SymbolTableviewCellViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "")
        default:
            return nil
        }
    }
    
    /// - TAG: A function that takes a selected index and returns a stocksDetailsViewModel
    func createStockDetailsViewModel(indexPath: IndexPath) -> StockDetailsViewModel? {
        let sectionName = appDataManager.sectionNames[indexPath.section]
        switch toggleSegmentedControl.selectedSegmentIndex {
        case 0:
            let symbol = appDataManager.dailySymbolsData[sectionName]
            return StockDetailsViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "", date: sectionName.formattedDateString, symbolName: appDataManager.symbolName)
        case 1:
            let symbol = appDataManager.weeklySymbolsData[sectionName]
            return StockDetailsViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "", date: sectionName.formattedDateString, symbolName: appDataManager.symbolName)
        case 2:
            let symbol = appDataManager.monthlSymbolsData[sectionName]
            return StockDetailsViewModel(open: symbol?.openingPrice ?? "", close: symbol?.close ?? "", high: symbol?.high ?? "", low: symbol?.low ?? "", date: sectionName.formattedDateString, symbolName: appDataManager.symbolName)
        default:
            return nil
        }
    }
}

extension StockListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchSymbol = searchBar.text,
              !searchSymbol.isEmpty,
              searchSymbol != " "
        else {
            return
        }
        fetchData(searchedTerm: searchSymbol)
    }
}

/// - Tag: Tableview Datasource
extension StockListViewController: UITableViewDataSource,
                                   UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appDataManager.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appDataManager.sectionNames[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let symbolCell = tableView.dequeueReusableCell(withIdentifier: SymbolTableviewCell.cellID, for: indexPath) as? SymbolTableviewCell else { return UITableViewCell() }
        symbolCell.viewModel = createSymbolTableviewCellViewModel(indexPath: indexPath)
        return symbolCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSelectStockDetails(indexPath: indexPath)
    }
}

//extension StockListViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user
//            let fullname = appleIDCredential.fullName?.description ?? ""
//            let email = appleIDCredential.email ?? ""
//            print("Email is ", email, "Full name is ", fullname, " and the user is ", userIdentifier)
//        default:
//            break
//        }
//    }
//}
