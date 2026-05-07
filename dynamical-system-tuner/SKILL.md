---
name: dynamical-system-tuner
description: Tunes and trials parameters for dynamical systems, including nonlinear systems, ODE models, circuit models, physical models, and mathematical systems. Use when the user asks to tune, trial, sweep, explore, adjust, or test parameters of a dynamical system, nonlinear system, ODE system, state-space model, chaos model, oscillator, or circuit model, especially when generating MATLAB simulations, time-response plots, and phase portraits.
metadata:
  version: 1.0.0
  category: dynamical-systems
---

# Dynamical System Tuner

## Purpose

This skill helps tune or trial parameters for dynamical systems, including nonlinear systems, linear systems, physical circuit models, nondimensionalized models, and purely mathematical ODE systems.

The main goal is not to directly optimize a scalar objective function. The main goal is to generate organized simulation results under different parameter sets, including:

- time-response plots
- phase-portrait plots
- parameter-indexed output images
- parameter logs for later comparison

The user will inspect these results to determine which parameter sets produce useful dynamical phenomena or behaviors.

This skill must follow the user's provided system equations, simulation settings, initial conditions, fixed parameters, tunable parameters, parameter constraints, and transient-discard requirements. It must not invent required information.

---

# Core Workflow

## Step 1. Trigger

Use this skill when the user asks to tune, trial, sweep, explore, test, or adjust parameters of a dynamical system.

Relevant user phrases may include:

- tune parameters of this dynamical system
- adjust parameters of this nonlinear system
- sweep parameters
- trial parameter sets
- test different parameters
- find usable parameters
- generate time responses and phase portraits
- tune this ODE model
- tune this circuit model
- explore parameters for chaos, oscillation, bifurcation, convergence, divergence, or self-excitation

The system may be given as:

- MATLAB code
- Python code
- plain-text ODEs
- LaTeX equations
- equations inside a document
- screenshots of equations
- circuit-derived state equations
- a pre-existing simulation script

---

## Step 2. Required Input Validation

Before writing, editing, or running any simulation code, verify that the user has explicitly provided all required information.

Do not guess missing required values.

The user must explicitly provide:

1. the ODE system or state equations
2. the state variable order
3. the simulation time range
4. the simulation step size
5. the initial condition vector
6. fixed parameters and their values, if any
7. tunable parameters
8. time-response transient-discard setting
9. phase-portrait transient-discard setting
10. source type and complete source expression, if the system contains an input source
11. parameter constraints or ranges, if any

If any required item is missing, stop and ask the user to provide the missing information.

Do not proceed by assigning default values.

---

## Critical Rule: No Unprovided Required Values

The agent must not invent, infer, assume, or silently choose any required simulation setting.

This prohibition applies especially to:

- simulation duration
- simulation step size
- initial conditions
- fixed parameter values
- whether a source is AC or DC
- source expression
- transient-discard values
- state variable order

If the user does not want to discard transient data, they must explicitly set the relevant transient-discard value to `0`.

Do not automatically choose values such as:

- 20 percent of the simulation
- the first 1000 time units
- the first 100000 samples
- any other inferred transient length

---

## Step 3. Read and Interpret the System

When the user provides or points to a file, read the file and extract:

- state equations
- state variables
- parameter names
- existing parameter values
- simulation settings
- initial conditions
- source expressions
- plotting structure
- solver usage
- output folder settings, if any

If the user provides equations in formula form, LaTeX, document text, or screenshots, convert the equations into MATLAB ODE code carefully and faithfully.

When writing MATLAB ODE code, follow the programming style of the sample scripts in `scripts/`.

In particular:

- write the main simulation script at the top
- define parameter sets clearly
- define the ODE system in the same `.m` file unless the user's existing structure requires otherwise
- keep the code readable and explicit
- keep parameter annotations available for figure titles or text labels
- preserve the user's naming conventions when reasonable

---

## Step 4. Parameter Name Consistency Check

Check that all parameter names are consistent across:

- system equations
- fixed parameter list
- tunable parameter list
- user-specified ranges
- source expressions
- existing MATLAB code

If the user lists a fixed or tunable parameter that does not appear in the system, report the mismatch and ask for clarification.

If the system contains a parameter that is neither fixed nor listed as tunable, report the missing classification and ask the user to classify it.

Fixed parameters must remain fixed throughout the parameter trial process.

Only parameters explicitly listed as tunable may be varied.

---

