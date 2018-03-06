//
//  ViewController.swift
//  Minhas viagens
//
//  Created by 5A Nucleo Desenvolvimento on 06/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    let locationManager = CLLocationManager()
    var viagem: Dictionary<String, String> = [:]
    var indiceSelecionado: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let indice = indiceSelecionado {
            if indice == -1 {
                configuraLocationManager()
            } else {
                exibirAnotacao(viagem: viagem)
            }
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        longPress.minimumPressDuration = 2
        
        mapa.addGestureRecognizer(longPress)
    }
    
    @objc func marcar(gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            // Recupera coordenadas do ponto selecionado
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = self.mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            // Recupera endereco do ponto selecionado
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (local, erro) in
                if erro == nil {
                    var localCompleto = "Endereço não encontrado!"
                    if let dadosLocal = local?.first {
                        if let nome = dadosLocal.name {
                            localCompleto = nome
                        } else {
                            if let endereco = dadosLocal.thoroughfare {
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    // Salvar viagem
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvar(viagem: self.viagem)
                    
                    // Exibe anotacao
                    self.exibirAnotacao(viagem: self.viagem)
                } else {
                    print(erro!)
                }
            })
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let localizacao = locations.last!
//
//        exibirLocal(latitude: localizacao.coordinate.latitude, longitude: localizacao.coordinate.longitude)
//    }
    
    func exibirLocal(latitude: Double, longitude: Double) {
        let coordenadas = CLLocationCoordinate2DMake(latitude, longitude)
        let area = MKCoordinateSpanMake(0.01, 0.01)
        let regiao = MKCoordinateRegionMake(coordenadas, area)
        self.mapa.setRegion(regiao, animated: true)
    }
    
    func exibirAnotacao(viagem: Dictionary<String, String>) {
        if let localViagem = viagem["local"] {
            if let latidudeString = viagem["latitude"] {
                if let longitudeString = viagem["longitude"] {
                    if let latitude = Double(latidudeString) {
                        if let longitude = Double(longitudeString) {
                            
                            // Exibe local
                            exibirLocal(latitude: latitude, longitude: longitude)
                            
                            let anotacao = MKPointAnnotation()
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.mapa.addAnnotation(anotacao)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func configuraLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let localizacao = locationManager.location {
            exibirLocal(latitude: localizacao.coordinate.latitude, longitude: localizacao.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso à sua localização", preferredStyle: .alert)
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let acaoConfigurar = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            alertController.addAction(acaoConfigurar)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
    }

}

