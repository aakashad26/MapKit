import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var artworks: [Artwork] = []

    let locationManager = CLLocationManager()

    let coordinates = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)

    var annotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        mapView.mapType = .standard

        self.isLocationAccessEnabled()
        checkLocationServices()
        setupLocationManager()

        loadInitialData()

        for i in stride(from: 0, to: artworks.count, by: 1){

            let artwork = artworks[i]

            let annotations = MKPointAnnotation()

            annotations.coordinate = artwork.coordinate

            mapView.addAnnotation(annotations)

        }

    }

    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            isLocationAccessEnabled()
        } else {
            print("Error in Location Services.")
        }
    }

    private func loadInitialData() {

      guard
        let fileName = Bundle.main.url(forResource: "PublicArt", withExtension: "geojson"),
        let artworkData = try? Data(contentsOf: fileName)
        else {
          return
      }

      do {
        let features = try MKGeoJSONDecoder()
          .decode(artworkData)
          .compactMap { $0 as? MKGeoJSONFeature }

        print(features)
        let validWorks = features.compactMap(Artwork.init)
         artworks.append(contentsOf: validWorks)
        print(artworks)
      } catch {

        print("Unexpected error: \(error).")
      }
    }

    //Check the Location Status
    func isLocationAccessEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined,.denied:
                print("No access. Please go to Settings -> Location Services -> Enable Location. ")
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("No Access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
            default:
                print("Location services not enabled.")
            }
        } else {
            print("Location services not enabled.")
        }
    }

}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){

        guard let location = locations.last else{ return }

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationServices()    }

}

