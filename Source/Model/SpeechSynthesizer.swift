import AVFoundation
import Foundation

class SpeechSynthesizer {
    private var synth = AVSpeechSynthesizer()
    func speak(number: Int) {
        let utterance = AVSpeechUtterance(string: "\(number)")
        synth.speak(utterance)
    }
}
