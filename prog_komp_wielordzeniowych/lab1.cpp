#include "omp.h"   // OpenMP project
#include <iostream>
#include <math.h>
double a[1000000];

int main()
{
	double start, end;
	for (int j = 1; j <= 16; j <<= 1)   // przesuwanie o 1 bit w lewo w kazdej iteracji
	{
		omp_set_num_threads(j);
		start = omp_get_wtime();
		#pragma omp parallel   // specify the code between the curly brackets is part of an OpenMP parallel section
		for (int i = 0; i < 1000000; i++)
			a[i] = 0.1 * sin(a[i]);
		end = omp_get_wtime();
		std::cout << "Time for " << j << " threads: "<< end-start << std::endl;
	}
}

// kompilacja: g++ -fopenmp lab1.cpp -o lab1.out
