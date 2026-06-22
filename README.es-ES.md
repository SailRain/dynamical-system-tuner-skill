<h1 align="center">Dynamical System Tuner</h1>

<p align="center">
  Flujo de trabajo para agentes de IA orientado a barridos de parámetros de sistemas dinámicos basados en MATLAB.
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-green.svg"></a>
  <img alt="MATLAB workflow" src="https://img.shields.io/badge/MATLAB-workflow-orange.svg">
  <img alt="AI agent skill" src="https://img.shields.io/badge/AI%20agent-skill-2563eb.svg">
  <img alt="Parameter sweep" src="https://img.shields.io/badge/parameter%20sweep-300%20default-0f766e.svg">
</p>

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.zh-CN.md">中文</a> |
  <strong>Español</strong>
</p>

---

## Descripción general

`dynamical-system-tuner` es un paquete de flujo de trabajo para agentes de programación con IA que necesitan probar, ajustar o barrer parámetros de sistemas dinámicos en MATLAB.

Está diseñado para casos en los que aún no se conocen valores de parámetros útiles y el usuario quiere evidencia de simulación organizada: gráficas de respuesta temporal, retratos de fase, archivos de imagen indexados y un registro de parámetros para comparaciones posteriores.

Este repositorio no está ligado a una sola plataforma de IA. Puede utilizarse con Codex, Claude Code, agentes de programación basados en ChatGPT o cualquier agente que pueda leer archivos del proyecto, editar scripts de MATLAB y seguir `SKILL.md`.

| Entrada | Flujo de trabajo del agente | Salida |
| --- | --- | --- |
| Ecuaciones del sistema, orden de estados, configuración de simulación, condiciones iniciales, parámetros fijos, parámetros ajustables, restricciones y reglas de descarte transitorio | Validar la información, crear o modificar un script de barrido en MATLAB, ejecutar o preparar pruebas de parámetros indexadas | `phase_*.png`, `time_response_*.png`, `parameter_log.csv` |

El archivo de instrucciones autorizado del flujo de trabajo es [`dynamical-system-tuner/SKILL.md`](dynamical-system-tuner/SKILL.md).

## Funciones

- **Flujo de trabajo listo para agentes**: instrucciones estructuradas para agentes de IA que preparan o modifican scripts de prueba de parámetros en MATLAB.
- **Ejecución centrada en MATLAB**: diseñado alrededor de scripts `.m` de MATLAB y del estilo de ejemplo del repositorio.
- **Barridos de conjuntos de parámetros**: prueba parámetros fijos y ajustables mientras preserva las restricciones explícitas del usuario.
- **Salidas de comparación visual**: genera retratos de fase y respuestas temporales para cada conjunto de parámetros.
- **Resultados trazables**: registra valores de parámetros, configuración de simulación, configuración de descarte transitorio y fallos en un log.
- **Preservación del solver**: mantiene el solver personalizado `ode45Ps` salvo que el usuario solicite explícitamente otro solver.
- **Uso flexible entre plataformas**: la carga formal del skill es opcional; los agentes también pueden tratar `SKILL.md` como una especificación de flujo de trabajo.

## Cuándo usarlo

Usa este flujo de trabajo cuando quieras que un agente de IA explore opciones de parámetros para sistemas como:

- sistemas ODE no lineales o lineales
- modelos físicos o de circuitos
- sistemas no dimensionalizados
- sistemas dinámicos puramente matemáticos

Las solicitudes típicas incluyen:

```text
Tune the parameters of this nonlinear system.
Try several parameter sets and save the phase portraits and time responses.
Modify my MATLAB script to sweep the tunable parameters.
Find usable parameters for this circuit model.
```

Este flujo de trabajo es para descubrimiento de parámetros y comparación visual. No es una prueba de optimalidad, estabilidad ni estructura de bifurcación.

## Entradas requeridas

El agente no debe inventar información científica ni información que defina la simulación. Proporciona estos elementos antes de pedirle al agente que prepare o ejecute un script de prueba de parámetros.

| Elemento requerido | Ejemplo |
| --- | --- |
| Ecuaciones del sistema o ecuaciones de estado | `dx/dt = sigma*(y - x)` |
| Orden de variables de estado | `[x, y, z]` |
| Rango de tiempo de simulación | `tspan = 0:0.002:500` |
| Tamaño de paso de simulación | `step size = 0.002` |
| Vector de condiciones iniciales | `Y0 = [1, 1, 1]` |
| Parámetros fijos y valores | `sigma = 10` |
| Parámetros ajustables | `rho`, `beta`, `R2`, `C1` |
| Descarte transitorio para respuesta temporal | `time_discard = 100` o `0` |
| Descarte transitorio para retrato de fase | `phase_discard = 100` o `0` |
| Tipo y expresión de fuente, si el modelo tiene una fuente de entrada | `v_source = A*sin(2*pi*f*t + phi)` |
| Rangos o restricciones de parámetros, si existen | `rho between 20 and 40` |

El conteo de conjuntos de parámetros es el único valor operativo predeterminado:

