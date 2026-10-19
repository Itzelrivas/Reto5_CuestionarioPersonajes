//
//  Cuestionario.swift
//  QuePersonajeEres
//
//  Lógica del cuestionario: controla en qué pregunta va el usuario, guarda sus
//  respuestas (sin permitir cambiarlas) y calcula el personaje resultante.
//

import Foundation

final class Cuestionario {

    /// Colección ordenada con las preguntas (Array).
    let preguntas: [Pregunta]

    /// Posición de la pregunta actual dentro del arreglo `preguntas`.
    private(set) var indiceActual = 0

    /// Personaje asociado a cada respuesta elegida, en orden (Array).
    private(set) var respuestas: [Personaje] = []

    init(preguntas: [Pregunta] = Cuestionario.preguntasPredeterminadas) {
        self.preguntas = preguntas
    }

    // MARK: - Estado

    var totalPreguntas: Int { preguntas.count }

    var haTerminado: Bool { indiceActual >= preguntas.count }

    var esUltimaPregunta: Bool { indiceActual == preguntas.count - 1 }

    var preguntaActual: Pregunta? {
        // Operador ternario: si ya no hay preguntas devuelve nil.
        return haTerminado ? nil : preguntas[indiceActual]
    }

    /// Indica si la pregunta actual ya tiene respuesta.
    var preguntaActualRespondida: Bool { respuestas.count > indiceActual }

    // MARK: - Acciones

    /// Registra la respuesta de la pregunta actual.
    /// Solo se acepta UNA respuesta por pregunta: si ya se respondió, devuelve `false`
    /// y la respuesta original no se modifica.
    @discardableResult
    func responder(_ opcion: Opcion) -> Bool {
        guard !haTerminado, !preguntaActualRespondida else { return false }
        respuestas.append(opcion.personaje)
        return true
    }

    /// Pasa a la siguiente pregunta (solo si la actual ya fue respondida).
    func avanzar() {
        guard preguntaActualRespondida else { return }
        indiceActual += 1
    }

    // MARK: - Resultado

    /// Cuenta los puntos de cada personaje con un diccionario y regresa el que más tiene.
    /// En caso de empate gana el personaje de la respuesta más reciente entre los empatados.
    func calcularResultado() -> Personaje {
        var conteo: [Personaje: Int] = [:]
        for personaje in respuestas {
            conteo[personaje, default: 0] += 1
        }

        let maximo = conteo.values.max() ?? 0
        let empatados = Set(conteo.filter { $0.value == maximo }.keys)

        for personaje in respuestas.reversed() where empatados.contains(personaje) {
            return personaje
        }
        return Personaje.allCases[0]
    }

    /// Cuántas respuestas coincidieron con un personaje.
    func coincidencias(con personaje: Personaje) -> Int {
        return respuestas.filter { $0 == personaje }.count
    }
}

// MARK: - Datos del cuestionario

extension Cuestionario {

    /// Las 5 preguntas de la app. Cada una ofrece una opción por personaje.
    static let preguntasPredeterminadas: [Pregunta] = [
        Pregunta(texto: "Es sábado por la tarde y no tienes tareas pendientes. ¿Qué haces?", opciones: [
            Opcion(texto: "Salgo a vivir una aventura sin un plan fijo", personaje: .harry),
            Opcion(texto: "Me quedo leyendo o aprendiendo algo nuevo", personaje: .hermione),
            Opcion(texto: "Invito a mis amigos a jugar o a comer algo rico", personaje: .ron),
            Opcion(texto: "Dibujo, escribo o imagino cosas fuera de lo común", personaje: .luna)
        ]),
        Pregunta(texto: "Un amigo está en problemas. ¿Cómo reaccionas?", opciones: [
            Opcion(texto: "Voy de inmediato, sin pensar en los riesgos", personaje: .harry),
            Opcion(texto: "Investigo y preparo un plan para ayudarlo", personaje: .hermione),
            Opcion(texto: "Lo acompaño y lo hago reír para animarlo", personaje: .ron),
            Opcion(texto: "Lo escucho con calma y le ofrezco otra forma de verlo", personaje: .luna)
        ]),
        Pregunta(texto: "¿Qué cualidad te describe mejor?", opciones: [
            Opcion(texto: "Valentía", personaje: .harry),
            Opcion(texto: "Inteligencia", personaje: .hermione),
            Opcion(texto: "Lealtad", personaje: .ron),
            Opcion(texto: "Originalidad", personaje: .luna)
        ]),
        Pregunta(texto: "En un trabajo en equipo, tú eres quien…", opciones: [
            Opcion(texto: "Toma la iniciativa y se lanza primero", personaje: .harry),
            Opcion(texto: "Organiza las tareas y revisa los detalles", personaje: .hermione),
            Opcion(texto: "Mantiene al grupo unido y de buen humor", personaje: .ron),
            Opcion(texto: "Aporta ideas que nadie esperaba", personaje: .luna)
        ]),
        Pregunta(texto: "¿Cuál sería tu lugar favorito para pasar el día?", opciones: [
            Opcion(texto: "Un parque de aventuras lleno de retos", personaje: .harry),
            Opcion(texto: "Una gran biblioteca en silencio", personaje: .hermione),
            Opcion(texto: "Una mesa llena de comida y amigos", personaje: .ron),
            Opcion(texto: "Un bosque misterioso con criaturas curiosas", personaje: .luna)
        ])
    ]
}
