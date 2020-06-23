class Neutron {

  PVector location;
  PVector velocity;
  float mass;
  float topSpeed = 10;
  float attractDistance = 100;
  float repulseDistance = 5;


  Neutron(float lx, float ly, float vx, float vy) {
    location = new PVector(lx, ly);
    velocity = new PVector(vx, vy);
    mass=1;
  }



  void display() {
    //noStroke();
    //stroke(#FFFFFF);
    fill(#2746F0);
    ellipse(location.x, location.y, 15*mass, 15*mass);
  }

  void step(PVector center) {
    /*attracted(protons);
    repulsed(neutrons);
    location.add(velocity);
    location.x = constrain(location.x,450,550);
    location.y = constrain(location.y,200,250);*/
    location.add(velocity);
    chaoticStep(center);
  }

  void chaoticStep(PVector center){
    float radius = 50;
    PVector randomLocation;
    float randomX, randomY;
    do{
    randomX = random(center.x-radius,center.x+radius);
    randomY = random(center.y-radius,center.y+radius);
    randomLocation = new PVector(randomX, randomY);
    randomLocation.sub(center);
    }while(randomLocation.mag() > radius);
    location = new PVector(randomX,randomY);
  }
  
  void fire() {
    location.add(velocity);
  }

  void attracted(Proton[] protons) {
    for (Proton p : protons) {
      PVector direction = PVector.sub(p.location, this.location);
      float distance = direction.mag();
      if (distance<attractDistance) {
        velocity.add(direction.mult(1));
        velocity.limit(topSpeed);
      }
    }
  }
  
  void repulsed(Neutron[] neutrons){
    for( Neutron n: neutrons){
      PVector direction = PVector.sub(this.location, n.location);
      float distance = direction.mag();
      if (distance<repulseDistance) {
        velocity.add(direction.mult(0.01));
        velocity.limit(topSpeed);
      }
    }
  }

  void remove() {
    mass = 0;
  }
}
