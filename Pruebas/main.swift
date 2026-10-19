//
//  main.swift (Pruebas de la lógica)
//
//  Script de pruebas que NO forma parte de la app. Verifica las reglas del cuestionario
//  usando los mismos archivos Personaje.swift y Cuestionario.swift de la app.
//
//  Se ejecuta automáticamente en GitHub Actions, o a mano en Terminal con:
//    swiftc -swift-version 5 -o /tmp/pruebas QuePersonajeEres/Personaje.swift \
//           QuePersonajeEres/Cuestionario.swift Pruebas/main.swift && /tmp/pruebas
//

import Foundation

var fallos = 0

func comprobar(_ condicion: Bool, _ mensaje: String) {
    if condicion {
        print("✅ \(mensaje)")
    } else {
        print("❌ \(mensaje)")
        fallos += 1
    }
}

/// Juega un cuestionario completo eligiendo, en cada pregunta, la opción del personaje indicado.
func jugar(_ elecciones: [Personaje]) -> Cuestionario {
    let cuestionario = Cuestionario()
    for eleccion in elecciones {
        guard let pregunta = cuestionario.preguntaActual,
              let opcion = pregunta.opciones.first(where: { $0.personaje == eleccion }) else { break }
        cuestionario.responder(opcion)
        cuestionario.avanzar()
    }
    return cuestionario
}

// MARK: - Estructura del cuestionario
let base = Cuestionario()
comprobar(base.totalPreguntas == 5, "El cuestionario tiene exactamente 5 preguntas")
comprobar(base.preguntas.allSatisfy { $0.opciones.count == 4 }, "Cada pregunta tiene 4 opciones")
comprobar(base.preguntas.allSatisfy { Set($0.opciones.map { $0.personaje }).count == Personaje.allCases.count },
          "Cada pregunta ofrece una opción por personaje")
comprobar(Personaje.allCases.allSatisfy { !$0.nombre.isEmpty && !$0.descripcion.isEmpty && !$0.emoji.isEmpty },
          "Todos los personajes tienen nombre, emoji y descripción")

// MARK: - Una sola respuesta por pregunta y sin cambios
let prueba = Cuestionario()
prueba.avanzar()
comprobar(prueba.indiceActual == 0, "No se puede avanzar sin responder la pregunta")

let opciones = prueba.preguntas[0].opciones
comprobar(prueba.responder(opciones[0]) == true, "Se acepta la primera respuesta")
comprobar(prueba.responder(opciones[1]) == false, "Se rechaza una segunda respuesta en la misma pregunta")
comprobar(prueba.respuestas.count == 1 && prueba.respuestas[0] == opciones[0].personaje,
          "La respuesta original no se modifica")
prueba.avanzar()
comprobar(prueba.indiceActual == 1, "Después de responder sí se puede avanzar")

// MARK: - Resultado
let todasHermione = jugar([.hermione, .hermione, .hermione, .hermione, .hermione])
comprobar(todasHermione.haTerminado, "Al responder la pregunta 5 el cuestionario termina")
comprobar(todasHermione.preguntaActual == nil, "Al terminar ya no hay pregunta actual")
comprobar(todasHermione.calcularResultado() == .hermione, "5 respuestas de Hermione dan como resultado a Hermione")
comprobar(todasHermione.coincidencias(con: .hermione) == 5, "Las coincidencias se cuentan bien (5 de 5)")

let mayoria = jugar([.harry, .ron, .harry, .luna, .harry])
comprobar(mayoria.calcularResultado() == .harry, "Gana el personaje con más respuestas (3 contra 1 y 1)")

let empateRon = jugar([.harry, .ron, .harry, .ron, .luna])
comprobar(empateRon.calcularResultado() == .ron, "Empate Harry/Ron: gana el elegido más recientemente (Ron)")

let empateHarry = jugar([.ron, .harry, .ron, .harry, .luna])
comprobar(empateHarry.calcularResultado() == .harry, "Empate Ron/Harry: gana el elegido más recientemente (Harry)")

let ultimaRespuesta = jugar([.harry, .hermione, .ron, .luna, .luna])
comprobar(ultimaRespuesta.calcularResultado() == .luna, "Con una respuesta repetida gana el personaje repetido (Luna)")

// MARK: - Cuestionario terminado
comprobar(todasHermione.responder(base.preguntas[0].opciones[0]) == false,
          "Terminado el cuestionario ya no se aceptan respuestas")

// MARK: - Resumen
if fallos > 0 {
    print("\n\(fallos) prueba(s) fallaron")
    exit(1)
} else {
    print("\n🎉 Todas las pruebas pasaron")
}
