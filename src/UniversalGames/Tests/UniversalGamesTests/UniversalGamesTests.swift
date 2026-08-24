import XCTest
@testable import UniversalGames

final class UniversalGamesTests: XCTestCase {
    
    // MARK: - Properties
    var performanceMonitor: PerformanceMonitor!
    var thermalManager: ThermalManager!
    var gpuSettings: GPUSettings!
    var notificationManager: NotificationManager!
    var settingsManager: SettingsManager!
    
    // MARK: - Setup
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
    
    // MARK: - UniversalGames Tests
    func testUniversalGamesPackage() {
        let games = UniversalGames()
        XCTAssertEqual(games.text, "Universal Games Package")
        XCTAssertEqual(UniversalGames.version, "1.0.0")
        XCTAssertEqual(UniversalGames.packageId, "com.universal.games")
    }
    
    // MARK: - PerformanceMonitor Tests
    func testPerformanceMonitorFPS() {
        // Test FPS meter
        performanceMonitor.enableFPSMeter()
        XCTAssertTrue(performanceMonitor.getCurrentFPS() > 0)
        
        performanceMonitor.disableFPSMeter()
        XCTAssertEqual(performanceMonitor.getCurrentFPS(), 0)
        
        // Test update
        performanceMonitor.updateFPS(30)
        performanceMonitor.enableFPSMeter()
        XCTAssertEqual(performanceMonitor.getCurrentFPS(), 30)
    }
    
    func testPerformanceMonitorTemperature() {
        // Test temperature meter
        performanceMonitor.enableTemperatureMeter()
        XCTAssertTrue(performanceMonitor.getCurrentTemperature() > 0)
        
        performanceMonitor.disableTemperatureMeter()
        XCTAssertEqual(performanceMonitor.getCurrentTemperature(), 0.0)
        
        // Test update
        performanceMonitor.updateTemperature(40.0)
        performanceMonitor.enableTemperatureMeter()
        XCTAssertEqual(performanceMonitor.getCurrentTemperature(), 40.0)
    }
    
    func testPerformanceMonitorThermalManagement() {
        performanceMonitor.enableThermalManagement()
        XCTAssertTrue(performanceMonitor.isThermalManagementEnabled())
        
        performanceMonitor.disableThermalManagement()
        XCTAssertFalse(performanceMonitor.isThermalManagementEnabled())
    }
    
    func testPerformanceMonitorStatus() {
        let status = performanceMonitor.getPerformanceStatus()
        XCTAssertNotNil(status["fps"])
        XCTAssertNotNil(status["temperature"])
        XCTAssertNotNil(status["fps_meter_enabled"])
        XCTAssertNotNil(status["temperature_meter_enabled"])
        XCTAssertNotNil(status["thermal_management_enabled"])
        XCTAssertNotNil(status["is_monitoring"])
    }
    
    // MARK: - ThermalManager Tests
    func testThermalManagerEnableDisable() {
        thermalManager.enableThermalManagement()
        var status = thermalManager.getThermalStatus()
        XCTAssertTrue(status["enabled"] as? Bool ?? false)
        
        thermalManager.disableThermalManagement()
        status = thermalManager.getThermalStatus()
        XCTAssertFalse(status["enabled"] as? Bool ?? false)
    }
    
    func testThermalManagerThresholds() {
        thermalManager.setThermalThreshold(50.0)
        thermalManager.setCriticalThreshold(60.0)
        
        let status = thermalManager.getThermalStatus()
        XCTAssertEqual(status["threshold"] as? Float, 50.0)
        XCTAssertEqual(status["critical"] as? Float, 60.0)
    }
    
    func testThermalManagerTemperatureCheck() {
        thermalManager.enableThermalManagement()
        
        let result1 = thermalManager.checkTemperature(35.0)
        XCTAssertTrue(result1.contains("normal"))
        
        let result2 = thermalManager.checkTemperature(48.0)
        XCTAssertTrue(result2.contains("WARNING"))
        
        let result3 = thermalManager.checkTemperature(58.0)
        XCTAssertTrue(result3.contains("CRITICAL"))
    }
    
    func testThermalManagerAverageTemperature() {
        thermalManager.checkTemperature(35.0)
        thermalManager.checkTemperature(40.0)
        thermalManager.checkTemperature(45.0)
        
        let average = thermalManager.getAverageTemperature()
        XCTAssertEqual(average, 40.0, accuracy: 0.01)
    }
    