```text
Default parameter-set count: 300
```

Si el usuario solicita un conteo diferente, como 50, 500 o 1000, el agente sigue el conteo solicitado.

## Inicio rápido

1. Coloca este repositorio, o la carpeta `dynamical-system-tuner/`, dentro del proyecto donde el agente pueda leerlo.
2. Pide al agente que use el flujo de trabajo de [`dynamical-system-tuner/SKILL.md`](dynamical-system-tuner/SKILL.md).
3. Proporciona la definición requerida del sistema, la configuración de simulación, los parámetros fijos, los parámetros ajustables y la configuración de descarte transitorio.
4. Deja que el agente cree o modifique un script de barrido de parámetros en MATLAB basado en el estilo de [`dynamical-system-tuner/scripts/phase_example.m`](dynamical-system-tuner/scripts/phase_example.m).
5. Ejecuta el script en MATLAB o haz que el agente lo ejecute si la ejecución de MATLAB está disponible.
6. Inspecciona los retratos de fase, las respuestas temporales y `parameter_log.csv` generados.

## Prompt de ejemplo

```text
Use the dynamical-system-tuner workflow in this repository.

I want to trial parameters for this dynamical system.

System:
dx/dt = sigma*(y - x)
dy/dt = x*(rho - z) - y
dz/dt = x*y - beta*z

State order:
[x, y, z]

Simulation:
tspan = 0:0.002:500
step size = 0.002

Initial condition:
Y0 = [1, 1, 1]

Fixed parameters:
sigma = 10

Tunable parameters:
rho
beta

Parameter constraints:
rho between 20 and 40
beta between 2 and 4

Transient discard:
time-response discard = 100
phase-portrait discard = 100

Parameter-set count:
300

Output:
Create phase_sweep_1.m and save figures to sweep_1_output.
```

Si se omite `Parameter-set count`, el flujo de trabajo usa 300 conjuntos de parámetros de forma predeterminada.

## Salidas

Una ejecución típica de 300 conjuntos crea imágenes indexadas y un log CSV:

```text
sweep_1_output/
|-- phase_001.png
|-- time_response_001.png
|-- phase_002.png
|-- time_response_002.png
|-- ...
|-- phase_300.png
|-- time_response_300.png
`-- parameter_log.csv
```

Para más de 999 conjuntos de parámetros, los nombres de archivo deben usar suficientes dígitos para conservar el orden:

```text
phase_0001.png
time_response_0001.png
phase_1000.png
time_response_1000.png
```

El log de parámetros debe registrar el índice del conjunto de parámetros, los nombres de las imágenes de salida, los parámetros fijos, los valores ajustables, las condiciones iniciales, el rango de simulación, el tamaño de paso, la configuración de descarte transitorio, la expresión de fuente cuando corresponda y los casos fallidos o divergentes.

### Salida de ejemplo

![Example output images of a continuous circuit system](docs/images/result-example-1.png)

*Imágenes de salida de ejemplo de un sistema de circuito continuo. Imagen proporcionada por Chi CHEN.*

## Estructura del repositorio

```text
dynamical-system-tuner-skill/
|-- README.md
|-- README.zh-CN.md
|-- README.es-ES.md
|-- LICENSE
|-- docs/
|   `-- images/
|       `-- result-example-1.png
`-- dynamical-system-tuner/
    |-- SKILL.md
    `-- scripts/
        `-- phase_example.m
```

- `README.md` es el punto de entrada predeterminado del proyecto en inglés.
- `README.zh-CN.md` y `README.es-ES.md` son documentos de entrada traducidos.
- `dynamical-system-tuner/SKILL.md` es el archivo de instrucciones detallado para agentes de IA.
- `dynamical-system-tuner/scripts/` almacena ejemplos de MATLAB y patrones de scripts.
- `docs/images/` almacena imágenes del README.

## Reglas importantes

- El agente no debe inventar ODE, duración de simulación, tamaño de paso, condiciones iniciales, valores de parámetros fijos, expresiones de fuente, orden de variables de estado ni configuración de descarte transitorio.
- Los parámetros fijos permanecen fijos.
- Solo pueden variarse los parámetros ajustables listados explícitamente.
- El descarte transitorio de respuesta temporal y de retrato de fase debe proporcionarse por separado. Usa `0` cuando no deba descartarse ningún transitorio.
- Para sistemas físicos, especialmente sistemas de circuitos, los valores de parámetros deben mantenerse físicamente razonables salvo que el usuario solicite explícitamente lo contrario.
- Las fuentes AC deben estar completamente definidas, con las cantidades ajustables de la fuente separadas claramente, como `A`, `f` y `phi`.
- Los conjuntos de parámetros fallidos, inestables o divergentes deben registrarse en el log en lugar de descartarse silenciosamente.
- Preserva `ode45Ps` salvo que el usuario solicite explícitamente `ode45`, `ode15s` u otro solver.

## Licencia

Este proyecto está licenciado bajo la [MIT License](LICENSE).
