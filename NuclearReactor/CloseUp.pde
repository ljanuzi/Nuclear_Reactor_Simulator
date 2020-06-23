/*Proton[] p;
 Neutron[] n;*/
class CloseUp{
  Atom2 u;
  Neutron n;

  ArrayList<Atom2> al;
  ArrayList<Neutron> neutrons;

  PImage img;
  boolean fire = false;
  int xTranslate;
  int yTranslate;
  void setup() {
    size(1000, 700);
    frameRate(15);
    init();
  }

  void init1() {
    al = new ArrayList<Atom2>();
    neutrons = new ArrayList<Neutron>();
    img = loadImage("gun.jpg");
    u = new Atom2(60, 60, 525, 225);
    n = new Neutron(266, 220, 5, 0);

    al.add(u);
    Atom2 legendAtom = new Atom2(15, 15, width-120, height/2+40);
    al.add(legendAtom);
    //if (mousePressed==true) {
    //  mouseClicked();
    //}
  }

  void draw1() {
    xTranslate = 400;
    yTranslate = 200;
    translate(xTranslate,yTranslate);
    background(#FFFFFF);
    legend();
    fireButton();
    resetButton();

    for (int i = 0; i<neutrons.size(); i++) {
      neutrons.get(i).display();
      neutrons.get(i).fire();
    }
    for (int i = 0; i<al.size(); i++) {
      al.get(i).step();
      if (al.get(i).reachedEdge()) {
        al.remove(i);
      }
    }
    if (fire) {
      n.display();
      //neutrons.add(n);
      n.fire();
    }
    if (al.size()>0) {
      ArrayList<Atom2> a = al.get(0).splitAtom(n);
      if (a!=null) {
        al.remove(0);
        al.addAll(a);
        fire = false;
        neutrons.remove(n);

        //TEMPORARY FIX
        Neutron neutron1 = new Neutron(525, 225, -7, -7);
        Neutron neutron2 = new Neutron(525, 225, 0, 10);
        Neutron neutron3 = new Neutron(525, 225, -7, 7);
        neutrons.add(neutron1);
        neutrons.add(neutron2);
        neutrons.add(neutron3);
      }
    }
    pushMatrix();
    strokeWeight(2);
    fill(#FFFFFF);
    rect(150-xTranslate, 100-yTranslate, 50, 50);
    fill(#D61A1D);
    ellipse(175-xTranslate, 125-yTranslate, 30, 30);
    fill(#000501);
    textSize(32);
    text("Change simulation", 30-xTranslate, 80-yTranslate);
    popMatrix();
  }

  //void mousePressed() {
  //  if (overFire()) {
  //    fire=true;
  //  } else if (resetSimulation()) {
  //    init();
  //    fire = false;
  //  }
  //}




  void fireButton() {
    image(img, 80, 190, 180, 100);
    fill(#000301);
    textSize(20);
    text("Fire neutron", 112, 305);
    if (overFire()) {
      fill(#21CB47);
      ellipse(170, 260, 30, 30);
    } else {
      fill(#DB2629);
      ellipse(170, 260, 30, 30);
    }
  }


  void resetButton() {
    strokeWeight(2);
    fill(#FFFFFF);
    rect(660, 400, 50, 50);
    if (resetSimulation()) {
      fill(#32CE5D);
    } else {
      fill(#D61A1D);
    }
    ellipse(685, 425, 30, 30);
    fill(#000501);
    textSize(25);
    text("RESET SIMULATION", 390, 430);
  }


  boolean overFire() {
    if (mouseX>=xTranslate+145 && mouseX<=xTranslate+195 && mouseY>=yTranslate+235 && mouseY<=yTranslate+285) {
      return true;
    } else {
      return false;
    }
  }

  boolean resetSimulation() {
    if (mouseX>=xTranslate+660 && mouseX<=xTranslate+710 && mouseY>=yTranslate+400 && mouseY<=yTranslate+450) {
      return true;
    } else {
      return false;
    }
  }


  void legend() {
    line(770, 0, 770, 700);
    fill(#010502);
    textSize(20);
    text("Legend", 850, 60);
    line(770, 100, 1000, 100);

    textSize(15);       //neutron
    text("-    Neutron", 865, 175);
    fill(#2746F0);
    ellipse(835, 170, 15, 15);

    textSize(15);       //proton
    fill(#010502);
    text("-    Proton", 865, 235);
    fill(#D81C1C);
    ellipse(835, 230, 15, 15);

    /*Neutron[] n;
     Proton[] p;
     p = new Proton[30];
     n = new Neutron[30];
     //font1 = createFont("Helvetica-Bold", 25);
     for (int i = 0; i<p.length; i++) {
     p[i] = new Proton(random(805,845),random(285,325));
     n[i] = new Neutron(random(805,845),random(285,325));
     }
     
     for(int i=0; i<p.length; i++){
     p[i].display();
     p[i].step(p,n);
     n[i].display();
     n[i].step(p,n);
     }*/


    fill(#26DB51);
    textSize(20);
    text("Ur-235", 791, 310);

    textSize(15);
    fill(#010502);
    text("-    Uranium-235", 865, 305);
  }
}
//ellipse();
//ellipse();
