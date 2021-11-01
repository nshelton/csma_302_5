WU Fall 2021 | CSMA 302 | Lab #5
---
# Compute Shader Particle System


For this assignment we're exploring some different types of particles simulations and proocedural rendering.

You will implement 3D boids algorithm with the following rules (based on wikipedia)
 - **cohesion** : add a velocity based on the center of all boids in a neighborhod. needs a parameter for neighborhood size and attraction factor.
 - **seperation** : add a velocity based on the center of all boids in a neighborhod. needs a parameter for neighborhood size and repulsion factor.
 - **alignment** : movement direction (not speed) is influenced by neighbors direction. needs a alignment factor parameter.
 
 The world should wrap so that the boid particles are always between 0 - 20 units in the x,y, and z dimensions. 

## Homework for 10.27.21: 
 - Make the material use additive blending
 - Add a color parameter to the material


## Due Date

**The assignment is due on Sunday November 7th before midnight.**

## Resources

[slides 1](https://docs.google.com/presentation/d/1BSUccUw_GJl6ywMH7f1rtPsfQDvDu9qIy8WD2JyEtVY/edit?usp=sharing)

[Boids on wikipedia](https://en.wikipedia.org/wiki/Boids)

[n-body simulation](http://www.scholarpedia.org/article/N-body_simulations_(gravitational))

## Grading

 - 20 points for each of 3 different rules implemented correctly
 - 10 points for numerical stability (no disappearing boids due to nans), using drag for dampening
 - 10 points for correct wrapping
 - 10 points for code organization and comments
 - 10 points for a custom particle texture for your boids 


## Submitting 
(this is also in the syllabus, but consider this an updated version)

1. Disregard what the Syllabus said about Moodle, just submit your work to a branch on github on this repo (branch should be your firstname-lastname)
When you are finished, "Tag" the commit in git as "Complete". You can still work on it after that if you want, I will just grade the latest commit.

2. The project has to run and all the shaders you are using should compile. If it doesn't I'm not going to try to fix it to grade it, I will just let you know that your project is busted and you have to resubmit.  Every time this happens I'll take off 5%. You have 24 hours from when I return it to get it back in, working. 

3. Late projects will lose 10% every 24 hours they are late, after 72 hours the work gets an F. 

4. Obviously plagarism will not be tolerated, there are a small number of students so I can read all your code. Because it is on git it's obvious if you copied some else's. If you copy code without citing the source in a comment, this will be considered plagarism. 
