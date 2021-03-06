//
//  CreateOrderViewController.swift
//  CleanStorePractice
//
//  Created by 조경진 on 2020/02/18.
//  Copyright (c) 2020 조경진. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
// 각종 뷰들에 띄워줄 protocol display 함수들
protocol CreateOrderDisplayLogic: class
{
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
}

class CreateOrderViewController: UITableViewController, CreateOrderDisplayLogic, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    var interactor: CreateOrderBusinessLogic?
    var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?    //화면 전환을 위한 router
    
    // MARK: Object lifecycle
    // nib 파일로부터 뷰 컨트롤러를 생성할 때 사용하며, 이 때 nib 파일은 아직 로딩되지 않는다.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configurePickers()
        showOrderToEdit()
    }
    
    func configurePickers()
    {
        ShippingMethodTextField.inputView = ShippingMethodPicker
        ExpirationDateTextField.inputView = ExpirationDatePicker
    }
    
    // MARK: Text fields
    
    @IBOutlet var TextFields: [UITextField]! //텍스트 필드 배열로 받음!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let index = TextFields.firstIndex(of: textField) {
            if index < TextFields.count - 1 {
                let nextTextField = TextFields[index + 1]
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) {
            for textField in TextFields {
                if textField.isDescendant(of: cell) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Shipping method PickerView
    
    @IBOutlet weak var ShippingMethodTextField: UITextField!
    @IBOutlet var ShippingMethodPicker: UIPickerView!
    // Shipping 방법 피커뷰로 구현
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return interactor?.shippingMethods.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return interactor?.shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        ShippingMethodTextField.text = interactor?.shippingMethods[row]
    }
    
    // MARK: - Expiration date
    // 만료일은 DatePicker로 구현
    @IBOutlet weak var ExpirationDateTextField: UITextField!
    @IBOutlet var ExpirationDatePicker: UIDatePicker!
    
    @IBAction func ExpirationDatePickerValueChanged(_ sender: Any)
    {
        let date = ExpirationDatePicker.date
        let request = CreateOrder.FormatExpirationDate.Request(date: date)
        interactor?.formatExpirationDate(request: request)  //request 정보를 presenter에게 response를 전달
    }
    // ViewModel의 데이터를 텍스트필드에 넣어줌
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    {
        let date = viewModel.date
        ExpirationDateTextField.text = date
    }
    
    // MARK: - Create order
    
    // MARK: Contact info
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    // MARK: Payment info
    @IBOutlet weak var BillingAddressStreet1TextField: UITextField!
    @IBOutlet weak var BillingAddressStreet2TextField: UITextField!
    @IBOutlet weak var BillingAddressCityTextField: UITextField!
    @IBOutlet weak var BillingAddressStateTextField: UITextField!
    @IBOutlet weak var BillingAddressZIPTextField: UITextField!
    
    @IBOutlet weak var CreditCardNumberTextField: UITextField!
    @IBOutlet weak var CcvTextField: UITextField!
    
    // MARK: Shipping info
    @IBOutlet weak var ShipmentAddressStreet1TextField: UITextField!
    @IBOutlet weak var ShipmentAddressStreet2TextField: UITextField!
    @IBOutlet weak var ShipmentAddressCityTextField: UITextField!
    @IBOutlet weak var ShipmentAddressStateTextField: UITextField!
    @IBOutlet weak var ShipmentAddressZIPTextField: UITextField!
    
    @IBAction func SaveButtonTapped(_ sender: Any)
    {
        // MARK: Contact info
        let firstName = FirstNameTextField.text!
        let lastName = LastNameTextField.text!
        let phone = PhoneTextField.text!
        let email = EmailTextField.text!
        
        // MARK: Payment info
        let billingAddressStreet1 = BillingAddressStreet1TextField.text!
        let billingAddressStreet2 = BillingAddressStreet2TextField.text!
        let billingAddressCity = BillingAddressCityTextField.text!
        let billingAddressState = BillingAddressStateTextField.text!
        let billingAddressZIP = BillingAddressZIPTextField.text!
        
        let paymentMethodCreditCardNumber = CreditCardNumberTextField.text!
        let paymentMethodCVV = CcvTextField.text!
        let paymentMethodExpirationDate = ExpirationDatePicker.date
        let paymentMethodExpirationDateString = ""
        
        // MARK: Shipping info
        let shipmentAddressStreet1 = ShipmentAddressStreet1TextField.text!
        let shipmentAddressStreet2 = ShipmentAddressStreet2TextField.text!
        let shipmentAddressCity = ShipmentAddressCityTextField.text!
        let shipmentAddressState = ShipmentAddressStateTextField.text!
        let shipmentAddressZIP = ShipmentAddressZIPTextField.text!
        
        let shipmentMethodSpeed = ShippingMethodPicker.selectedRow(inComponent: 0)
        let shipmentMethodSpeedString = ""
        
        // MARK: Misc
        var id: String? = nil
        var date = Date()
        var total = NSDecimalNumber.notANumber
        
        if let orderToEdit = interactor?.orderToEdit {
            id = orderToEdit.id
            date = orderToEdit.date
            total = orderToEdit.total
            let request = CreateOrder.UpdateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, billingAddressStreet1: billingAddressStreet1, billingAddressStreet2: billingAddressStreet2, billingAddressCity: billingAddressCity, billingAddressState: billingAddressState, billingAddressZIP: billingAddressZIP, paymentMethodCreditCardNumber: paymentMethodCreditCardNumber, paymentMethodCVV: paymentMethodCVV, paymentMethodExpirationDate: paymentMethodExpirationDate, paymentMethodExpirationDateString: paymentMethodExpirationDateString, shipmentAddressStreet1: shipmentAddressStreet1, shipmentAddressStreet2: shipmentAddressStreet2, shipmentAddressCity: shipmentAddressCity, shipmentAddressState: shipmentAddressState, shipmentAddressZIP: shipmentAddressZIP, shipmentMethodSpeed: shipmentMethodSpeed, shipmentMethodSpeedString: shipmentMethodSpeedString, id: id, date: date, total: total))
            //request에 다 때려박음
            interactor?.updateOrder(request: request) //request로 갱신
        } else {
            let request = CreateOrder.CreateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, billingAddressStreet1: billingAddressStreet1, billingAddressStreet2: billingAddressStreet2, billingAddressCity: billingAddressCity, billingAddressState: billingAddressState, billingAddressZIP: billingAddressZIP, paymentMethodCreditCardNumber: paymentMethodCreditCardNumber, paymentMethodCVV: paymentMethodCVV, paymentMethodExpirationDate: paymentMethodExpirationDate, paymentMethodExpirationDateString: paymentMethodExpirationDateString, shipmentAddressStreet1: shipmentAddressStreet1, shipmentAddressStreet2: shipmentAddressStreet2, shipmentAddressCity: shipmentAddressCity, shipmentAddressState: shipmentAddressState, shipmentAddressZIP: shipmentAddressZIP, shipmentMethodSpeed: shipmentMethodSpeed, shipmentMethodSpeedString: shipmentMethodSpeedString, id: id, date: date, total: total))
            // id, date , total 정보가 없다면 새로 create
            interactor?.createOrder(request: request)
        }
    }
    // router에 전달
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    {
        if viewModel.order != nil {
            router?.routeToListOrders(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to create order", message: "Please correct your order and submit again.")
        }
    }
    
    // MARK: - Edit order
    // Request 받은걸로 presenter 에게 response 전달
    func showOrderToEdit()
    {
        let request = CreateOrder.EditOrder.Request()
        interactor?.showOrderToEdit(request: request)
    }
    // 수정할 때 textField에 기존에 있던 값 넣어줌
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    {
        let orderFormFields = viewModel.orderFormFields
        FirstNameTextField.text = orderFormFields.firstName
        LastNameTextField.text = orderFormFields.lastName
        PhoneTextField.text = orderFormFields.phone
        EmailTextField.text = orderFormFields.email
        
        BillingAddressStreet1TextField.text = orderFormFields.billingAddressStreet1
        BillingAddressStreet2TextField.text = orderFormFields.billingAddressStreet2
        BillingAddressCityTextField.text = orderFormFields.billingAddressCity
        BillingAddressStateTextField.text = orderFormFields.billingAddressState
        BillingAddressZIPTextField.text = orderFormFields.billingAddressZIP
        
        CreditCardNumberTextField.text = orderFormFields.paymentMethodCreditCardNumber
        CcvTextField.text = orderFormFields.paymentMethodCVV
        
        ShipmentAddressStreet1TextField.text = orderFormFields.shipmentAddressStreet1
        ShipmentAddressStreet2TextField.text = orderFormFields.shipmentAddressStreet2
        ShipmentAddressCityTextField.text = orderFormFields.shipmentAddressCity
        ShipmentAddressStateTextField.text = orderFormFields.shipmentAddressState
        ShipmentAddressZIPTextField.text = orderFormFields.shipmentAddressZIP
        
        ShippingMethodPicker.selectRow(orderFormFields.shipmentMethodSpeed, inComponent: 0, animated: true)
        ShippingMethodTextField.text = orderFormFields.shipmentMethodSpeedString
        
        ExpirationDatePicker.date = orderFormFields.paymentMethodExpirationDate
        ExpirationDateTextField.text = orderFormFields.paymentMethodExpirationDateString
    }
    
    // MARK: - Update order
    
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
    {
        if viewModel.order != nil {
            router?.routeToShowOrder(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to update order", message: "Please correct your order and submit again.")
        }
    }
    
    // MARK: Error handling
    
    private func showOrderFailureAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        showDetailViewController(alertController, sender: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //return 버튼 누르면 키보드 내려갈수있게 설정.
    }
    
    
}
