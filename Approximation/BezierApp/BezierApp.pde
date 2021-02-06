/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/GfPJ3Dw6GeY

*/

ArrayList<PVector> points;
ArrayList<PVector> drawingPoints;

float t = 0.0;
Bezier bezier;

boolean bezierIsDrawing = false;

void setup() {
	// size(960, 540);
	fullScreen();

	points = new ArrayList<PVector>();
	drawingPoints = new ArrayList<PVector>();
	bezier = new Bezier();

	strokeWeight(3);
	textAlign(CENTER);
	textSize(14);
}

void draw() {

	background(0);

	fill(#ffffff);
	for(PVector p : points){
		ellipse(p.x, p.y, 12, 12);
	}

	if(bezierIsDrawing){
		t = constrain(t+0.003, 0, 1);
		
		PVector bezierPoint = bezier.displayBezier(points, t);
		if(!drawingPoints.contains(bezierPoint)) drawingPoints.add(bezierPoint);

		stroke(#ff0000);
		noFill();
		beginShape();
		for(PVector p : drawingPoints){
			vertex(p.x, p.y);
		}
		endShape();
	}

	
	fill(#ffffff);
	text("Click on screen to add bezier points, press ENTER to start the simulation, press BACKSPACE to clear the screen. Created by Ivan Vlahov, find me on YouTube!", width/2, 0.98*height);

}

void mouseReleased() {
	if(!bezierIsDrawing) points.add(new PVector(mouseX, mouseY));
}

void keyPressed() {
	if(keyCode == ENTER){
		if(points.size()>1)	bezierIsDrawing = true;
	}

	if(keyCode == BACKSPACE){
		if(t==1.0){
			stroke(#ffffff);
			t = 0.0;
			bezierIsDrawing = false;
			points.clear();
			drawingPoints.clear();
		}
	}
}
