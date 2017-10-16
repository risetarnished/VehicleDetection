
function features1 = getBWratio(img)
   % foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
   %     'NumTrainingFrames', 50);
    %foreground = step(foregroundDetector, img);
   foreground = rgb2gray(img);
    image=imresize(foreground, [256 256]);
    imwrite(image, 'temp.jpg');
		blockCount = 1;
		xpixel = 1;
		ypixel = 1;        
		blocksize = 16;
		yblockCount = 1;
		xblockCount = 1;
        features1 = zeros(1,256);
		while (blockCount <= blocksize*blocksize)
			whitepixel = 0;
			blackpixel = 0;
            originalypixel = ypixel;
            originalxpixel = xpixel;
			for i = ypixel:(blocksize*yblockCount)
				for j = xpixel:(blocksize*xblockCount)
					if( image(i,j) <= 128)
                        blackpixel = blackpixel + 1;
                    else 
                        whitepixel = whitepixel + 1;
                    end
				end
            end
            if blackpixel == 0 
                blackpixel = 1;
            end
            if whitepixel == 0
                whitepixel = 1;
            end
            
    
                
            features1(blockCount) = whitepixel / blackpixel;
            
			if xblockCount == blocksize
				xpixel = 1;
				ypixel = blocksize*yblockCount;
				xblockCount = 1;
                yblockCount = yblockCount + 1;
            elseif xblockCount < blocksize
				ypixel = originalypixel;
                xpixel = blocksize*xblockCount;
				xblockCount = xblockCount + 1;
            end
			blockCount = blockCount + 1;						
		end
    %hist(features);
end
