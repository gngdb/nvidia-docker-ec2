# Installing nvidia-docker on Amazon EC2 

These are a few scripts to take an Amazon EC2 from scratch to running
[nvidia-docker][nd], so that you can easily run [any deep learning
library][kai] (although I have to also provide a modified version of the
[Tensorflow devel-gpu Dockerfile][tensor], as the standard one is not
configured for cuda compute capability of 3.0).

The installation procedure is pretty crude and involves running the three
scripts provided in this repository in sequence, rebooting in between (but
not after the third).

## Starting an Instance

Start either a regular or spot instance, the image this is tested with is
the 64 bit Ubuntu 14.04 image `ami-8446ff93`. If you would like to, you
could fill in the `KeyName` and `SecurityGroupIds` in
`nvidocker-spec.json.template` to start an instance from the command line.
Then, with the aws cli tools installed, you can run the following command
to start a spot instance with a max price of one dollar:

```
aws ec2 request-spot-instances --spot-price 1.00 --instance-count 1 --type one-time --launch-specification file://nvidocker-spec.json
```

If you're not using AWS for anything else, you can also use the following
command to get the public DNS name of _probably_ the instance you just
started (give it a few minutes to start up):

```
aws ec2 describe-instances --query Reservations[0].Instances[0].PublicDnsName
```

Later, I'm going to refer to the address of this instance as `EC2ADDRESS`. 

## Install instructions

First, copy all of the files in this repository to the new machine:

```
scp -i <your-key>.pem * ubuntu@$EC2ADDRESS:~/
```

__Or__, clone this repo while in a shell on the remote machine:

```
git clone https://github.com/gngdb/nvidia-docker-ec2.git
```

Make all the scripts executable:

```
chmod +x ec2-nvidocker-setup-*
```

Then run the three scripts, the first two will trigger reboot upon
finishing:

* `./ec2-nvidocker-setup-1.sh` __REBOOT__
* `./ec2-nvidocker-setup-2.sh` __REBOOT__
* `./ec2-nvidocker-setup-3.sh` 

After the third script you can log out and log back in for the docker group
to operate correctly, or you can just run:

```
newgrp docker
```

## Building the Tensorflow Image

__Warning__: I haven't tested the current version of this Dockerfile, but I
think it should work.

The `devel-gpu` docker image provided by Tensorflow has to be rebuilt with
the `TF_CUDA_COMPUTE_CAPABILITY` environment variable set to 3.0. To do
this, build the docker image using the Dockerfile in this repository:

```
nvidia-docker build -t gngdb/tensorflow:latest-devel-gpu .
```

## All the other deep learning tools

Every other major deep learning library can be pulled from Docker hub
thanks to [kaixhin's great collection of builds for each of them][kai]. So
you can have Caffe, Keras and Theano all running in 10 minutes,
simultaneously, on the same machine. And, if you accidentally break an
install, you can just start a new container.

[nd]: https://github.com/NVIDIA/nvidia-docker 
[kai]: https://github.com/Kaixhin/dockerfiles 
[tensor]: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.devel-gpu
