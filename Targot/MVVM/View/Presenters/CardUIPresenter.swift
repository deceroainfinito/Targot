//
//  CardDetailPresenter.swift
//  Targot
//
//

import UIKit

class CardUIPresenter: Presenter {

  let scrollView: UIScrollView = {
    let scrollV = UIScrollView(frame: CGRect.zero)

    scrollV.flashScrollIndicators()
    scrollV.scrollsToTop = true
    scrollV.alwaysBounceHorizontal = false
    scrollV.alwaysBounceVertical   = false

    scrollV.backgroundColor = TargotColors.lightGrisete.color


    return scrollV
  }()

  let mainContent: UIView = {
    let mainC = UIView(frame: CGRect.zero)

    mainC.backgroundColor = TargotColors.lightGrisete.color

    return mainC
  }()

  let nameLabel = Label(withText: NSLocalizedString("CardDetailNameLabel", comment: ""))
  let nameField = DecoratedTextField(placeholder: NSLocalizedString("CardDetailNamePH", comment: ""), style: .upAndDown)

  let categories = CategoryView()

  let addressLabel = Label(withText: NSLocalizedString("CardDetailAddressLabel", comment: ""))
  let addressField = DecoratedTextField(placeholder: NSLocalizedString("CardDetailAddressPH", comment: ""), style: .up)
  let cityField    = DecoratedTextField(placeholder: NSLocalizedString("CardDetailCityPH", comment: ""), style: .down)
  let cpField: DecoratedTextField = { let cpF = DecoratedTextField(placeholder: NSLocalizedString("CardDetailCPPH", comment: ""), style: .down)

    cpF.textField.keyboardType = .numberPad

    return cpF
  }()

  let geoButton = RoundedButton(type: .geo)

  let phoneLabel = Label(withText: NSLocalizedString("CardDetailPhoneLabel", comment: ""))
  let phoneField: DecoratedTextField = {
    let phoneF =
    DecoratedTextField(placeholder: NSLocalizedString("CardDetailPhonePH", comment: ""), style: .upAndDown)

    phoneF.textField.keyboardType = .phonePad

    return phoneF
  }()

  let socialLabel    = Label(withText: NSLocalizedString("CardDetailSocialLabel", comment: ""))
  let facebookField  = DecoratedTextField(placeholder: NSLocalizedString("CardDetailFacePH", comment: ""),
    style        : .upAndDown,
    socialNetwork: SocialNetwork.facebook)
  let instagramField = DecoratedTextField(placeholder: NSLocalizedString("CardDetailInstagramPH", comment: ""),
    style        : .down,
    socialNetwork: SocialNetwork.instagram)
  let twitterField   = DecoratedTextField(placeholder: NSLocalizedString("CardDetailTwitterPH", comment: ""),
    style         : .none,
    socialNetwork : SocialNetwork.twitter)
  let webField       = DecoratedTextField(placeholder: NSLocalizedString("CardDetailWebPH", comment: ""),
    style        : .upAndDown,
    socialNetwork: SocialNetwork.web)

  let visitsLabel    = Label(withText: NSLocalizedString("CardDetailVisitsLabel", comment: ""))
  let visitsButton   = DecoratedButton(withText: NSLocalizedString("CardDetailNewVisit", comment: ""), style: .upAndDown)

  let photosLabel     = Label(withText: NSLocalizedString("CardDetailPhotosLabel", comment: ""))
  lazy var photosRoll = PhotosRoll()

  let notesLabel      = Label(withText: NSLocalizedString("CardDetailNotesLabel", comment: ""))
  lazy var notesField: UITextView = { [unowned self] in
    guard let viewController = self.viewController as? CardViewController else { fatalError("Wrong casting")}
    let notesF = UITextView(frame: .zero)

    notesF.delegate = viewController

    return notesF
  }()

  let doneButton = RoundedButton(type: .done)

  var fields: [UITextField]!

  func setTitle(_ title: String) {
    let titleView = TextField(withPlaceholderText: title)
    titleView.isEnabled = false

    self.viewController.navigationItem.titleView = titleView
  }

  override func setupViews() {

    fields = [nameField, addressField, cityField, cpField, phoneField,
      facebookField, instagramField, twitterField, webField].compactMap { $0.textField }

    fields.enumerated().forEach { (index, ele) in
      ele.tag = index
    }

    addViews()
    settingLayout()
  }

  func addViews() {
    viewController.view.backgroundColor = .gray
    viewController.view.addSubview(scrollView)

    viewController.view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
    viewController.view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)

    scrollView.addSubview(mainContent)
    scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: mainContent)
    scrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: mainContent)

    [nameLabel, nameField, categories, addressLabel, addressField, cityField, cpField, geoButton, phoneLabel,
     phoneField, socialLabel, facebookField, instagramField, twitterField, webField, visitsLabel, visitsButton, photosLabel,
     photosRoll, notesLabel, notesField, doneButton] .forEach({ mainContent.addSubview($0) })
  }

  func settingLayout() {
    settingHorizontalLayout()
    settingVerticalLayout()
  }

  func settingHorizontalLayout() {
    // Horizontal alignment
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|",
      views: nameLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: nameField)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: categories)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|",
      views: addressLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: addressField)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth * 0.6))]-0-[v1(\(UIScreen.mainWidth * 0.4))]|",
      views: cityField, cpField)
    mainContent.addConstraintsWithFormat(format: "H:|-100-[v0]-100-|", views: geoButton)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|",
      views: phoneLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: phoneField)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|", views: socialLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: facebookField)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: instagramField)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: twitterField)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: webField)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|", views: visitsLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: visitsButton)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|", views: photosLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: photosRoll)
    mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.mainWidth - 40.cgPixels))]|", views: notesLabel)
    mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.mainWidth))]|", views: notesField)
    mainContent.addConstraintsWithFormat(format: "H:|-100-[v0]-100-|", views: doneButton)
  }

  func settingVerticalLayout() {
    //Vertical alignment
    mainContent.addConstraintsWithFormat(format:
      "V:|-8-[v0(24)][v1]-16-[v2]-16-[v3(24)][v4][v5]-16-[v6(\(96.cgPixels))]-16-[v7(24)][v8]-16-[v9(24)][v10][v11][v12][v13]-16-[v14][v15]-16-[v16(24)]-[v17]-16-[v18(24)]-[v19(\(400.cgPixels))]-16-[v20(\(96.cgPixels))]|",
      views: nameLabel,
      nameField,
      categories,
      addressLabel,
      addressField,
      cityField,
      geoButton,
      phoneLabel,
      phoneField,
      socialLabel,
      facebookField,
      instagramField,
      twitterField,
      webField,
      visitsLabel,
      visitsButton,
      photosLabel,
      photosRoll,
      notesLabel,
      notesField,
      doneButton)

    mainContent.addConstraint( NSLayoutConstraint(item: cityField, attribute: .top, relatedBy: .equal, toItem: cpField, attribute: .top, multiplier: 1, constant: 0))
    mainContent.addConstraint( NSLayoutConstraint(item: cityField, attribute: .height, relatedBy: .equal, toItem: cpField, attribute: .height, multiplier: 1, constant: 0))

    cpField.leftAnchor.constraint(equalTo: cityField.rightAnchor, constant: 0)
  }
}

