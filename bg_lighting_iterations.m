clear
close all

% bg_lighting with more iterations

load time_info.mat
load background_light.mat
static_mask = imread('static_mask.png');

bg_int = zeros(179,1);
for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int(i,1) = mean(im_red_masked(im_red_masked < 2.5*im_mean_R)); 

    disp(['i=1 &' num2str(i)])
end

bg_int_smooth = smooth(bg_int,11,'lowess');
% p = polyfit(1:179,bg_int,1);
% bg_int_smooth = p(1)*(1:179)+p(2);

figure;
plot(time_TLP,bg_int/bg_int_smooth(1)*100,'.-','linewidth',1);hold on;
plot(time_TLP,bg_int_smooth/bg_int_smooth(1)*100,'linewidth',2);hold on;
legend('','i = 1')
xlabel('time')
ylabel('percentage decrease (%)')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

%% a new iteration
bg_int_i2 = zeros(179,1);
for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int_i2(i,1) = mean(im_red_masked(im_red_masked < 2.5*im_mean_R*bg_int_smooth(i)/bg_int_smooth(1))); 

    disp(['i=2 &' num2str(i)])
end

bg_int_smooth_i2 = smooth(bg_int_i2,11,'lowess');
% p = polyfit(1:179,bg_int_i2,1);
% bg_int_smooth_i2 = p(1)*(1:179)+p(2);

% figure;
% plot(time_TLP,bg_int_i2/bg_int_smooth_i2(1)*100,'.-','linewidth',1);hold on;
% plot(time_TLP,bg_int_smooth_i2/bg_int_smooth_i2(1)*100,'linewidth',2);hold on;
% legend('','i = 2')
% xlabel('time')
% ylabel('percentage decrease (%)')
% set(gca,'fontsize',16,'fontname','Arial')
% set(gcf,'color','white');

%% a new iteration
bg_int_i3 = zeros(179,1);
for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int_i3(i,1) = mean(im_red_masked(im_red_masked < 2.5*im_mean_R*bg_int_smooth_i2(i)/bg_int_smooth_i2(1))); 

    disp(['i=3 &' num2str(i)])
end

bg_int_smooth_i3 = smooth(bg_int_i3,11,'lowess');
% p = polyfit(1:179,bg_int_i3,1);
% bg_int_smooth_i3 = p(1)*(1:179)+p(2);

%% a new iteration
bg_int_i4 = zeros(179,1);
for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int_i4(i,1) = mean(im_red_masked(im_red_masked < 2.5*im_mean_R*bg_int_smooth_i3(i)/bg_int_smooth_i3(1))); 

    disp(['i=4 &' num2str(i)])
end

bg_int_smooth_i4 = smooth(bg_int_i4,11,'lowess');
% p = polyfit(1:179,bg_int_i4,1);
% bg_int_smooth_i4 = p(1)*(1:179)+p(2);

%% a new iteration
bg_int_i5 = zeros(179,1);
for i = 1:179
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    im_red = double(im(:,:,1));
    im_red(im_red == 0) = 0.01;
    im_red_masked = im_red.*static_mask;
    im_red_masked(im_red_masked == 0) = nan;
    bg_int_i5(i,1) = mean(im_red_masked(im_red_masked < 2.5*im_mean_R*bg_int_smooth_i4(i)/bg_int_smooth_i4(1))); 

    disp(['i=5 &' num2str(i)])
end

bg_int_smooth_i5 = smooth(bg_int_i5,11,'lowess');
% p = polyfit(1:179,bg_int_i5,1);
% bg_int_smooth_i5 = p(1)*(1:179)+p(2);



%%

figure;
plot(time_TLP,ones(1,179)*100,'k','linewidth',2);hold on;
plot(time_TLP,bg_int_smooth/bg_int_smooth(1)*100,'linewidth',2);hold on;
plot(time_TLP,bg_int_smooth_i2/bg_int_smooth_i2(1)*100,'linewidth',2);hold on;
plot(time_TLP,bg_int_smooth_i3/bg_int_smooth_i3(1)*100,'linewidth',2);hold on;
plot(time_TLP,bg_int_smooth_i4/bg_int_smooth_i4(1)*100,'linewidth',2);hold on;
plot(time_TLP,bg_int_smooth_i5/bg_int_smooth_i5(1)*100,'linewidth',2);hold on;
legend('i = 0','i = 1','i = 2','i = 3','i = 4','i = 5')
% ylim([70 105])
xlabel('time')
ylabel('percentage decrease (%)')
set(gca,'fontsize',16,'fontname','Arial')
set(gcf,'color','white');

%% test
% 045-001 ==> 87
im_t = imread('minion_pics/045-001-2023-11-28_00-49-11_IMG-TLP.jpg');
im_t = uint8(double(im_t).*static_mask);
im_t_red = im_t(:,:,1);
th1 = bg_int_smooth(87)/bg_int_smooth(1);
th2 = bg_int_smooth_i2(87)/bg_int_smooth_i2(1);
th5 = bg_int_smooth_i5(87)/bg_int_smooth_i5(1);
th6 = th5*2.5*im_mean_R;
th6(th6<255*0.05) = 255*0.05;
mask1 = im_t_red>th1*2*im_mean_R;
mask2 = im_t_red>th2*2*im_mean_R;
mask5 = im_t_red>th5*2*im_mean_R;
mask6 = im_t_red>th6;


im_t_1 = uint8(double(im_t).*mask1);
im_t_2 = uint8(double(im_t).*mask2);
im_t_5 = uint8(double(im_t).*mask5);
im_t_6 = uint8(double(im_t).*mask6);

figure;imshowpair(mask1,mask6);