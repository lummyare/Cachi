import Foundation
import HTTPKit
import os

struct ScriptRoute: Routable {
    let path = "/script"
    let description = "Script route, used for html rendering"
    
    func respond(to req: HTTPRequest, with promise: EventLoopPromise<HTTPResponse>) {
        os_log("Script request received", log: .default, type: .info)
        
        guard let scriptIdentifier = req.url.query else {
            let res = HTTPResponse(status: .notFound, body: HTTPBody(staticString: "Not found..."))
            return promise.succeed(res)
        }

        let scriptContent: String?
        switch scriptIdentifier {
        case "screenshot": scriptContent = scriptScreenshot()
        default: scriptContent = nil
        }

        guard scriptContent != nil else {
            let res = HTTPResponse(status: .notFound, body: HTTPBody(staticString: "Not found..."))
            return promise.succeed(res)
        }

        let res = HTTPResponse(headers: HTTPHeaders([("Content-Type", "application/javascript")]), body: HTTPBody(string: scriptContent!))
        return promise.succeed(res)
    }
    
    private func scriptScreenshot() -> String {
        return """
            var screenshotTopAnchorY = 0;
            var screenshotPositionSticky = true;
            var screenshotImageElement = null;
            var screenshotImageTopOffset = 10;
        
            window.onload = function() {
                screenshotTopAnchorY = document.getElementById('screenshot-column').getBoundingClientRect().top + window.scrollY;
                screenshotImageElement = document.getElementById('screenshot-image')
                window.onscroll();
            }
        
            window.onscroll = function() {
                if (screenshotImageElement == null) { return; }
        
                if (window.pageYOffset != undefined) {
                    if (pageYOffset > screenshotTopAnchorY && !screenshotPositionSticky) {
                        screenshotImageElement.style.position = "fixed";
                        screenshotImageElement.style.top = `${screenshotImageTopOffset}px`;
                        screenshotPositionSticky = true;
                    } else if (pageYOffset <= screenshotTopAnchorY && screenshotPositionSticky) {
                        screenshotImageElement.style.position = "absolute";
                        screenshotImageElement.style.top = `${screenshotTopAnchorY + screenshotImageTopOffset}px`;
                        screenshotPositionSticky = false;
                    }
                }
            }
        
            function onMouseEnter(result_identifier, attachment_identifier, content_type) {
                document.getElementById('screenshot-image').src = `\(AttachmentRoute().path)?result_id=${result_identifier}&id=${attachment_identifier}&content_type=${content_type}`;
            }
        """
    }
}
