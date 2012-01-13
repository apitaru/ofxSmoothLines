#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	ofxiPhoneAlerts.addListener(this);
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	//ofSetVerticalSync(true);

	mySmootheLines.setup();
	
}


void testApp::update(){


}

//--------------------------------------------------------------
void testApp::draw(){
	mySmootheLines.draw();
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	if(touch.id == 0)
	{
		mySmootheLines.startLine(touch.x, touch.y);
	}

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	

	if(touch.id == 0)
	{
		mySmootheLines.addVertex(touch.x, touch.y);
	}
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){	
	mySmootheLines.endLine(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	mySmootheLines.clearAllLines();
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

