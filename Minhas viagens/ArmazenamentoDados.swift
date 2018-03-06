//
//  ArmazenamentoDados.swift
//  Minhas viagens
//
//  Created by 5A Nucleo Desenvolvimento on 06/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit

class ArmazenamentoDados {
    
    let key = "locaisViagem"
    var viagens: [ Dictionary<String, String> ] = []
    
    func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func salvar(viagem: Dictionary<String, String>) {
        viagens = listarViagens()
        
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: self.key)
        getDefaults().synchronize()
    }
    
    func listarViagens() -> [ Dictionary<String, String> ] {
        if let dados = getDefaults().object(forKey: key) {
            return dados as! Array
        } else {
            return []
        }
    }
    
    func removerViagem(at indice: Int) {
        viagens = listarViagens()
        viagens.remove(at: indice)
        
        getDefaults().set(viagens, forKey: self.key)
        getDefaults().synchronize()
    }
}
