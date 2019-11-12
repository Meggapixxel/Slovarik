import Foundation

protocol P_ViewPresenter where VIEW.PRESENTER == Self {

    associatedtype VIEW: P_PresenterConfigurableView

    func updateUI(_ view: VIEW)

}

