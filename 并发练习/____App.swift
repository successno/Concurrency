//___FILEHEADER___

import SwiftUI

@main
struct concurrency: App {
    var body: some Scene {
        WindowGroup {
            DownloadImageAsync()
        }
    }
}
