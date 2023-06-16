# PhotonVisual

## Generating Photon Trajectories
Compiling from ```project folder/PhotonData```: 
```swiftc -o GenerateTrajectories GenerateTrajectories.swift```
Running script and its parameters:
```./GenerateTrajectories a b```
Where 
- a = number of photons to generate
- b = number of points in each photon's trajectory

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

## Setup Project in XCode
1. Clone the project from the git repo ```https://github.com/Aplysiida/PhotonVisual.git```
2. Create an empty XCode project at the repo's location.
3. Open Xcode then do the following:
    1. Add all files in ```/RenderPipeline``` folder
    2. Add all files in ```/RenderPipeline``` to Compile Sources. Make sure it's only the ```.m, .h ``` and ```.metal``` files.
    3. In Xcode bar go to ```Product/Scheme/Edit Scheme...``` and add the two arguments needed for Render Pipeline.
