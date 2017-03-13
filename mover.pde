
class Mover {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  String text;

  Mover(float m, float x, float y, String t) {
    mass = m;
    acceleration = new PVector(0,0);
    velocity = new PVector(random(0,2),random(0,1));
    position = new PVector(x,y);
    r = 3.0;
    maxspeed = 5;
    maxforce = 0.1;
    text = t;
  }

  void run(ArrayList<Mover> movers) {
    flock(movers);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
    acceleration.add(force);

  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Mover> movers) {
    PVector sep = separate(movers);   // Separation
    PVector ali = align(movers);      // Alignment
    PVector coh = cohesion(movers);   // Cohesion
    // Arbitrarily weight these forces
    //sep.mult(3.5);
    ali.mult(1.0);
    //coh.mult(0.5);
    // Add the force vectors to acceleration
    //applyForce(sep);
    applyForce(ali);
    //applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(360);
    float w;   
     w = abs((position.x - width/2)/20);
    fill(0, abs((w+50)*2));
    noStroke();
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);;   
   
    //w = abs(sin(TWO_PI * frameCount/400))*100;
    //w = abs(50-(frameCount % 4));
    textSize(min(50, w));

    
    //PFont nytimes;
    //nytimes = createFont("Olde English Regular.ttf", w);
    //textFont(nytimes);
    text(text, r, r);
     popMatrix();
      //print(w);

  }
  
  //PVector repel(Mover m) {
  //  PVector force = PVector.sub(position,m.position);             // Calculate direction of force
  //  float distance = force.mag();                                 // Distance between objects
  //  distance = constrain(distance,1.0,10000.0);                             // Limiting the distance to eliminate "extreme" results for very close or very far objects
  //  force.normalize();                                            // Normalize vector (distance doesn't matter here, we just want this vector for direction

  //  float strength = (g * mass * m.mass) / (distance * distance); // Calculate gravitional force magnitude
  //  force.mult(-0.1*strength);                                      // Get force vector --> magnitude * direction
  //  return force;
  //}

  void borders() {
    if (position.x > width) {
      position.x = width;
      velocity.x *= -1;
    } 
    else if (position.x < 0) {
      position.x = 0;
      velocity.x *= -1;
    }
    if (position.y > height) {
      position.y = height;
      velocity.y *= -1;
    } 
    else if (position.y < 0) {
      position.y = 0;
      velocity.y *= -1;
    }
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Mover> movers) {
    float desiredseparation = 30.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Mover other : movers) {
      float d = PVector.dist(position,other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position,other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Mover> movers) {
    float neighbordist = 5;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Mover other : movers) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Mover> movers) {
    float neighbordist = 20;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Mover other : movers) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0,0);
    }
  }
}