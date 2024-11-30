import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "Image" asset catalog image resource.
    static let image = DeveloperToolsSupport.ImageResource(name: "Image", bundle: resourceBundle)

    /// The "Radial_Gradient" asset catalog image resource.
    static let radialGradient = DeveloperToolsSupport.ImageResource(name: "Radial_Gradient", bundle: resourceBundle)

    /// The "av_man" asset catalog image resource.
    static let avMan = DeveloperToolsSupport.ImageResource(name: "av_man", bundle: resourceBundle)

    /// The "av_woman" asset catalog image resource.
    static let avWoman = DeveloperToolsSupport.ImageResource(name: "av_woman", bundle: resourceBundle)

    /// The "back" asset catalog image resource.
    static let back = DeveloperToolsSupport.ImageResource(name: "back", bundle: resourceBundle)

    /// The "cat" asset catalog image resource.
    static let cat = DeveloperToolsSupport.ImageResource(name: "cat", bundle: resourceBundle)

    /// The "cellImage" asset catalog image resource.
    static let cell = DeveloperToolsSupport.ImageResource(name: "cellImage", bundle: resourceBundle)

    /// The "dog" asset catalog image resource.
    static let dog = DeveloperToolsSupport.ImageResource(name: "dog", bundle: resourceBundle)

    /// The "done" asset catalog image resource.
    static let done = DeveloperToolsSupport.ImageResource(name: "done", bundle: resourceBundle)

    /// The "elephant" asset catalog image resource.
    static let elephant = DeveloperToolsSupport.ImageResource(name: "elephant", bundle: resourceBundle)

    /// The "enot" asset catalog image resource.
    static let enot = DeveloperToolsSupport.ImageResource(name: "enot", bundle: resourceBundle)

    /// The "eye" asset catalog image resource.
    static let eye = DeveloperToolsSupport.ImageResource(name: "eye", bundle: resourceBundle)

    /// The "finish" asset catalog image resource.
    static let finish = DeveloperToolsSupport.ImageResource(name: "finish", bundle: resourceBundle)

    /// The "fireParticle" asset catalog image resource.
    static let fireParticle = DeveloperToolsSupport.ImageResource(name: "fireParticle", bundle: resourceBundle)

    /// The "frog" asset catalog image resource.
    static let frog = DeveloperToolsSupport.ImageResource(name: "frog", bundle: resourceBundle)

    /// The "grid_cell" asset catalog image resource.
    static let gridCell = DeveloperToolsSupport.ImageResource(name: "grid_cell", bundle: resourceBundle)

    /// The "grid_cell_red" asset catalog image resource.
    static let gridCellRed = DeveloperToolsSupport.ImageResource(name: "grid_cell_red", bundle: resourceBundle)

    /// The "hare" asset catalog image resource.
    static let hare = DeveloperToolsSupport.ImageResource(name: "hare", bundle: resourceBundle)

    /// The "hint_back" asset catalog image resource.
    static let hintBack = DeveloperToolsSupport.ImageResource(name: "hint_back", bundle: resourceBundle)

    /// The "logo" asset catalog image resource.
    static let logo = DeveloperToolsSupport.ImageResource(name: "logo", bundle: resourceBundle)

    /// The "logo2" asset catalog image resource.
    static let logo2 = DeveloperToolsSupport.ImageResource(name: "logo2", bundle: resourceBundle)

    /// The "logo3" asset catalog image resource.
    static let logo3 = DeveloperToolsSupport.ImageResource(name: "logo3", bundle: resourceBundle)

    /// The "logod" asset catalog image resource.
    static let logod = DeveloperToolsSupport.ImageResource(name: "logod", bundle: resourceBundle)

    /// The "menu_back" asset catalog image resource.
    static let menuBack = DeveloperToolsSupport.ImageResource(name: "menu_back", bundle: resourceBundle)

    /// The "new" asset catalog image resource.
    static let new = DeveloperToolsSupport.ImageResource(name: "new", bundle: resourceBundle)

    /// The "new_game" asset catalog image resource.
    static let newGame = DeveloperToolsSupport.ImageResource(name: "new_game", bundle: resourceBundle)

    /// The "owl" asset catalog image resource.
    static let owl = DeveloperToolsSupport.ImageResource(name: "owl", bundle: resourceBundle)

    /// The "parrot" asset catalog image resource.
    static let parrot = DeveloperToolsSupport.ImageResource(name: "parrot", bundle: resourceBundle)

    /// The "renew" asset catalog image resource.
    static let renew = DeveloperToolsSupport.ImageResource(name: "renew", bundle: resourceBundle)

    /// The "score" asset catalog image resource.
    static let score = DeveloperToolsSupport.ImageResource(name: "score", bundle: resourceBundle)

    /// The "selected_cell" asset catalog image resource.
    static let selectedCell = DeveloperToolsSupport.ImageResource(name: "selected_cell", bundle: resourceBundle)

    /// The "shrug" asset catalog image resource.
    static let shrug = DeveloperToolsSupport.ImageResource(name: "shrug", bundle: resourceBundle)

    /// The "skip" asset catalog image resource.
    static let skip = DeveloperToolsSupport.ImageResource(name: "skip", bundle: resourceBundle)

    /// The "splash" asset catalog image resource.
    static let splash = DeveloperToolsSupport.ImageResource(name: "splash", bundle: resourceBundle)

    /// The "start_menu_button_back" asset catalog image resource.
    static let startMenuButtonBack = DeveloperToolsSupport.ImageResource(name: "start_menu_button_back", bundle: resourceBundle)

    /// The "start_menu_button_back33" asset catalog image resource.
    static let startMenuButtonBack33 = DeveloperToolsSupport.ImageResource(name: "start_menu_button_back33", bundle: resourceBundle)

    /// The "start_menu_button_back_sel" asset catalog image resource.
    static let startMenuButtonBackSel = DeveloperToolsSupport.ImageResource(name: "start_menu_button_back_sel", bundle: resourceBundle)

    /// The "undo" asset catalog image resource.
    static let undo = DeveloperToolsSupport.ImageResource(name: "undo", bundle: resourceBundle)

}

