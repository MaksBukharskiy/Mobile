import SwiftUI
import MapKit

struct SimpleMapView: UIViewRepresentable {
    let markers: [EducationalMapMarker]
    let onMarkerTap: (EducationalMapMarker) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        let initialLocation = CLLocation(latitude: 55.7558, longitude: 37.6173)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        for marker in markers {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: marker.latitude,
                longitude: marker.longitude
            )
            annotation.title = marker.title
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        for marker in markers {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: marker.latitude,
                longitude: marker.longitude
            )
            annotation.title = marker.title
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SimpleMapView
        
        init(_ parent: SimpleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }
            
            let identifier = "marker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
                markerAnnotationView.markerTintColor = UIColor(Color.brandRed)
                markerAnnotationView.glyphImage = UIImage(systemName: "graduationcap.fill")
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation,
                  let title = annotation.title,
                  let markerTitle = title else { return }
            
            if let marker = parent.markers.first(where: { $0.title == markerTitle }) {
                parent.onMarkerTap(marker)
            }
        }
    }
}
