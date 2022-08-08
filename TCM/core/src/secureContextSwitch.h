/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#ifndef HEADER_FILE_SECURE_CONTEXT_SWITCHER
#define HEADER_FILE_SECURE_CONTEXT_SWITCHER
/**
 * Allow the secure code to perform any back up or cleaning upon interrupt request 
 */
void secureCleaner();

/**
 * Allow the secure code to restore any data or register before resuming its operations
 */
void secureRestorer();
#endif