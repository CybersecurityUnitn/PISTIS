#ifndef PINSUTIL_H_
#define PINSUTIL_H_

/* Macros for easy access to the LEDs */
#define __led_init(led) \
        led##_OUT &= ~led; \
        led##_DIR |= led; \
        led##_OUT &= ~led;

#define __led_on(led) led##_OUT |= led;
#define __led_off(led) led##_OUT &= ~led;
#define __led_toggle(led) led##_OUT ^= led;

#define __set_out(port,bit) \
        P##port##DIR |= BIT##bit; \
        P##port##OUT &= ~BIT##bit;

#define __set_in(port,bit) P##port##DIR &= ~BIT##bit;

#define __set(port,bit) P##port##OUT |= BIT##bit;
#define __clr(port,bit) P##port##OUT &= ~BIT##bit;
#define __toggle(port,bit) P##port##OUT ^= BIT##bit;

#endif /* PINSUTIL_H_ */
