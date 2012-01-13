#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

class ofxSmootheLines  {
	
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
	void startLine(float x, float y);
	void addVertex(float x, float y);
	void endLine(float x, float y);
	void clearAllLines();

	
private: 
	void _makeMesh();
	void addPolyVertices(float x, float y);
	void drawToFBO();
	
	Boolean clearFlag;
	ofPolyline polyLine;
	ofPolyline rawPolyLine;
	ofFbo fbo;
	ofImage img;
	ofMesh mesh;
	
	int lineSizePrev;
	int lineSizeNow;
	int linesToDraw;
	int curveNum;
};


