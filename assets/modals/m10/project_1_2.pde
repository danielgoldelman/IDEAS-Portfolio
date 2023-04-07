import java.util.Map;
import controlP5.*;
import java.util.regex.*;

// controlP5 definition
ControlP5 cp5;

ColorPicker cp;

// set starter randomness
float Randomness = 1.25;

// color of the windows
color col;

String hexInput = "FFFFFF";

// line color for the window
color lC = #efd3a4;

// three brick colors
color dBrown = #644511;
color mBrown = #875d17;
color lBrown = #9a6a1a;

// List of the three brick colors
int [] cList = {dBrown, mBrown, lBrown};

void setup () {
  // Change screen size as desired
  size(1200,800); 
  background(255);
  cp5 = new ControlP5(this);
  
  // set randomness of brick layer construction
  cp5.addSlider("Randomness")
    .setPosition(20,20)
    .setRange(0.5,2)
    ;
    
  cp = cp5.addColorPicker("picker")
    .setPosition(20,40)
    .setColorValue(color(125,125,125,255))
    ;
    
  PFont font = createFont("arial",12);
  
  cp5.addTextfield("Hex Input")
     .setPosition(20,105)
     .setSize(100,20)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0,255))
     ;
    
  // apply changes
  cp5.addBang("bang")
    .setPosition(20, 150)
    .setSize(40,40)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("Apply Changes")
    ;
    
  genStorageBricks();
  arch();
}

void draw () {}

public void colorChange(ControlEvent c) {
  if(c.isFrom(cp)) {
    int r = int(c.getArrayValue(0));
    int g = int(c.getArrayValue(1));
    int b = int(c.getArrayValue(2));
    //int a = int(c.getArrayValue(3));
    int a = 255;
    col = color(r,g,b,a);
  }
}

// function to call when the bang is banged
public void bang() {
  charValue();
  genStorageBricks();
  arch();
}

// Note: This function was taken from the internet 
public static boolean isValidHexaCode(String str)
{
    // Regex to check valid hexadecimal color code.
    String regex = "^([A-Fa-f0-9]{6})$";
 
    // Compile the ReGex
    Pattern p = Pattern.compile(regex);
 
    // If the string is empty
    // return false
    if (str == null) {
        return false;
    }
 
    // Pattern class contains matcher() method
    // to find matching between given string
    // and regular expression.
    Matcher m = p.matcher(str);
 
    // Return if the string
    // matched the ReGex
    return m.matches();
}

void charValue(){
  
  if (isValidHexaCode(cp5.get(Textfield.class, "Hex Input").getText())){
    hexInput = cp5.get(Textfield.class, "Hex Input").getText();
    println("YES",hexInput);
  } else {
    cp5.get(Textfield.class, "Hex Input").setText("Nope");
    println("NO",hexInput);
  }
}


// Storage approach to the brick layer
void genStorageBricks(){
  stroke(0);
  strokeWeight(1);
  
  // Hash to remember the value of the brick above
  HashMap<String,int[]> hm = new HashMap<String,int[]>();
  
  int [] firstLayer = new int[(width/16)+1];
  
  // first layer
  int ct1 = 0;
  for (int x = 0; x < width; x += 16){
    int fChoice = cList[int(random(0,3))];
    fill(fChoice);
    firstLayer[ct1] = fChoice;
    ct1 += 1;
    rect(x, 0, 16, 8);
  }
  
  hm.put("line0",firstLayer);
  
  // start of loop to assign the next layer 
  for (int i = 1; i < (height/8)+1; i += 1){
    // list of the current layer initialized as 0s
    int [] newLayer = new int[(width/16)+2];
    int ctNew = 0;
    
    if (i % 2 == 0){
      // even row
      for (int x = 0; x < width; x += 16){
        // gen new choice of brick color 
        int fChoiceNew;
        if (random(2) < Randomness){
          // choose a new color
          if (random(2) < Randomness || ctNew == 0) {
            // Choose from cList
            fChoiceNew = cList[int(random(0,3))];
          } else {
            // assign to previous (left) brick color
            fChoiceNew = newLayer[ctNew-1];
          }
        } else {
          // choose the above brick's color
          fChoiceNew = hm.get("line" + str(i-1))[ctNew];
        }
        // fill brick with this color
        fill(fChoiceNew);
        // put current brick color into the list for this line 
        newLayer[ctNew] = fChoiceNew;
        // increment brick count
        ctNew += 1;
        // draw brick
        rect(x, i*8, 16, 8);
      }
      // place the array into the hashmap
      hm.put("line"+str(i), newLayer);
    } else {
      // odd row
      for (int x = -8; x < width; x += 16){
        int fChoiceNew;
        if (random(2) < Randomness){
          if (random(2) < Randomness || ctNew == 0) {
            fChoiceNew = cList[int(random(0,3))];
          } else {
            fChoiceNew = newLayer[ctNew-1];
          }
        } else {
          fChoiceNew = hm.get("line" + str(i-1))[ctNew];
        }
        fill(fChoiceNew);
        newLayer[ctNew] = fChoiceNew;
        ctNew += 1;
        rect(x, i*8, 16, 8);
      }
      hm.put("line"+str(i), newLayer);
    }
  }   
}



