import SwiftUI
import WebKit

struct YandexWebMapView: UIViewRepresentable {
    let apiKey: String
    let markers: [EducationalMapMarker]
    var onMarkerTap: ((EducationalMapMarker) -> Void)? = nil
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = true
        webView.navigationDelegate = context.coordinator

        webView.configuration.userContentController.add(context.coordinator, name: "markerClicked")
        
        let htmlString = createHTMLString()
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
       
        let htmlString = createHTMLString()
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    private func createHTMLString() -> String {
        print("Creating HTML with \(markers.count) markers")
        
        let markersScript = markers.enumerated().map { index, marker in
            return """
            {
                center: [\(marker.latitude), \(marker.longitude)],
                title: '\(marker.title.replacingOccurrences(of: "'", with: "\\'"))',
                description: '\(marker.description?.replacingOccurrences(of: "'", with: "\\'") ?? "Образовательное учреждение")',
                index: \(index)
            }
            """
        }.joined(separator: ",\n            ")
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <script src="https://api-maps.yandex.ru/2.1/?apikey=\(apiKey)&lang=ru_RU"></script>
            <style>
                * { margin: 0; padding: 0; }
                html, body, #map { width: 100%; height: 100%; }
                body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
            </style>
        </head>
        <body>
            <div id="map"></div>
            <script>
                ymaps.ready(init);
                
                function init() {
                    console.log('Initializing Yandex Map with \(markers.count) markers');
                    
                    var map = new ymaps.Map('map', {
                        center: [55.7558, 37.6173],
                        zoom: 10,
                        controls: ['zoomControl', 'fullscreenControl']
                    });
                    
                    var places = [
            \(markersScript)
                    ];
                    
                    console.log('Places to add:', places);
                    
                    var clusterer = new ymaps.Clusterer({
                        preset: 'islands#invertedRedClusterIcons',
                        clusterDisableClickZoom: true,
                        clusterOpenBalloonOnClick: false,
                        clusterBalloonContentLayout: 'cluster#balloonCarousel'
                    });
                    
                    places.forEach(function(place, index) {
                        var placemark = new ymaps.Placemark(place.center, {
                            balloonContentHeader: place.title,
                            balloonContentBody: place.description,
                            hintContent: place.title
                        }, {
                            preset: 'islands#redEducationIcon',
                            iconColor: '#ba2135'
                        });
                        
                       
                        placemark.events.add('click', function(e) {
                            console.log('Marker clicked:', place.index, place.title);
                            window.webkit.messageHandlers.markerClicked.postMessage(place.index);
                            e.preventDefault();
                            return false;
                        });
                        
                        clusterer.add(placemark);
                    });
                    
                    map.geoObjects.add(clusterer);
                    
                    if (places.length > 0) {
                        map.setBounds(clusterer.getBounds(), {
                            checkZoomRange: true
                        });
                    }
                    
                    console.log('Map initialized successfully');
                }
            </script>
        </body>
        </html>
        """
        
        print("HTML created successfully")
        print("=== HTML CONTENT DEBUG ===")
        print("Markers count: \(markers.count)")
        print("First marker: \(markers.first?.title ?? "none")")
        print("HTML length: \(html.count) characters")
        return html
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: YandexWebMapView
        
        init(_ parent: YandexWebMapView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Yandex Map loaded successfully with \(parent.markers.count) markers")
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("Received message: \(message.name), body: \(message.body)")
            
            if message.name == "markerClicked", let index = message.body as? Int {
                print("Marker clicked with index: \(index)")
                if index < parent.markers.count {
                    let marker = parent.markers[index]
                    print("Calling onMarkerTap for: \(marker.title)")
                    DispatchQueue.main.async {
                        self.parent.onMarkerTap?(marker)
                    }
                }
            }
        }
    }
}
