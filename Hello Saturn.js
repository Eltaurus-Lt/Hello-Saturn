//---Saturn Layer---

//CC Sphere
//	Rotation X
transform.xRotation
//	Rotation Y
transform.orientation[1]
//	Light Intensity
thisComp.layer("Light 1").lightOption.intensity
//	Light Color
thisComp.layer("Light 1").lightOption.color
//	Light Height
lightLayerTr=thisComp.layer("Light 1").transform;
lightVec=fromWorldVec(lightLayerTr.position-lightLayerTr.pointOfInterest)
200*Math.atan2(-lightVec[2],Math.sqrt(lightVec[0]*lightVec[0]+lightVec[1]*lightVec[1]))/Math.PI
//	Light Direction
lightLayerTr=thisComp.layer("Light 1").transform;
lightVec=fromWorldVec(lightLayerTr.position-lightLayerTr.pointOfInterest)
180*Math.atan2(-lightVec[0],lightVec[1])/Math.PI+180

//Orientation
xy=thisComp.activeCamera.transform.position-transform.position;
[0,180+radiansToDegrees(Math.atan2(xy[0],xy[2])),0];

//X Rotation
rc=thisComp.activeCamera.transform.position-transform.position;
xz=Math.sqrt(rc[0]*rc[0]+rc[2]*rc[2]);
radiansToDegrees(Math.atan2(rc[1],xz))


//---Drop Shadow Shape Layer---

//Size
R = 2*thisComp.layer("Saturn").effect("CC Sphere")("Radius");
[R,R]

//Position
thisComp.layer("Saturn").transform.position

//Orientation
lightLayerTr=thisComp.layer("Light 1").transform;
lookAt(lightLayerTr.position,lightLayerTr.pointOfInterest)