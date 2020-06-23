class Atom {
  float mass;
  int atomicNumber;
  int neutrons;
  PVector location;
  PVector velocity;
  PVector acceleration;
  Atom2 u;
  Neutron n;

  Atom(int atomicNumber, int neutrons, float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 1;
    this.atomicNumber = atomicNumber;
    this.neutrons = neutrons;
  }

  void display() {
    fill(#FFFFFF);

    ellipse(location.x, location.y, 5*mass, 5*mass);
    ellipse(location.x+6, location.y-2, 5*mass, 5*mass);
    ellipse(location.x+2, location.y+6, 5*mass, 5*mass);
    ellipse(location.x+11, location.y+5, 5*mass, 5*mass);
    if (atomicNumber>90)
      fill(#D32B2B);
    else
      fill(#666666);
    ellipse(location.x+3, location.y+2, 5*mass, 5*mass);
    ellipse(location.x+10, location.y+1, 5*mass, 5*mass);
    ellipse(location.x+6, location.y+4, 5*mass, 5*mass);
  }

  void step() {
    location = location.add(velocity); 
    velocity = velocity.add(acceleration);
  }

  boolean collide(ArrayList<Particle> particles, ArrayList<Atom> atoms) {
    float radius = 10;
    for (int i =0; i<particles.size(); i++) {
      float distance = PVector.sub(particles.get(i).location, this.location).mag();
      if (distance<radius && atomicNumber>90) {
        splitAtom(atoms);
        particles.remove(i);
        for (int j = 0; j<3; j++) {
          float velocityX = random(-1, 1);
          float velocityY = random(-1, 1);
          PVector location1 = new PVector(location.x+velocityX, location.y+velocityY);
          PVector velocity1 = new PVector(velocityX, velocityY);
          particles.add(new Particle(location1, velocity1));
        }
        return true;
      }
    }
    return false;
  }

  void splitAtom(ArrayList<Atom> atoms) {
    float random = random(-10, 10);
    Atom kr = new Atom(36, 55, location.x+random, location.y+random);
    random = random(-10, 10);
    Atom ba = new Atom(56, 86, location.x+random, location.y-random);
    atoms.add(kr);
    atoms.add(ba);
    atoms.remove(this);
  }
}
