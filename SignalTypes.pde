/**
 * Additive Wave
 * by Daniel Shiffman. 
 * 
 * Create a more complex wave by adding two waves together. 
 */
 
float xspacing = 0.5;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int maxwaves = 10;   // total # of waves to add together

int TEXT_COLOR = #FFFFFF;

float center_x, center_y;
float gap = 200;
float theta = 0.0;
float[] amplitude = new float[maxwaves];   // Height of wave
float[] dx = new float[maxwaves];          // Value for incrementing X, to be calculated as a function of period and xspacing
float[] yvalues;                           // Using an array to store height values for the wave (not entirely necessary)

void setup() {
  size(1100, 1100);
  pixelDensity(displayDensity());
  frameRate(50);
  
  center_x = width/2;
  center_y = height/2;
  
  colorMode(RGB, 255, 255, 255, 100);
  w = width/4 + 50;

  for (int i = 0; i < maxwaves; i++) {
    amplitude[i] = random(-10,50);
    float period = random(100,600); // How many pixels before the wave repeats
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new float[w*2];
}

void draw() {
  background(0);
  drawAxes();
  calcWave();
  renderWave();
  //saveFrame("output3/SignalTypes_####.png");
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // Set all height values to zero
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }
 
  // Accumulate wave height values
  for (int j = 0; j < maxwaves; j++) {
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      // Every other wave is cosine instead of sine
      if (j % 2 == 0)  yvalues[i] += sin(2*x)*amplitude[j];
      else yvalues[i] += cos(2*x)*amplitude[j];
      x+=dx[j];
    }
  }
  
}

void renderWave() {
  // A simple way to draw the wave with an ellipse at each location
  noStroke();
  //Maybe change color based on y value
  fill(255,50);
  ellipseMode(CENTER);
  for (int x = 1; x < yvalues.length; x++) {
    fill(255);
    //Analog, Continuous
    ellipse(x*xspacing+gap,height/2+yvalues[x] - (center_y-gap)/2,3,3);
    
    //
    
    fill(255);
    //Maybe make this a line?
    stroke(TEXT_COLOR);
    line((x-1)*xspacing+gap, height/2+(int(yvalues[x-1]/20)*20)+150, x*xspacing+gap, height/2+(int(yvalues[x]/20)*20)+150);
    //ellipse(x*xspacing,height/2+(int(yvalues[x]/20)*20)+150, 5, 5);
    
    if (x % 15 == 0){
      stroke(TEXT_COLOR);
      noFill();
      line(x*xspacing+center_x+15, center_y - (center_y - gap)/2+15, x*xspacing+center_x+15, height/2+yvalues[x] - (center_y-gap)/2+15);
      ellipse(x*xspacing+center_x+15,height/2+yvalues[x] - (center_y-gap)/2+15,6,6);
      
      line(x*xspacing+center_x+15, center_y + (center_y - gap)/2+15, x*xspacing+center_x+15, height/2+(int(yvalues[x]/20)*20)+150+15);
      ellipse(x*xspacing+center_x+15, height/2+(int(yvalues[x]/20)*20)+150+15, 6,6);
    }
  }
  
  //Make this the digital signal.
  //for (int x = 0; x < yvalues.length; x++) {
  //  ellipse(x*xspacing,height/2+yvalues[x]+50,16,16);
  //}
  
}

void drawAxes() {
  stroke(TEXT_COLOR);
  line(gap, center_y, width - gap, center_y);
  line(center_x, gap, center_x, height - gap);
  fill(TEXT_COLOR);
  textSize(25);
  textAlign(CENTER,CENTER);
  text("ANALOG", center_x, gap - textAscent());
  text("DIGITAL", center_x, height - gap + textAscent());
  textAlign(RIGHT, CENTER);
  text("CONTINUOUS", gap - 15, center_y);
  textAlign(LEFT, CENTER);
  text("DISCRETE", width - gap + 15, center_y);
}
