
import processing.serial.*;

import java.awt.geom.Area;
import java.awt.Shape;
import java.awt.geom.Path2D;
import java.awt.geom.Path2D.Float;
import java.awt.geom.Line2D; 
import java.awt.geom.Point2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.PathIterator;
import java.awt.geom.FlatteningPathIterator;
import java.awt.geom.AffineTransform; 
import java.util.List;

Plotter plotter; 

List<Shape> shapes;

float xzoom = 0;
float yzoom =0;
float zoom =1; 
int shapenum = 0; 

float penThickness = 1.5; 

color[] colours = new color[11]; 

void setup() { 
  size(1920, 1080, JAVA2D);
  noSmooth();
  plotter = new Plotter(this, width, height); 
  plotter.connectToSerial("usbserial"); 
  //println(plotter.aspectRatio);
  //surface.setSize((int)(1080*plotter.aspectRatio), 1080);

  colours[0] = #FF4DD6; // pink
  colours[1] = #DE2B30;   // red
  colours[2] = #A05C2F;// light brown
  colours[3] = #744627;  // dark brown
  colours[4] = #266238; // dark green 
  colours[5] = #49AF55; // light green 
  colours[6] = #FFE72E ; // yellow
  colours[7] = #FF8B17 ; // orange
  colours[8] = #6722B2 ; // purple
  colours[9] = #293FB2 ; // navy blue
  colours[10] = #6FC6FF ; // sky blue

  int[] selectedpens = new int[8];
  selectedpens[0] = 3;
  selectedpens[1] = 8;
  selectedpens[2] = 9;
  selectedpens[3] = 5;
  selectedpens[4] = 1;
  selectedpens[5] = 0;
  selectedpens[6] = 6;

  for (int i = 0; i<7; i++) { 
    plotter.setPenColour(i+1, colours[selectedpens[i]]);
  }
  plotter.setPenColour(0, #000000);  

  for (int i = 0; i<8; i++) { 
    plotter.setPenThicknessMM(i, 0.8);
  }

  initGui();

 // makeShapes();
}

void draw() { 

  pushMatrix(); 
  scale(zoom);
  if (zoom==1) {
    xzoom = 0; 
    yzoom = 0;
  }
  xzoom += (constrain(map(mouseX, width*0.1, width*0.9, 0, - width * (zoom-1)/zoom), -width * (zoom-1)/zoom, 0)-xzoom)*0.1; 
  yzoom += (constrain(map(mouseY, height*0.1, height*0.9, 0, - height * (zoom-1)/zoom), -height * (zoom-1)/zoom, 0)-yzoom)*0.1; 
  translate(xzoom, yzoom); 


  background(0);
  noFill(); 

  strokeJoin(ROUND);
  strokeCap(ROUND);

  plotter.update();
  plotter.renderPreview();

  popMatrix();
}

void mousePressed() {
}

void keyPressed() { 

  if (key=='z') {
    zoom = 3-zoom; 
    xzoom += (constrain(map(mouseX, width*0.1, width*0.9, 0, - width * (zoom-1)/zoom), -width * (zoom-1)/zoom, 0)-xzoom); 
    yzoom += (constrain(map(mouseY, height*0.1, height*0.9, 0, - height * (zoom-1)/zoom), -height * (zoom-1)/zoom, 0)-yzoom);
  }
  key = (""+key).toUpperCase().charAt(0);
  println(key);
  if (key == 'H') {
    println("INIT"); 
    //plotter.initHPGL();
  } else if (key == 'P') {
    println("PRINT"); 
    plotter.startPrinting();
  } else if (key == 'C') {
    shapenum = 0;
    for (Shape shape : shapes) {
      fillContour((Shape)shape, (shapenum%7)+1, penThickness, false);
      shapenum++;
    }
  } else if (key == 'S') {
    makeShapes(shapeType, seedValue, happy, stim, plotter.screenWidth, plotter.screenHeight);
   
  } else if (key == '=') {
  } else if (key =='w') {
  } else if (keyCode == RIGHT) {
     typeSlider.setValue(typeSlider.getValue()+1);
  } else if (keyCode == LEFT) {
     typeSlider.setValue(typeSlider.getValue()-1);
  } else if (keyCode == UP) {
     seedSlider.setValue(seedSlider.getValue()+1);
  } else if (keyCode == DOWN) {
     seedSlider.setValue(seedSlider.getValue()-1);
  } else if (key=='l') {
  }
}


void serialEvent(Serial port) { 
  plotter.serialEvent(port);
}