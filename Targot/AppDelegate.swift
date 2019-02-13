//
//  AppDelegate.swift
//  Targot
//
//

import UIKit

import RxSwift
import RxFlow

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var coordinator = Coordinator()
  let disposeBag = DisposeBag()

  lazy var mainFlow = {
    return MainFlow()
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = UIViewController()

    window?.rootViewController = viewController
    window?.makeKeyAndVisible()

    //    _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe({ (_) in
    //      print("Resource count \(RxSwift.Resources.total)")
    //    })

    //    for family in UIFont.familyNames.sorted() {
    //      let names = UIFont.fontNames(forFamilyName: family)
    //      print("Family: \(family) Font names: \(names)")
    //    }

    //    fatalError()

    #if targetEnvironment(simulator)
    coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
      print("did navigate to flow=\(flow) and step=\(step)")
    }).disposed(by: self.disposeBag)
    #endif

    Flows.whenReady(flow1: mainFlow) { [unowned self] (root) in
      self.window!.rootViewController = root
    }

    coordinator.coordinate(flow: self.mainFlow, withStepper: OneStepper.init(withSingleStep: TargotSteps.cardsList))

    let fontURL = Bundle.main.url(forResource: "NoyhR-Bold", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

    // TODO: REMOVE THIS !!!
//    RealmStorageManager().killThemAll()

    #if targetEnvironment(simulator)

//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")!.load()
//    print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString)

    #endif

    if !SDPhotosHelper.hasGrantedAccess {
      SDPhotosHelper.askForPermission {
        SDPhotosHelper.createAlbum(withTitle: Constants.TargotAlbumName) { (success, error) in
          if !success {
            fatalError(error.debugDescription)
          } else {
            print("Photo Album created correctly")
          }
        }
      }
    }

    return true
  }

}
