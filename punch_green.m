function I2 = punch_green(I)

r = I(:,:,1); g = I(:,:,2); b = I(:,:,3);
mean_g = mean(g(:));
std_g = std(g(:));
punch = (r-g) > 0 & (r-g) < 10 & (g > (mean_g-std_g)) & (g < (mean_g+std_g));
g(punch) = g(punch) + (r(punch) - g(punch)) + 1;
I2 = cat(3,r,g,b);

end