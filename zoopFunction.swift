//
//  FuncoesZoop.swift
//  Pagamentos, Cancelamento e Geração do token
//
//  Created by Vilanio  Alves on 30/08/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//
//ESTA VERSAO PARA METODO DE PAGAMENTO DA ZOOP.
//VOCE DEVERAR TER OS PARAMETOS COMO, ID DO VENDEDOR, VALOR DA VENDA E ID DA VENDA.
//IREI ANEXAR O PHP DE ACESSO A CURL PARA USO COM SERVICE.




import Foundation
import UIKit

let cardSave = UserDefault.standar

func gerarTokenCartao(cardName: String, expiration_month: String, expiration_year: String, resultCard: String, security_code: String){
    
    let urlString = "https://seuDominio/admin/zoop.php?funcao=gerartoken&name=\(cardName)&mm=\(expiration_month)&yyyy=\(expiration_year)&card=\(resultCard)&cvv=\(security_code)"
    
    guard let myURL = URL(string: urlString) else { return }
    let request = NSMutableURLRequest(url: myURL)
    
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: myURL) {
        data, response, error in
        
        if error != nil{
            
            print("error is \(error!)")
            return
            
        }
        do {
            //converting resonse to NSDictionary
            let transacao = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary)
            
            let respostaTransacao = [transacao]
            
            
            //looping through all the json objects in the array teams
            for i in 0 ..< respostaTransacao.count {
                
                
                let resultT: String = respostaTransacao[i]["result"] as! String
                
                let idtoken: String = respostaTransacao[i]["token"] as! String
                
                if resultT == "0" {
                    
                    print("RESULTADO TOKEN -> ")
                    
                } else if resultT == "1" {
                    
                    if (cardSave.string(forKey: "token") == nil) {
                        
                        cardSave.set(idtoken, forKey: "token")
                        cardSave.synchronize()
                        
                    } else {
                        
                        cardSave.removeObject(forKey: "token")
                        cardSave.set(idtoken, forKey: "token")
                        cardSave.synchronize()
                    }

                }

            
        } catch {
            print(error)
            
        }
        }
        .resume()
   
}




func cancelAutorization(vendedor:String, valor:String, idvenda: String) {
    
    let urlCancel = "https://seuDominioAqui/zoop.php?funcao=estorna&vendedor=\(vendorId)&valor=\(amount)&idtransacao=\(idvenda)"

    guard let myURL = URL(string: urlCancel) else { return }
    let request = NSMutableURLRequest(url: myURL)
    
    request.httpMethod = "POST"
    
    URLSession.shared.dataTask(with: myURL) {
        data, response, error in
        
        if error != nil{
            
            return
            
        }
        do {
            //converting resonse to NSDictionary
            let cancelamento = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary)
            
            let retCancelamento = [cancelamento]
            
            //looping through all the json objects in the array teams
            for i in 0 ..< retCancelamento.count {
                
               
                let resultErro: String = retCancelamento[i]["result"] as! String
                let temVenda = retCancelamento[i]["venda"] as! String
                
                if resultErro == "0" {
                    
                } else if temVenda.isEmpty {
                  
                     
                }else{
                    
                    if memTransacao.string(forKey: "idCancelamento") == nil {
                        
                        memTransacao.set(temVenda, forKey: "idCancelamento")
                        memTransacao.synchronize()
                    
                        //Save to UserDefault our send to variavel.
                        
                    }else{
                        
                        memTransacao.removeObject(forKey: "idCancelamento")
                    }
                    
                    
                }
                
                
            }
        } catch {
            print(error)
            
        }
        }
        .resume()

}

func pegaSellerId(id:String){
    
    let urlString = "https://seuDominio/pegaseller.php?id=\(id)"
    
    guard let myURL = URL(string: urlString) else { return }
    let request = NSMutableURLRequest(url: myURL)
    
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: myURL) {
        data, response, error in
        
        if error != nil{
            
            print("error is \(error!)")
            return
            
        }
        do {
            //converting resonse to NSDictionary
            let operacao = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:String])

            let resultT: String = operacao["iSellerId"]!
            
            if cardSave.string(forKey: "iSellerId") == nil {
               
                cardSave.set(resultT, forKey: "iSellerId")
            } else {
                print("RODOU SALVAR A ISELLERID NAO NULA")
                cardSave.removeObject(forKey: "iSellerId")
                cardSave.set(resultT, forKey: "iSellerId")
                
            }
    
            
        } catch {
            print(error)
            
        }
        }
        .resume()

}

func pagamento(valorPag:String, tipo:String, vendedor: String) {
    /*RECUPERA VALOR DA TARIFA, E RETIRA R$ E PONTO EX:800 */

   
    let prePag = true
    
    let descricao1 = ("IO\(random(6))")
    
    if descricao.string(forKey: "descricao") == nil {
        descricao.set(descricao1, forKey: "descricao")
        descricao.synchronize()
    }else{
        descricao.removeObject(forKey: "descricao")
        descricao.set(descricao1, forKey: "descricao")
        descricao.synchronize()
    }

    
    let resNome = cardSave.string(forKey: "holder_name")!.removingWhitespaces()
    
    let resultCard=cardSave.string(forKey: "card_number")!.removingWhitespacesCard()
    
    let mes = cardSave.string(forKey: "expiration_month")
    
    let ano = cardSave.string(forKey: "expiration_year")
    
    let cvv = cardSave.string(forKey: "security_code")

    gerarTokenCartao(resNome: resNome, expiration_month: mes!, expiration_year: ano!, resultCard: resultCard, security_code: cvv!)
    
    let tokenGera = cardSave.string(forKey: "token")
   
    let urlString = "https://seuDominio/zoop.php?funcao=preautorizacao2&valor=\(valorPag)&tipo=\(tipo)&descricao=\(descricao1)&token_cartao=\(tokenGera!)&capture=\(prePag)&vendedor=\(vendedor)"
    

    
    print("A URL ENVIADA -> \(urlString)")
    guard let myURL = URL(string: urlString) else { return }
    let request = NSMutableURLRequest(url: myURL)
    
    request.httpMethod = "GET"
   
    URLSession.shared.dataTask(with: myURL) {
        data, response, error in
        
        
        if error != nil{
            
            print("error is \(error!)")
            return
            
        }
        do {
            //converting resonse to NSDictionary
            let dataCardRec = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary)
            
            let dataCard = [dataCardRec]
            
            print("O RETORNO DO PAGAMENTO -> \(dataCard)")
            
            //looping through all the json objects in the array teams
            for i in 0 ..< dataCard.count {
                
                //let retornoErro:String = dataCard[i]["message"] as! String // MENSAGEM DO RESULDAO SE QUIZER USAR
                
                let resultErro: String = dataCard[i]["result"] as! String
                
                
                
                
                if resultErro == "0" {
                    
                    
                    //EMITIR ALERTA INFORMANDO A NAO AUTORIZACAO
                } else if resultErro == "1"{
                    //EMITIR ALERTA INFORMANDO AUTORIZACAO.        
                }
                
                
            }
        } catch {
            print(error)
            
        }
        }
        .resume()
  
    DispatchQueue.main.async() {
        //self.generateToken()
        
    }
    

}
