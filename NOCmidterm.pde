
Mover[] movers = new Mover[35];
Mover[] movers2 = new Mover[35];
//usa news:
String[] words1 = {"worries", "western", "businesses", "extensive", "$300 billion", "targeted", "2025", "officials", "industries", "computer chips", "planes", "kick-start", "next stage", "economic", "development", "companies", "worry", "unfair", "advantage", "report", "enormous", "Chinese", "government", "implement", "force", "competitors", "accelerate", "lead", "global champion", "market share", "large", "low-interest", "loans", "state-owned", "investment"};
//chinese news:
String[] words2 = {"against", "negative", "border", "wall", "building", "rally", "distorted", "Public", "misjudged", "released", "leverage", "thwart", "Donald Trump", "tarnish", "image", "mimic", "enemy", "media ", "CNN", "hostile", "subversive", "democratic", "trust", "Western", "FAKE NEWS", "truth", "danger", "failing", "bias", "human rights", "committed", "the West", "reprioritize", "free trade", "transform"};

Attractor a;
Attractor a2;

Flock flock;
Flock flock2;

float g = 1;
void setup() {
  fullScreen();
  //size(600, 300);
  flock = new Flock();
  a = new Attractor();
  // Add an initial set of boids into the system
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(1, 0, random(height), words1[i]); //attract
    flock.addMover(movers[i]); //flocking

  }
  
  flock2 = new Flock();
  a2 = new Attractor();
  // Add an initial set of boids into the system
  for (int i = 0; i < movers2.length; i++) {
    stroke(255, 0, 0);
    movers2[i] = new Mover(random(0.1, 2), width, random(height), words2[i]); //attract
    flock2.addMover(movers2[i]); //flocking

  }

}

void draw() {
  background(255);
  flock.run();
  
   for (int i = 0; i < movers.length; i++) {
  
    PVector force = a.attract(movers[i]);
    movers[i].applyForce(force);
    movers[i].update();
    movers[i].render();
  }
  
  
  flock2.run();
  
   for (int i = 0; i < movers2.length; i++) {
    
    PVector force = a2.attract(movers2[i]);
    movers2[i].applyForce(force);
    movers2[i].update();
    movers2[i].render();
  }
  
  


}