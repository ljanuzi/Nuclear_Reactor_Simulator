class Atom2 {
  Neutron[] n;
  Proton[] p;
  float mass;
  boolean remove = false;
  PVector location;
  PVector velocity;
  PFont font1;



  Atom2(int protons, int neutrons, float  x, float y) {
    p = new Proton[protons];
    n = new Neutron[neutrons];
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    font1 = createFont("Helvetica-Bold", 25);
    for (int i = 0; i<p.length; i++) {
      p[i] = new Proton(random(475, 575), random(225, 275));
    }
    for (int i = 0; i<n.length; i++) {
      n[i] = new Neutron(random(475, 575), random(225, 275), 0, 0);
    }
  }

  void display() {

    for (int i=0; i<p.length; i++) {
      p[i].display();
      p[i].step(location);
      n[i].display();
      n[i].step(location);
    }

    fill(#26DB51);
    textFont(font1);
    text("Ur-235", 480, 230);
  }

  void step() {
      location.add(velocity);
      display();
      for(int i =0; i<p.length;i++){
        //p[i].display();
        //n[i].display();
      }
  }

  ArrayList<Atom2> splitAtom(Neutron n) {
    ArrayList<Atom2> al = new ArrayList<Atom2>();
    if (p.length>41) {
      Atom2 a1,a2;
      if (n.location.x>=480) {
        n.remove();
        //al.add(createBarium());
        a1 = createBarium();
        a2 = createKrypton();
        al.add(a1);
        al.add(a2);
        return al;
      }
    }
    return null;
  }

  Atom2 createBarium() {
    Atom2 barium = new Atom2(40, 40, location.x+20, location.y+20);
    barium.setVelocity(10, -10);
    return barium;
  }

  Atom2 createKrypton() {
    Atom2 krypton = new Atom2(20, 20, location.x+20, location.y+20);
    krypton.setVelocity(10, 10);
    return krypton;
  }

  void setVelocity(float x, float y) {
    velocity = new PVector(x, y);
  }
  
  boolean reachedEdge(){
    if(location.x>=width-250 && velocity.x >0){
      return true;
    }
    return false;
  }
}
