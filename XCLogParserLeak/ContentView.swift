import SwiftUI
import XCLogParser

struct ContentView: View {
    var body: some View {
        VStack {
            Button(role: .destructive, action: {
                Task {
                    do {
                        try self.parseLogs()
                    } catch {
                        print("Unable to parse logs. Error: \(error)")
                    }
                }
            }) {
                Spacer()
                Text("Fetch logs")
                Spacer()
            }
        }
        .padding()
    }

    private func parseLogs() throws {
        let derivedDataPath = "/Users/josecorreiamirandaramos/Library/Developer/Xcode/DerivedData/"
        let derivedDataURL = URL(fileURLWithPath: derivedDataPath)
        let xcActivityLogExtension = ".xcactivitylog"
        let fileManager = FileManager.default

        print("Started parsing logs in \(derivedDataPath)")


        guard let enumerator = fileManager.enumerator(at: derivedDataURL, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
            return
        }

        for case let fileURL as URL in enumerator {
            try autoreleasepool {
                guard fileURL.absoluteString.contains(xcActivityLogExtension) else {
                    return
                }
                
                print("Started parsing \(fileURL)")

                let parser = ActivityParser()
                let mainSection = try parser.parseActivityLogInURL(
                    fileURL,
                    redacted: false,
                    withoutBuildSpecificInformation: false
                )
                print("Finished parsing \(fileURL)")

                _ =  mainSection
            }
        }

        print("Finished parsing logs in \(derivedDataPath)")
    }
}
