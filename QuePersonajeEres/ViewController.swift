//
//  ViewController.swift
//  QuePersonajeEres
//
//  Pantalla única de la app «¿Qué personaje eres?».
//
//  Funcionamiento:
//   1. Se muestran 5 preguntas, una a la vez, cada una con una lista de opciones.
//   2. El usuario elige UNA opción; al elegirla las demás se bloquean y ya no puede cambiarla.
//   3. Con «Siguiente pregunta» avanza. Al responder la 5.ª pregunta el cuestionario se cierra
//      y se muestra el personaje obtenido con una breve descripción.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Datos

    private var cuestionario = Cuestionario()

    /// Controles de opción que se están mostrando (Array).
    private var controlesOpcion: [OpcionControl] = []

    /// Opciones de la pregunta actual, en el orden (aleatorio) en que se muestran (Array).
    private var opcionesMostradas: [Opcion] = []

    // MARK: - Vistas

    private let scrollView = UIScrollView()
    private let pilaRaiz = UIStackView()

    // Cuestionario
    private let grupoCuestionario = UIStackView()
    private let etiquetaTitulo = UILabel()
    private let etiquetaProgreso = UILabel()
    private let barraProgreso = UIProgressView(progressViewStyle: .bar)
    private let etiquetaPregunta = UILabel()
    private let pilaOpciones = UIStackView()
    private let botonSiguiente = UIButton(type: .system)

    // Resultado
    private let grupoResultado = UIStackView()
    private let etiquetaEmoji = UILabel()
    private let etiquetaEres = UILabel()
    private let etiquetaNombre = UILabel()
    private let etiquetaDescripcion = UILabel()
    private let etiquetaCoincidencias = UILabel()
    private let botonReiniciar = UIButton(type: .system)

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        construirInterfaz()
        mostrarPreguntaActual()
    }

    // MARK: - Construcción de la interfaz

    private func construirInterfaz() {
        // --- Cuestionario ---
        etiquetaTitulo.text = "¿Qué personaje eres?"
        etiquetaTitulo.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 30, weight: .heavy))
        etiquetaTitulo.textAlignment = .center
        etiquetaTitulo.numberOfLines = 0
        etiquetaTitulo.adjustsFontForContentSizeCategory = true
        etiquetaTitulo.accessibilityTraits = .header

        etiquetaProgreso.font = UIFont.preferredFont(forTextStyle: .subheadline)
        etiquetaProgreso.textColor = .secondaryLabel
        etiquetaProgreso.textAlignment = .center
        etiquetaProgreso.adjustsFontForContentSizeCategory = true

        barraProgreso.progressTintColor = .systemIndigo
        barraProgreso.trackTintColor = .systemGray5

        etiquetaPregunta.font = UIFontMetrics(forTextStyle: .title3)
            .scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .semibold))
        etiquetaPregunta.numberOfLines = 0
        etiquetaPregunta.adjustsFontForContentSizeCategory = true

        pilaOpciones.axis = .vertical
        pilaOpciones.spacing = 12

        configurarBotonPrincipal(botonSiguiente)
        botonSiguiente.addTarget(self, action: #selector(siguienteTocado), for: .touchUpInside)

        grupoCuestionario.axis = .vertical
        grupoCuestionario.spacing = 16
        let vistasCuestionario: [UIView] = [etiquetaTitulo, etiquetaProgreso, barraProgreso,
                                            etiquetaPregunta, pilaOpciones, botonSiguiente]
        for vista in vistasCuestionario {
            grupoCuestionario.addArrangedSubview(vista)
        }
        grupoCuestionario.setCustomSpacing(24, after: etiquetaTitulo)
        grupoCuestionario.setCustomSpacing(24, after: barraProgreso)
        grupoCuestionario.setCustomSpacing(24, after: pilaOpciones)

        // --- Resultado ---
        etiquetaEmoji.font = UIFont.systemFont(ofSize: 96)
        etiquetaEmoji.textAlignment = .center
        etiquetaEmoji.isAccessibilityElement = false

        etiquetaEres.text = "¡Tu personaje es…"
        etiquetaEres.font = UIFont.preferredFont(forTextStyle: .title3)
        etiquetaEres.textColor = .secondaryLabel
        etiquetaEres.textAlignment = .center
        etiquetaEres.adjustsFontForContentSizeCategory = true

        etiquetaNombre.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: UIFont.systemFont(ofSize: 34, weight: .heavy))
        etiquetaNombre.textColor = .systemIndigo
        etiquetaNombre.textAlignment = .center
        etiquetaNombre.numberOfLines = 0
        etiquetaNombre.adjustsFontForContentSizeCategory = true

        etiquetaDescripcion.font = UIFont.preferredFont(forTextStyle: .body)
        etiquetaDescripcion.textAlignment = .center
        etiquetaDescripcion.numberOfLines = 0
        etiquetaDescripcion.adjustsFontForContentSizeCategory = true

        etiquetaCoincidencias.font = UIFont.preferredFont(forTextStyle: .footnote)
        etiquetaCoincidencias.textColor = .secondaryLabel
        etiquetaCoincidencias.textAlignment = .center
        etiquetaCoincidencias.adjustsFontForContentSizeCategory = true

        configurarBotonPrincipal(botonReiniciar)
        botonReiniciar.setTitle("Volver a empezar", for: .normal)
        botonReiniciar.addTarget(self, action: #selector(reiniciarTocado), for: .touchUpInside)

        grupoResultado.axis = .vertical
        grupoResultado.spacing = 12
        grupoResultado.isHidden = true
        let vistasResultado: [UIView] = [etiquetaEmoji, etiquetaEres, etiquetaNombre,
                                         etiquetaDescripcion, etiquetaCoincidencias, botonReiniciar]
        for vista in vistasResultado {
            grupoResultado.addArrangedSubview(vista)
        }
        grupoResultado.setCustomSpacing(20, after: etiquetaNombre)
        grupoResultado.setCustomSpacing(24, after: etiquetaCoincidencias)

        // --- Contenedor con scroll ---
        pilaRaiz.axis = .vertical
        pilaRaiz.addArrangedSubview(grupoCuestionario)
        pilaRaiz.addArrangedSubview(grupoResultado)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pilaRaiz.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(pilaRaiz)

        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guia.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guia.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pilaRaiz.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            pilaRaiz.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            pilaRaiz.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            pilaRaiz.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            pilaRaiz.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48)
        ])
    }

    /// Estilo común de los botones grandes («Siguiente» y «Volver a empezar»).
    private func configurarBotonPrincipal(_ boton: UIButton) {
        boton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        boton.layer.cornerRadius = 14
        boton.setTitleColor(.white, for: .normal)
        boton.setTitleColor(.secondaryLabel, for: .disabled)
        boton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        actualizarEstilo(de: boton)
    }

    private func actualizarEstilo(de boton: UIButton) {
        boton.backgroundColor = boton.isEnabled ? .systemIndigo : .systemGray5
    }

    // MARK: - Flujo del cuestionario

    /// Muestra la pregunta actual con sus opciones en orden aleatorio.
    private func mostrarPreguntaActual() {
        guard let pregunta = cuestionario.preguntaActual else {
            mostrarResultado()
            return
        }

        grupoResultado.isHidden = true
        grupoCuestionario.isHidden = false

        let numero = cuestionario.indiceActual + 1
        let total = cuestionario.totalPreguntas
        etiquetaProgreso.text = "Pregunta \(numero) de \(total)"
        barraProgreso.progress = Float(cuestionario.indiceActual) / Float(total)
        etiquetaPregunta.text = pregunta.texto

        // Se vacía la lista anterior y se crea un control por cada opción.
        for control in controlesOpcion {
            control.removeFromSuperview()
        }
        controlesOpcion.removeAll()

        opcionesMostradas = pregunta.opciones.shuffled()
        for (indice, opcion) in opcionesMostradas.enumerated() {
            let control = OpcionControl()
            control.texto = opcion.texto
            control.tag = indice
            control.addTarget(self, action: #selector(opcionTocada(_:)), for: .touchUpInside)
            pilaOpciones.addArrangedSubview(control)
            controlesOpcion.append(control)
        }

        botonSiguiente.isEnabled = false
        botonSiguiente.setTitle(cuestionario.esUltimaPregunta ? "Ver resultado" : "Siguiente pregunta", for: .normal)
        botonSiguiente.setTitle(cuestionario.esUltimaPregunta ? "Ver resultado" : "Siguiente pregunta", for: .disabled)
        actualizarEstilo(de: botonSiguiente)
        scrollView.setContentOffset(.zero, animated: false)
        UIAccessibility.post(notification: .screenChanged, argument: etiquetaPregunta)
    }

    /// Muestra el personaje obtenido y cierra el cuestionario.
    private func mostrarResultado() {
        let personaje = cuestionario.calcularResultado()
        let aciertos = cuestionario.coincidencias(con: personaje)

        etiquetaEmoji.text = personaje.emoji
        etiquetaNombre.text = personaje.nombre
        etiquetaDescripcion.text = personaje.descripcion
        etiquetaCoincidencias.text = "Coincidiste en \(aciertos) de \(cuestionario.totalPreguntas) respuestas"

        grupoCuestionario.isHidden = true
        grupoResultado.isHidden = false
        scrollView.setContentOffset(.zero, animated: false)
        UIAccessibility.post(notification: .screenChanged, argument: etiquetaNombre)
    }

    // MARK: - Acciones

    @objc private func opcionTocada(_ sender: OpcionControl) {
        // Validación: el índice debe ser válido y la pregunta no puede estar respondida.
        guard sender.tag >= 0 && sender.tag < opcionesMostradas.count else { return }
        guard cuestionario.responder(opcionesMostradas[sender.tag]) else { return }

        // La elegida se resalta y las demás se bloquean: no se puede cambiar la respuesta.
        for control in controlesOpcion {
            control.estado = (control === sender) ? .elegida : .bloqueada
        }

        botonSiguiente.isEnabled = true
        actualizarEstilo(de: botonSiguiente)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @objc private func siguienteTocado() {
        cuestionario.avanzar()
        transicionar {
            if self.cuestionario.haTerminado {
                self.mostrarResultado()
            } else {
                self.mostrarPreguntaActual()
            }
        }
    }

    @objc private func reiniciarTocado() {
        cuestionario = Cuestionario()
        transicionar {
            self.mostrarPreguntaActual()
        }
    }

    /// Cambio de pantalla con un suave fundido.
    private func transicionar(_ cambios: @escaping () -> Void) {
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: cambios)
    }
}
