//
//  CardViewController.swift
//  Targot
//
//

import UIKit

import CoreLocation

import RxFlow
import RxSwift
import RxCocoa

public enum CardState {
  case newCard, existingCard
}

class CardViewController: UIViewController, ViewModelBased, Stepper {

  internal var disposeBag = DisposeBag()

  internal var cardState = CardState.newCard

  var viewModel: CardDetailViewModel! {
    didSet {
      if viewModel.isNewCard {
        cardState = .newCard
//        cardP.setTitle("New Card")
      } else {
        cardState = .existingCard
      }
    }
  }

  var delegate: RecievesCard!

  var presenter: PresenterDelegate!

  lazy var locationManager = CLLocationManager()
  lazy var geoService = GeolocationService(withLocationManager: locationManager)

  var activeTextField: UIView?

  let dismissEditing = UITapGestureRecognizer()
  let backGesture: UISwipeGestureRecognizer = {
    let backG = UISwipeGestureRecognizer()
    backG.direction = .right

    return backG
  }()

  var cardP: CardUIPresenter {
    if let pres = presenter as? CardUIPresenter {
      return pres as CardUIPresenter
    } else {
      fatalError()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addGestureRecognizer(backGesture)
    view.addGestureRecognizer(dismissEditing)

    presenter.setupViews()

    settingFieldsDelegation()

    rxMagic()

    viewModel.assignFirstValues()
    cardP.setTitle(viewModel.name.value ?? "New Card")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleShowingKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleHidingKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  func bindFields() {

    [cardP.nameField: viewModel.name,
     cardP.addressField: viewModel.address,
     cardP.cityField   : viewModel.city,
     cardP.cpField     : viewModel.zipCode,
     cardP.phoneField  : viewModel.phone].forEach { (field, viewMA) in
      field.textField.rx.text.orEmpty.bind(to: viewMA).disposed(by: disposeBag)
      viewMA.asObservable().bind(to: field.textField.rx.text).disposed(by: disposeBag)
    }

    [cardP.facebookField: viewModel.facebook,
     cardP.instagramField: viewModel.instagram,
     cardP.twitterField: viewModel.twitter,
     cardP.webField: viewModel.web].forEach { (field, viewMA) in
      field.textField.rx.text.orEmpty.do(onNext: { (value) in
          field.activateIcon(!value.isEmpty)
        })
        .bind(to: viewMA).disposed(by: disposeBag)
      viewMA.asObservable().bind(to: field.textField.rx.text).disposed(by: disposeBag)
    }
    cardP.notesField.rx.text.orEmpty .bind(to: viewModel.notes).disposed(by: disposeBag)
    viewModel.notes.asObservable().bind(to: cardP.notesField.rx.text).disposed(by: disposeBag)
  }

  func categoryRxMagic() {
    let tagSports   = cardP.categories.sportButton.rx
      .tap.map { [unowned self] _ in return self.cardP.categories.sportButton.tag }
    let tagLeisure  = cardP.categories.leisureButton.rx
      .tap.map { [unowned self] _ in return self.cardP.categories.leisureButton.tag }
    let tagShopping = cardP.categories.shoppingButton.rx
      .tap.map { [unowned self] _ in return self.cardP.categories.shoppingButton.tag }
    let tagBR       = cardP.categories.brButton.rx
      .tap.map { [unowned self] _ in return self.cardP.categories.brButton.tag }

    let observableTag = Observable.of(tagSports, tagLeisure, tagShopping, tagBR).merge()

    observableTag.debug("category", trimOutput: true)
      .map { (tag) -> CategoryValue in
        guard let safeCategory = CategoryValue(rawValue: tag) else { return CategoryValue.none}

        return safeCategory
      }
      .do(onNext: { [unowned self] (category) in
        self.cardP.categories.setCategory(category)
      })
      .bind(to: viewModel.category)
      .disposed(by: disposeBag)

    viewModel.category.asObservable().subscribe(onNext: { [unowned self] (categoryValue) in
      self.cardP.categories.setCategory(categoryValue)
    }).disposed(by: disposeBag)
  }

  func cameraRxMagic() {
    cardP.photosRoll.addNewPhotoButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.step.accept(TargotSteps.addNewPhoto(self))
    }).disposed(by: disposeBag)
  }

  func setupGestures() {
    dismissEditing.rx.event.subscribe { (_) in
      self.view.endEditing(true)
      }.disposed(by: disposeBag)

    backGesture.rx.event.subscribe { (_) in
      self.navigationController?.popViewController(animated: true)
      }.disposed(by: disposeBag)
  }

  func rxMagic() {

    setupGestures()

    cardP.photosRoll.photosCollection.delegate = nil
    cardP.photosRoll.photosCollection.rx.setDelegate(self).disposed(by: disposeBag)

    viewModel.photos
      .asObservable()
      .bind(to:  cardP.photosRoll.photosCollection.rx.items(cellIdentifier: "PhotoCollectionCell")) { _, id, cell in
         guard let cell = cell as? PhotoCollectionCell else { fatalError("Wrong Casting!!") }

        cell.identifier = id

      }.disposed(by: disposeBag)


    bindFields()

    categoryRxMagic()

    cameraRxMagic()

    cardP.geoButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      guard let currentAddress = self.geoService.getCurrentAddress() else { return }
      guard let currentLocation = self.geoService.getCurrentLocation() else { return }

      let locationDuple = Location(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

      self.viewModel.setAddress(currentAddress)
      self.viewModel.setLocation(locationDuple)
    }).disposed(by: disposeBag)

    cardP.doneButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      //TODO: What if the save goes wrong!
      if self.viewModel.save() != nil {
        switch self.cardState {
        case .newCard:
          self.delegate.getCard(self.viewModel.card)
        case .existingCard:
          self.delegate.updateCard(self.viewModel.card)
        }

        self.step.accept(TargotSteps.newCardDone)
      }
    }).disposed(by: disposeBag)
  }
}

protocol RecievesPhotoIds {
  func getPhotoId(_ photoId: String?)
}

extension CardViewController: RecievesPhotoIds {
  func getPhotoId(_ photoId: String?) {
    guard let photoId = photoId else { return }

    self.viewModel.photos.value.append(photoId)
  }
}

extension CardViewController {

  @objc func handleShowingKeyboard(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
          let activeTextField = self.activeTextField else { return }

    let contentInsets                      = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    cardP.scrollView.contentInset          = contentInsets
    cardP.scrollView.scrollIndicatorInsets = contentInsets

    var viewRect = self.view.frame
    viewRect.size.height -= keyboardSize.height

    if (!viewRect.contains(activeTextField.frame.origin)) {
      cardP.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
    }
  }

  @objc func handleHidingKeyboard(notification: Notification) {
    let contentsInset = UIEdgeInsets.zero

    cardP.scrollView.contentInset          = contentsInset
    cardP.scrollView.scrollIndicatorInsets = contentsInset
  }
}

extension CardViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.activeTextField = textField

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }

  func settingFieldsDelegation() {
    self.cardP.fields.forEach { [unowned self] (field) in
      field.delegate      = self
      field.returnKeyType = .next
    }
  }
}

extension CardViewController: UITextViewDelegate {

  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    self.activeTextField = textView

    return true
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    self.activeTextField = nil
  }
}

extension CardViewController: UICollectionViewDelegate { }

extension CardViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: 300.cgPixels, height: 300.cgPixels)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}