    func testThermalManagerResetHistory() {
        thermalManager.checkTemperature(35.0)
        thermalManager.checkTemperature(40.0)
        
        thermalManager.resetTemperatureHistory()
        let status = thermalManager.getThermalStatus()
        XCTAssertEqual(status["history_count"] as? Int, 0)
    }
    
    // MARK: - GPUSettings Tests
    func testGPUSettingsToggles() {
        var gpu = GPUSettings()
        
        gpu.toggleAntiLag()
        XCTAssertTrue(gpu.antiLagEnabled)
        
        gpu.toggleFreezerMode()
        XCTAssertTrue(gpu.freezerModeEnabled)
        
        gpu.toggleSmoothlessPerformance()
        XCTAssertTrue(gpu.smoothlessPerformanceEnabled)
        
        gpu.toggleGPUMonitoring()
        XCTAssertTrue(gpu.gpuMonitoringEnabled)
        
        gpu.toggleFramePacing()
        XCTAssertTrue(gpu.framePacingEnabled)
    }
    
    func testGPUSettingsRenderScale() {
        var gpu = GPUSettings()
        
        gpu.setRenderScale(1.5)
        XCTAssertEqual(gpu.renderScale, 1.5)
        
        gpu.setRenderScale(2.5) // Should cap at 2.0
        XCTAssertEqual(gpu.renderScale, 2.0)
        
        gpu.setRenderScale(0.3) // Should cap at 0.5
        XCTAssertEqual(gpu.renderScale, 0.5)
    }
    
    func testGPUSettingsGPUUsage() {
        var gpu = GPUSettings()
        gpu.gpuMonitoringEnabled = true
        
        gpu.updateGPUUsage(75.5)
        let status = gpu.getGPUStatus()
        XCTAssertEqual(status["gpu_usage"] as? Float, 75.5)
        
        gpu.updateGPUUsage(150.0) // Should cap at 100
        status.forEach { print("\($0.key): \($0.value)") }
    }
    
    func testGPUSettingsFrameTimes() {
        var gpu = GPUSettings()
        
        gpu.recordFrameTime(16.7) // 60 FPS
        gpu.recordFrameTime(16.7)
        gpu.recordFrameTime(16.7)
        
        let avgFrameTime = gpu.getAverageFrameTime()
        XCTAssertEqual(avgFrameTime, 16.7, accuracy: 0.01)
        
        let fps = gpu.getCurrentFPS()
        XCTAssertEqual(fps, 60.0, accuracy: 1.0)
    }
    
    // MARK: - NotificationManager Tests
    func testNotificationManagerEnableDisable() {
        notificationManager.enableNotifications()
        XCTAssertTrue(notificationManager.isNotificationsEnabled())
        
        notificationManager.disableNotifications()
        XCTAssertFalse(notificationManager.isNotificationsEnabled())
    }
    
    func testNotificationManagerSendNotification() {
        notificationManager.enableNotifications()
        notificationManager.sendNotification(title: "Test", message: "Test message", type: .info)
        
        let history = notificationManager.getNotificationHistory()
        XCTAssertTrue(history.contains { $0.title == "Test" })
        XCTAssertTrue(history.contains { $0.message == "Test message" })
    }
    
    func testNotificationManagerClearHistory() {
        notificationManager.enableNotifications()
        notificationManager.sendNotification(title: "Test1", message: "Message1")
        notificationManager.sendNotification(title: "Test2", message: "Message2")
        
        XCTAssertEqual(notificationManager.getNotificationCount(), 2)
        
        notificationManager.clearNotificationHistory()
        XCTAssertEqual(notificationManager.getNotificationCount(), 0)
    }
    
    func testNotificationManagerDisabledSending() {
        notificationManager.disableNotifications()
        notificationManager.sendNotification(title: "Disabled", message: "Should not appear")
        
        let history = notificationManager.getNotificationHistory()
        XCTAssertEqual(history.count, 0)
    }
    
    // MARK: - SettingsManager Tests
    func testSettingsManagerSetGet() {
        settingsManager.setSetting("fps_meter", value: true)
        let fpsEnabled = settingsManager.getBoolSetting("fps_meter")
        XCTAssertTrue(fpsEnabled)
        
        settingsManager.setSetting("temperature_meter", value: false)
        let tempEnabled = settingsManager.getBoolSetting("temperature_meter")
        XCTAssertFalse(tempEnabled)
        
        settingsManager.setSetting("render_scale", value: 1.5)
        let renderScale = settingsManager.getFloatSetting("render_scale")
        XCTAssertEqual(renderScale, 1.5)
    }
    
