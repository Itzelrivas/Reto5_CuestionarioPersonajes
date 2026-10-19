//
//  OpcionControl.swift
//  QuePersonajeEres
//
//  Vista personalizada para cada opción de respuesta (se comporta como un botón
//  y crece en altura si el texto ocupa varias líneas).
//

import UIKit

final class OpcionControl: UIControl {

    /// Estados visuales de una opción.
    enum Estado {
        case normal     // Disponible para elegir
        case elegida    // Es la respuesta que el usuario seleccionó
        case bloqueada  // Ya no se puede seleccionar (la pregunta fue respondida)
    }

    private let etiqueta = UILabel()

    var texto: String {
        get { return etiqueta.text ?? "" }
        set {
            etiqueta.text = newValue
            accessibilityLabel = newValue
        }
    }

    var estado: Estado = .normal {
        didSet { actualizarEstilo() }
    }

    override var isHighlighted: Bool {
        didSet { alpha = (isHighlighted && estado == .normal) ? 0.7 : 1.0 }
    }

    // MARK: - Inicialización

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurar()
    }

    private func configurar() {
        layer.cornerRadius = 14
        layer.borderWidth = 1.5

        etiqueta.translatesAutoresizingMaskIntoConstraints = false
        etiqueta.numberOfLines = 0
        etiqueta.font = UIFont.preferredFont(forTextStyle: .body)
        etiqueta.adjustsFontForContentSizeCategory = true
        etiqueta.isUserInteractionEnabled = false
        addSubview(etiqueta)

        NSLayoutConstraint.activate([
            etiqueta.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            etiqueta.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            etiqueta.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            etiqueta.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        ])

        isAccessibilityElement = true
        actualizarEstilo()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Los CGColor no se adaptan solos al modo claro/oscuro: se recalculan.
        actualizarEstilo()
    }

    // MARK: - Estilo

    private func actualizarEstilo() {
        let acento = UIColor.systemIndigo

        switch estado {
        case .normal:
            backgroundColor = .secondarySystemBackground
            etiqueta.textColor = .label
            layer.borderColor = acento.withAlphaComponent(0.35).resolvedColor(with: traitCollection).cgColor
            isEnabled = true
            accessibilityTraits = [.button]
        case .elegida:
            backgroundColor = acento
            etiqueta.textColor = .white
            layer.borderColor = acento.resolvedColor(with: traitCollection).cgColor
            isEnabled = false
            accessibilityTraits = [.button, .selected]
        case .bloqueada:
            backgroundColor = .secondarySystemBackground
            etiqueta.textColor = .tertiaryLabel
            layer.borderColor = UIColor.separator.resolvedColor(with: traitCollection).cgColor
            isEnabled = false
            accessibilityTraits = [.button, .notEnabled]
        }
        accessibilityLabel = etiqueta.text
    }
}
