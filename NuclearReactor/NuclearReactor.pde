import g4p_controls.*;
import java.util.*;
ArrayList<Atom> atoms;
ControlRod[] controlRods;
ArrayList<Particle> particles;
boolean fire = false;
boolean rodUp = false;
float energy;
boolean lockedOn;
ArrayList <GSlider> sliders;
GSlider simulationSlider, uraniumSlider, neutronSlider;
boolean simStarted;
PImage img;
LinkedList<PVector> energyNodes;
int handleX, handleY, handleWidth, handleHeight;
int containerX, containerY, containerWidth, containerHeight;
int wContainerX, wContainerY, wContainerWidth, wContainerHeight;
int yOffSet;
int energyCounter;
PImage turbine;
boolean sim2 = false;
CloseUp c;

void setup() {

  sliders = new ArrayList<GSlider>();
  setupSliders();

  c = new CloseUp();
  size(1920, 1080);
  frameRate(30);
  init();
  c.init1();
}

void init() {
  energyNodes = new LinkedList<PVector>();
  energyNodes.add(new PVector(0, 0));
  energy = energyCounter = 0;
  lockedOn = false;
  simStarted = false;
  //645, 420, 650, 30
  img = loadImage("thermometer.png");
  turbine = loadImage("wheel.png");
  containerX = 120;
  containerY = 600;
  containerWidth = 700;
  containerHeight = 300;

  handleX = containerX+30;
  handleY = 520;
  handleWidth = 650;
  handleHeight = 30;

  wContainerX = 1000;
  wContainerY=500;
  wContainerWidth=300;
  wContainerHeight=400;


  //slider.setOpaque(true);

  atoms = new ArrayList<Atom>();
  particles = new ArrayList<Particle>();

  controlRods = new ControlRod[4];
  int x = containerX+(containerWidth/6);
  for (int i=0; i<4; i++) {
    controlRods[i] = new ControlRod(x, handleY+handleHeight);
    x+=containerWidth/5;
  }

  if (mousePressed==true) {
    mouseClicked();
  }
}


