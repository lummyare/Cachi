extension ResultBundle {
    func htmlTitle() -> String {
        if let userInfo = userInfo {
            return "\(userInfo.branchName) - \(userInfo.commitHash)"
        } else {
            return identifier
        }
    }
    
    func htmlSubtitle() -> String {
        return userInfo?.commitMessage ?? ""
    }
}

extension ResultBundle {
    func htmlStatusImageUrl(for test: ResultBundle.Test) -> String {
        if test.status == .success {
            return "/image?imageTestPass"
        }
        
        if testsUniquelyFailed.contains(where: { $0.matches(test) }) {
            return "/image?imageTestFail"
        } else {
            return "/image?imageTestRetried"
        }
    }
    
    func htmlStatusTitle(for test: ResultBundle.Test) -> String {
        if test.status == .success {
            return "Passed"
        }
        
        if testsUniquelyFailed.contains(where: { $0.matches(test) }) {
            return "Failed"
        } else {
            return "Failed, but passed on retry"
        }
    }
    
    func htmlTextColor(for test: ResultBundle.Test) -> String {
        if test.status == .success {
            return "color-text"
        }
        
        if testsUniquelyFailed.contains(where: { $0.matches(test) }) {
            return "color-error"
        } else {
            return "color-retry"
        }
    }
}

extension ResultBundle {
    func htmlStatusImageUrl() -> String {
        if testsFailed.count > 0 {
            return "/image?imageTestFail"
        } else {
            return "/image?imageTestPass"
        }
    }
    
    func htmlStatusTitle() -> String {
        if testsFailed.count > 0 {
            return "Failed"
        } else {
            return "Passed"
        }
    }
    
    func htmlTextColor() -> String {
        if testsFailed.count > 0 {
            return "color-error"
        } else {
            return "color-text"
        }
    }
}
