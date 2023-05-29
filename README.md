# PhotonVisual

## Generating Photon Trajectories
Compiling from project folder: 
```swiftc -o PhotonData\GenerateTrajectories PhotonData\GenerateTrajectories.swift```
Running script and its parameters:
```./PhotonData/GenerateTrajectories a b c```
Where 
    - a = number of photons to generate
    - b = number of points in each photon's trajectory
    - c = rng seed
The script will write to PhotonData.txt.

## Running Render Pipeline to render photon trajectories
