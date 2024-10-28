clear
close all

% validate the background light intensity
% here the background area is changing due to the arrivals of particles
% therefore we mask out the identified particles based on the adaptive
% threshold


load time_info.mat
load background_light.mat
static_mask = imread('static_mask.png');

mask2 = zeros(1944,2592);
mask2(600:1500,900:2100) = 1;

bg_int = zeros(179,1);
bg_int2 = zeros(179,1); % inner region
bg_int3 = zeros(179,1); % outer region

for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int(i,1) = mean(im_red_masked(im_red_masked < 2*im_mean_R)); 

    im_red_masked2 = im_red_masked.*mask2;
    im_red_masked2(im_red_masked2 == 0) = nan;
    bg_int2(i,1) = mean(im_red_masked(im_red_masked2 < 2*im_mean_R));

    im_red_masked3 = im_red_masked.*~mask2;
    im_red_masked3(im_red_masked3 == 0) = nan;
    bg_int3(i,1) = mean(im_red_masked(im_red_masked3 < 2*im_mean_R));
end


figure;
plot(time_TLP,bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int2,'linewidth',2);hold on;
plot(time_TLP,bg_int3,'linewidth',2);hold on;
xlabel('Time')
ylabel('Average BG Intensity(0-255)')
legend('FOV','inner FOV','outer FOV')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

figure;
plot(time_TLP,bg_int./bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int2./bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int3./bg_int,'linewidth',2);hold on;
xlabel('Time')
legend('FOV','inner FOV','outer FOV')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

figure;
plot(time_TLP,bg_int - bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int2 - bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int3 - bg_int,'linewidth',2);hold on;
xlabel('Time')
legend('FOV','inner FOV','outer FOV')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

% the result seems not good but makes sense

bg_int_smooth = smooth(bg_int,11,'lowess');

figure;
plot(time_TLP,bg_int,'linewidth',2);hold on;
plot(time_TLP,bg_int_smooth,'linewidth',2);hold on;
xlabel('Time')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

figure;
plot(time_TLP,bg_int_smooth/bg_int_smooth(1)*100,'linewidth',2);hold on;
xlabel('Time')
ylabel('%')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

