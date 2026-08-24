import XCTest
@testable import UniversalGames

final class UniversalGamesTests: XCTestCase {
    
    var performanceMonitor: PerformanceMonitor!
    var thermalManager: ThermalManager!
    var gpuSettings: GPUSettings!
    var notificationManager: NotificationManager!
    var settingsManager: SettingsManager!
    
    override func setUp() {
        super.setUp()
        performanceMonitor = PerformanceMonitor()
        thermalManager = ThermalManager()
        gpuSettings = GPUSettings()
        notificationManager = NotificationManager()
        settingsManager = SettingsManager.shared
    }
    
    override func tearDown() {
        performanceMonitor = nil
        thermalManager = nil
        gpuSettings = nil
        notificationManager = nil
        settingsManager = nil
        super.tearDown()
    }
    
    func testPerformanceMonitor() {
        // Test FPS meter
        performanceMonitor.enableFPSMeter()
        XCTAssertTrue(performanceMonitor.getCurrentFPS() > 0)
        
        performanceMonitor.disableFPSMeter()
        XCTAssertEqual(performanceMonitor.getCurrentFPS(), 0)
        
        // Test temperature meter
        performanceMonitor.enableTemperatureMeter()
        XCTAssertTrue(performanceMonitor.getCurrentTemperature() > 0)
        
        performanceMonitor.disableTemperatureMeter()
        XCTAssertEqual(performanceMonitor.getCurrentTemperature(), 0.0)
        
        // Test update methods
        performanceMonitor.updateFPS(30)
        XCTAssertEqual(performanceMonitor.getCurrentFPS(), 30)
        
        performanceMonitor.updateTemperature(40.0)
        XCTAssertEqual(performanceMonitor.getCurrentTemperature(), 40.0)
    }
    
    func testThermalManager() {
        // Test enable/disable
        thermalManager.enableThermalManagement()
        var status = thermalManager.getThermalStatus()
        XCTAssertTrue(status["enabled"] as? Bool ?? false)
        
        thermalManager.disableThermalManagement()
        status = thermalManager.getThermalStatus()
        XCTAssertFalse(status["enabled"] as? Bool ?? false)
        
        // Test threshold settings
        thermalManager.setThermalThreshold(50.0)
        thermalManager.setCriticalThreshold(60.0)
        
        status = thermalManager.getThermalStatus()
        XCTAssertEqual(status["threshold"] as? Float, 50.0)
        XCTAssertEqual(status["critical"] as? Float, 60.0)
        
        // Test temperature checking
        thermalManager.enableThermalManagement()
        let result1 = thermalManager.checkTemperature(35.0)
        XCTAssertTrue(result1.contains("normal"))
        
        let result2 = thermalManager.checkTemperature(48.0)
        XCTAssertTrue(result2.contains("WARNING"))
        
        let result3 = thermalManager.checkTemperature(58.0)
        XCTAssertTrue(result3.contains("CRITICAL"))
    }
    
    func testGPUSettings() {
        // Test toggles
        gpuSettings.toggleAntiLag()
        XCTAssertTrue(gpuSettings.antiLagEnabled)
        
        gpuSettings.toggleFreezerMode()
        XCTAssertTrue(gpuSettings.freezerModeEnabled)
        
        gpuSettings.toggleSmoothlessPerformance()
        XCTAssertTrue(gpuSettings.smoothlessPerformanceEnabled)
        
        gpuSettings.toggleGPUMonitoring()
        XCTAssertTrue(gpuSettings.gpuMonitoringEnabled)
        
        // Test GPU usage
        gpuSettings.updateGPUUsage(75.5)
        let status = gpuSettings.getGPUStatus()
        XCTAssertEqual(status["usage"] as? Float, 75.5)
    }
    
    func testNotificationManager() {
        // Test enable/disable
        notificationManager.enableNotifications()
        notificationManager.sendNotification(title: "Test", message: "Test message")
        
        let history = notificationManager.getNotificationHistory()
        XCTAssertTrue(history.contains { $0.contains("Test") })
        
        notificationManager.clearNotificationHistory()
        XCTAssertEqual(notificationManager.getNotificationHistory().count, 0)
        
        notificationManager.disableNotifications()
        notificationManager.sendNotification(title: "Disabled", message: "Should not appear")
        let newHistory = notificationManager.getNotificationHistory()
        XCTAssertEqual(newHistory.count, 0)
    }
    
    func testSettingsManager() {
        // Test setting values
        settingsManager.setSetting("fps_meter", value: true)
        let fpsEnabled = settingsManager.getSetting("fps_meter") as? Bool
        XCTAssertTrue(fpsEnabled ?? false)
        
        settingsManager.setSetting("temperature_meter", value: false)
        let tempEnabled = settingsManager.getSetting("temperature_meter") as? Bool
        XCTAssertFalse(tempEnabled ?? true)
        
        // Test reset settings
        settingsManager.resetSettings()
        let allSettings = settingsManager.getAllSettings()
        XCTAssertTrue(allSettings["fps_meter"] as? Bool ?? false)
        XCTAssertTrue(allSettings["temperature_meter"] as? Bool ?? false)
        XCTAssertTrue(allSettings["thermal_management"] as? Bool ?? false)
        XCTAssertTrue(allSettings["gpu_monitoring"] as? Bool ?? false)
        XCTAssertTrue(allSettings["anti_lag"] as? Bool ?? false)
        XCTAssertFalse(allSettings["freezer_mode"] as? Bool ?? true)
        XCTAssertTrue(allSettings["smoothless_performance"] as? Bool ?? false)
        XCTAssertTrue(allSettings["notifications"] as? Bool ?? false)
    }
    
    func testUniversalGamesPackage() {
        let games = UniversalGames()
        XCTAssertEqual(games.text, "Universal Games Package")
        XCTAssertEqual(UniversalGames.version, "1.0.0")
        XCTAssertEqual(UniversalGames.packageId, "com.universal.games")
    }
    
    func testPerformanceImpact() {
        // Test performance
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Run operations
        for _ in 0..<1000 {
            performanceMonitor.enableFPSMeter()
            let _ = performanceMonitor.getCurrentFPS()
            thermalManager.enableThermalManagement()
            let _ = thermalManager.checkTemperature(35.0)
            gpuSettings.updateGPUUsage(50.0)
            notificationManager.sendNotification(title: "Test", message: "Performance test")
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = endTime - startTime
        
        // Should be fast (< 1 second)
        XCTAssertLessThan(executionTime, 1.0)
    }
}
