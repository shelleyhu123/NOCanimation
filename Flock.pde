
class Flock {
  ArrayList<Mover> movers; // An ArrayList for all the boids
 
  Flock() {
    movers = new ArrayList<Mover>();
    // Initialize the ArrayList
  }

  void run() {
    for (Mover b : movers) {
      b.run(movers);  // Passing the entire list of boids to each boid individually
    }
    
    
  }

  void addMover(Mover b) {
    movers.add(b);
  }
  
 

}