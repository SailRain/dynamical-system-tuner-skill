# Dynamical System Tuner

`dynamical-system-tuner` is an AI-agent workflow package for trialing and tuning parameters of dynamical systems, including nonlinear systems, linear systems, ODE models, circuit models, physical models, nondimensionalized models, and purely mathematical systems.

It is not tied to a single AI platform. It can be used by Codex, Claude Code, ChatGPT-based coding agents, and other AI agents that can read project files, edit scripts, and work with MATLAB code. For platforms that support formal skill loading, use `SKILL.md` as the skill instruction file. For other agents, use `SKILL.md` as the workflow specification that the agent should follow.

The workflow is designed for MATLAB-based parameter trials. It generates organized simulation results under different parameter sets, especially:

- time-response plots
- 2D phase portraits
- parameter-indexed image outputs
- parameter logs for later comparison

The purpose is not to automatically prove optimality or stability. Instead, the workflow helps generate a large set of clearly indexed simulation results so that the user can inspect the figures and decide which parameter sets produce useful dynamical behavior.

---

## Intended AI Agents

This workflow can be used with any capable AI coding agent, including but not limited to:

- Codex
- Claude Code
- ChatGPT-based coding agents
- other local or cloud AI agents that can read files and edit MATLAB scripts

The agent should be able to:

- read `SKILL.md`
- inspect files in `scripts/`
- create or modify `.m` files
- preserve the required MATLAB coding style
- generate parameter-trial scripts
- save output figures and parameter logs

If an agent cannot directly execute MATLAB, it can still use this workflow to prepare or modify the MATLAB scripts. The user can then run the generated scripts manually in MATLAB.

---

## When to Use This Workflow

Use this workflow when you want an AI agent to:

- tune parameters of a dynamical system
- trial parameter sets for a nonlinear system
- explore parameters of an ODE model
- test parameters of a physical or circuit model
- modify a MATLAB script for parameter trials
- generate time-response plots and phase portraits
- compare different parameter sets visually
- search for oscillation, self-excitation, periodic behavior, chaotic behavior, convergence, divergence, or other dynamical phenomena

Typical user requests include:

```text
Tune the parameters of this nonlinear system.
```

```text
Try several parameter sets and save the phase portraits and time responses.
```

```text
Modify my MATLAB script to sweep the tunable parameters.
```

```text
Find usable parameters for this circuit model.
```

---

## Core Principle

The agent must not guess scientific or simulation-defining information.

Before the agent writes, modifies, or runs a MATLAB parameter-trial script, the user must explicitly provide the required system information, simulation settings, initial conditions, fixed parameters, tunable parameters, and transient-discard settings.

The only default operational value is the number of parameter sets:

```text
Default parameter-set count: 300
```

If the user does not specify how many parameter sets to run, the agent runs 300 parameter sets by default. If the user requests a different count, such as 50, 500, or 1000, the agent follows the user's requested count.

---

## Required User Inputs

The following items must be explicitly provided before the agent can prepare or run a MATLAB parameter-trial script.

### 1. System Equations

Provide the ODE system or state equations.

Accepted formats include:

- MATLAB code
- plain-text equations
- LaTeX equations
- equations in a document
- screenshots of equations
- an existing simulation script

Example:

```text
dx/dt = sigma*(y - x)
dy/dt = x*(rho - z) - y
dz/dt = x*y - beta*z
```

---

### 2. State Variable Order

Specify the order of state variables.

Example:

```text
State order: [x, y, z]
```

This order must match the initial condition vector and the MATLAB ODE implementation.

---

### 3. Simulation Time Range

Specify the simulation time range.

Example:

```matlab
tspan = 0:0.002:500;
```

---

### 4. Simulation Step Size

Specify the time step.

Example:

```text
step size = 0.002
```

---

### 5. Initial Conditions

Specify the initial condition vector.

Example:

```matlab
Y0 = [1, 1, 1];
```

The length of `Y0` must match the number of state variables.

---

### 6. Fixed Parameters

List all parameters that are already fixed and must not be changed.

Example:

```text
Fixed parameters:
sigma = 10
R1 = 10 kOhm
C2 = 100 nF
m = 0.5
```

Fixed parameters remain unchanged throughout the parameter trial.

---

### 7. Tunable Parameters

List the parameters that need to be adjusted or trialed.

Example:

```text
Tunable parameters:
rho
beta
R2
C1
A
f
```

Only explicitly listed tunable parameters may be varied. The agent will not assume that unmentioned parameters are tunable.

---

### 8. Time-Response Transient Discard

Specify how much transient data should be discarded before plotting time responses.

Example:

```text
Time-response transient discard: t < 100
```

or:

```text
time_discard = 100
```

If no transient should be discarded, explicitly write:

```text
time_discard = 0
```

---

### 9. Phase-Portrait Transient Discard

Specify how much transient data should be discarded before plotting phase portraits.

