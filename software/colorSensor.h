#pragma once

#include <unistd.h>				//Needed for I2C port
#include <fcntl.h>				//Needed for I2C port
#include <sys/ioctl.h>			//Needed for I2C port
#include <linux/i2c-dev.h>		//Needed for I2C port
#include <wiringPi.h>

#include "ISL_29125.h"

#define BBPROX_PIN 3
#define NEAR 0

class Sensor
{
public:
    explicit Sensor(const char* i2c_dev = "/dev/i2c-1");    
    ~Sensor();

    void init();
    void setConfig();
    unsigned int readRed();
    unsigned int readGreen();
    unsigned int readBlue();
    unsigned int dominantColor();

private:
    const char* i2c_dev;
    int file;

    void write8(unsigned char reg, unsigned char data);
    unsigned char read8(unsigned char);  
};

void proxInit(void);
char backboardProx(void);
