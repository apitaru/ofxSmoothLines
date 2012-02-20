#include "ofxSmootheLines.h"

//--------------------------------------------------------------
void ofxSmootheLines::setup(){	

	ofFbo::Settings settings; 
	max(ofGetWidth(),ofGetHeight());
	settings.width = max(ofGetWidth(),ofGetHeight());;  
	settings.height = max(ofGetWidth(),ofGetHeight());;  
	settings.internalformat = GL_RGBA;  
	settings.numSamples = 0;  
	settings.useDepth = true;  
	settings.useStencil = true;  
	fbo.allocate(settings);  

	img.loadImage("brushes/BlurryCircle.png");
	img.setImageType(OF_IMAGE_COLOR_ALPHA);
	clearFlag = true;
	lineSizePrev = 0;
	lineSizeNow = 0;
	linesToDraw = 0;
	
	polyLine = ofPolyline();
	rawPolyLine = ofPolyline();
	
	curveNum = 8;

}


void ofxSmootheLines::_makeMesh()
{

	polyLine.simplify(0.3); // 0.3
	vector<ofPoint> p = polyLine.getVertices();
	
	
	mesh.setMode(OF_PRIMITIVE_TRIANGLES);
	float w = 0.5;
	float wBase = 1.5;
	
	for(int k =0; k < p.size() - 1; k++)  //k < linesToDraw
	{

		ofVec2f a = ofVec2f(p[k].x,p[k].y);		
		ofVec2f b = ofVec2f(p[k+1].x,p[k+1].y);	
		
		//w += (ofMap(a.distance(b), 1., 50., 3.5, 0.) - w)/10.; // Wrong because these are simplified verts. Capture external timing. 
		//if(k%3 == 0) 		cout << w << " "; 
		ofVec2f e = (ofVec2f)(b - a).normalize() * (w + wBase);
	
		ofVec2f N = ofVec2f(-e.y, e.x);		
		ofVec2f S = -N;		
		ofVec2f NE = N + e;
		ofVec2f NW = N - e;
		ofVec2f SW = -NE;
		ofVec2f SE = -NW;
		
		
		mesh.addVertex(a + SW);
		mesh.addVertex(a + NW);
		mesh.addVertex(a + S);
		mesh.addVertex(a + N);	
		mesh.addVertex(b + S);	
		mesh.addVertex(b + N);	
		mesh.addVertex(b + SE);	
		mesh.addVertex(b + NE);
		
		int vertOffest = k * 8;
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
void ofxSmootheLines::draw(){

	ofEnableAlphaBlending();
	img.draw(10, 10);

	if(clearFlag)
	{
		fbo.begin();
		ofClear(0,0,0, 1); // we clear the fbo. 
		fbo.end();
	}
	fbo.draw(0,0);
	
	
    if(polyLine.getVertices().size() > 0) 
	{
		_makeMesh();
	}
	
	img.getTextureReference().bind();	
	mesh.draw();
	img.getTextureReference().unbind();
	mesh.clear();
	
	if(polyLine.getVertices().size() > 10)
	{
		drawToFBO();
		vector <ofPoint> rawPoints = rawPolyLine.getVertices();
		int s = rawPoints.size();
		polyLine.curveTo(rawPoints[s-3], curveNum);
		polyLine.curveTo(rawPoints[s-2], curveNum);
		polyLine.curveTo(rawPoints[s-1], curveNum);

	} 		

	ofDisableAlphaBlending();
	ofDrawBitmapString( ofToString(ofGetFrameRate(), 2), 20, 20);

	clearFlag = false;
}

void ofxSmootheLines::drawToFBO()
{	

	fbo.begin();
	ofPushMatrix();

	if (iPhoneGetOrientation() == OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT)
	{
		ofRotate(-90, 0, 0, 1);
		ofTranslate(-1024, 0, 0);
	} else if  (iPhoneGetOrientation() == OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT)
	{
		ofRotate(90, 0, 0, 1);
		ofTranslate(0, -1024, 0);		
	}
	
	
	img.getTextureReference().bind();
	if(polyLine.getVertices().size() > 0) _makeMesh();
	mesh.draw();
	
	img.getTextureReference().unbind();
	ofPopMatrix();	
	fbo.end();
	//activeLineRef->pts.erase(activeLineRef->pts.begin(),activeLineRef->pts.end() - 3);
	mesh.clear();
	polyLine.clear();
	linesToDraw = 0;

}



void ofxSmootheLines::addPolyVertices(float x, float y)
{
	
	vector <ofPoint> rawPoints = rawPolyLine.getVertices();
	int s = rawPoints.size();
	if(s > 0)
	{
		ofPoint p1 = rawPoints[s-1];
		ofVec2f v1; v1.set(p1.x, p1.y);
		ofVec2f v2; v2.set(x, y);
		float d = v2.distance(v1);
		float a = atan2( (v1.y - v2.y),(v1.x - v2.x)) * RAD_TO_DEG;// v2.angle(v1);
		bool b = v2.align(v1);
		cout << "dist: " << d << " " ;
		cout << "angle: " << a << " " ;
		cout << "alinfed: " << b << endl;
	} else {
		if(s < 1)
		{
			
		} else if (s < 2)
		{
			
		} else {
			
		}
	}

	 
	
	polyLine.curveTo(x, y, 0 ,curveNum);	
	rawPolyLine.lineTo(x, y, 0);
	
	
}

//--------------------------------------------------------------
void ofxSmootheLines::startLine(float x, float y){

	polyLine.lineTo(x, y);
	rawPolyLine.lineTo(x, y);		
	addPolyVertices(x,y);	
	linesToDraw++;
}

void ofxSmootheLines::addVertex(float x, float y){
	
		addPolyVertices(x,y);
}

//--------------------------------------------------------------
void ofxSmootheLines::endLine(float x, float y){	
	polyLine.lineTo(x, y, 0);
	rawPolyLine.lineTo(x, y, 0);		
	drawToFBO();
	rawPolyLine.clear();
}

//--------------------------------------------------------------
void ofxSmootheLines::clearAllLines(){	
	clearFlag = true;
}

