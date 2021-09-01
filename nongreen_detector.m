function [I, mask] = nongreen_detector(I)

 I = double(I);
 val = max(I,[],3); 
 mask = I(:,:,2)~=val;
 %imshow(I.*mask);
 I = I.*mask;

end