import numpy as np
import os
import pathlib
import cv2
import tkinter

directory = os.getcwd()+"/CroppedImages"

def map(value, leftMin, leftMax, rightMin, rightMax):
	# Figure out how 'wide' each range is
	leftSpan = leftMax - leftMin
	rightSpan = rightMax - rightMin

	# Convert the left range into a 0-1 range (float)
	valueScaled = float(value - leftMin) / float(leftSpan)

	# Convert the 0-1 range into a value in the right range.
	return rightMin + (valueScaled * rightSpan)

def translate(fullRes, rightMin, rightMax):
	print(" Fvr : ")
	print(fullRes)

	p = np.array(fullRes)
	newImageBytesRaw = []
	for x in fullRes: 
		clrByte = []
		for y in x:		
			y[0] = map(y[0],0,255,rightMin, rightMax)
			y[1] = map(y[1],0,255,rightMin, rightMax)
			y[2] = map(y[2],0,255,rightMin, rightMax)
			arr = [y[0],y[1],y[2]]
			clrByte.append(arr)
		newImageBytesRaw.append(clrByte)
	print(" Arr : ")
	print(newImageBytesRaw)
	return np.array(newImageBytesRaw)
			


def ResizeWithAspectRatio(image, width=None, height=None, inter=cv2.INTER_AREA):
	dim = None
	(h, w) = image.shape[:2]

	if width is None and height is None:
		return image
	if width is None:
		r = height / float(h)
		dim = (int(w * r), height)
	else:
		r = width / float(w)
		dim = (width, int(h * r))

	return cv2.resize(image, dim, interpolation=inter)

#file name with cion to crop, icon starting XY, left to right gap, top to bottom gap
def cropImage(iconsFileName,LTxy,iconSize,GappXy):
	iconsImg = cv2.imread(iconsFileName,1)
	imgheight = iconsImg.shape[0]
	imgwidth = iconsImg.shape[1]
	vImageCount = round((imgheight-(2*LTxy[1]))/(iconSize[1]+GappXy[1]))
	hImageCount = round((imgwidth-(2*LTxy[0]))/(iconSize[0]+GappXy[0]))
	print(vImageCount," ",hImageCount)
	
	
	downOffset = LTxy[1]
	for i in range(vImageCount):
		rightOffset = LTxy[0]
		for j in range(hImageCount):
			print("Icon : ",i," ",j)
			print(downOffset," ",downOffset+iconSize[1]," ",rightOffset," ",rightOffset+iconSize[0])
			cropped_image = iconsImg[downOffset:downOffset+iconSize[1],rightOffset:rightOffset+iconSize[0]]
			
			if not os.path.exists("./CroppedImages"):
				os.makedirs("./CroppedImages")
			cv2.imwrite("./CroppedImages/im_"+iconsFileName[0:3]+"_"+str(i)+"_"+str(j)+".bmp", cropped_image);
			cropped_image = ResizeWithAspectRatio(cropped_image,width=400)
			cv2.imshow("cropped", cropped_image)
			#cv2.waitKey(0)
			cv2.destroyAllWindows()
			rightOffset += iconSize[0]+GappXy[0]
		downOffset += iconSize[1]+GappXy[1]

def visualizeIcon(data192bbytesRGB):
	rbgCnt = 0
	dataImgPix2d = []
	dataRow = []
	curentRow = 0
	currentCol = 0
	imgH = 8
	imgW = 8
	for i in range(0,len(data192bbytesRGB),3): 
		dataRow.append([data192bbytesRGB[i],data192bbytesRGB[i+1],data192bbytesRGB[i+2]])
		currentCol+=1
		if currentCol==(imgW):
			curentRow+=1
			currentCol = 0
			dataImgPix2d.append(dataRow)
			dataRow = []
		if curentRow==(imgW):
			break
	dataImgPix2d = np.array(dataImgPix2d)
	dataImgPix2d = ResizeWithAspectRatio(dataImgPix2d,width=400)
	cv2.imshow("dataImgPix2d", dataImgPix2d)
	cv2.waitKey(0)
	print(dataImgPix2d)

def exportHeaderFile(directory):
	strFileData = "#ifndef __ICONS_H\n#define __ICONS_H\n\n#ifdef SEPARATE_ARRAY\n\n"
	singleArray = "const uint8_t icnData[][192] = { \n"
	outPutFileName = "icons.h"
	totalBytesExported = 0
	fileList = os.listdir(directory)
	expoRange = [0,150]
	for idxFile,filename in enumerate(fileList):
		f = os.path.join(directory, filename)
		# checking if it is a file
		if os.path.isfile(f):
			if (pathlib.Path(f).suffix == ".bmp"):
				print(f)			
				fullRes = cv2.imread(f,1)
			
				if(fullRes.shape[0] != 8) or (fullRes.shape[1] != 8):
					fullRes = cv2.resize(fullRes, (8,8), interpolation=cv2.INTER_AREA)
				fullRes = translate(fullRes,expoRange[0],expoRange[1])
				p = np.array(fullRes)
				imageBytes = []
				imageBytesRaw = []
				for x in p: 
					for y in x:
						st = '0x%02x, 0x%02x, 0x%02x' % (y[0],y[1],y[2])
						imageBytesRaw.append(y[0])
						imageBytesRaw.append(y[1])
						imageBytesRaw.append(y[2])
						imageBytes.append(st)	
						totalBytesExported += 3
				visualizeIcon(imageBytesRaw)
				varName = str(''.join(e for e in pathlib.Path(f).stem if e.isalnum()))
				strConv = "const uint8_t "+varName+"[] PROGMEM = {\n"
				
				#create separate array
				for idx,x in enumerate(imageBytes):
					strConv += x
					if(idx != len(imageBytes)-1):
						strConv += ", " 
					if ((idx+1)%8 == 0):
						strConv += "\n" 
				strConv += "};"	
				strFileData += strConv + "\n\n"
				
				#create single array structure
				if idxFile!=0:
					singleArray += ",\n"
				singleArray += "{ "
				   
				for idx,x in enumerate(imageBytes):
					singleArray += x
					if(idx != len(imageBytes)-1):
						singleArray += ", " 
					if ((idx+1)%8 == 0):
						singleArray += "\n" 
				singleArray += "}"	
				
				fullRes = ResizeWithAspectRatio(fullRes,width=400)			
				cv2.imshow(f, fullRes)
				#cv2.waitKey(0)
				cv2.destroyWindow(f)
	strFileData += "#else\n\n"
	singleArray += "};\n#endif\n\n#endif\n"
	print(singleArray)
	f = open(outPutFileName,"w")
	f.write(strFileData+singleArray)
	f.close()
	print("Total bytes exported : "+ str(totalBytesExported) +" , "+ str(totalBytesExported/1024)+" Kb")


#cropImage("smil.png",(5,24),(32,32),(20,16))
#cropImage("marvel.png",(10,15),(72,72),(17,17))
exportHeaderFile(directory)