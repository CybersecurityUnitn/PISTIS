#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import os, subprocess, sys,os, csv , ntpath
 

from pathlib import Path

if len(sys.argv) < 2:
    print("The number of arguments is inappropriate.\nCorrect syntax is: python {} testDir [destDirDeployables]".format(sys.argv[0]))
    exit(1)

destDirDeployables = ""
if len(sys.argv) > 2:
    destDirDeployables = sys.argv[2]
    if (not Path(destDirDeployables).is_dir()):
        print("The destination directory for deployable files does not exist")
        exit(1)
    else:
        print("Using {} as destination for the output deployable files".format(sys.argv[2]))

#Check whether we are executing the script from the UpdateApplication folder
if (ntpath.basename(os.getcwd()) != "UpdateApplication"):
    print("You must execute this script the UpdateApplication folder")
    exit(1)

#Check whether all of the required files are in the folder
elif(not Path("./src").is_dir() or not Path("./Makefile").is_file()):
    print("You must execute this script from a COMPLETE UpdateApplication folder. Missing 'src/' and/or 'Makefile'")
    exit(1)

testDir=sys.argv[1]
collection = []

#Function that compiles the entire directory
def compileDir(directoryToScan):

    #Cycle through the various applications folders
    for entry in os.scandir(directoryToScan):

        #Compile only non TIBenchmark applications
        if entry.name != "." and entry.name != ".." and entry.name != "TiBenchmark" and entry.is_dir() and entry.name.startswith(".") is not True:
            
            #Clean the current directory
            result = subprocess.run(['make','clean'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
            result = subprocess.run(['rm', 'src/*'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
            os.system('rm src/*')
            print(result)
            print("Compiling " + entry.name)
            
            #Copy all of the application files
            os.system('cp ' + entry.path+"/*.c " + "src/")

            #Make the application
            result = subprocess.run(['make'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
            result = subprocess.run(['make','libraries'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
            result = subprocess.run(['make','clean'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
            result = subprocess.run(['make'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
   
            #The compilation was successfull
            if(result.find("File is") != -1):

                #Retrieve the file size from the makefile output
                start = result.index("File is '") + len("File is '")
                end = start+ result[start:start+20].index("'")
                deployableSizeNew = int(result[start:end])

                #Retrieve the code size from the makefile output
                start = result.index("Code size: '") + len("Code size: '")
                end = start+ result[start:start+20].index("'")
                codeSizeNew = int(result[start:end])

                #Retrieve the flash size from the makefile output
                start = result.index("Flash size: '") + len("Flash size: '")
                end = start+ result[start:start+20].index("'")
                flashSizeNew = int(result[start:end])

                #Retrieve the elf size from the file itself
                elfSizeNew = int(os.stat("appWithNoMetadata.out").st_size) 

                #Copy the files in destination folder
                if destDirDeployables != "":
                    os.system("cp deployable.out {}{}_instrumented.out".format(destDirDeployables,entry.name))

                #Clean the directory and remove the instrumented helper files
                #Compile the application without the instrumentation
                result = subprocess.run(['make','clean'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')
                result = subprocess.run(['rm','src/*.asm'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')

                result = subprocess.run(['make','original'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')

                #Application compiled
                if(result.find("File is") != -1):

                    #Get data as before
                    start = result.index("File is '") + len("File is '")
                    end = start+ result[start:start+20].index("'")
                    deployableSizeOriginal = int(result[start:end])

                    start = result.index("Code size: '") + len("Code size: '")
                    end = start+ result[start:start+20].index("'")
                    codeSizeOriginal = int(result[start:end])

                    start = result.index("Flash size: '") + len("Flash size: '")
                    end = start+ result[start:start+20].index("'")
                    flashSizeOriginal = int(result[start:end])


                    elfSizeOriginal = int(os.stat("appWithNoMetadata.out").st_size) 

                    if destDirDeployables != "":
                        os.system("cp deployable.out {}{}_original.out".format(destDirDeployables,entry.name))
                    
                    #Create archive of various data
                    item = dict()
                    
                    item["name"]=entry.name
                    item["elfNew"] = elfSizeNew
                    item["elfOri"] = elfSizeOriginal
                    item["depNew"] = deployableSizeNew
                    item["depOri"] = deployableSizeOriginal
                    item["codNew"] = codeSizeNew
                    item["codOri"] = codeSizeOriginal
                    item["flsNew"] = flashSizeNew
                    item["flsOri"] = flashSizeOriginal
                    collection.append(item)
                    #print("*********** {} ***********".format(entry.name))
                    #print("NEW: \n\t Elf file: {}; Deployble: {}; Code: {}".format(elfSizeNew,deployableSizeNew,codeSizeNew))
                    #print("OLD: \n\t Elf file: {}; Deployble: {}; Code: {}".format(elfSizeOriginal,deployableSizeOriginal,codeSizeOriginal))
                else:
                    print("build failed")
                    continue
            else:
                print("build failed")
                continue


compileDir(testDir)
compileDir(testDir+"TiBenchmark")
        
#for entryKey in collection:
#    print("\n*********** {} ***********".format(entryKey["name"]))
#    print("NEW: \t Elf file: {}; Deployble: {}; Code: {}".format(entryKey["elfNew"],entryKey["depNew"],entryKey["codNew"]))
#    print("OLD: \t Elf file: {}; Deployble: {}; Code: {}".format(entryKey["elfOri"],entryKey["depOri"],entryKey["codOri"]))

result = subprocess.run(['make','clean'], stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout.decode('utf-8')

#Write results into a csv file!
keys = collection[0].keys()
with open('sizeResult.csv', 'w', newline='')  as output_file:
    dict_writer = csv.DictWriter(output_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(collection)
    print("Create file sizeResult.csv with size info")
