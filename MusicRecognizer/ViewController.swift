//
//  ViewController.swift
//  MusicRecognizer
//
//  Created by Decagon on 28/06/2021.
//

import ShazamKit
import UIKit

class ViewController: UIViewController, SHSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeSong()
    }
    
    private func recognizeSong() {
        // Session
        let session = SHSession()
        // Delegate
        session.delegate = self
        do {
            // Get track
            guard let url = Bundle.main.url(forResource: "hozier_take_me_to_church_mp3_1", withExtension: "mp3") else {
                print("Failed to get song url")
                return
            }
            // Create audio file
            let file = try AVAudioFile(forReading: url)
            // Audio -> Buffer
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length / 25)
            ) else {
                print("Failed to create buffer")
                return
            }
            // read the file into the buffer
            try file.read(into: buffer)
            // SignatureGenerator
            let generator = SHSignatureGenerator()
            try generator.append(buffer, at: nil)
            // Create the signature
            let signature = generator.signature()
            // Try to match
            session.match(signature)
        } catch {
            print(error)
        }
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        // Get the results
        let items = match.mediaItems
        items.forEach { item in
            print(item.title ?? "title")
            print(item.artist ?? "artist")
            print(item.artworkURL?.absoluteURL ?? "Artwork URL")
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
        }
    }

}

