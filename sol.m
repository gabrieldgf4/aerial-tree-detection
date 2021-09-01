img = I;

% set the range of the axes
% The image will be stretched to this.
min_x = 0;
max_x = 1;
min_y = 0;
max_y = 1;

y = [410 180] / 601;
x = [440 240] / 601;

% Flip the image upside down before showing it
figure; imagesc([min_x max_x], [min_y max_y], flipdim(img,1));
 
% NOTE: if your image is RGB, you should use flipdim(img, 1) instead of flipud.
 
hold on;
%plot(x,fliplr(y),'b-*','linewidth',1.5);
a = annotation('arrow',x,fliplr(y));
a.Color = 'blue';
a.LineWidth = 2;
a.HeadStyle = 'vback1';
a.HeadWidth = 15;

% set the y-axis back to normal.
set(gca,'ydir','normal');

