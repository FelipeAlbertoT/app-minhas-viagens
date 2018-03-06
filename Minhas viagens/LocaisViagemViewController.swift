//
//  LocaisViagemViewController.swift
//  Minhas viagens
//
//  Created by 5A Nucleo Desenvolvimento on 06/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit

class LocaisViagemViewController: UITableViewController {

    var viagens: [Dictionary<String, String>] = []
    var controleNavegacao = "adicionar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        atualizarViagens()
    }

    func atualizarViagens() {
        viagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viagens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viagem = viagens[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        cell.textLabel?.text = viagem["local"]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            ArmazenamentoDados().removerViagem(at: indexPath.row)
            atualizarViagens() 
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleNavegacao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocal" {
            let viewControllerDestino = segue.destination as! ViewController
            if self.controleNavegacao == "listar" {
                if let indiceRecuperado = sender {
                    let indice = indiceRecuperado as! Int
                    viewControllerDestino.viagem = viagens[indice]
                    viewControllerDestino.indiceSelecionado = indice
                }
            } else {
                viewControllerDestino.viagem = [:]
                viewControllerDestino.indiceSelecionado = -1
            }
        }
    }
    

}
