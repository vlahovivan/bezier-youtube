/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/GfPJ3Dw6GeY

*/

class Bezier{
	int circR = 12;

	Bezier(){
		println("Bezier created.");
	}

	public PVector displayBezier(ArrayList<PVector> points, float t){
		int n = points.size();
		color c = color(constrain(150+28*n, 150, 255), constrain(100+32*n, 100, 200), constrain(90+36*n, 90, 255));
		stroke(c);
		fill(c);

		if(n==1){
			PVector p1 = points.get(0);

			ellipse(p1.x, p1.y, circR, circR);

			return p1;
		}else{
			ArrayList<PVector> newPoints = new ArrayList<PVector>();
	
			for(int i=1; i<points.size(); i++){
				PVector p1 = points.get(i-1);
				PVector p2 = points.get(i);
	
				line(p1.x, p1.y, p2.x, p2.y);
				ellipse(p1.x, p1.y, circR, circR);
				ellipse(p2.x, p2.y, circR, circR);
	
				newPoints.add(new PVector(p1.x+t*(p2.x-p1.x), p1.y+t*(p2.y-p1.y)));
	
			}
	
			return displayBezier(newPoints, t);
		}
	}

}