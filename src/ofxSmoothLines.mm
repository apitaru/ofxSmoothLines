#include "ofxSmoothLines.h"

//--------------------------------------------------------------
void ofxSmoothLines::setup(){
	
	
	_brushImage.loadImage("brushes/BlurryCircleHard.png");
	_brushImage.setImageType(OF_IMAGE_COLOR_ALPHA);
		
	polyLine = ofPolyline();
	rawPolyLine = ofPolyline();
	
	curveNum = 8;
	
}


void ofxSmoothLines::_makeMesh()
{
	
	polyLine.simplify(0.3); // 0.3
	vector<ofPoint> p = polyLine.getVertices();
	
	
	mesh.setMode(OF_PRIMITIVE_TRIANGLES);
	//float w = 0.5;
	//float wBase = 10.5;// 1.5;
	
	int meshNumVerts = mesh.getNumVertices();
	
	for(int k =0; k <  p.size() - 1; k++)  //k < linesToDraw
	{
		
		ofVec3f a = ofVec3f(p[k].x,p[k].y, p[k].z) ;
		ofVec3f b = ofVec3f(p[k+1].x,p[k+1].y, p[k+1].z);
		
		ofVec3f e = (ofVec3f)(b - a).normalize() * lineWidth;//* (w + wBase);
		
		ofVec3f N = ofVec3f(-e.y, e.x, e.z);
		ofVec3f S = -N;
		ofVec3f NE = N + e;
		ofVec3f NW = N - e;
		ofVec3f SW = -NE;
		ofVec3f SE = -NW;
		
		mesh.addVertex(a + SW);
		mesh.addVertex(a + NW);
		mesh.addVertex(a + S);
		mesh.addVertex(a + N);
		mesh.addVertex(b + S);
		mesh.addVertex(b + N);
		mesh.addVertex(b + SE);
		mesh.addVertex(b + NE);
		
		int vertOffest = meshNumVerts + k * 8;
		mesh.addIndex(vertOffest + 0); 	mesh.addIndex(vertOffest +1); 	mesh.addIndex(vertOffest +2);
		mesh.addIndex(vertOffest +2); 	mesh.addIndex(vertOffest +1); 	mesh.addIndex(vertOffest +3);
		mesh.addIndex(vertOffest +2); 	mesh.addIndex(vertOffest +3); 	mesh.addIndex(vertOffest +4);
		mesh.addIndex(vertOffest +4); 	mesh.addIndex(vertOffest +3); 	mesh.addIndex(vertOffest +5);
		mesh.addIndex(vertOffest +4); 	mesh.addIndex(vertOffest +5); 	mesh.addIndex(vertOffest +6);
		mesh.addIndex(vertOffest +6); 	mesh.addIndex(vertOffest +5); 	mesh.addIndex(vertOffest +7);
		
		mesh.addTexCoord(ofVec2f(0,0));
		mesh.addTexCoord(ofVec2f(0,1));
		mesh.addTexCoord(ofVec2f(0.5,0));
		mesh.addTexCoord(ofVec2f(0.5,1));
		mesh.addTexCoord(ofVec2f(0.5,0));
		mesh.addTexCoord(ofVec2f(0.5,1));
		mesh.addTexCoord(ofVec2f(1,0));
		mesh.addTexCoord(ofVec2f(1,1));
		
	}
	
	
	
	
}



//--------------------------------------------------------------
void ofxSmoothLines::draw(){
	
	ofEnableAlphaBlending();
//	img.draw(ofGetWidth() - 20, 20);
	
    if(polyLine.getVertices().size() > 0)
	{
		_makeMesh();
		polyLine.clear();
		
		
		vector <ofPoint> rawPoints = rawPolyLine.getVertices();
		int s = rawPoints.size();
		if (s > 3){
			polyLine.curveTo(rawPoints[s-3], curveNum);
			polyLine.curveTo(rawPoints[s-2], curveNum);
			polyLine.curveTo(rawPoints[s-1], curveNum);
		}
		
	}
	

	_brushImage.getTextureReference().bind();
	mesh.draw();
	_brushImage.getTextureReference().unbind();
	
	ofDisableAlphaBlending();
	//ofDrawBitmapString( ofToString(ofGetFrameRate(), 2), 20, 20);
	
}


void ofxSmoothLines::addPolyVertices(float x, float y, float z)
{
	polyLine.curveTo(x, y, z ,curveNum);
	rawPolyLine.lineTo(x, y, z);
}

//--------------------------------------------------------------
void ofxSmoothLines::startLine(float x, float y, float z){
	
	polyLine.lineTo(x, y, z);
	rawPolyLine.lineTo(x, y, z);
	addPolyVertices(x,y, z);
}

void ofxSmoothLines::continueLine(float x, float y, float z){
	
	addPolyVertices(x,y, z);
}

//--------------------------------------------------------------
void ofxSmoothLines::endLine(float x, float y, float z){
	polyLine.lineTo(x, y, z);
	rawPolyLine.clear();
	polyLine.clear();
}

void ofxSmoothLines::setLineWidth(float w) {
	lineWidth = w;
}
void ofxSmoothLines::setBrushImage(ofImage brushImage){
	_brushImage = brushImage;
	_brushImage.setImageType(OF_IMAGE_COLOR_ALPHA);
}


