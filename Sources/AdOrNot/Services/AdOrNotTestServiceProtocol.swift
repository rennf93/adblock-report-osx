import Foundation

protocol AdOrNotTestServiceProtocol: Sendable {
    func runTests(
        domains: [TestDomain],
        onProgress: @Sendable (AdOrNotTestService.TestProgress) -> Void
    ) async -> [TestResult]
}

extension AdOrNotTestService: AdOrNotTestServiceProtocol {}
