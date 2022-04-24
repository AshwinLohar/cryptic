# cryptic

A client-side encryption app for cloud storage

# Introduction

Data portability is an important aspect of making personal data readily available for our use where
ever we may need this. Earlier this was done through portable media such as pen drive, portable
HDD, etc. But here there was the inconvenience of physically carrying the portable media. One
could also risk losing the portable media or completely forget to bring it with them completely.
Here, cloud storage is a huge life saver, as we could upload out data to the cloud and have easy
access to it whenever we require out data, from any device connected to the internet.
Cloud storage is very useful as it is a quick and easy way to share files and have high level of ease
of access. The cloud storage is also encrypted so as to protect the data. If the cloud servers are
compromised, the attackers will not be completely successful as they will not have the key to
decrypt the files, thereby keeping your data safe.
But there is one way the attackers can access your data, and that is, if they are able to get your user
credentials. Using these they can access your data just as you would. By this method one would
also not come to know that their data is now not safe and is accessed by someone. One way to
protect against this is to password protect our files. But this is also not very secure as computers
now have high computing capacity and can easily crack the password that you used for encryption.
So, here we have tried to provide a solution for this dilemma by encrypting the files before they
get uploaded to the cloud. 

# Problem Statement

The proposed system encrypts the files before uploading them to the cloud. The encrypted files
key would be with the user adding an extra layer of security as there will be no other way of
decrypting the files. As this is a completely client-side approach there is no third party that can see
you key and has the maximum availability. The files would be decrypted only by using this
application. One can see the files by accessing the cloud be any other method, but would not be
able to identify the name and data of the file as they would be encrypted. 

# Proposed System Algorithm

The algorithm works in mainly 3 phase, file selection, file processing and file saving. The very
first sate consists of the user selecting the file. This might be stored locally or in the cloud. If stored
in the cloud then the user needs to login into the cloud. The Second Stage is of processing the file
where in the file gets either encrypted or decrypted. While encryption 2 algorithms are used in the
following order, Blowfish encryption algorithm and AES encryption algorithm. Decryption
happens in the reverse order. First AES decryption algorithm and then BlowFish decryption
algorithm. The third stage is save the file, it can be either saved locally or can get uploaded to the
cloud. 

# Methodology

The system uses a Hybrid Encryption algorithm that is a combination of AES and Blowfish, for
the encryption and decryption of our files. Form the literature survey we found out the AES
algorithm and Blowfish algorithm are the most suited according to our requirements. This will be
implemented using Flutter as it is a native app development cross platform framework.
The system is developed using Flutter It is done so because this software development toolkit helps
to develop for a wide range of operating systems. Also, it is very easy to create Graphical User
Interfaces also known as GUI using Flutter. There will exist 2 parts to the system:
1. Core: This part will contain all the logic that is related to the core functioning of the system.
This will include all the encryption and decryption related algorithms, the fetch of data
9
from the cloud by the use of API keys, creation of master key, Authentication of the master
key, fetching name and other details about the files stored on the cloud. This part of the
system remains the same irrespective of the Operating system that the application is
running on. This essentially acts as the Back-end for the system.
2. GUI: This part contains the logic that is responsible for taking user inputs and showing the
desired result and navigating through the cloud storage. This is different for each operating
system as they each use different structure for showing data and the fundamental way to
create guide for each is different. This will rely on the core of the system to for the
processing of the data, fetching and uploading the data. This essentially acts as a Front-end
for the system.