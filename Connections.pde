class Connections{
    ArrayList<Person> people;

    ArrayList<ArrayList<Person>> queue;
    ArrayList<Person> visited;
    ArrayList<Person> currentPath;

    Person start, end;
    boolean searching = false;
    boolean found = false;

    Connections(ArrayList<Person> p){
        people = p;
    }

    // Starts a new BFS search between two people
    void startSearch(Person p1, Person p2){
        start = p1;
        end = p2;

        queue = new ArrayList<ArrayList<Person>>();
        visited = new ArrayList<Person>();

        ArrayList<Person> first = new ArrayList<Person>();
        first.add(start); // Start path begins with first person

        queue.add(first);

        searching = true;
        found = false;
    }

    void stepSearch(){
        // Runs one step of BFS (Breadth-First Search)

        if(!searching || found) return;

        if(queue.size() == 0){
            searching = false;
            println("No connection found.");
            return;
        }

        ArrayList<Person> path = queue.remove(0);
        Person last = path.get(path.size()-1);

        // If we reached the target person, stop
        if(last == end){
            currentPath = path;
            found = true;
            searching = false;
            return;
        }

        // Expand to all friends
        if(!visited.contains(last)){
            visited.add(last);

            for(Person friend : last.getFriends()){
                ArrayList<Person> newPath = new ArrayList<Person>(path);
                newPath.add(friend);
                queue.add(newPath);
            }
        }

        currentPath = path;
    }

    void drawConnections(){
        // Draws all connections between people
        stroke(180, 180, 180, 120);
        strokeWeight(2);
        for(Person p : people){
            for(Person f : p.getFriends()){
                line(p.x, p.y, f.x, f.y);
            }
        }
    }

    void drawSearch(){
        // Draws the current searching path (blue)
        if(currentPath == null) return;

        stroke(0,0,255);
        strokeWeight(2);

        for(int i = 0; i < currentPath.size()-1; i++){
            Person a = currentPath.get(i);
            Person b = currentPath.get(i+1);
            line(a.x, a.y, b.x, b.y);
        }

        strokeWeight(1);
    }

    void drawFinalPath(){
        // Draws the final shortest path (red)
        if(!found || currentPath == null) return;

        stroke(255,0,0);
        strokeWeight(4);

        for(int i = 0; i < currentPath.size()-1; i++){
            Person a = currentPath.get(i);
            Person b = currentPath.get(i+1);
            line(a.x, a.y, b.x, b.y);
        }

        strokeWeight(1);
    }
}