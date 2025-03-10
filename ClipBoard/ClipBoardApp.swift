//
//  ClipBoardApp.swift
//  ClipBoard
//
//  Created by Ahmet OZBERK on 12.01.2025.
//

import ServiceManagement
import SwiftData
import SwiftUI

@main
struct ClipBoardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 


    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ClipboardItem.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(
                for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {

        MenuBarExtra {
            ClipboardListView()
                .modelContainer(sharedModelContainer)
        } label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 16
                $0.size.width = 16 / ratio
                $0.isTemplate = true
                return $0
            }(NSImage(named: "clipboard-icon")!)

            Image(nsImage: image).foregroundStyle(.white)
        }.menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var clipboardMonitor: ClipboardMonitor?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Dock'ta görünmesini engelle
        NSApp.setActivationPolicy(.accessory)

        clipboardMonitor = ClipboardMonitor()
        clipboardMonitor?.startMonitoring()

        // Otomatik başlatma ayarını etkinleştir
        registerAutoLaunch()
    }

    private func registerAutoLaunch() {
        do {
            try SMAppService.mainApp.register()
        } catch {
            print("Failed to register auto launch: \(error)")
        }
    }

    // Uygulamanın tamamen kapanmasını engelle
    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return false
    }
}
