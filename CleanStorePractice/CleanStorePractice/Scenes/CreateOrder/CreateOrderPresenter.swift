//
//  CreateOrderPresenter.swift
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
// MARK: PresentationLogic
protocol CreateOrderPresentationLogic   //Business logic에서 얻어온 데이터를 ViewModel로 변환
{
  func presentExpirationDate(response: CreateOrder.FormatExpirationDate.Response)
  func presentCreatedOrder(response: CreateOrder.CreateOrder.Response)
  func presentOrderToEdit(response: CreateOrder.EditOrder.Response)
  func presentUpdatedOrder(response: CreateOrder.UpdateOrder.Response)
}

class CreateOrderPresenter: CreateOrderPresentationLogic
{
  weak var viewController: CreateOrderDisplayLogic?
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
  
  // MARK: - Expiration date
  //Response 데이터를 formatter에 맞춰서 ViewModel에 전달
  func presentExpirationDate(response: CreateOrder.FormatExpirationDate.Response)
  {
    let date = dateFormatter.string(from: response.date)
    let viewModel = CreateOrder.FormatExpirationDate.ViewModel(date: date)
    viewController?.displayExpirationDate(viewModel: viewModel)
  }
  
  // MARK: - Create order
  
  func presentCreatedOrder(response: CreateOrder.CreateOrder.Response)
  {
    let viewModel = CreateOrder.CreateOrder.ViewModel(order: response.order)
    viewController?.displayCreatedOrder(viewModel: viewModel)
  }
  
  // MARK: - Edit order
  
  func presentOrderToEdit(response: CreateOrder.EditOrder.Response)
  {
    let orderToEdit = response.order
    let viewModel = CreateOrder.EditOrder.ViewModel(
      orderFormFields: CreateOrder.OrderFormFields(
        firstName: orderToEdit.firstName,
        lastName: orderToEdit.lastName,
        phone: orderToEdit.phone,
        email: orderToEdit.email,
        billingAddressStreet1: orderToEdit.billingAddress.street1,
        billingAddressStreet2: (orderToEdit.billingAddress.street2 != nil ? orderToEdit.billingAddress.street2! : ""),
        billingAddressCity: orderToEdit.billingAddress.city,
        billingAddressState: orderToEdit.billingAddress.state,
        billingAddressZIP: orderToEdit.billingAddress.zip,
        paymentMethodCreditCardNumber: orderToEdit.paymentMethod.creditCardNumber,
        paymentMethodCVV: orderToEdit.paymentMethod.cvv,
        paymentMethodExpirationDate: orderToEdit.paymentMethod.expirationDate,
        paymentMethodExpirationDateString: dateFormatter.string(from: orderToEdit.paymentMethod.expirationDate),
        shipmentAddressStreet1: orderToEdit.shipmentAddress.street1,
        shipmentAddressStreet2: orderToEdit.shipmentAddress.street2 != nil ? orderToEdit.shipmentAddress.street2! : "",
        shipmentAddressCity: orderToEdit.shipmentAddress.city,
        shipmentAddressState: orderToEdit.shipmentAddress.state,
        shipmentAddressZIP: orderToEdit.shipmentAddress.zip,
        shipmentMethodSpeed: orderToEdit.shipmentMethod.speed.rawValue,
        shipmentMethodSpeedString: orderToEdit.shipmentMethod.toString(),
        id: orderToEdit.id,
        date: orderToEdit.date,
        total: orderToEdit.total
      ) //orderFormFields
    ) // viewModel
    viewController?.displayOrderToEdit(viewModel: viewModel)
  }
  
  // MARK: - Update order
  
  func presentUpdatedOrder(response: CreateOrder.UpdateOrder.Response)
  {
    let viewModel = CreateOrder.UpdateOrder.ViewModel(order: response.order)
    viewController?.displayUpdatedOrder(viewModel: viewModel)
  }
}
