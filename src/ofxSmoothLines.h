#pragma once

#include "ofMain.h"
#include "ofAppiOSWindow.h"


class ofxSmoothLines  {
	
	struct clr {
		unsigned char r;
		unsigned char g;
		unsigned char b;
		unsigned char a;
	};
	/*
	struct line
	{
		vector <float> pts;	
		vector <float> clrs;
	};
	 */
	
public:
	
	void setup();
	void draw();
	void startLine(float x, float y, float z);
	void continueLine(float x, float y, float z);
	void endLine(float x, float y, float z);
	
	void setBrushImage(ofImage brushImage);
	
	void setLineWidth(float w);
	void clearAllLines();

	
private: 
	void _makeMesh();
	void addPolyVertices(float x, float y, float z);
	
	ofPolyline polyLine;
	ofPolyline rawPolyLine;

	ofImage _brushImage;
	ofMesh mesh;
	
	int curveNum;
	float lineWidth = 2;

	

};


