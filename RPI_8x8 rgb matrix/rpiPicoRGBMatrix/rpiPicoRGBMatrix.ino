#include "NeoPixelConnect.h"
#define MAXIMUM_NUM_NEOPIXELS 64
#include "icons.h"
// Create an instance of NeoPixelConnect and initialize it
// to use GPIO pin 4 (D12) as the control pin, for a string
// of 8 neopixels. Name the instance p
NeoPixelConnect p(4, MAXIMUM_NUM_NEOPIXELS, pio0, 0);

// this array will hold a pixel number and the rgb values for the
// randomly generated pixel values
uint8_t random_pixel_setting[4];

typedef struct clr {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} clr;

// select a random pixel number in the string
uint8_t get_pixel_number() {
  return ((uint16_t)random(0, MAXIMUM_NUM_NEOPIXELS - 1));
}

// select a random intensity
uint8_t get_pixel_intensity() {
  return ((uint8_t)random(0, 255));
}

void get_random_pixel_and_color() {
  random_pixel_setting[0] = get_pixel_number();
  random_pixel_setting[1] = get_pixel_intensity();
  random_pixel_setting[2] = get_pixel_intensity();
  random_pixel_setting[3] = get_pixel_intensity();
}

clr adjustGama(clr c,uint8_t s,uint8_t e)
{
  c.r = map(c.r, 0, 255, s, e);
  c.g = map(c.g, 0, 255, s, e);
  c.b = map(c.b, 0, 255, s, e);
  return c;
}

void setup() {
  Serial.begin(115200);
  delay(2000);
  Serial.println("In setup");
  p.neoPixelClear();
}

void loop() {
  
  for (int i = 0; i < sizeof(icnData)/192; i++) {
    p.neoPixelClear();
    delay(100);
    // const uint8_t *imgPtr = icnData[i];
    clr *c = (clr *)icnData[i];
    // display the randomly assigned pixel and color
    for (int i = 0; i < 64; i++) {
      Serial.print(c[i].r,HEX);
      Serial.print(",");
      Serial.print(c[i].g,HEX);
      Serial.print(",");
      Serial.print(c[i].b,HEX);
      Serial.print(",");
      clr clrGm = adjustGama(c[i],0,50);
      p.neoPixelSetValue(i,
                         clrGm.r,
                         clrGm.g,
                         clrGm.b, false);
    }
    Serial.println("\n");
    p.neoPixelShow();
    delay(1000);
  }
}