## Step 5. System Type Classification

Classify the system before choosing parameter trial values.

Use one of the following categories:

1. mathematical system
2. physical circuit system
3. other physical system
4. nondimensionalized system
5. unclear system type

Examples:

- Lorenz, Rössler, Chen, and similar abstract ODE systems are mathematical systems.
- Chua circuits, memristor circuits, Josephson-junction circuits, and oscillator circuits are physical circuit systems unless explicitly nondimensionalized.
- A compact ODE model derived from a physical circuit but using dimensionless parameters is a nondimensionalized system.

If the system type is unclear and this affects parameter choice, ask the user for clarification.

---

## Step 6. Rules for Mathematical Systems

For mathematical systems, parameter values may have relatively high freedom.

It is acceptable for parameters to be non-integer or not directly realizable as physical components.

For example, values similar to the following may be acceptable in mathematical systems:

```matlab
sigma = 10;
rho = 28;
beta = 8/3;
```

However, the agent must still obey:

- user-specified fixed parameters
- user-specified tunable parameters
- user-specified ranges
- user-specified constraints
- user-specified simulation settings
- user-specified initial conditions
- user-specified transient-discard settings

---

## Step 7. Rules for Physical Circuit Systems

For physical circuit systems, parameter values must be physically reasonable unless the user explicitly states otherwise.

Check the reasonableness of:

- resistors
- capacitors
- inductors
- voltage sources
- current sources
- frequencies
- angular frequencies
- device constants
- coupling coefficients
- memristor parameters
- source amplitudes
- duty cycles
- component units

Avoid obviously unreasonable values for microelectronics or circuit simulation unless the user explicitly requires them.

Examples of problematic physical values:

- resistance values that are unrealistically small for the intended circuit
- capacitance values that are unrealistically large
- highly unusual component values that are not commonly available
- source amplitudes that are inconsistent with the circuit scale
- frequencies that are inconsistent with the intended physical model

When possible, choose physical component values that are reasonable and commonly available.

For example, prefer common component values such as:

```text
1 kOhm, 2.2 kOhm, 4.7 kOhm, 10 kOhm
10 nF, 47 nF, 100 nF, 220 nF
1 uH, 10 uH, 100 uH, 1 mH
```

Do not force market-available component constraints onto nondimensionalized systems.

If the user states that the system is nondimensionalized, treat the parameters as mathematical or normalized quantities rather than physical component values.

---

## Step 8. Source Handling Rules

If the system contains a source, the user must specify the source type.

At minimum, the user must specify whether the source is:

- DC
- AC
- square wave
- pulse
- piecewise-defined
- another explicit form

The user must provide the complete source expression.

Examples:

```matlab
v = 0.5;
```

```matlab
v = 0.5*cos(200*t);
```

```matlab
v = A*sin(2*pi*f*t + phi);
```

If a source is tunable, decompose it into separate tunable quantities.

For example, do not treat this as one vague parameter:

```matlab
v_source = A*sin(2*pi*f*t + phi);
```

Instead, separate the tunable quantities:

```matlab
A
f
phi
```

Respect the distinction between frequency and angular frequency.

If the source is written as:

```matlab
sin(2*pi*f*t + phi)
```

then `f` is frequency in Hz.

If the source is written as:

```matlab
sin(omega*t + phi)
```

then `omega` is angular frequency in rad/s.

If the existing sample code uses a form such as:

```matlab
Iext = A*cos(F*t);
```

then `F` should be treated as an angular frequency unless the user defines it otherwise.

---

## Step 9. Constraint Extraction

Extract all user-specified parameter requirements.

These may include:

- fixed values
- allowed ranges
- preferred ranges
- excluded ranges
- component availability constraints
- unit constraints
- physical reasonableness constraints
- source waveform constraints
- domain constraints

Examples:

```text
R3 must be between 1 kOhm and 10 kOhm.
C1 should be around 100 nF.
Duty cycle must be between 0 and 1.
A should not exceed 1 V.
f must stay below 10 kHz.
```

All generated parameter sets must obey these constraints.

If a parameter has a natural domain, enforce it.

Examples:

- duty cycle must be in `[0, 1]`
- capacitance must be positive
- resistance must be positive
- inductance must be positive
- frequency must be nonnegative
- physical source amplitude should be reasonable for the system scale

If a user-specified range conflicts with physical reasonableness, report the conflict before proceeding.

---

## Step 10. Determine Coarse Trial or Fine Trial

