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
int DIGITAL_SAMPLE_PERIOD = 15;
int digital_y_offset = 150;

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
  
  w = width/4 + 50;

  for (int i = 0; i < maxwaves; i++) {
    amplitude[i] = random(-10,40);
    amplitude[i] = 0;
    float period = random(100,600); // How many pixels before the wave repeats
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new float[w*2];
  
  stroke(TEXT_COLOR);
  fill(TEXT_COLOR);
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
  
  ellipseMode(CENTER);
  for (int x = 1; x < yvalues.length; x++) {
    fill(TEXT_COLOR);
    
    //Analog, Continuous
    ellipse(x*xspacing+gap,height/2+yvalues[x] - (center_y-gap)/2,3,3);
    
    // Digital, Continuous
    line((x-1)*xspacing+gap, height/2+(int(yvalues[x-1]/20)*20)+(center_y-gap)/2, x*xspacing+gap, height/2+(int(yvalues[x]/20)*20)+(center_y-gap)/2);
    
    
    if (x % DIGITAL_SAMPLE_PERIOD == 0){
      noFill();
      
      // Discrete, Analog Signal
      line(x*xspacing+center_x+15, center_y - (center_y - gap)/2, x*xspacing+center_x+15, height/2+yvalues[x] - (center_y-gap)/2);
      ellipse(x*xspacing+center_x+15,height/2+yvalues[x] - (center_y-gap)/2,6,6);
      
      // Discrete, Digital Signal
      line(x*xspacing+center_x+15, center_y + (center_y - gap)/2, x*xspacing+center_x+15, height/2+(int(yvalues[x]/20)*20)+(center_y-gap)/2);
      ellipse(x*xspacing+center_x+15, height/2+(int(yvalues[x]/20)*20)+(center_y-gap)/2, 6,6);
    }
  }
  
}

void drawAxes() {
  // X, Y Axes Lines
  stroke(TEXT_COLOR);
  line(gap, center_y, width - gap, center_y);
  line(center_x, gap, center_x, height - gap);
  
  // Axes Labels
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
