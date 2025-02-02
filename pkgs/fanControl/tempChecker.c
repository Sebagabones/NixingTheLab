/*
 * God this is terrible code - I wrote this years ago when I was going through a C is the best thing ever and is totally good for scripting - I now know better
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <stdbool.h>
#include <getopt.h>
/* #include "fanTester.h" */
#define	OPTLIST		"dvh:"
/* #define IPMITOOL_PATH */


bool verbose = false;
bool dryRun = false;
bool fanTest = false;
int seconds = 4;
int temps(int numCores)
{
	FILE *fp;
	char path[1035];
	int coreTemps[numCores];
	fp = popen("sensors", "r");
	if(fp == NULL) {
		exit(1);
	}
	int counter = 0;
	while(fgets(path, sizeof(path), fp) != NULL)
	{
		char* temp = strtok(path, " ");
		if(!strcmp(temp,"Core"))
		{
			temp = strtok(NULL, " ");
			temp = strtok(NULL, " ");
			char temps[10];
			memcpy(temps, &temp[1], 4);
			temps[4] = '\0';
			coreTemps[counter] = atoi(temps);
			counter += 1;
		}

	}
	int check = 0;
	for(int i = 0; i < numCores; ++i)
	{
		if(verbose)
		{
			printf("Core %i (out of %i)is %i\n", i, numCores, coreTemps[i]);
		}
		if(coreTemps[i] >= 65)
		{
			check = 2;
			break;
		}
		if(coreTemps[i] >= 55  && check != 2)
		{
			check = 1;
		}
	}
	if(!dryRun)
	{
		if(check == 2)
		{
			const char *command = "sudo " IPMITOOL_PATH " raw 0x3a 0x07 0x01 0xff 0x01 && sudo" IPMITOOL_PATH " raw 0x3a 0x07 0x02 0xff 0x01";
			system(command);
		}
		else if(check == 1)
		{
			const char *command = "sudo " IPMITOOL_PATH " raw 0x3a 0x07 0x01 0xff 0x00 &&  sudo " IPMITOOL_PATH " raw 0x3a 0x07 0x02 0xff 0x00";
			system(command);
		}
		else
		{
			const char *command = "sudo " IPMITOOL_PATH "raw 0x3a 0x07 0x02 0x30 0x01 && sudo " IPMITOOL_PATH " raw 0x3a 0x07 0x01 0x30 0x01";
			system(command);
		}
	}
	pclose(fp);
	return check;
}


int main(int argc, char * argv[])
{
    int  opt;
    opterr = 0;
    while((opt = getopt(argc, argv, OPTLIST)) != -1)
    {
//  verbose flag option
        if(opt == 'v')
        {
                verbose = true;
                printf("verbose output\n");
        }
		else if(opt == 'h')
		{
			printf("Run with -v for verbose, or -d for a dry run\n");
			exit(0);
		}
		else if(opt == 'd')
		{
			dryRun = true;
			verbose = true;
		}
		else if(opt == 't')
		{
			printf("Testing fan speeds noise levels\n");
			fanTest = true;
		}
		else if(opt == 's')
		{
			seconds = atoi(optarg);
		}
	}
	int fan = 0;
	char cont;
	bool loopVal = true;
	if(fanTest)
	{
		while(loopVal)
		{
		    char fanspeed[3];
			char command[100];
		    printf("\n\n\033[31;1;4mTurning off fanServ.service - (this should turn back on automatically, but if you ctrl + C make sure to turn this back on)\033[0m\n\n");
			system("sudo systemctl stop fanServ.service");
		    printf("Please enter fan speed (between 00 and ff) you want to test noise levels of (hexadecimal):\n");
		    scanf("%s",&fanspeed);
		    printf("fanspeed chosen is %s, testing: \n", fanspeed);
	        snprintf(command, sizeof(command), "sudo ipmitool raw 0x3a 0x07 0x01 0x%s 0x01 && sudo ipmitool raw 0x3a 0x07 0x02 0x%s 0x01",fanspeed, fanspeed);
			printf("%s\n", command);
			printf("\033[31mrunning:\033[0m\n");
	        system(command);
			sleep(seconds);
			printf("\033[32mfinished running\n\033[0m");
		    // test fan speed
		    system("sudo systemctl start fanServ.service");
 			printf("\n\033[31;1;4mRestoring to default fan settings - turning fanServ.service back on\033[0m\n");
		    printf("Would you like to test another speed(y) or exit(any other key)\n");
		    scanf(" %c", &cont);
			if(cont != 'y')
			{
				loopVal = false;
			}
		}
	}

//	else
//	{
//		printf("fan %i\n", fan);
	while(1)
	{
		int numberOfCores = (get_nprocs() / 2);
		if(verbose)
		{
			printf("number of cores is %i\n", numberOfCores);
		}
		int temp = temps(numberOfCores);
		if(verbose)
		{
			if(dryRun)
			{
				printf("Dry run, although I would have run: ");
			}
			else
			{
				printf("Ran ");
			}
			if(temp == 0)
			{
				printf("'sudo ipmitool raw 0x3a 0x07 0x02 0x34 0x01 && sudo ipmitool raw 0x3a 0x07 0x01 0x34 0x01'\n");
				printf("(lowest fan speed)\n");
			}
			else if(temp == 1)
			{
				printf("'sudo ipmitool raw 0x3a 0x07 0x01 0xff 0x00 &&  sudo ipmitool raw 0x3a 0x07 0x02 0xff 0x00'\n");
				printf("(medium fan speed)\n");
			}
			else if(temp == 0)
			{
				printf("'sudo ipmitool raw 0x3a 0x07 0x01 0xff 0x01 && sudo ipmitool raw 0x3a 0x07 0x02 0xff 0x01'\n");
				printf("(highest fan speed)\n");
			}
		}
		/* return 0; */
		sleep(seconds);
	}
	return 0;
}
