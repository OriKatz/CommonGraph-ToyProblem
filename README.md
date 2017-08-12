# CommonGraph-ToyProblem

Code for the toy problem example described in https://arxiv.org/abs/1701.03619. 

The code folder contains 4 scripts:
  - The main script is "ToyProblemDemo.m".
  - "DataGenerator.m" - generates the snapshots captured by each camera.
  - "CommonGraphSimulation.m" - computes the embeddings achieved by:
      - Application of diffusion map (DM) separately on each sensor .
      - Application of alternating DM on pair of sensors.
      - Appication of the Common Graph scheme (CG) for the whole set of sensors.
  - "ShowEmbedding.m" - plots the calculated embeddings.

For the application of the standard DM and the alternating DM we use the code package shared by Roy Lederman, the relevant scripts are located in the "Utils" folder. The full package is available in https://roy.lederman.name/alternating-diffusion/.
