import MapKit
import UIKit

protocol InformationPostingViewDelegate: AnyObject {
    func didtapCancel()
    func didtapFindLocation(location: String, mediaURL: String)
    func didtapFinish()
}

final class InformationPostingView: UIView {

    // MARK: - Properties

    weak var delegate: InformationPostingViewDelegate?

    // MARK: - API

    func setupView() {
        backgroundColor = .white
        addViewHierarchy()
    }

    func findingErrorState(shouldShow: Bool, message: String?) {
        feedbackLabel.isHidden = !shouldShow
        feedbackLabel.text = message
    }

    func requestingData() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        contentStackView.isHidden = true
        mapView.isHidden = true
        finishButton.isHidden = true
    }

    func dataRequested(success: Bool) {
        loadingIndicator.stopAnimating()
        imageView.isHidden = success
        contentStackView.isHidden = success
        mapView.isHidden = !success
        finishButton.isHidden = !success
    }

    func addAnnotation(_ annotation: MKAnnotation) {
        let coordinate = annotation.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)

        mapView.setCenter(coordinate, animated: true)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }

    // MARK: - UI

    lazy var cancelButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAction))
        barButtonItem.title = "CANCEL"
        return barButtonItem
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_world")
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var locationTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Location"
        textField.textContentType = .addressCityAndState
        textField.keyboardType = .default
        textField.autocapitalizationType = .words
        return textField
    }()

    private lazy var mediaURLTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Media URL"
        textField.textContentType = .URL
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        return textField
    }()

    private lazy var findLocationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(red: 2/255, green: 179/255, blue: 228/255, alpha: 1)
        button.setTitle("FIND LOCATION", for: .normal)
        button.addTarget(self, action: #selector(findLocationAction), for: .touchUpInside)
        return button
    }()

    private lazy var feedbackLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .red
        label.isHidden = true
        return label
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.isMultipleTouchEnabled = true
        mapView.showsCompass = true
        mapView.delegate = self
        mapView.isHidden = true
        return mapView
    }()

    private lazy var finishButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 2/255, green: 179/255, blue: 228/255, alpha: 1)
        button.setTitle("FINISH", for: .normal)
        button.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: View

    private func addViewHierarchy() {
        addSubview(imageView)
        addSubview(contentStackView)
        addSubview(loadingIndicator)
        addSubview(mapView)
        addSubview(finishButton)
        
        contentStackView.addArrangedSubview(locationTextField)
        contentStackView.addArrangedSubview(mediaURLTextField)
        contentStackView.addArrangedSubview(findLocationButton)
        contentStackView.addArrangedSubview(feedbackLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            finishButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -24),
            finishButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            finishButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - UIActions

    @objc private func cancelAction(_ sender: UIButton) {
        delegate?.didtapCancel()
    }

    @objc private func findLocationAction(_ sender: UIButton) {
        guard let location = locationTextField.text,
                let mediaURL = mediaURLTextField.text,
                !location.isEmpty, !mediaURL.isEmpty else {
            findingErrorState(shouldShow: true, message: "Must specify an Location and Media URL")
            return
        }
        findingErrorState(shouldShow: false, message: nil)
        delegate?.didtapFindLocation(location: location, mediaURL: mediaURL)
    }

    @objc private func finishAction(_ sender: UIButton) {
        delegate?.didtapFinish()
    }
}

extension InformationPostingView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.markerTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
}