Example:

```text
Phase-portrait transient discard: t < 200
```

or:

```text
phase_discard = 200
```

If no transient should be discarded, explicitly write:

```text
phase_discard = 0
```

The time-response discard and phase-portrait discard may be identical or different.

---

### 10. Source Type and Source Expression

If the model contains an input source, especially in a physical circuit system, specify the source type and complete expression.

At minimum, specify whether the source is:

- DC
- AC
- square wave
- pulse
- piecewise-defined
- another explicit form

Examples:

```matlab
v_source = 0.5;
```

```matlab
v_source = A*sin(2*pi*f*t + phi);
```

```matlab
Iext = A*cos(omega*t);
```

For an AC source, separate the tunable quantities. For example, instead of treating the entire source as one vague parameter:

```matlab
v_source = A*sin(2*pi*f*t + phi);
```

provide:

```text
Tunable source parameters:
A
f
phi
```

---

## Optional User Inputs

The following information is optional but useful.

### Parameter Ranges

```text
R3 must be between 1 kOhm and 10 kOhm.
rho must be between 20 and 40.
```

### Preferred Parameter Values

```text
C1 should be around 100 nF.
f should be near 1 kHz.
```

### Physical Constraints

```text
Use common commercially available resistor and capacitor values.
Avoid capacitance values larger than 1 uF.
The source amplitude should not exceed 1 V.
```

### Target Behavior

```text
I want to find parameters that produce stable oscillation.
```

```text
I want to look for chaotic behavior.
```

```text
Avoid divergent solutions.
```

### Phase-Portrait Variable Pairs

By default, the agent selects representative 2D phase portraits based on the physical or mathematical meaning of the variables.

You may also specify the pairs manually.

```text
Plot phase portraits:
x-y
x-z
v-i
```

Unless explicitly requested, the agent generates 2D phase portraits only.

### Parameter-Set Count

The user may specify how many parameter sets to run.

Examples:

```text
Run 500 parameter groups.
```

```text
Run 1000 parameter groups.
```

```text
Run only 50 groups for a quick test.
```

If this item is not provided, the agent uses the default value:

```text
300 parameter sets
```

### Output Folder

You may specify where result images should be saved.

Example:

```text
Save outputs to ./results/trial_1/
```

If no output folder is specified, the agent creates a trial output folder inside the project folder.

---

## Complete Input Example

```text
Use the dynamical-system-tuner workflow.

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
Create phase_sweep_1.m
Save figures to sweep_1_output
```

If `Parameter-set count` is omitted, the agent still runs 300 parameter sets by default.

---

## Incomplete Input Example

This request is not enough:

```text
Tune the parameters of this nonlinear system and generate phase portraits.
```

The agent will ask the user to provide the missing required information, such as:

- system equations
- state variable order
- simulation time range
- step size
- initial conditions
- fixed parameters
- tunable parameters
- time-response transient discard
- phase-portrait transient discard
- source type and expression, if applicable

The agent will not ask for the parameter-set count as a required missing item. If the count is not specified, it uses 300.

---

## Basic Workflow

### Step 1. Provide the System

The user provides the ODE system, simulation settings, initial conditions, fixed parameters, tunable parameters, and transient-discard settings.

### Step 2. Validate Required Information

The agent verifies that all required information is complete. If anything required is missing, the agent stops and asks the user to provide it.

### Step 3. Classify the System

The agent determines whether the system is:

- a mathematical system
- a physical circuit system
- another physical system
- a nondimensionalized system
- unclear

This classification affects how parameter values are selected.

For physical circuit systems, component values should be physically reasonable and preferably close to commonly available values.

For mathematical or nondimensionalized systems, parameter values may be more flexible.

### Step 4. Separate Fixed and Tunable Parameters

Fixed parameters remain unchanged.

Only explicitly tunable parameters are varied.

If a parameter appears in the equations but is not classified as fixed or tunable, the agent asks the user to clarify.

### Step 5. Decide Coarse Trial or Fine Trial

The agent determines whether the task is a coarse trial or a fine trial.

Use a coarse trial when:

- the system is new
- many tunable parameters have no narrow ranges
- the user wants broad exploration

Use a fine trial when:

- promising parameter regions are already known
- previous trial results exist
- the user provides narrow ranges
- the user wants refinement around a known behavior

### Step 6. Prepare a MATLAB Script

The agent creates or modifies a MATLAB `.m` script.

Default script naming:

```text
phase_sweep_1.m
phase_sweep_2.m
phase_sweep_3.m
```

The script follows the style of the sample scripts in `scripts/`.

By default, the agent preserves the custom solver:

```matlab
ode45Ps
```

It will not replace it with `ode45`, `ode15s`, or another solver unless the user explicitly requests that.

### Step 7. Run Parameter Trials

For each parameter set, the agent generates:

- one time-response figure
- one phase-portrait figure
- one parameter-log entry

