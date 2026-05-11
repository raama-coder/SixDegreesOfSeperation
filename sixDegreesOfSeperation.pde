/* Controls:
r/R: two new random people will be picked.
Spacebar: toggles whether to show the process of finding the relation between two people
Mouse: Click on any two people to find the connection them
*/

Simulation sim;


// Parameters that affect the degree of seperation
int numPeople = 150; // Total number of people
int numClusters = 5; // Number of groups of people
int minFriends = 1; // Minimum amount of friends a person can have (has to be atleast 1)
int maxFriends = 5; // Maximum amount of friends a person can have
float connectionChance = 100; // Percent chance of a person from cluster x to connect to cluster y

Boolean showProcess = true; // Determines whether to show the process of finding the relationship

void mousePressed(){
    sim.handleClick(); // Handles selecting people with the mouse
}

void keyPressed(){
    if(key == 'r' || key == 'R'){
        // Picks two random people and starts a new search
        Person a = sim.getRandomPerson();
        Person b = sim.getRandomPerson();

        while(a == b){
            b = sim.getRandomPerson(); // Ensures two different people are selected
        }

        sim.startNewSearch(a, b);
    }

    if(key == ' '){
        // Toggles between step-by-step search and instant search
        showProcess = !showProcess;
    }
}

void setup(){
    size(900,700);
    sim = new Simulation(); // Create simulation object
    sim.runSimulation(); // Initialize everything
}

void draw(){
    background(245); // Light background for better visuals
    sim.display(); // Draw everything in the simulation
}