# Dynamical System Tuner

`dynamical-system-tuner` is a skill for trialing and tuning parameters of dynamical systems, including nonlinear systems, linear systems, ODE models, circuit models, physical models, and mathematical systems.

Its main purpose is to generate organized MATLAB simulation results under different parameter sets, especially:

- time-response plots
- 2D phase portraits
- parameter-indexed image outputs
- parameter logs for later comparison

The user inspects the generated figures to determine which parameter sets produce useful dynamical behavior.

---

## When to Use This Skill

Use this skill when you want to:

- tune parameters of a dynamical system
- trial parameter sets for a nonlinear system
- explore parameters of an ODE model
- test parameters of a circuit model
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

## Required User Inputs

Before the skill can write or run a MATLAB parameter-trial script, the user must explicitly provide the following information.

The skill must not guess these values.

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

Fixed parameters will remain unchanged during the parameter trial.

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

Only explicitly listed tunable parameters may be varied.

The skill will not assume that unmentioned parameters are tunable.

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

The time-response discard and phase-portrait discard may be the same or different.

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

For an AC source, the tunable quantities should be separated.

For example, instead of treating the whole source as one vague parameter:

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

The following information is not always required, but can help the skill produce better and more targeted parameter trials.

### Parameter Ranges

Example:

```text
R3 must be between 1 kOhm and 10 kOhm.
rho must be between 20 and 40.
```

---

### Preferred Parameter Values

Example:

```text
C1 should be around 100 nF.
f should be near 1 kHz.
```

---

### Physical Constraints

Example:

```text
Use common commercially available resistor and capacitor values.
Avoid capacitance values larger than 1 uF.
The source amplitude should not exceed 1 V.
```

---

### Target Behavior

Example:

```text
I want to find parameters that produce stable oscillation.
```

```text
I want to look for chaotic behavior.
```

```text
Avoid divergent solutions.
```

---

### Phase-Portrait Variable Pairs

By default, the skill selects representative 2D phase portraits based on the physical or mathematical meaning of the variables.

You may also specify the pairs manually.

Example:

```text
Plot phase portraits:
x-y
x-z
v-i
```

Unless explicitly requested, the skill will generate 2D phase portraits only.

---

### Output Folder

You may specify where result images should be saved.

Example:

```text
Save outputs to ./results/trial_1/
```

If no output folder is specified, the skill will create a trial output folder inside the project folder.

---

## Complete Input Example

```text
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

Output:
Create phase_sweep_1.m
Save figures to sweep_1_output
```

---

## Incomplete Input Example

This request is not enough:

```text
Tune the parameters of this nonlinear system and generate phase portraits.
```

The skill will ask the user to provide the missing required information, such as:

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

---

## Basic Workflow

### Step 1. User Provides the System

The user provides the ODE system, simulation settings, initial conditions, fixed parameters, tunable parameters, and transient-discard settings.

---

### Step 2. The Skill Checks Required Information

The skill verifies that all required information is complete.

If anything required is missing, the skill stops and asks the user to provide it.

---

### Step 3. The Skill Classifies the System

The skill determines whether the system is:

- a mathematical system
- a physical circuit system
- another physical system
- a nondimensionalized system
- unclear

This classification affects how parameter values are selected.

For physical circuit systems, component values should be physically reasonable and preferably close to commonly available values.

For mathematical or nondimensionalized systems, parameter values may be more flexible.

---

### Step 4. The Skill Separates Fixed and Tunable Parameters

Fixed parameters remain unchanged.

Only explicitly tunable parameters are varied.

If a parameter appears in the equations but is not classified as fixed or tunable, the skill asks the user to clarify.

---

### Step 5. The Skill Decides Coarse Trial or Fine Trial

The skill determines whether the task is a coarse trial or a fine trial.

Use a coarse trial when:

- the system is new
- many tunable parameters have no narrow ranges
- the user wants broad exploration

Use a fine trial when:

- promising parameter regions are already known
- previous trial results exist
- the user provides narrow ranges
- the user wants refinement around a known behavior

---

### Step 6. The Skill Prepares a MATLAB Script

The skill creates or modifies a MATLAB `.m` script.

Default naming:

```text
phase_sweep_1.m
phase_sweep_2.m
phase_sweep_3.m
```

The script follows the style of the sample scripts in `scripts/`.

By default, the skill preserves the custom solver:

```matlab
ode45Ps
```

It will not replace it with `ode45`, `ode15s`, or another solver unless the user explicitly requests that.

---

### Step 7. The Skill Runs Parameter Trials

For each parameter set, the skill generates:

- one time-response figure
- one phase-portrait figure

Each figure is annotated with the corresponding parameter values, initial conditions, and transient-discard settings.

---

### Step 8. The Skill Saves Output Files

Default output structure:

```text
sweep_1_output/
├── phase_001.png
├── time_response_001.png
├── phase_002.png
├── time_response_002.png
└── parameter_log.csv
```

Recommended image naming:

```text
phase_001.png
time_response_001.png
phase_002.png
time_response_002.png
```

The index in the image name corresponds to the parameter-set index.

---

### Step 9. The Skill Generates a Parameter Log

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

### The Skill Will Not Guess Required Values

The skill will not invent:

- ODE equations
- simulation duration
- step size
- initial conditions
- fixed parameter values
- transient-discard settings
- source type
- source expression
- state variable order

---

### Fixed Parameters Stay Fixed

If a parameter is listed as fixed, it will not be changed during trialing.

---

### Only Tunable Parameters Are Varied

A parameter must be explicitly listed as tunable before the skill can vary it.

---

### Transient Discard Must Be Explicit

The user must separately specify:

```text
time-response transient discard
phase-portrait transient discard
```

They may be identical or different.

---

### Physical Parameters Must Be Reasonable

For physical systems, especially circuit systems, the skill avoids unrealistic component values unless the user explicitly requests them.

For example, the skill should avoid obviously unreasonable values such as extremely small resistances or unrealistically large capacitances for the intended physical scale.

---

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
your-repo/
├── README.md
└── dynamical-system-tuner/
    ├── SKILL.md
    ├── scripts/
    │   └── phase_sys_4_AC.m
    ├── references/
    └── assets/
```

`README.md` is for human users.

`SKILL.md` is the actual skill instruction file.

`scripts/` stores MATLAB sample scripts or helper scripts.

`references/` stores additional documentation if needed.

`assets/` stores templates or other reusable assets if needed.

---

## Minimal Quick Start

1. Put `README.md` at the repository root.
2. Put the actual skill inside `dynamical-system-tuner/`.
3. Provide the required system information.
4. Ask the agent to prepare or modify a MATLAB parameter-trial script.
5. Inspect the generated `phase_*.png` and `time_response_*.png` files.
6. Use `parameter_log.csv` to identify useful parameter sets.

---

## Recommended First Prompt

```text
Use the dynamical-system-tuner skill.

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

Source:
[DC/AC/source expression, if applicable]

Output:
Create phase_sweep_1.m and save figures to sweep_1_output.
```