Determine whether the current parameter trial is a coarse trial or a fine trial.

Use a coarse trial when:

- the system is new
- many tunable parameters have no narrow ranges
- the user has not yet identified promising regions
- the user wants broad exploration
- previous usable parameter sets are not available

Use a fine trial when:

- the user has already performed earlier trials
- the user has provided narrow parameter ranges
- the user has identified promising parameter sets
- the user wants to refine around a known behavior
- the user asks for a smaller or more targeted trial

This skill performs trial parameter selection rather than strict grid optimization.

The agent does not need to use a fixed step size or exhaustive grid unless the user explicitly requests it.

The agent should generate a manageable number of candidate parameter sets that are meaningfully different and useful for visual inspection.

---

## Step 11. MATLAB Script Preparation

After all required information is complete, prepare a MATLAB script.

If the user has already provided a script and asks to modify it, modify that script.

If the user has not provided or specified a script location, create a new `.m` script in the project folder.

Use the naming rule:

```text
phase_sweep_x.m
```

where `x` indicates the sweep or trial number in the current context.

Examples:

```text
phase_sweep_1.m
phase_sweep_2.m
phase_sweep_3.m
```

At the top of the script, add a comment identifying the trial number.

Example:

```matlab
% phase_sweep_1.m
% First parameter trial for the current dynamical system.
```

Follow the style of the sample MATLAB scripts in `scripts/`.

The sample script style includes:

- explicit parameter definitions
- explicit simulation settings
- explicit initial conditions
- use of `ode45Ps`
- plotting time responses
- plotting phase portraits
- annotating figures with parameter and initial-condition information
- saving figures to an output folder

---

## Step 12. Solver Rule

Use the custom solver `ode45Ps` if the sample script uses it.

Do not replace `ode45Ps` with MATLAB built-in `ode45`, `ode15s`, or another solver unless the user explicitly requests it.

If the simulation produces numerical failure, such as:

- NaN
- Inf
- obvious divergence
- solver failure
- step-size instability
- meaningless numerical output

then report the issue.

Do not silently change the solver.

Suggest possible remedies only as suggestions, such as:

- allow changing the solver
- reduce the step size
- shorten or lengthen simulation time
- rescale variables
- revise parameter ranges
- check the ODE equations

---

## Step 13. Parameter Set Structure

Prefer storing all trial parameter sets in one script using a clear structure.

For example:

```matlab
param_sets(1) = struct(...);
param_sets(2) = struct(...);
param_sets(3) = struct(...);
```

Each parameter set should correspond to one simulation run and one pair of output images:

- one phase-portrait image
- one time-response image

The image index must match the parameter-set index.

Fixed parameters must be included or referenced clearly, but they must not vary across parameter sets.

Tunable parameters should vary according to the trial plan.

---

## Step 14. Dimension-Adaptive Plotting

Adapt the plotting code to the dimension of the user's system.

For an `n`-dimensional system:

1. Plot all time responses in one figure.
2. Use `n` vertical subplots for the time-response figure.
3. Plot selected 2D phase portraits in one figure.
4. Do not generate 3D phase portraits unless the user explicitly requests them.
5. Do not plot every possible 2D phase combination for high-dimensional systems unless the user explicitly requests that.

The time-response plot should include all state variables, arranged from top to bottom according to the state variable order.

The phase-portrait figure should include physically or structurally meaningful 2D combinations.

If the user specifies phase-portrait variable pairs, use the user's choices.

If the user does not specify phase-portrait variable pairs, select representative pairs based on:

- physical meaning
- variable coupling
- voltage-current relationships
- flux-charge relationships
- state-variable relationships
- similarity to the sample script
- interpretability

Add comments in the script explaining the selected phase-portrait pairs.

---

## Step 15. Transient-Discard Rules

The user must explicitly provide two transient-discard settings:

1. transient discard for time-response plots
2. transient discard for phase-portrait plots

These two values may be identical or different.

If the user wants no transient removal, they must explicitly set the relevant value to `0`.

Prefer time-based transient discard rather than index-based transient discard.

Example:

```matlab
time_discard = 1000;
phase_discard = 2000;
```

Meaning:

```text
For time-response plots, plot only data with t >= 1000.
For phase-portrait plots, plot only data with t >= 2000.
```

In MATLAB, use a robust time-based index method such as:

