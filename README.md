AI-Driven Anomaly Detection for Component Burn-In

A physics-grounded synthetic telemetry simulator and anomaly detection pipeline for burn-in testing of electronic components, with a roadmap to extend it with deep learning (LSTM, autoencoder, TCN).

> This project is based on a problem statement from ISRO's Smart India Hackathon ("AI-Driven Anomaly Detection in Component Burn-In & Screening"). It started as a team project and is now being developed further.




---

Overview

Burn-in is a screening step where electronic components are run at elevated temperature and voltage so that weak parts fail early, before they reach a mission. During burn-in, each device produces telemetry (temperature, voltage, current, quiescent current), and subtle drift in that data can signal a component that is about to fail.

Real burn-in data is scarce and usually not public. This project tackles that in two steps:

1. Generate realistic data. A physics-based simulator produces labelled burn-in telemetry.
2. Detect anomalies. Machine-learning detectors are trained and evaluated on that data, and benchmarked against each other.

What is in this repository

Component	Description

simulator.py	Physics-grounded synthetic telemetry simulator modelling MIL-STD-883 Method 1015 static burn-in at 125°C
Dataset (CSV)	Simulator output with a fixed, validated schema (below)
Detection	Isolation Forest and CUSUM-based anomaly detection
evaluation_report.json	Benchmark results for the detectors


> Adjust the file names above to match the actual layout of the repository.



Dataset schema

Each row is one telemetry sample:

Column	Meaning

timestamp	Time of the sample during the burn-in run
temperature	Device or chamber temperature
voltage	Supply voltage
current	Supply current
iddq_uA	Quiescent supply current (IDDQ) in microamps
criticality_level	Severity of the injected anomaly, if any
label	Ground truth: normal or anomalous


Because the data is simulated, every anomaly has a known label. That gives a true ground truth for evaluating detectors, which is hard to get from real burn-in logs.

Approach

1. Simulator

simulator.py models static burn-in as specified in MIL-STD-883 Method 1015 at 125°C. It generates telemetry for normal devices and injects physically motivated anomalies, so detectors can be tested against known failure behaviour.

2. Detection methods

- Isolation Forest: an unsupervised method that isolates outliers using random trees. Anomalies are few and different, so they are separated in fewer splits than normal points.
- CUSUM (cumulative sum): a sequential change-detection method that accumulates small deviations from the expected value, so slow drifts are caught that single-point thresholds would miss.

3. Evaluation

Detectors are scored against the simulator's ground-truth labels. Results are recorded in evaluation_report.json.

Roadmap

The current detectors are classical baselines. The next stage is to explore deep learning for time-series anomaly detection and compare it against them.

Planned models (not yet implemented):

- [ ] LSTM: sequence model that learns normal telemetry behaviour and flags deviations
- [ ] Autoencoder: reconstruct normal data; high reconstruction error indicates an anomaly
- [ ] TCN (Temporal Convolutional Network): convolutional sequence model for time series
- [ ] Other time-series detectors, to be decided after the first benchmarks

Planned data and evaluation work:

- [ ] Benchmark all models against the Isolation Forest baseline on the same data and metrics
- [ ] Generate higher-fidelity and more varied synthetic data
- [ ] Evaluate on real-world aging datasets (for example, public NASA Prognostics Center of Excellence data) to test whether the methods transfer beyond simulation

Getting started

git clone <this-repo-url>  
cd <repo-folder>  
pip install numpy scikit-learn matplotlib  
python simulator.py

> Check the simulator's options and the exact entry points in the code and update these commands to match.



Tech stack

Python, NumPy, scikit-learn, Matplotlib

Contributors

This was developed as a team project.

- Devvrat Kandpal: physics simulator, dataset schema and ground truth, detection and evaluation work

Acknowledgements

- Problem statement: ISRO, via the Smart India Hackathon
- Burn-in specification: MIL-STD-883, Method 1015

License

MIT