    func testSettingsManagerReset() {
        settingsManager.setSetting("fps_meter", value: false)
        settingsManager.setSetting("temperature_meter", value: false)
        
        settingsManager.resetSettings()
        
        XCTAssertTrue(settingsManager.isFPSMeterEnabled())
        XCTAssertTrue(settingsManager.isTemperatureMeterEnabled())
        XCTAssertTrue(settingsManager.isThermalManagementEnabled())
        XCTAssertTrue(settingsManager.isGPUMonitoringEnabled())
        XCTAssertTrue(settingsManager.isAntiLagEnabled())
        XCTAssertFalse(settingsManager.isFreezerModeEnabled())
        XCTAssertTrue(settingsManager.isSmoothlessPerformanceEnabled())
        XCTAssertTrue(settingsManager.areNotificationsEnabled())
    }
    
    func testSettingsManagerConvenienceMethods() {
        settingsManager.setSetting("fps_meter", value: true)
        XCTAssertTrue(settingsManager.isFPSMeterEnabled())
        
        settingsManager.setSetting("temperature_meter", value: true)
        XCTAssertTrue(settingsManager.isTemperatureMeterEnabled())
        
        settingsManager.setSetting("anti_lag", value: true)
        XCTAssertTrue(settingsManager.isAntiLagEnabled())
        
        settingsManager.setSetting("freezer_mode", value: false)
        XCTAssertFalse(settingsManager.isFreezerModeEnabled())
        
        settingsManager.setSetting("notifications", value: true)
        XCTAssertTrue(settingsManager.areNotificationsEnabled())
    }
    
    // MARK: - Performance Tests
    func testPerformanceImpact() {
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
    
    // MARK: - Integration Tests
    func testFullIntegration() {
        // Setup
        let games = UniversalGames()
        let monitor = PerformanceMonitor()
        let thermal = ThermalManager()
        var gpu = GPUSettings()
        let notifications = NotificationManager()
        let settings = SettingsManager.shared
        
        // Configure
        monitor.enableFPSMeter()
        monitor.enableTemperatureMeter()
        thermal.enableThermalManagement()
        gpu.toggleAntiLag()
        notifications.enableNotifications()
        
        settings.setSetting("debug_mode", value: true)
        
        // Simulate gameplay
        monitor.updateFPS(60)
        monitor.updateTemperature(38.5)
        let thermalStatus = thermal.checkTemperature(38.5)
        gpu.updateGPUUsage(65.0)
        
        // Send notification if needed
        if thermalStatus.contains("WARNING") || thermalStatus.contains("CRITICAL") {
            notifications.sendNotification(
                title: "Thermal Alert",
                message: thermalStatus
            )
        }
        
        // Verify
        XCTAssertNotNil(games)
        XCTAssertTrue(monitor.isThermalManagementEnabled())
        XCTAssertTrue(settings.isDebugModeEnabled())
        XCTAssertEqual(monitor.getCurrentFPS(), 60)
        XCTAssertEqual(monitor.getCurrentTemperature(), 38.5, accuracy: 0.1)
    }
}

// MARK: - Test Helpers
extension SettingsManager {
    func isDebugModeEnabled() -> Bool {
        return getBoolSetting("debug_mode")
    }
}

// MARK: - Async Tests
class UniversalGamesAsyncTests: XCTestCase {
    
    func testAsyncNotificationSending() {
        let expectation = expectation(description: "Notification sent")
        
        let manager = NotificationManager()
        manager.enableNotifications()
        
        // Send notification
        manager.sendNotification(title: "Async Test", message: "Testing async notifications")
        
        // Wait a bit for the notification to be sent
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let history = manager.getNotificationHistory()
            XCTAssertTrue(history.contains { $0.title == "Async Test" })
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testConcurrentSettingsAccess() {
        let settings = SettingsManager.shared
        let expectation = expectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            settings.setSetting("concurrent_\(index)", value: index)
            let value = settings.getSetting("concurrent_\(index)") as? Int
            XCTAssertEqual(value, index)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
