PImage enhanceContrast(PImage orig, float parameter) {
  PImage img = createImage(orig.width, orig.height, RGB);
  img.copy(orig, 0, 0, orig.width, orig.height, 0, 0, orig.width, orig.height);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    float avg = (red(img.pixels[i]) + green(img.pixels[i]) + blue(img.pixels[i])) / 3.0;
    avg = (((avg - 128) * parameter) + 128);
    avg = constrain(avg, 0, 255);
    img.pixels[i] = color(avg);
  }
  img.updatePixels();
  return img;
}