void draw() {
  if(sim2){
    c.draw1();
  }else
  {
  background(#FFFFFF);
  fireNeutronsButton();
  resetButton();
  moveControlRodsButton();
  slider();
  fill(#A7D3F0);
  strokeWeight(10);



  if (particles.size()==0 && !simStarted)
    setUraniumNumber(uraniumSlider.getValueI());


  rect(containerX, containerY, containerWidth, containerHeight);
  strokeWeight(1);

  //update the energy graph every 30 frames, implemted with a counter instead of frameCount because of previous conflicting changes
  energyCounter++;
  if (energyCounter==30) {
    energyCounter = 0;
    energyNodes.addLast(new PVector(0, energy));
    if (energyNodes.size()>=10) {
      energyNodes.remove(0);
    }
  }


  for (int i=0; i<atoms.size(); i++) {
    atoms.get(i).step();
    atoms.get(i).display();
    boolean collide = atoms.get(i).collide(particles, atoms);
    if (collide) {
      energy++;
    }
    if (energy>50) energy=50;
  }

  if (fire) {
    for (int i =0; i<neutronSlider.getValueI(); i++) {
      particles.add(new Particle(containerX, containerY, containerWidth, containerHeight));
    }
    fire = false;
  }
  for (int i = 0; i<particles.size(); i++) {
    particles.get(i).setSpeed(simulationSlider.getValueF());
    particles.get(i).display();
    particles.get(i).step();
    particles.get(i).bounceOnEdges(containerX, containerY, containerWidth, containerHeight);
  }
  for (int i = 0; i<controlRods.length; i++) {
    if (!rodUp) {
      controlRods[i].absorb(particles);
      controlRods[i].display();
      //controlRods[i].setHeight();
    }
  }
  displayEnergyBar();
  energy=energy*0.992;
  if (energy>0) {
    simStarted = true;
  }

  drawPipes();
  displayEnergy();
  displayTurbine();
  displayEnergyBar();
  changeSimulationButton();
  }
    
}




void fireNeutronsButton() {
  strokeWeight(2);
  fill(#FFFFFF);
  rect(width-100, 70, 50, 50);
  fill(#D61A1D);
  ellipse(width-100+24, 95, 30, 30);
  fill(#000501);
  textSize(32);
  text("F I R E     N E U T R O N S", width-600, 110);
}
void resetButton() {
  strokeWeight(2);
  fill(#FFFFFF);
  rect(width-100, 140, 50, 50);
  fill(#D61A1D);
  ellipse(width-100+25, 165, 30, 30);
  fill(#000501);
  textSize(32);
  text("RESET SIMULATION", width-600, 180);
}
void slider() {
  textSize(16);
  text("Simulation speed", width-320, height/3-10);
  textSize(16);
  text("Number of uraniums", width-320, height/3+190);
  textSize(16);
  text("Number of neutrons", width-320, height/3+190+190);
  textSize(12);
  text("0 W", width-450, height-50);
  textSize(12);
  text("10M KW", width-450, height-120);
  textSize(12);
  text("20M KW", width-450, height-190);
}
void moveControlRodsButton() {
  fill(#EAE126);
  rect(handleX, handleY, handleWidth, handleHeight);
  fill(#050500);
  textSize(24);
  text("C O N T R O L     R O D S", 2*handleX, handleY+25);
}

void changeSimulationButton(){
  strokeWeight(2);
  fill(#FFFFFF);
  rect(150, 100, 50, 50);
  fill(#D61A1D);
  ellipse(175, 125, 30, 30);
  fill(#000501);
  textSize(32);
  text("Change simulation", 30, 80);
}

boolean overFire() {
  if (mouseX>=width-100 && mouseX<=width-50 && mouseY>=70 && mouseY<=120) {
    return true;
  } else {
    return false;
  }
}

boolean overUp() {
  if (mouseX>=1300 && mouseX<=1370 && mouseY>=400 && mouseY<=470) {
    return true;
  } else {
    return false;
  }
}

boolean overHandle() {
  if (mouseX>=handleX && mouseX<=handleX+handleWidth && mouseY>=handleY && mouseY <= handleY+handleHeight) 
    return true;
  else 
  return false;
}

boolean resetSimulation() {
  if (mouseX>=width-100 && mouseX<=width-50 && mouseY>=140 && mouseY<=190) {
    return true;
  } else {
    return false;
  }
}

boolean overUraniumSetter() {
  if (mouseX>=width-100 && mouseX<=width-50 && mouseY>=140 && mouseY<=190) {
    return true;
  } else {
    return false;
  }
}

boolean changeSimulation(){
  if (mouseX>=150 && mouseX<=200 && mouseY>=100 && mouseY<=150) {
    return true;
  } else {
    return false;
  }
}

void displayEnergy() {
  strokeWeight(1);
  fill(#FFFFFF);
  rect(width-400, height-200, 300, 150);

  fill(#000000);
  int i=0;
  float previous = energyNodes.get(0).y;
  float max = 0;
  for (PVector p : energyNodes) {
    line(width-370+(i-1)*30, height-50-previous*2.5, width-370+(i)*30, height-50-p.y*2.5);
    ellipse(width-370+i*30, height-50-p.y*2.5, 5, 5);
    previous = p.y;
    i++;
    if (max<p.y) max=p.y;
  }
}

void displayEnergyBar() {
  image(img, width-500, height/2+100, 40, 180);

  fill(#666666);
  strokeWeight(1);
  //rect(width-500,height/2+100,40,200);
  fill(#D61A1D);
  strokeWeight(0);
  float temperatureH = constrain(height/2+260-energy*5, height/2+105, height);
  float temperatureL = constrain(energy*5, 0, 150);
  rect(width-491, temperatureH, 9, temperatureL);
}

void displayTurbine() {
  pushMatrix();
  translate(800, 140);
  rotate(energy-0.1);
  image(turbine, -100, -100, 200, 200);
  popMatrix();
}

void setupSliders() {

  simulationSlider = new GSlider(this, width-400, height/3, 300, 60, 10);  
  simulationSlider.setLimits(1, 0.5, 2);
  simulationSlider.setNbrTicks(8);
  simulationSlider.setNumberFormat(G4P.DECIMAL, 0);

  uraniumSlider = new GSlider(this, width-400, height/3+200, 300, 60, 10);
  uraniumSlider.setLimits(60, 30, 100);
  uraniumSlider.setNbrTicks(12);
  uraniumSlider.setNumberFormat(G4P.INTEGER, 0);

  neutronSlider = new GSlider(this, width-400, height/3+400, 300, 60, 10);
  neutronSlider.setLimits(5, 1, 10);
  neutronSlider.setNbrTicks(10);
  neutronSlider.setNumberFormat(G4P.INTEGER, 0);

  sliders.add(simulationSlider);
  sliders.add(uraniumSlider);
  sliders.add(neutronSlider);
  for (GSlider gs : sliders) {
    gs.setShowValue(true);
    gs.setShowLimits(true);
    gs.setShowTicks(true);
    gs.setEasing(6.0);
  }
}

void setUraniumNumber(int counter) {
  int atomX, atomY;
  if (counter<atoms.size()) {
    while (atoms.size()-counter>0) {
      atoms.remove(atoms.size()-1);
    }
  } else if (counter>atoms.size()) {
    while (counter-atoms.size()>0) {
      atomX = atoms.size()%10;
      atomY = atoms.size()/10;
      //for (int i = 0; i<10; i++) {
      //  for (int j = 0; j<12; j++) {
      atoms.add(new Atom(143, 92, containerX+20+atomX*70, containerY+20+atomY*20));
      //  }
      //}
    }
  }
  //atoms = new ArrayList<Atom>();
  //int atomX, atomY;
  //while(atoms.size()<counter){
  //  atomX = atoms.size()%10;
  //  atomY = atoms.size()/10;
  ////for (int i = 0; i<10; i++) {
  ////  for (int j = 0; j<12; j++) {
  //    atoms.add(new Atom(143, 92, containerX+20+atomX*70, containerY+20+atomY*20));
  ////  }
  ////}
  //  }
}

void drawPipes() {
  //cold pipe
  strokeWeight(10);
  fill(#999999);
  ellipse((wContainerX+(wContainerWidth)/2), wContainerY, wContainerWidth, wContainerHeight-180);
    fill(#A7D3F0);
  rect(wContainerX,wContainerY,wContainerWidth, wContainerHeight);

  strokeWeight(0);
  int red =45+(int)energy;
  int green=45;
  int blue=45;
  colorMode(RGB, 100);
  fill(red, green, blue);

  rect(width-1095, height-245, 170, 20);
  //hot pipe
  rect(width-1095, height-450, 170, 20);


  //Pipes inside boiler, horizontal
  rect(width-915, height-450, 170, 20);
  //Pipes above water boiler
  rect(width-784, height-1000, 30, 307);
  rect(width-1034, height-1000, 250, 30); 
  rect(width-890, height-370, 147, 20);
  rect(width-915, height-245, 170, 20);
  rect(width-890, height-300, 147, 20);



  //Pipes inside boiler, vertical

  rect(width-763, height-450, 20, 95);
  rect(width-890, height-370, 20, 85);
  rect(width-763, height-290, 20, 60);
  //Pipes above water boiler
  fill(#999999);
  rect(width-784, height-1000, 30, 307);
  rect(width-1034, height-1000, 250, 30);
  rect(wContainerX+5,wContainerY+5, wContainerWidth-10, 100);
  //Water surface
  fill(#649cf5);
  ellipse((wContainerX+5+(wContainerWidth-10)/2), wContainerY+105, wContainerWidth-10, 30);
}

void mousePressed() {
  if(changeSimulation()){
    sim2 = !sim2;
  }
  if(!sim2){
    if (overFire()) {
      fire=true;
    } 
    else if (resetSimulation()) {
      init();
    } else {
      if (overHandle()) {
        lockedOn = true;
      } else {
        lockedOn = false;
      }
      yOffSet = mouseY-handleY;
    }
  }else{
    if (c.overFire()) {
      c.fire=true;
    } else if (c.resetSimulation()) {
      c.init1();
      c.fire = false;
    }
  }
}

void mouseDragged() {
  int y = mouseY;
  y = constrain(y, 520 - containerHeight+yOffSet, 520+yOffSet);
  if (lockedOn) {
    handleY = y - yOffSet;
    for (int i =0; i<controlRods.length; i++) {
      controlRods[i].setY(handleY+handleHeight);
    }
  }
}

void mouseReleased() {
  lockedOn = false;
}
