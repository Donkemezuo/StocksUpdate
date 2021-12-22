//
//  SymbolTableviewCell.swift
//  StocksUpdate
//
//  Created by Raymond Donkemezuo on 12/21/21.
//

import UIKit

class SymbolTableviewCell: UITableViewCell {
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var closePriceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    
    @IBOutlet weak var symbolNameLabel: UILabel!
    static let cellID = "SymbolTableviewCell"
    
    var viewModel: SymbolTableviewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return;
            }
            setupUI(viewModel)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    private func setupUI(_ viewModel: SymbolTableviewCellViewModel) {
        openPriceLabel.text = viewModel.openPrice
        closePriceLabel.text = viewModel.closePrice
        highPriceLabel.text = viewModel.highPrice
        lowPriceLabel.text = viewModel.lowPrice
        guard let symbolName = viewModel.symbolName else { return }
        symbolNameLabel.isHidden = false
        symbolNameLabel.text = symbolName
    }
    
}
