# ¿Qué personaje eres? – App iOS en Swift

Cuestionario de 5 preguntas que indica qué personaje (de la saga de Harry Potter) eres según tus respuestas.

## Funcionamiento

1. La app muestra **cinco preguntas**, una a la vez, cada una con una **lista de opciones** en pantalla.
2. El usuario elige **una sola respuesta por pregunta**. Al elegirla, las demás opciones se bloquean: **no se puede cambiar**.
3. Con el botón «Siguiente pregunta» avanza; los botones se habilitan solo después de responder.
4. Al responder la **pregunta 5** el cuestionario se cierra y se muestra **qué personaje eres** con una breve descripción.
5. Opcionalmente puede volver a empezar con «Volver a empezar».

El orden de las opciones cambia cada vez (es aleatorio), para que la posición de la respuesta no delate el resultado.

## Cómo se calcula el resultado

Cada opción suma un punto a un personaje. Al terminar se cuenta cuántos puntos tiene cada uno y gana el que más tiene.
Si hay empate, gana el personaje de la respuesta más reciente entre los empatados.

## Requisitos

- macOS con **Xcode 14 o superior**.
- Objetivo mínimo: **iOS 13.0** (iPhone).
- Lenguaje: **Swift 5**.

## Cómo abrirlo y ejecutarlo

1. Abre `QuePersonajeEres.xcodeproj` con Xcode.
2. Elige un simulador de iPhone en la barra superior.
3. Presiona **▶ Run** (⌘R).

## Estructura del proyecto

```
QuePersonajeEres/
├── QuePersonajeEres.xcodeproj
├── QuePersonajeEres/
│   ├── AppDelegate.swift       Punto de entrada; crea la ventana
│   ├── ViewController.swift    Pantalla: interfaz y flujo del cuestionario
│   ├── OpcionControl.swift     Vista personalizada de cada opción de respuesta
│   ├── Cuestionario.swift      Lógica: preguntas, respuestas, resultado
│   ├── Personaje.swift         Modelo: personajes, opciones y preguntas
│   ├── Info.plist
│   └── Assets.xcassets         Ícono y color de acento
├── Pruebas/main.swift          Pruebas automáticas de la lógica (no forman parte de la app)
└── .github/workflows/          Compilación y pruebas automáticas en GitHub
```

## Operadores, estructuras y colecciones utilizados

Consulta el archivo `Justificacion_Reto5.pdf` incluido en la entrega.

## Pruebas de la lógica

En una Mac, desde la carpeta del proyecto:

```
swiftc -swift-version 5 -o /tmp/pruebas QuePersonajeEres/Personaje.swift QuePersonajeEres/Cuestionario.swift Pruebas/main.swift && /tmp/pruebas
```
