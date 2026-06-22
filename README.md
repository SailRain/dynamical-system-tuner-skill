<h1 align="center">Dynamical System Tuner</h1>

<p align="center">
  AI-agent workflow for MATLAB-based parameter sweeps of dynamical systems.
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-green.svg"></a>
  <img alt="MATLAB workflow" src="https://img.shields.io/badge/MATLAB-workflow-orange.svg">
  <img alt="AI agent skill" src="https://img.shields.io/badge/AI%20agent-skill-2563eb.svg">
  <img alt="Parameter sweep" src="https://img.shields.io/badge/parameter%20sweep-300%20default-0f766e.svg">
</p>

<p align="center">
  <img src="docs/images/readme-banner.png" alt="Dynamical System Tuner workflow banner" width="100%">
</p>

---

## Overview

`dynamical-system-tuner` is a workflow package for AI coding agents that need to trial, tune, or sweep parameters of dynamical systems in MATLAB.

It is designed for cases where useful parameter values are not yet known and the user wants organized simulation evidence: time-response plots, phase portraits, indexed image files, and a parameter log for later comparison.

This repository is not tied to one AI platform. It can be used by Codex, Claude Code, ChatGPT-based coding agents, or any agent that can read project files, edit MATLAB scripts, and follow `SKILL.md`.

| Input | Agent workflow | Output |
| --- | --- | --- |
| System equations, state order, simulation settings, initial conditions, fixed parameters, tunable parameters, constraints, transient-discard rules | Validate the information, create or modify a MATLAB sweep script, run or prepare indexed parameter trials | `phase_*.png`, `time_response_*.png`, `parameter_log.csv` |

The authoritative workflow instruction file is [`dynamical-system-tuner/SKILL.md`](dynamical-system-tuner/SKILL.md).

## Features

- **Agent-ready workflow**: structured instructions for AI agents that prepare or modify MATLAB parameter-trial scripts.
- **MATLAB-first execution**: designed around MATLAB `.m` scripts and the repository sample style.
- **Parameter-set sweeps**: trials fixed and tunable parameters while preserving explicit user constraints.
- **Visual comparison outputs**: generates phase portraits and time responses for each parameter set.
- **Traceable results**: records parameter values, simulation settings, transient-discard settings, and failures in a log.
- **Solver preservation**: keeps the custom `ode45Ps` solver unless the user explicitly asks for another solver.
- **Platform-flexible use**: formal skill loading is optional; agents can also treat `SKILL.md` as a workflow specification.

## When to Use

Use this workflow when you want an AI agent to explore parameter choices for systems such as:

- nonlinear or linear ODE systems
- physical or circuit models
- nondimensionalized systems
- purely mathematical dynamical systems

Typical requests include:

```text
Tune the parameters of this nonlinear system.
Try several parameter sets and save the phase portraits and time responses.
Modify my MATLAB script to sweep the tunable parameters.
Find usable parameters for this circuit model.
```

This workflow is for parameter discovery and visual comparison. It is not a proof of optimality, stability, or bifurcation structure.

## Required Inputs

The agent must not guess scientific or simulation-defining information. Provide these items before asking the agent to prepare or run a parameter-trial script.

| Required item | Example |
| --- | --- |
| System equations or state equations | `dx/dt = sigma*(y - x)` |
| State variable order | `[x, y, z]` |
| Simulation time range | `tspan = 0:0.002:500` |
| Simulation step size | `step size = 0.002` |
| Initial condition vector | `Y0 = [1, 1, 1]` |
| Fixed parameters and values | `sigma = 10` |
| Tunable parameters | `rho`, `beta`, `R2`, `C1` |
| Time-response transient discard | `time_discard = 100` or `0` |
| Phase-portrait transient discard | `phase_discard = 100` or `0` |
| Source type and expression, if the model has an input source | `v_source = A*sin(2*pi*f*t + phi)` |
| Parameter ranges or constraints, if any | `rho between 20 and 40` |

The parameter-set count is the only operational default:

```text
Default parameter-set count: 300
```

If the user requests a different count, such as 50, 500, or 1000, the agent follows that requested count.

## Quick Start

1. Put this repository, or the `dynamical-system-tuner/` folder, inside the project where your agent can read it.
2. Ask the agent to use the workflow in [`dynamical-system-tuner/SKILL.md`](dynamical-system-tuner/SKILL.md).
3. Provide the required system definition, simulation settings, fixed parameters, tunable parameters, and transient-discard settings.
4. Let the agent create or modify a MATLAB parameter-sweep script based on the style in [`dynamical-system-tuner/scripts/phase_example.m`](dynamical-system-tuner/scripts/phase_example.m).
5. Run the script in MATLAB, or have the agent run it if MATLAB execution is available.
6. Inspect the generated phase portraits, time responses, and `parameter_log.csv`.

## Example Prompt

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

If `Parameter-set count` is omitted, the workflow uses 300 parameter sets by default.

## Outputs

A typical 300-set run creates indexed images and a CSV log:

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

For more than 999 parameter sets, filenames should use enough digits to preserve sorting:

```text
phase_0001.png
time_response_0001.png
phase_1000.png
time_response_1000.png
```

The parameter log should record the parameter-set index, output image names, fixed parameters, tunable values, initial conditions, simulation range, step size, transient-discard settings, source expression when applicable, and failed or divergent cases.

### Example Output

![Example output images of a continuous circuit system](docs/images/result-example-1.png)

*Example output images of a continuous circuit system. Image provided by Chi CHEN.*

## Repository Structure

```text
dynamical-system-tuner-skill/
|-- README.md
|-- LICENSE
|-- docs/
|   `-- images/
|       |-- readme-banner.png
|       `-- result-example-1.png
`-- dynamical-system-tuner/
    |-- SKILL.md
    `-- scripts/
        `-- phase_example.m
```

- `README.md` is the human-facing project entry point.
- `dynamical-system-tuner/SKILL.md` is the detailed instruction file for AI agents.
- `dynamical-system-tuner/scripts/` stores MATLAB examples and script patterns.
- `docs/images/` stores README images.

## Important Rules

- The agent must not invent ODEs, simulation duration, step size, initial conditions, fixed parameter values, source expressions, state variable order, or transient-discard settings.
- Fixed parameters stay fixed.
- Only explicitly listed tunable parameters may be varied.
- Time-response and phase-portrait transient discard must be provided separately. Use `0` when no transient should be discarded.
- For physical systems, especially circuit systems, parameter values should remain physically reasonable unless the user explicitly asks otherwise.
- AC sources must be fully defined, with tunable source quantities separated clearly, such as `A`, `f`, and `phi`.
- Failed, unstable, or divergent parameter sets should be logged instead of silently discarded.
- Preserve `ode45Ps` unless the user explicitly requests `ode45`, `ode15s`, or another solver.

## License

This project is licensed under the [MIT License](LICENSE).
