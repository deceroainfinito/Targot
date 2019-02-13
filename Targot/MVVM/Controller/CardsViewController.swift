//
//  CardsViewController.swift
//  Targot
//
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class CardsViewController: UIViewController, Stepper {

  fileprivate var cardsViewModel: Variable<[CardCellViewModel]>! = Variable([])

  var presenter: PresenterDelegate!

  let addCardGesture: UITapGestureRecognizer = {
    let addG = UITapGestureRecognizer()

    addG.numberOfTapsRequired = 2

    return addG
  }()

  var cardsPresenter: CardsUIPresenter {
    guard let presenter = presenter as? CardsUIPresenter else { fatalError() }
    return presenter
  }

  internal var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true
    view.addGestureRecognizer(addCardGesture)

    presenter.setupViews()

    rxMagic()
  }

  func rxMagic() {

    //TODO: Make a dependency injection here
    cardsViewModel.value = CardsViewModel().cards()

    cardsPresenter.collectionView.delegate = nil
    cardsPresenter.collectionView.rx.setDelegate(self).disposed(by: disposeBag)

    addCardGesture.rx.event.subscribe { _ in
      self.step.accept(TargotSteps.newCardDetails(self))
    }.disposed(by: disposeBag)


    cardsViewModel
      .asObservable()
      .subscribe(onNext: { (cards) in
        if cards.isEmpty {
          self.cardsPresenter.collectionView.backgroundView?.isHidden = false
        }
      })
      .disposed(by: disposeBag)

    cardsViewModel
      .asObservable()
      .bind(to: cardsPresenter.collectionView.rx.items(cellIdentifier: "CardCollectionCell")) { _, cvm, cell in
        guard let cell = cell as? CardCollectionCell else { fatalError("Wrong casting!")}

        self.cardsPresenter.collectionView.backgroundView?.isHidden = true

        cell.viewModel = cvm
      }.disposed(by: disposeBag)

    cardsPresenter.collectionView
      .rx
      .itemSelected
      .subscribe(onNext: { [weak self] (indexPath) in
        guard let safeSelf = self else { return }
        let id = safeSelf.cardsViewModel.value[indexPath.row].card.id
        self?.step.accept(TargotSteps.cardDetails(withId: id, andStepper: safeSelf))
      }).disposed(by: disposeBag)

    cardsPresenter.moreBarButtonItem
      .rx
      .tap
      .subscribe({ [unowned self] _ in
      self.step.accept(TargotSteps.newCardDetails(self))
    }).disposed(by: self.disposeBag)
    //
    //    p.settingsBarButtonItem.rx.tap.subscribe({ [unowned self] event in
    //      self.step.accept(TargotSteps.settings)
    //    }).disposed(by: self.disposeBag)
    //
    //    p.detailsBarButtonItem.rx.tap.subscribe({ [unowned self] event in
    //      self.step.accept(TargotSteps.cardDetails(withId: "pepe"))
    //    }).disposed(by: self.disposeBag)
  }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CardCollectionCell.width, height: CardCollectionCell.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}


protocol RecievesCard {
  func getCard(_ card: Card?)
  func updateCard(_ card: Card)
}

extension CardsViewController: RecievesCard {
  func getCard(_ card: Card?) {
    guard let card = card else { return }

    let newCardViewModel = CardCellViewModel(card: card)

    self.cardsViewModel.value.append(newCardViewModel)
  }

  func updateCard(_ card: Card) {
    guard let viewModel = cardsViewModel.value.filter({ (viewModel) -> Bool in
      viewModel.card.id == card.id
    }).first else { return }

    viewModel.updateWithCard(card)
  }
}