void arch() {
  // middle arch draw
  archBricksLMR(1,2.0);
  archLMR(1,2.0);
  if (width > 900) {
    // left arch draw
    archBricksLMR(1, 4.0);
    archLMR(1, 4.0);
    // right arch draw
    archBricksLMR(3,4.0);
    archLMR(3, 4.0);
  }
}



// Bricks surrounding the arch and window
void archBricksLMR(int mult, float div){
  noStroke();
  
  int col = unhex("FF"+hexInput);
  fill(col);
  circle((mult*width)/div,height/2, 202);
  
  // Bricks are 16*8
  
  rectMode(CORNER);
  float farRight = ((mult*width)/div)+2+75;
  boolean flag = true;
  for (int i = height/2; i < height; i += 8){
    if (flag){
      fill(random(100));
      rect(farRight, i, 16, 8);
      fill(random(100));
      rect(farRight+16, i, 8, 8);
      flag = false;
    } else {
      fill(random(100));
      rect(farRight, i, 8, 8);
      fill(random(100));
      rect(farRight+8, i, 16,8);
      flag = true;
    }
  }
  
  float farLeft = ((mult*width)/div)-75-2;
  for (int i = height/2; i < height; i += 8){
    if (flag){
      fill(random(100));
      rect(farLeft-24, i, 16, 8);
      fill(random(100));
      rect(farLeft-8, i, 8, 8);
      flag = false;
    } else {
      fill(random(100));
      rect(farLeft-24, i, 8, 8);
      fill(random(100));
      rect(farLeft-16, i, 16, 8);
      flag = true;
    }
  }
}

// Arch and window draw
void archLMR(int mult, float div){
  // Window fill
  fill(cp.getColorValue());
  
  stroke(lC);
  strokeWeight(6);
  //big circle => small
  circle((mult*width)/div, height/2, 150);
  strokeWeight(3);
  circle((mult*width)/div, height/2, 115);
  strokeWeight(6);
  circle((mult*width)/div, height/2, 80);
  strokeWeight(3);
  circle((mult*width)/div, height/2, 40);
  
  strokeWeight(6);
  rectMode(CENTER);
  rect((mult*width)/div, 3*height/4, 150, height/2);
  fill(lC);
  rect((mult*width)/div, (height/2)-95, 20, 40);
  
  strokeWeight(3);
  // 90d
  line((mult*width)/div, (height/2)-75, (mult*width)/div, height/2);
  // 70d
  line(((mult*width)/div)+30, (height/2)-70, (mult*width)/div, height/2);
  line(((mult*width)/div)-30, (height/2)-70, (mult*width)/div, height/2);
  // 45d
  line(((mult*width)/div)+50, (height/2)-50, (mult*width)/div, height/2);
  line(((mult*width)/div)-50, (height/2)-50, (mult*width)/div, height/2);
  // 30d
  line(((mult*width)/div)+70, (height/2)-30, (mult*width)/div, height/2);
  line(((mult*width)/div)-70, (height/2)-30, (mult*width)/div, height/2);
  
  // lines inside rect: out to in
  line(((mult*width)/div)-57.5, height/2,((mult*width)/div)-57.5, height);
  line(((mult*width)/div)+57.5, height/2,((mult*width)/div)+57.5, height);
  
  strokeWeight(6);
  line(((mult*width)/div)-40, height/2,((mult*width)/div)-40, height);
  line(((mult*width)/div)+40, height/2,((mult*width)/div)+40, height);
  
  strokeWeight(3);
  line(((mult*width)/div)-20, height/2,((mult*width)/div)-20, height);
  line(((mult*width)/div)+20, height/2,((mult*width)/div)+20, height);
  
  line((mult*width)/div, height/2, (mult*width)/div, height);
  
  // lines inside rect: top to bottom, soft
  for (int i = height/2 + height/16; i < height; i += height/8){
    line(((mult*width)/div)-75, i, ((mult*width)/div)+75, i);
  }
  strokeWeight(4);
  for(int i = height/2 + height/8; i < height; i += height/8){
    line(((mult*width)/div)-75, i, ((mult*width)/div)+75, i);
  } 
}

