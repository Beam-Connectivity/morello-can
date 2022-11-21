
# Morello Android-Nano Compilation Envrionment

#### Android-Nano compilation image

A docker image is used to compile applications which are then passed on to the morello machine to run.

The image can be built in a 2 step process:
 - Step 1, Build the android environment

		cd docker_build
		docker build --rm=false -t pipeline_android_build:latest \
		--progress="plain" .

 - step 2, Copy the relavent files to small docker container

		cd ../docker_shared
		docker build --rm=false -t pipeline_android_env:latest \
		--progress="plain" .

#### Extracting the Android-Nano OS and firmware

With the docker container ready we can launch it with a shared folder to allow moving files between environments.

		docker run -w /root -v ./docker_shared:/root/docker_shared -it \
		pipeline_android_env:latest bash

In the docker container, the android image and firmware files can be copied to the `docker_shared` folder using the `docker_shared/fetch_morello_files.sh` script.

#### Compilation example, can-utils

The compilation of can-utils can be done by running the `docker_shared/build_can-utils.sh` script. This uses a cmake toolchain file for morello. This probably isn't the best way to do this, but allows easy compilation of projects without needing to change their `CMakeLists.txt` files significantly.

#### Running the binaries on Morello

Once compiled the binaries produces are placed in the "docker_shared/bin" folder which need to be copied over to the morello PC to be run. Once the "android-nano.img" has been flashed on to the morello board, adb can be used to transfer files. Calling the `morello_can/move_files_to_morello.sh` script puts the can-util files in a directory /storage/primary/bin and makes them executable.

On the morello machine with a slcan compliant USB can adapter plugged in, candump can be used to observe the data on a canbus. The file `morello_can/launch_can_dump.sh` shows the steps to do this.
