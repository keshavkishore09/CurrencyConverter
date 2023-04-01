//
//  CurrencyConversionViewController.swift
//  CurrencyConverter
//
//  Created by Keshav Kishore on 08/02/23.
//

import UIKit

class CurrencyConversionViewController: UIViewController {
    
    var selectedCurrencyPriceToUSD: Double?
    var workItemRefence: DispatchWorkItem? = nil
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    var homeViewModel = CurrencyConverionControllerViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyConversionTableViewCell.self, forCellReuseIdentifier: "currencyCell")
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.backgroundColor = .clear
        textField.tintColor = .white
        textField.textColor = .white
        let redPlaceholderText = NSAttributedString(string: "Enter the amount",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.attributedPlaceholder = redPlaceholderText
        textField.borderStyle = .bezel
        return textField
    }()
    
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .systemGray
        return pickerView
    }()
    
    
    private let dropDownImageView: UIImageView = {
        let image = UIImage(imageLiteralResourceName: "downArrow")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let selectedTextField: UITextField = {
        let redPlaceholderText = NSAttributedString(string: "Select the Currency",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let textField = UITextField()
        textField.attributedPlaceholder = redPlaceholderText
        textField.textColor = .white
        textField.tag = 1
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let selectCurrencyView: UIView = {
        let currencyView = UIView()
        currencyView.backgroundColor = .clear
        return currencyView
    }()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        constraintsForAmountTextField()
        
        constraintsForSelectedCurrencyView()
        constraintsForSelectedCurrencyTextField()
        constraintsFordropDownImageView()
        
        
        constraintsForTableView()
        constraintsForPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        amountTextField.delegate = self
        selectedTextField.delegate = self
        
        pickerView.isHidden = true
        
        activityIndicatorView = self.activityIndicator(style: .large, center: self.view.center)
        self.view.addSubview(activityIndicatorView)
        
        view.backgroundColor = UIColor(hex: 0x1A1D1F)
        
        overrideUserInterfaceStyle = .light
        
        homeViewModel.populateDropDownView {[weak self] success in
            self?.activityIndicatorVisibleAndAnimating()
            if (success) {
                DispatchQueue.main.async {
                    self?.activityIndicatorHiddenAndNotAnimating()
                    self?.pickerView.reloadAllComponents()
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.activityIndicatorHiddenAndNotAnimating()
                    self?.showAlert(msg: self?.homeViewModel.errorString ?? "")
                }
            }
        }
    }
    
    private func showAlert(msg: String) {
        let alertController: UIAlertController =
        UIAlertController(title:"Error",
                          message: msg,
                          preferredStyle: .alert)
        
        
        let okAction:UIAlertAction =
        UIAlertAction(title: "OK",
                      style: .default, handler: {_ in alertController.dismiss(animated: true)})
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        pickerView.isHidden = false
        selectedTextField.inputView = pickerView
    }
    
    private func calculateSelectedCurrencyToUSD() {
        selectedCurrencyPriceToUSD = homeViewModel.currencyConversionTableViewCellModel.filter({$0.currencyName == homeViewModel.selectedCurrency?.currencyName}).first?.rate
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        if let center = center {
            activityIndicatorView.center = center
        }
        return activityIndicatorView
    }
    
    private func activityIndicatorVisibleAndAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    private func activityIndicatorHiddenAndNotAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
}


// MARK: - TableView
extension CurrencyConversionViewController: UITableViewDelegate {}

extension CurrencyConversionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.homeViewModel.currencyConversionTableViewCellModel.count == 0 ? self.tableView.setEmptyMessage("Choose United States dollar to start the app.") : self.tableView.restore()
        return self.homeViewModel.currencyConversionTableViewCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyConversionTableViewCell else {return UITableViewCell()}
        cell.userSelectedCurrencyPriceToUSD = selectedCurrencyPriceToUSD ?? 1
        let viewModel = homeViewModel.currencyConversionTableViewCellModel[indexPath.row]
        cell.selectedCurrency = homeViewModel.selectedCurrency
        cell.amountToConvert = Double(amountTextField.text ?? "1") ?? 1.0
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}


// MARK: - TextField
extension CurrencyConversionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == selectedTextField) {
            pickerView.isHidden = false
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        calculateSelectedCurrencyToUSD()
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          workItemRefence?.cancel()
           guard let _ = textField.text else {
               return true
           }
          let dispatchWorkItem = DispatchWorkItem {
              self.tableView.reloadData()
          }
          workItemRefence = dispatchWorkItem
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: dispatchWorkItem)
           return true
       }
}

// MARK: - PickerView
extension CurrencyConversionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return homeViewModel.currencyModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return homeViewModel.currencyModels[row].currencyFullName
    }
    
    
    func  pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerView.isHidden = true
        homeViewModel.populateTableViewWithConvertedCurencies(selectedCurrency: homeViewModel.currencyModels[row]) {[weak self] success in
            self?.activityIndicatorVisibleAndAnimating()
            if (success) {
                DispatchQueue.main.async {
                    self?.activityIndicatorHiddenAndNotAnimating()
                    self?.selectedTextField.text = self?.homeViewModel.currencyModels[row].currencyFullName
                    self?.calculateSelectedCurrencyToUSD()
                    self?.tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.activityIndicatorHiddenAndNotAnimating()
                    self?.showAlert(msg: self?.homeViewModel.errorString ?? "")
                }
            }
        }
    }
}


// MARK: - Constraints
extension CurrencyConversionViewController {
    private func constraintsForAmountTextField() {
        view.addSubview(amountTextField)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 100, enableInsets: true)
    }
    
    
    private func constraintsForSelectedCurrencyView() {
        view.addSubview(selectCurrencyView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        selectCurrencyView.addGestureRecognizer(tapGesture)
        selectCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        selectCurrencyView.anchor(top: amountTextField.bottomAnchor, left: nil, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 200, height: 50, enableInsets: true)
    }
    
    private func constraintsForSelectedCurrencyTextField() {
        selectCurrencyView.addSubview(selectedTextField)
        selectedTextField.translatesAutoresizingMaskIntoConstraints = false
        selectedTextField.anchor(top: selectCurrencyView.topAnchor, left: selectCurrencyView.leftAnchor, bottom: selectCurrencyView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 170, height: 0, enableInsets: true)
    }
    
    private func constraintsFordropDownImageView() {
        selectCurrencyView.addSubview(dropDownImageView)
        dropDownImageView.translatesAutoresizingMaskIntoConstraints = false
        dropDownImageView.anchor(top: selectCurrencyView.topAnchor, left: nil, bottom: selectCurrencyView.bottomAnchor, right: selectCurrencyView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 0, enableInsets: true)
    }
    
    private func constraintsForTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: selectCurrencyView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: true)
    }
    
    
    private func constraintsForPickerView() {
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 300, enableInsets: true)
    }
}