void keyPressed (){
  String a = str(key);
  a = a + ".jpg";
  save(a);
}

// Generative approach to the brick layer. First attempt at bricks
//void genBricks() {
//  stroke(0);
//  strokeWeight(1);
//  for (int x = 0; x < width; x += 16){
//    for (int y = 0; y < height; y += 16) {
//      fill(cList[int(random(0,3))]);
//      rect(x, y, 16, 8);
//    }
//  }
//  for (int x = -8; x < width; x += 16){
//    for (int y = 8; y < height; y += 16) {
//      fill(cList[int(random(0,3))]);
//      rect(x, y, 16, 8);
//    }
//  }
//}

// Arch and window draw
//void archLines(){
//  // REPLACE THE FILL WITH SOMETHING ELSE
//  fill(255);
  
//  stroke(lC);
//  strokeWeight(6);
//  //big circle => small
//  circle(width/2, height/2, 150);
//  strokeWeight(3);
//  circle(width/2, height/2, 115);
//  strokeWeight(6);
//  circle(width/2, height/2, 80);
//  strokeWeight(3);
//  circle(width/2, height/2, 40);
  
//  strokeWeight(6);
//  rectMode(CENTER);
//  rect(width/2, 3*height/4, 150, height/2);
//  fill(lC);
//  rect(width/2, (height/2)-95, 20, 40);
  
//  strokeWeight(3);
//  // 90d
//  line(width/2, (height/2)-75, width/2, height/2);
//  // 70d
//  line((width/2)+30, (height/2)-70, width/2, height/2);
//  line((width/2)-30, (height/2)-70, width/2, height/2);
//  // 45d
//  line((width/2)+50, (height/2)-50, width/2, height/2);
//  line((width/2)-50, (height/2)-50, width/2, height/2);
//  // 30d
//  line((width/2)+70, (height/2)-30, width/2, height/2);
//  line((width/2)-70, (height/2)-30, width/2, height/2);
  
//  // lines inside rect: out to in
//  line((width/2)-57.5, height/2,(width/2)-57.5, height);
//  line((width/2)+57.5, height/2,(width/2)+57.5, height);
  
//  strokeWeight(6);
//  line((width/2)-40, height/2,(width/2)-40, height);
//  line((width/2)+40, height/2,(width/2)+40, height);
  
//  strokeWeight(3);
//  line((width/2)-20, height/2,(width/2)-20, height);
//  line((width/2)+20, height/2,(width/2)+20, height);
  
//  line(width/2, height/2, width/2, height);
  
//  // lines inside rect: top to bottom, soft
//  for (int i = height/2 + height/16; i < height; i += height/8){
//    line((width/2)-75, i, (width/2)+75, i);
//  }
//  strokeWeight(4);
//  for(int i = height/2 + height/8; i < height; i += height/8){
//    line((width/2)-75, i, (width/2)+75, i);
//  } 
//}

// Bricks surrounding the arch and window
//void archBricks(){
//  fill(0);
//  circle(width/2,height/2, 202);
  
//  // Bricks are 16*8
  
//  noStroke();
//  rectMode(CORNER);
//  int farRight = (width/2)+2+75;
//  boolean flag = true;
//  for (int i = height/2; i < height; i += 8){
//    if (flag){
//      fill(random(100));
//      rect(farRight, i, 16, 8);
//      fill(random(100));
//      rect(farRight+16, i, 8, 8);
//      flag = false;
//    } else {
//      fill(random(100));
//      rect(farRight, i, 8, 8);
//      fill(random(100));
//      rect(farRight+8, i, 16,8);
//      flag = true;
//    }
//  }
  
//  int farLeft = (width/2)-75-2;
//  for (int i = height/2; i < height; i += 8){
//    if (flag){
//      fill(random(100));
//      rect(farLeft-24, i, 16, 8);
//      fill(random(100));
//      rect(farLeft-8, i, 8, 8);
//      flag = false;
//    } else {
//      fill(random(100));
//      rect(farLeft-24, i, 8, 8);
//      fill(random(100));
//      rect(farLeft-16, i, 16, 8);
//      flag = true;
//    }
//  }
//}
