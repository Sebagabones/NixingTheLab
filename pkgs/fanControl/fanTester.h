//#include "tempChecker.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int fanTester()
{
	char fanspeed;
//	char command[100];
	printf("For best results make sure the systemd service is turned off\n\n");
	printf("Please enter fan speed (between 00 and ff) you want to test noise levels of (int):\n");
	scanf("%s",&fanspeed);
	printf("fanspeed chosen is %d\n", fanspeed);
	// test fan speed
	char continueVal;
	printf("would you like to test another speed(y) or exit(any other key)\n");
	scanf(" %d", &continueVal);
//	fgets(continueVal, sizeof(continueVal), stdin);

//	printf(continueVal);
	if(continueVal == 'y')
	{
		fanTester();
	}
	return 0;
//	if(continueVal == 'n' || continueVal == 'N')
//	{
//		printf("Exiting\n");
//		return 0;
//	}

}
