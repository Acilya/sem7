#include "omp.h"
#include <stdio.h>
#include <math.h>
int main()
{
    int iX,iY;
    int i;
    const int iXmax = 400; 
    const int iYmax = 400;

    double Cx,Cy;
    const double CxMin=-2.5;
    const double CxMax=1.5;
    const double CyMin=-2.0;
    const double CyMax=2.0;
   
    double PixelWidth=(CxMax-CxMin)/iXmax;
    double PixelHeight=(CyMax-CyMin)/iYmax;

    const int MaxColorComponentValue=255; 
    FILE * fp;
    char *filename="new1.ppm";
    char *comment="# ";
    unsigned char color[iXmax*iYmax][3];
   
    double Zx, Zy;
    double Zx2, Zy2; 
    
    int Iteration;
    const int IterationMax=100;
    const double EscapeRadius=2;
    double ER2=EscapeRadius*EscapeRadius;
  
    fp= fopen(filename,"wb"); 
    fprintf(fp,"P6\n %s\n %d\n %d\n %d\n",comment,iXmax,iYmax,MaxColorComponentValue);
 
    int counter;
  
    int threads = 8;
    omp_set_num_threads(threads);
    double start = omp_get_wtime();

    #pragma omp parallel for shared(color) private(counter, Zx2, Zy2, Zx, Zy, Cx, Cy, iY, iX, Iteration)
    for(iY=0;iY<iYmax;iY++)
    {
        Cy=CyMin + iY*PixelHeight;
        if (fabs(Cy)< PixelHeight/2) 
            Cy=0.0; 
        for(iX=0;iX<iXmax;iX++)
        {         
            counter = iY * iXmax + iX;  
            Cx=CxMin + iX*PixelWidth;
            Zx=0.0;
            Zy=0.0;
            Zx2=Zx*Zx;
            Zy2=Zy*Zy;
            for (Iteration=0;Iteration<IterationMax && ((Zx2+Zy2)<ER2);Iteration++)
            {
                Zy=2*Zx*Zy + Cy;
                Zx=Zx2-Zy2 +Cx;
                Zx2=Zx*Zx;
                Zy2=Zy*Zy;
            };
            if (Iteration==IterationMax)
            { 
                color[counter][0]=0;
                color[counter][1]=0;
                color[counter][2]=0;      
            }
            else 
            { 
                color[counter][0]=255; 
                color[counter][1]=255;  
                color[counter][2]=255;
            };
        }
    }
  
    double end = omp_get_wtime();
    printf("Time for %d threads: %f\n", threads, end-start);
  
    fwrite(color, 1, iXmax * iYmax * 3, fp);
    fclose(fp);
  
    return 0;
}