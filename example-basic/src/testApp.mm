#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	ofxiPhoneAlerts.addListener(this);
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT);
	
	//ofSetVerticalSync(true);

	mySmoothLines.setup();
	
}


void testApp::update(){


}

//--------------------------------------------------------------
void testApp::draw(){
	mySmoothLines.draw();
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	if(touch.id == 0)
	{
		mySmoothLines.startLine(touch.x, touch.y);
	}

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	

	if(touch.id == 0)
	{
		mySmoothLines.addVertex(touch.x, touch.y);
	}
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){	
	mySmoothLines.endLine(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	mySmoothLines.clearAllLines();
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

