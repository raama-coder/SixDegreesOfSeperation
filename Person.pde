class Person{
    String name;
    int id;
    ArrayList<Person> friends;
    String clusterName;
    int socialSkils;
    float x, y;

    Person(String n, int i, int s){
        name = n;
        id = i;
        socialSkils = s; // Determines how social the person is (1-10)
        friends = new ArrayList<Person>();

        x = random(50, width-50);
        y = random(50, height-50);
    }

    void addFriend(Person p){
        // Adds a friend if not already in the list
        if(!friends.contains(p)){
            friends.add(p);
        }
    }

    ArrayList<Person> getFriends(){
        return friends; // Returns all friends of this person
    }

    void setCluster(String c){
        clusterName = c; // Assigns this person to a cluster
    }

    String getCluster(){
        return clusterName; // Returns cluster name
    }

    int getClusterColour(){
        // Gets the color of the cluster this person belongs to
        int index = int(clusterName.split("_")[1]);
        return sim.clusterColors[index];
    }

    void drawMe(){
        // Highlight selected nodes
        if(this == sim.selected1 || this == sim.selected2 ||this == sim.p1 || this == sim.p2){
            stroke(0);
            strokeWeight(4);
        }
        
        // Normal nodes
        else{
            stroke(0);
            strokeWeight(1);
        }

        fill(getClusterColour());
        circle(x, y, 20);
    }  
}