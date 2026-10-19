//
//  Personaje.swift
//  QuePersonajeEres
//
//  Modelo de datos: los personajes posibles, las opciones de respuesta y las preguntas.
//

import Foundation

/// Personajes que puede obtener el usuario como resultado.
/// Al ser un `enum` con casos fijos, el compilador obliga a manejar todos en cada `switch`.
enum Personaje: CaseIterable {
    case harry
    case hermione
    case ron
    case luna

    var nombre: String {
        switch self {
        case .harry:    return "Harry Potter"
        case .hermione: return "Hermione Granger"
        case .ron:      return "Ron Weasley"
        case .luna:     return "Luna Lovegood"
        }
    }

    var emoji: String {
        switch self {
        case .harry:    return "⚡️"
        case .hermione: return "📚"
        case .ron:      return "♟️"
        case .luna:     return "🌙"
        }
    }

    var descripcion: String {
        switch self {
        case .harry:
            return "Eres valiente y decidido. Cuando alguien te necesita, actúas sin dudar y enfrentas los retos de frente, aunque den miedo. Tu determinación inspira a quienes te rodean."
        case .hermione:
            return "Eres estudiosa, organizada y muy inteligente. Prefieres prepararte antes de actuar y casi siempre tienes un plan listo. La gente confía en ti cuando hay un problema por resolver."
        case .ron:
            return "Eres leal, divertido y un amigo incondicional. Tu buen humor y tu apoyo mantienen unido al grupo, y sabes que lo más valioso son las personas que te acompañan."
        case .luna:
            return "Eres creativa, auténtica y piensas distinto a los demás. Ves magia donde otros no la ven, y tu forma tan original de mirar el mundo hace que nadie te olvide."
        }
    }
}

/// Una opción de respuesta: el texto que ve el usuario y el personaje al que suma un punto.
struct Opcion {
    let texto: String
    let personaje: Personaje
}

/// Una pregunta del cuestionario con sus opciones de respuesta.
struct Pregunta {
    let texto: String
    let opciones: [Opcion]
}