```matlab
idx_time = find(t >= time_discard, 1, 'first');
idx_phase = find(t >= phase_discard, 1, 'first');

if isempty(idx_time)
    error('time_discard is larger than or equal to the simulation end time.');
end

if isempty(idx_phase)
    error('phase_discard is larger than or equal to the simulation end time.');
end
```

Then use:

```matlab
plot(t(idx_time:end), y(idx_time:end, i));
```

for time responses, and use:

```matlab
plot(y(idx_phase:end, a), y(idx_phase:end, b));
```

for phase portraits.

Do not use hard-coded discard indices such as:

```matlab
y(1e5:end, :)
```

unless the user explicitly requests index-based transient discard.

---

## Step 16. Figure Annotation Rules

Every generated figure must clearly show which parameter set produced it.

Each time-response figure and each phase-portrait figure should include:

- parameter set index
- tunable parameter values
- fixed parameter values, if practical
- initial conditions
- simulation time range
- transient-discard setting
- source expression, if relevant

This is required because the user will inspect saved images later.

The image itself must contain enough parameter information for the user to identify the corresponding simulation without opening the MATLAB script.

When the annotation becomes too long for the title, use one or more of:

- subtitle
- text annotation
- `sgtitle`
- textbox annotation
- compact parameter string

---

## Step 17. Output Folder Rules

If the user specifies an output folder, save all generated result images there.

If the user does not specify an output folder, create a new output folder inside the project folder.

Use one of the following naming styles:

```text
sweep_1_output
sweep_2_output
sweep_3_output
```

or:

```text
trial_1_output
trial_2_output
trial_3_output
```

Use the same numbering as the script when possible.

Do not create additional nested subfolders inside the output folder unless the user explicitly requests it.

All output images for the same trial should be stored directly in the same output folder.

---

## Step 18. Image Naming Rules

Use clear, ordered, machine-readable image names.

Preferred names:

```text
phase_001.png
time_response_001.png
phase_002.png
time_response_002.png
phase_003.png
time_response_003.png
```

Avoid spaces in file names.

Do not use names such as:

```text
phase 001.png
time responds 001.png
```

Use `time_response`, not `time_responds`.

The numeric index must correspond to the parameter set index.

---

## Step 19. Parameter Log

For every parameter trial, generate a parameter log file in the output folder.

Preferred file names:

```text
parameter_log.csv
```

or:

```text
parameter_log.txt
```

The parameter log should map each image to its parameter set.

The log should include:

- index
- phase image name
- time-response image name
- fixed parameters
- tunable parameters
- initial conditions
- simulation time range
- simulation step size
- time-response transient discard
- phase-portrait transient discard
- source expression, if relevant
- notes about failed or divergent simulations, if any

The user should be able to identify and reproduce a parameter set from the log file.

---

## Step 20. Running Parameter Trials

For each candidate parameter set:

1. insert the parameter values into the script structure
2. run the ODE simulation
3. generate the time-response figure
4. generate the phase-portrait figure
5. annotate both figures with parameter information
6. save both figures using ordered file names
7. append the result to the parameter log

If a simulation fails, record the failure in the log.

Do not delete failed cases silently.

If a simulation diverges or produces meaningless output, save the result only if useful for diagnosis. Otherwise, log the failure and explain it in the final summary.

---

## Step 21. Final Response to User

After preparing or running the trial, report concisely:

- which script was created or modified
- which parameters were fixed
- which parameters were varied
- whether the trial was coarse or fine
- how many parameter sets were tested
- where the output images were saved
- where the parameter log was saved
- whether any cases failed or diverged

If required information was missing, do not provide trial results. Instead, list exactly what information is missing.

---

# Required Missing-Information Response Format

If the user has not provided all required information, respond with a clear checklist.

Use this structure:

```text
I cannot start the parameter trial yet because the required information is incomplete.

Missing items:
1. ...
2. ...
3. ...

Please provide these items. After that, I can prepare the MATLAB sweep script.
```

Do not ask for unnecessary information.

Only ask for missing information that is required by this skill or needed to resolve a concrete ambiguity.

---

# MATLAB Style Requirements

When generating MATLAB code, follow these style requirements unless the user explicitly asks otherwise:

