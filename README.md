# Abe-tiny-image

A little bash script, which reduce the size of all images in a folder

## Require
You need to have curl installed to be able to use this script. If you don't
have it just run this command :
```
	sudo apt-get install curl
```

## Installation
Just add this function to your .bashrc file. You can just launch this :
```
	cat tinypng >> ~/.bashrc
```
You need to create a .env file at the root of the project. When you are registerid on
tinypng.com you just have to fill in your apikey in the .env file.

## Utilisation
Go to a folder full of images and then launch the command :
```
	tinypng
```
Let the script works !

Enjoy !
