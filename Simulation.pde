class Simulation{
    ArrayList<Person> people;
    Connections connections;

    Person p1, p2; // Randomly selected start and end nodes

    int[] clusterColors;

    Person selected1 = null;
    Person selected2 = null;

    float offsetX = 120; // Shifts simulation right to make space for UI

    Simulation(){
        people = new ArrayList<Person>(); // Initialize list of people
    }

    void runSimulation(){
        createPeople(); // Create all person objects
        createClusters(); // Assign clusters and friendships
        connections = new Connections(people); // Create connection system

        // Pick two random people to start simulation
        do{
            p1 = getRandomPerson();
            p2 = getRandomPerson();
        } while(p1 == p2);

        connections.startSearch(p1, p2); // Begin BFS search
    }

    void createPeople(){
        // Create all people with random social skill values
        for(int i = 0; i < numPeople; i++){
            Person p = new Person("Person_" + i, i, int(random(1,11)));
            people.add(p);
        }
    }

    void createClusters(){
        float[] clusterX = new float[numClusters];
        float[] clusterY = new float[numClusters];

        clusterColors = new int[numClusters];

        // Generate random cluster centers and colors
        for(int i = 0; i < numClusters; i++){
            clusterX[i] = random(200, width - 200);
            clusterY[i] = random(200, height - 200);

            clusterColors[i] = color(random(255), random(255), random(255));
        }

        // Assign each person to a cluster and position them nearby
        for(Person p : people){
            int c = int(random(numClusters));
            p.setCluster("Cluster_" + c);

            // Position near cluster center + shift right for UI
            p.x = clusterX[c] + random(-150, 150) + offsetX;
            p.y = clusterY[c] + random(-150, 150);

            // Clamp positions so nodes never go off screen
            p.x = constrain(p.x, offsetX + 20, width - 20);
            p.y = constrain(p.y, 20, height - 20);
        }

        // Create friendships between people
        for(Person p : people){
            int numFriends = int(random(minFriends, maxFriends+1));

            // Keep adding friends until target is reached
            while(p.friends.size() < numFriends){
                Person other = getRandomPerson();

                if(other != p && !p.friends.contains(other)){
                    // Social factor: more social people connect more easily
                    float socialFactor = (p.socialSkils + other.socialSkils) / 20.0;

                    // Same cluster or chance based cross-cluster connection
                    if(p.getCluster().equals(other.getCluster()) || random(1) < (connectionChance/100.0) * socialFactor){
                        p.addFriend(other);
                        other.addFriend(p); // Ensure mutual friendship
                    }
                }
            }
        }
    }

    void startNewSearch(Person a, Person b){
        // Starts a new search between two selected people
        if(a == null || b == null || a == b) return;

        p1 = a; // Start node
        p2 = b; // End node

        connections.startSearch(p1, p2);
    }

    void handleClick(){
        // Detect if user clicked on a person
        for(Person p : people){
            float d = dist(mouseX, mouseY, p.x, p.y);

            if(d <= 10){
                if(selected1 == null){
                    selected1 = p; // First selected node
                }
                else if(selected2 == null){
                    selected2 = p; // Second selected node

                    // Start search between selected nodes
                    startNewSearch(selected1, selected2);

                    // Reset selection
                    selected1 = null;
                    selected2 = null;
                }
                return;
            }
        }
    }

    Person getRandomPerson(){
        // Returns a random person from the list
        return people.get(int(random(people.size())));
    }

    void display(){
        fill(0);
        textSize(18);
        text("Six Degrees of Separation", 20, 30);

        textSize(12);
        text("Click 2 people", 20, 50);
        text("r/R = random pair", 20, 65);
        text("Space = toggle search", 20, 80);

        int legendY = 110;
        text("Clusters:", 20, legendY);

        legendY += 15;

        // Display cluster colors
        for(int i = 0; i < clusterColors.length; i++){
            fill(clusterColors[i]);
            circle(30, legendY, 10);
            fill(0);
            text("Cluster " + i, 45, legendY + 5);
            legendY += 15;
        }

        connections.drawConnections(); // Draw all edges

        // Control how BFS runs (step-by-step or instant)
        if(showProcess){
            if(frameCount % 5 == 0){
                connections.stepSearch();
            }
        }
        else{
            while(connections.searching && !connections.found){
                connections.stepSearch();
            }
        }

        connections.drawSearch(); // Blue path (searching)
        connections.drawFinalPath(); // Red path (final)

        // Draws all people
        for(Person p : people){
            p.drawMe();
        }

        // Show degrees of separation once path is found
        if(connections.currentPath != null && connections.found){
            fill(0);
            text("Degrees: " + (connections.currentPath.size()-1), 25, height - 25);
        }
    }
}