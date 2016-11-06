import Foundation
import AVFoundation

class SpeechSynthesizer {
    private var synth = AVSpeechSynthesizer()
    func speak(number: Int) {
        let utterance = AVSpeechUtterance(string: "\(number)")
        synth.speak(utterance)
    }
}
