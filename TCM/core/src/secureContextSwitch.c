/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
//Function that should clean the RAM
__attribute__((section(".tcm:code"))) void secureCleaner(){
    //Backup and clean
    //TODO implement
    //Serve the interrupt
    __asm("BRA &0x10006");
}

//Function to restore the RAM content
__attribute__((section(".tcm:code"))) void secureRestorer(){
    //TODO implement
    //TODO link with virtual function (return from call?)
}