# PhotonVisual

## Generating Photon Trajectories
Compiling from ```project folder/PhotonData```: 
```swiftc -o GenerateTrajectories GenerateTrajectories.swift```
Running script and its parameters:
```./GenerateTrajectories a b c```
Where 
- a = number of photons to generate
- b = number of points in each photon's trajectory
- c = rng seed
The script will write to PhotonData.txt.
### Bounding Box Structure
The bounding box is used to generate the photon trajectories and for the render pipeline to know where to centre the camera.
The structure of the ```BoundingBox.txt``` is:
- Position of top left point
- Width(x) of box 
- Height(y) of box
- Depth(z) of box

## Running Render Pipeline to render photon trajectories
Main function found in ```main.m``` with the arguments needed being:
- a = file path to PhotonData.txt
- b = file path to BoundingBox.txt
