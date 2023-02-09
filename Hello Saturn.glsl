const float fov0=40.;
const vec3 l1=vec3(cos(radians(4.)),0,sin(radians(4.)));
const vec4 sphere[2] = vec4 [2] (vec4(0,0,0,1),vec4(2,1.5,0,.12));
const vec3 n2=vec3(0,0,1); const vec2 rR=vec2(1.5,2.2);
const int SSAA=4;

const float pi=radians(180.);
const float fov=2.*tan(radians(fov0)*.5);
const float e=1e-4;

#define load(P) texelFetch(iChannel0, ivec2(P), 0)
const ivec2 EULEROLD = ivec2(2, 2);
const ivec2 EULER = ivec2(2, 1);

mat3 RM(float psi, float theta) {
    
    float cX = cos(theta);
    float sX = sin(theta);
    float cZ = cos(psi);
    float sZ = sin(psi);
    
    return 
  mat3( 
         cZ, sZ, 0, //wtf
        -sZ, cZ, 0,
          0,  0, 1
)*mat3(
        1,   0,  0,
        0,  cX, sX,
        0, -sX, cX
      );
}

vec4 TraceRay(inout vec3 o, in vec3 p)
{
 vec4 col = vec4(0,0,0,-1);
 vec3 P=l1*1e4,n;
 float a,d,hchord,perp;

 for (int i=0;i<(sphere.length());++i) {
 float m=float(i);

    vec3 center=sphere[i].xyz;
    float incl=radians(15.);
    center=center*cos(.1*iTime)+length(center)*vec3(-.6*cos(incl),.8*cos(incl),sin(incl))*sin(.1*iTime);
    
    a = length(cross(center-o,p)); 
     
     if (a<sphere[i].w) {
     
         perp=dot(center-o,p);
         hchord=sqrt(pow(sphere[i].w,2.)-pow(a,2.));
         d=perp-hchord; if (d<e) {d=perp+hchord;}
            
         if (e<d && (d<col.a || col.a<0.)) { 
             P=o+d*p;
             n=normalize(P-center);
             col=vec4(0.5+.4*m)*dot(n,l1);
             if (i==0) {col*=texelFetch(iChannel1, ivec2(0,.1*iResolution.y*(P.z+1.+.0025*smoothstep(.5,.9,P.z)*sin(6.*atan(P.y,P.x)))), 0);}
             col.a=d;
         }            
     }
 }
 

 a= dot(p,n2);
 
 if (abs(a)>e){
     d=dot(sphere[0].xyz-o,n2)/a; vec3 P1=o+d*p;
         if (e<d && (d<col.a || col.a<0.) && rR.x<length(P1) && rR.y>length(P1)) { 
             P=P1;
             col=vec4(.25);
             col*=texelFetch(iChannel1, ivec2(0,.25*iResolution.y*length(P)), 0);
             col.a=d;
         }  
 }

o=P;
return col;

}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 comp = (fragCoord-.5*iResolution.xy)/iResolution.x;  
    
    vec4 euler=load(EULER);
    float psi=euler.x;
    float theta=euler.y;
    mat3 M=RM(psi,theta);
       
    float ii,jj;
    vec3 O0=M*vec3(0,0,10),O,V;
    vec2 spv;//subpixel vector
    fragColor=vec4(0);  
    
    for (int i=0;i<SSAA;++i) {
    for (int j=0;j<SSAA;++j) { //supersampling loops
          
    O=O0;
    spv=((2.*vec2(i,j)+1.)/float(SSAA)-1.)/(2.*iResolution.x);
    V=M*normalize(vec3(0,0,-1)+fov*vec3(comp+spv,0));   
    fragColor+=clamp(TraceRay(O,V),0.,1.)*step(0.,-TraceRay(O,l1).w);
     
    }}
    
    fragColor/=pow(float(SSAA),2.);
}


