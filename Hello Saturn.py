import numpy as np
from numpy import array as v
from numpy.linalg import norm
from math import tan,sin,cos
from scipy import interpolate
from scipy.spatial.transform import Rotation as R
import random
from PIL import Image

width,height=640,360
fov=40
deg=np.pi/180
fw=tan(fov*deg/2)
fh=fw*height/width

random.seed(2)
xs= [i/12-1 for i in range(50)]
ys= [1+random.random() for i in range(50)]
splines = interpolate.splrep(xs,ys)
def tex(vx):
    return interpolate.splev(vx,splines)

def normalize(vec):
    return v(vec)/norm(vec)

def TraceRay(o,n,sd=True):
        
    spheres=[[[0,0,0],1],[[2,1.5,0],.2]]
    c2,r2,R2,n2=[0,0,0],1.5,2.2,[0,0,1]
    l=[cos(3*deg),0,sin(3*deg)]
    
    o,n =v(o),v(n) 
    col,dist,e=0,999,.001
    
    for sp in spheres:
        oc=sp[0]-o
        a=norm(np.cross(oc,n))
        if a<sp[1]:
            ds=np.dot(oc,n)+np.sqrt(sp[1]**2-a**2)*v([-1,1])
            for d in ds:
                if e<d<dist:
                    p=o+n*d
                    if not sd:
                        col=0
                    elif TraceRay(p,l,False)[1]==999:
                        col=0.5*np.dot(l,normalize(p-sp[0]))*tex(p[2])
                    else:
                        col=0
                    dist=d

    a=np.dot(n,n2)
    if abs(a)>e:
        d=np.dot(-o+c2,n2)/a
        p=o+n*d
        if e<d<dist and r2<norm(p-c2)<R2:
            if not sd:
                col=0
            elif TraceRay(p,l,False)[1]==999:
                col=0.25*tex(2*norm(p)-3)
            else:
                col=0
            dist=d

    return [col,dist]

M=v([[cos(60*deg), -sin(60*deg),0],[sin(60*deg),cos(60*deg),0],[0,0,1]]) @ [[1,0,0],[0,cos(60*deg), -sin(60*deg)],[0,sin(60*deg),cos(60*deg)]]
CR=R.from_rotvec(60*deg*v([0, 0, 1])).__mul__(R.from_rotvec(60*deg*v([1, 0, 0])))

pixels=[[TraceRay(CR.apply([0,0,10]),CR.apply(normalize([xcomp,ycomp,-1])))[0] for xcomp in np.linspace(-fw,fw,width)] for ycomp in np.linspace(fh,-fh,height)]

img=Image.fromarray(v(255*v(pixels), dtype=np.uint8))
display(img)