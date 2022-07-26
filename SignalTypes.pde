/*
                                Signal Types
                                ------------
   This sketch uses a randomly generated wave (thanks to Daniel Shiffman
   for the inspiration here, https://processing.org/examples/additivewave.html)
   to highlight the differences between an analog and digital signal, as well as,
   a continuous and discrete signal.
*/
 
// Global Constants
final int SAMPLE_PERIOD = 15; 
final int DIGITAL_OFFSET_Y = 150; // The y offset of the two digital plots on bottom
final int DISCRETE_CIRCLE_SIZE = 6; // Size of the circle drawn at each discrete point
final int MAX_WAVES = 10;   // total # of waves to add together
final float GAP = 200; // Buffer on the side and top
final int TEXT_COLOR = #FFFFFF;
final float X_SPACING = 0.5;   // How far apart should each horizontal location be spaced

// Global Variables
float center_x, center_y, theta;
float[] amplitude = new float[MAX_WAVES]; // Height of wave
float[] dx = new float[MAX_WAVES]; // Value for incrementing X, to be calculated as a function of period and xspacing
int w; // Width of entire wave
float[] yvalues; // Using an array to store height values for the wave (not entirely necessary)

void setup() {
  size(1100, 1100);
  pixelDensity(displayDensity());
  frameRate(50);
  
  center_x = width/2;
  center_y = height/2;
  theta = 0;
  
  w = width/4 + 50;

  for (int i = 0; i < MAX_WAVES; i++) {
    amplitude[i] = random(-10, 40);
    float period = random(100,600); // How many pixels before the wave repeats
    dx[i] = (TWO_PI / period) * X_SPACING;
  }

  yvalues = new float[w*2];
  
  stroke(TEXT_COLOR);
  fill(TEXT_COLOR);
} // End of setup()

void draw() {
  background(0);
  drawAxes();
  calcWave();
  renderWave();
  //saveFrame("output3/SignalTypes_####.png");
} // End of draw() 

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // Set all height values to zero
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }
 
  // Accumulate wave height values
  for (int j = 0; j < MAX_WAVES; j++) {
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      // Every other wave is cosine instead of sine
      if (j % 2 == 0)  yvalues[i] += sin(2*x)*amplitude[j];
      else yvalues[i] += cos(2*x)*amplitude[j];
      x+=dx[j];
    }
  }
} // End of calcWave() 

void renderWave() {
  ellipseMode(CENTER);
  for (int i = 1; i < yvalues.length; i++) {
    fill(TEXT_COLOR);
    
    float cont_x_previous = (i-1) * X_SPACING + GAP;
    float cont_x = (i * X_SPACING) + GAP;
    float analog_y = height/2+yvalues[i] - (center_y-GAP)/2;
    float digital_y_previous = height/2+(int(yvalues[i-1]/20)*20)+(center_y-GAP)/2;
    float digital_y = height/2+(int(yvalues[i]/20)*20)+(center_y-GAP)/2;
    
    // Analog, Continuous
    ellipse(cont_x, analog_y, 3, 3);
    
    // Digital, Continuous
    line(cont_x_previous, digital_y_previous, cont_x, digital_y);
    
    // "Sample" the continuous signal
    if (i % SAMPLE_PERIOD == 0){
      noFill();
      
      float discrete_x = i*X_SPACING+center_x+15;
      float y_0 = center_y - (center_y - GAP)/2;
      
      // Analog, Discrete Signal
      line(discrete_x, y_0, discrete_x, analog_y);
      ellipse(discrete_x, analog_y, DISCRETE_CIRCLE_SIZE, DISCRETE_CIRCLE_SIZE);
      
      // Set "0" for y on the digital signal
      y_0 = center_y + (center_y - GAP)/2;
      
      // Digital, Discrete Signal
      line(discrete_x, y_0, discrete_x, digital_y);
      ellipse(discrete_x, digital_y, DISCRETE_CIRCLE_SIZE, DISCRETE_CIRCLE_SIZE);
    }
  }
} // End of renderWave() 

void drawAxes() {
  // X, Y Axes Lines
  stroke(TEXT_COLOR);
  line(GAP, center_y, width - GAP, center_y);
  line(center_x, GAP, center_x, height - GAP);
  
  // Axes Labels
  fill(TEXT_COLOR);
  textSize(25);
  textAlign(CENTER,CENTER);
  text("ANALOG", center_x, GAP - textAscent());
  text("DIGITAL", center_x, height - GAP + textAscent());
  textAlign(RIGHT, CENTER);
  text("CONTINUOUS", GAP - 15, center_y);
  textAlign(LEFT, CENTER);
  text("DISCRETE", width - GAP + 15, center_y);
} // End of drawAxes() 
