#include "tm4c123gh6pm.h"
#include "Systic.h"

void Systick_Init()
{
    NVIC_ST_CTRL_R = 0x00;
    NVIC_ST_RELOAD_R = 0xFFFFFF;
    NVIC_ST_CURRENT_R = 0x00;
    NVIC_ST_CTRL_R = 0x05; // enable ,CLK,disable interrupt
}

void Systic_Delay_ms(unsigned int time_ms)
{
    unsigned int i;
    for (i = 0; i < time_ms; i++)
    {
        Systick_Delay_cycles(16000); // 1 ms delay.
    }
}

void Systick_Delay_cycles(unsigned int delay)
{
    NVIC_ST_RELOAD_R = delay - 1;
    NVIC_ST_CURRENT_R = 0x00;
    while ((NVIC_ST_CTRL_R & 0x10000) == 0)
    {
    }
}

/*
* Initialize the Systick timer to send interrupt every [delay_ms] milliseconds.
*/
void Systick_Interrupt_Init(int delay_ms){
    NVIC_ST_CTRL_R = 0x00;
    NVIC_ST_RELOAD_R = delay_ms*(16000 - 1); // 1 second delay at 16 MHz.
    NVIC_ST_CURRENT_R = 0x00;
    NVIC_ST_CTRL_R = 0x07; // Srt enable ,CLK, interrupt.
}
