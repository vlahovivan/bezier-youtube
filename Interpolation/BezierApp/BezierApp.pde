/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/GfPJ3Dw6GeY !!! Promini ovo !!!

*/

import Jama.LUDecomposition;
import Jama.Matrix;

ArrayList<PVector> points;
ArrayList<PVector> interpolationPoints;
ArrayList<PVector> drawingPoints;

float t = 0.0;
Bezier bezier;

boolean bezierIsDrawing = false;

void setup() {
	// size(960, 540);
	fullScreen();

	
	points = new ArrayList<PVector>();
	interpolationPoints = new ArrayList<PVector>();
	drawingPoints = new ArrayList<PVector>();
	bezier = new Bezier();

	strokeWeight(3);
	textAlign(CENTER);
	textSize(14);
}

void draw() {

	background(0);
	noStroke();

	fill(#ffffff);
	for(PVector p : points){
		ellipse(p.x, p.y, 12, 12);
	}

	fill(#44ff44);
	for(PVector p : interpolationPoints){
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
	if(!bezierIsDrawing){
		interpolationPoints.add(new PVector(mouseX, mouseY));

		if(interpolationPoints.size() > 1) calculatePoints();
	}
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
			interpolationPoints.clear();
			drawingPoints.clear();
		}
	}
}

void calculatePoints() {
	points.clear();

	int n = interpolationPoints.size();
	double[][] tArr = new double[n][n];

	for(int i=0; i<n; i++){
		tArr[i][n-1] = 1;

		float factor = (float)(i)/(float)(n-1);

		for(int j=n-2; j>=0; j--){
			tArr[i][j] = tArr[i][j+1]*factor;
		}
	}

	double[][] bArr = new double[n][n];

	for(int i=0; i<n; i++){
		bArr[i][n-1] = 0;
		bArr[0][i] = 1;
	}

	for(int j=n-2; j>=0; j--){
		for(int i=1; i<n; i++){
			bArr[i][j] = bArr[i-1][j+1]+bArr[i][j+1];
		}
	}

	for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			bArr[i][j] *= bArr[j][0];
		}
	}

	for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			if((i+j)%2==n%2) bArr[i][j] *= -1;
		}
	}


	double[][] pArr = new double[n][2];

	int pointCnt = 0;
	for(PVector point : interpolationPoints){
		pArr[pointCnt][0] = point.x;
		pArr[pointCnt][1] = point.y;

		pointCnt++;
	}

	Matrix tMatrix = new Matrix(tArr);
	Matrix pMatrix = new Matrix(pArr);

	Matrix kMatrix = tMatrix.inverse().times(pMatrix);

	Matrix bMatrix = new Matrix(bArr);

	Matrix resMatrix = bMatrix.inverse().times(kMatrix);

	for(int i=0; i<n; i++){
		points.add(new PVector((float)resMatrix.get(i, 0), (float)resMatrix.get(i, 1)));
	}

}