If the user does not specify the number of parameter sets, the agent runs 300 parameter sets.

If the user specifies a different number, the agent follows the user's requested number.

Each figure is annotated with the corresponding parameter values, initial conditions, simulation settings, and transient-discard settings.

### Step 8. Save Output Files

Default output structure for a 300-set run:

```text
sweep_1_output/
├── phase_001.png
├── time_response_001.png
├── phase_002.png
├── time_response_002.png
├── ...
├── phase_300.png
├── time_response_300.png
└── parameter_log.csv
```

Recommended image naming:

```text
phase_001.png
time_response_001.png
```

When the number of parameter sets exceeds 999, use enough digits to preserve filename ordering:

```text
phase_0001.png
time_response_0001.png
phase_1000.png
time_response_1000.png
```

### Step 9. Generate a Parameter Log

The output folder includes a parameter log such as:

```text
parameter_log.csv
```

The log records:

- parameter-set index
- phase image name
- time-response image name
- fixed parameters
- tunable parameter values
- initial conditions
- simulation time range
- step size
- transient-discard settings
- source expression, if applicable
- failed or divergent cases, if any

---

## Important Rules

### The Agent Will Not Guess Required Values

The agent will not invent:

- ODE equations
- simulation duration
- step size
- initial conditions
- fixed parameter values
- transient-discard settings
- source type
- source expression
- state variable order

### The Parameter-Set Count Has a Default

The number of parameter sets is not a required input.

If the user does not specify it, the agent runs:

```text
300 parameter sets
```

If the user explicitly asks for another count, the agent follows the user's requested count.

### Fixed Parameters Stay Fixed

If a parameter is listed as fixed, it will not be changed during trialing.

### Only Tunable Parameters Are Varied

A parameter must be explicitly listed as tunable before the agent can vary it.

### Transient Discard Must Be Explicit

The user must separately specify:

```text
time-response transient discard
phase-portrait transient discard
```

They may be identical or different. If no transient should be discarded, set the value to `0`.

### Physical Parameters Must Be Reasonable

For physical systems, especially circuit systems, the agent avoids unrealistic component values unless the user explicitly requests them.

For example, the agent should avoid obviously unreasonable values such as extremely small resistances or unrealistically large capacitances for the intended physical scale.

### AC Sources Must Be Fully Defined

For AC sources, specify the complete expression and separate tunable quantities.

Example:

```matlab
v_source = A*sin(2*pi*f*t + phi);
```

Tunable quantities:

```text
A
f
phi
```

---

## Folder Structure

Recommended repository structure:

```text
yourPROJfolder/
├── README.md
└── dynamical-system-tuner/
    ├── SKILL.md
    ├── scripts/
    │   └── phase_sys_4_AC.m
    ├── references/
    └── assets/
```

`README.md` is for human users and should stay at the repository root.

`SKILL.md` is the workflow instruction file. It should be placed inside the workflow package folder so that AI agents can read and follow it.

`scripts/` stores MATLAB sample scripts or helper scripts.

`references/` stores additional documentation if needed.

`assets/` stores templates or other reusable assets if needed.

Do not place a separate `README.md` inside the workflow package folder. Keep human-facing repository documentation at the repository root.

---

## Minimal Quick Start

1. Put `README.md` at the repository root.
2. Put the workflow package inside `dynamical-system-tuner/`.
3. Put the main workflow instructions in `dynamical-system-tuner/SKILL.md`.
4. Put the MATLAB sample script in `dynamical-system-tuner/scripts/`.
5. Provide the required system information.
6. Ask your AI agent to prepare or modify a MATLAB parameter-trial script.
7. Inspect the generated `phase_*.png` and `time_response_*.png` files.
8. Use `parameter_log.csv` to identify useful parameter sets.

---

## Recommended First Prompt

```text
Use the dynamical-system-tuner workflow in this repository.

I will provide a dynamical system and want to trial parameters.

System:
[write ODEs here]

State order:
[...]

Simulation:
tspan = ...
step size = ...

Initial condition:
Y0 = [...]

Fixed parameters:
[...]

Tunable parameters:
[...]

Parameter constraints:
[...]

Transient discard:
time-response discard = ...
phase-portrait discard = ...

Parameter-set count:
[optional; default is 300 if omitted]

Source:
[DC/AC/source expression, if applicable]

Output:
Create phase_sweep_1.m and save figures to sweep_1_output.
```

---

## Notes

- This workflow is designed for visual parameter trialing, not automatic theorem proving or formal bifurcation analysis.
- The user remains responsible for interpreting the dynamical behavior shown in the generated figures.
- Failed or divergent parameter sets should be logged, not silently discarded.
- The custom solver `ode45Ps` should be preserved unless the user explicitly requests another solver.
- Platform-specific skill loading is optional. The same workflow can be followed by any AI agent that can read the repository files and work with MATLAB scripts.
