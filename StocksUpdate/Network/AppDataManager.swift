//
//  AppDataManager.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/20/21.
//

import Foundation
import CoreData
import UIKit

class AppDataManager {
    private let webService = WebService(endPoint: "", urlSession: URLSession.shared)
    var dailySymbolsData = [String: DailyTimeSeries]()
    var weeklySymbolsData = [String: WeeklyTimeSeries]()
    var monthlSymbolsData = [String: MonthlyTimeSeries]()
    var sectionNames = [String]()
    var symbol = ""
    var symbolName = ""
    var favoritedStocksDict = [String: [FavoriteStock]]()
    var stocksFavoritedDates = [String]()
    
    /// - Tag:  A function to fetch a symbol daily time series
    func fetchDailySymbolRecords(searchedSymbol: String?, completionHandler: @escaping(AppErrors?) -> ()) {
        let endPoint = SymbolSearchEndpoint.daily(searchedSymbol: searchedSymbol).endPointsString
        webService.fetchData(endPoint: endPoint) { responseData, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(AppErrors.failedNetworkRequest(message: error.localizedDescription))
            } else if let responseData = responseData {
                do {
                    let symbols = try JSONDecoder().decode(DailySymbol.self, from: responseData)
                    self.symbolName = symbols.metaData.symbol
                    self.symbol = "\(symbols.metaData.symbol) Stocks Daily"
                    self.dailySymbolsData = symbols.dailyTimeSeries
                    self.sectionNames = []
                    self.sectionNames = Array(symbols.dailyTimeSeries.keys)
                    completionHandler(nil)
                } catch {
                    completionHandler(AppErrors.jsonParsing)
                }
            }
        }
    }
    
    /// - Tag:  A function to fetch a symbol weekly time series
    func fetchWeeklySymbolRecords(searchedSymbol: String?, completionHandler: @escaping(AppErrors?) -> ()) {
        let endPoint = SymbolSearchEndpoint.weekly(searchedSymbol: searchedSymbol).endPointsString
        webService.fetchData(endPoint: endPoint) { responseData, error in
            if let error = error {
                completionHandler(AppErrors.failedNetworkRequest(message: error.localizedDescription))
            } else if let responseData = responseData {
                do {
                    let symbols = try JSONDecoder().decode(WeeklySymbol.self, from: responseData)
                    self.symbolName = symbols.metaData.symbol
                    self.symbol = "\(symbols.metaData.symbol) Stocks Weekly"
                    self.sectionNames = []
                    self.sectionNames = Array(symbols.weeklyTimeSeries.keys)
                    self.weeklySymbolsData = symbols.weeklyTimeSeries
                    completionHandler(nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(AppErrors.jsonParsing)
                }
            }
        }
    }
    
    /// - Tag:  A function to fetch a symbol monthly time series
    func fetchMonthlySymbolRecords(searchedSymbol: String?, completionHandler: @escaping(AppErrors?) -> ()) {
        let endPoint = SymbolSearchEndpoint.monthly(searchedSymbol: searchedSymbol).endPointsString
        webService.fetchData(endPoint: endPoint) { responseData, error in
            if let error = error {
                completionHandler(AppErrors.failedNetworkRequest(message: error.localizedDescription))
            } else if let responseData = responseData {
                do {
                    let symbols = try JSONDecoder().decode(MonthlySymbol.self, from: responseData)
                    self.symbolName = symbols.metaData.symbol
                    self.symbol = "\(symbols.metaData.symbol) Stocks Monthly"
                    self.sectionNames = []
                    self.sectionNames = Array(symbols.monthlyTimeSeries.keys)
                    self.monthlSymbolsData = symbols.monthlyTimeSeries
                    completionHandler(nil)
                } catch {
                    print(error.localizedDescription)
                    completionHandler(AppErrors.jsonParsing)
                }
            }
        }
    }
    
    /// - Tag:  A function to  get the coreData  view context from the appDelegate
    private func getCoreDataContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    /// - Tag:  A function to save a stock to coredata
    func saveStockSymbolInCoreData(stock: CoreDataModel) {
        guard let context = getCoreDataContext() else { return }
        let favoriteStock = FavoriteStock(context: context)
        favoriteStock.id = stock.id
        favoriteStock.high = stock.high
        favoriteStock.low = stock.low
        favoriteStock.close = stock.close
        favoriteStock.open = stock.open
        favoriteStock.symbolName = stock.symbolName
        favoriteStock.favoritedDate = stock.favoritedDate
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// - Tag:  A function to fetch a stock from coredata using the id
    func fetchFavoriteFromCoreData(id: String) -> FavoriteStock? {
        guard let context = getCoreDataContext() else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteStock")
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            guard let results = try context.fetch(request) as? [FavoriteStock] else {return nil}
            guard let favoriteStock = results.first else {return nil}
            return favoriteStock
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// - Tag:  A function to fetch all favorited symbols
    func fetchAllFavoritesFromCoreData(completionHandler: @escaping(AppErrors?) -> ()) {
        guard let context = getCoreDataContext() else {return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteStock")
        do {
            guard let results = try context.fetch(request) as? [FavoriteStock] else { return }
            guard !results.isEmpty else { return }
            for result in results {
                if favoritedStocksDict[result.favoritedDate ?? ""] != nil {
                    favoritedStocksDict[result.favoritedDate ?? ""]?.append(result)
                } else {
                    stocksFavoritedDates.append(result.favoritedDate ?? "")
                    favoritedStocksDict[result.favoritedDate ?? ""] = [result]
                }
            }
            completionHandler(nil)
        } catch {
            print(error.localizedDescription)
            completionHandler(AppErrors.coreDataFetch)
            return
        }
    }
    
    /// - Tag:  A function to check if there are favorites
    func favoritesExist() -> Bool {
        guard let context = getCoreDataContext() else {return false }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteStock")
        do {
            guard let results = try context.fetch(request) as? [FavoriteStock] else { return false }
            return !results.isEmpty
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// - Tag:  A function to fetch stocks favorited in a given day
    func fetchAllStocksFavoritedInADate(dateString: String) -> [FavoriteStock] {
        guard let favoritedStocks = favoritedStocksDict[dateString] else {return []}
        return favoritedStocks
    }
}