1. Use `.m` scripts.
2. Keep the main script and local functions in the same file when practical.
3. Use `ode45Ps` by default if this is the sample-script convention.
4. Do not replace the user's solver without permission.
5. Use explicit parameter structures or explicit parameter variables.
6. Use clear state variable ordering.
7. Use time-based transient-discard indexing.
8. Save all result figures automatically.
9. Generate a parameter log.
10. Annotate figures with parameter values and initial conditions.
11. Keep time-response plots in one figure.
12. Keep phase portraits in one figure.
13. Use 2D phase portraits unless the user requests 3D plots.
14. Avoid hard-coded array indices for transient removal.
15. Preserve the style of the sample scripts in `scripts/`.

---

# Example: Complete Required Input

A complete request may look like this:

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
rho, beta

Parameter constraints:
rho between 20 and 40
beta between 2 and 4

Transient discard:
time-response discard = 100
phase-portrait discard = 100

Output:
Create phase_sweep_1.m and save figures to sweep_1_output.
```

This input is complete enough to prepare the trial script.

---

# Example: Incomplete Input

If the user says:

```text
Tune the parameters of this nonlinear system and generate phase portraits.
```

but does not provide equations, simulation settings, initial conditions, or transient-discard settings, do not proceed.

Respond by asking for the missing required information.

---

# Example: Physical Source Handling

If the user gives a circuit model with a source but only says:

```text
v_source is tunable.
```

Do not proceed.

Ask whether the source is DC, AC, square wave, pulse, or another explicit waveform.

If the source is AC, ask for the complete expression or required form.

Examples of acceptable source definitions:

```matlab
v_source = A*sin(2*pi*f*t + phi);
```

```matlab
v_source = A*cos(omega*t);
```

Then treat `A`, `f`, `phi`, or `omega` as separate tunable quantities if the user marks them as tunable.

---

# Example: Fixed and Tunable Parameter Separation

If the system contains:

```text
R1, R2, R3, C1, C2, L1, L2, m
```

and the user says:

```text
R1, C2, and m are fixed.
```

then only those parameters are fixed.

The remaining parameters must be explicitly classified by the user as tunable or fixed before proceeding.

Do not assume that all unmentioned parameters are tunable.

---

# Quality Checklist Before Execution

Before running or finalizing a script, verify:

- the ODE system has been transcribed correctly
- the state variable order is clear
- `Y0` length matches the number of state variables
- `tspan` and step size are explicitly provided
- fixed parameters are not varied
- tunable parameters are the only varied parameters
- all user-specified ranges are obeyed
- physical parameters are reasonable when the system is physical
- source expressions are complete
- source tunables are decomposed into separate quantities
- time-response transient discard is explicitly provided
- phase-portrait transient discard is explicitly provided
- transient-discard values are valid for the simulation time range
- `ode45Ps` is preserved unless the user requested otherwise
- figure annotations include parameter information
- output image names are ordered and clear
- parameter log is generated

---

# Troubleshooting

## Missing Required Information

Cause:

The user has not provided all required system, simulation, parameter, or transient-discard information.

Action:

Stop and ask for the missing items.

Do not choose defaults.

---

## Parameter Name Mismatch

Cause:

A fixed or tunable parameter named by the user does not appear in the system, or a system parameter is not classified.

Action:

Report the mismatch and ask the user to clarify.

---

## Source Is Underspecified

Cause:

The system contains a source, but the source type or expression is incomplete.

Action:

Ask the user to specify the source type and full expression.

At minimum, ask whether it is DC or AC when the source is in a physical circuit system.

---

## Transient Discard Is Missing

Cause:

The user has not provided time-response and phase-portrait transient-discard settings.

Action:

Ask for both values.

Do not infer them.

---

## Physical Parameter Is Unreasonable

Cause:

A trial parameter value is unrealistic for the physical system.

Action:

Avoid that value and select a physically reasonable one if the parameter is tunable and the user has allowed trial selection.

If the unrealistic value was given by the user as fixed or constrained, report the issue and ask whether to keep it.

---

## Simulation Fails or Diverges

Cause:

The ODE system or parameter set causes numerical failure, divergence, NaN, Inf, or solver instability.

Action:

Record the failed case in the parameter log.

Do not silently change the solver.

Report the failure and suggest possible next steps.

---

# Non-Goals

This skill does not automatically prove stability, chaos, bifurcation structure, or optimality unless the user explicitly asks for additional analysis.

This skill does not replace the user's judgment of dynamical behavior.

This skill does not choose missing required simulation settings.

This skill does not silently change solvers.

This skill does not treat physical circuit parameters as arbitrary mathematical constants unless the model is explicitly nondimensionalized or the user instructs otherwise.