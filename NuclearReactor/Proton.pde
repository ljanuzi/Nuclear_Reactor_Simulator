class Proton {

  PVector location;
  PVector velocity;
  float mass;
  float topSpeed = 10;
  float attractDistance = 100;
  float repulseDistance = 5;


  Proton(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(5, 0);
    mass=1;
  }

  void repulsed(Proton[] protons) {
    for (Proton p : protons) {
      PVector direction = PVector.sub(this.location, p.location);
      float distance = direction.mag();
      if (distance<attractDistance) {
        velocity.add(direction.mult(0.01));
        velocity.limit(topSpeed);
      }
    }
  }

  void attracted(Neutron[] neutrons) {
    for ( Neutron n : neutrons) {
      PVector direction = PVector.sub(n.location, this.location);
      float distance = direction.mag();
      if (distance<repulseDistance) {
        velocity.add(direction);
        velocity.limit(topSpeed);
      }
    }
  }

  void display() {
    //noStroke();
    //stroke(#FFFFFF);
    fill(#D81C1C);
    ellipse(location.x, location.y, 15*mass, 15*mass);
  }

  void step(PVector center) {
    /*attracted(neutrons);
     repulsed(protons);
     location.add(velocity);
     location.x = constrain(location.x,500,550);
     location.y = constrain(location.y,200,250);*/
    float radius = 50;
    PVector randomLocation;
    float randomX;
    float randomY;
    do {
      randomX = random(center.x-radius, center.x+50);
      randomY = random(center.y-radius, center.y+radius);
      randomLocation = new PVector(randomX, randomY);
      randomLocation.sub(center);
    } while (randomLocation.mag() > radius);
    location = new PVector(randomX, randomY);
  }
}
