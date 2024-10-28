clear
close all

% binarization and particle identification

load background_light_smooth.mat
load background_light.mat
load time_info.mat
static_mask = imread("static_mask.png");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw boundary or not
draw_boundary = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TLP dir
TLP_dir = list_TLP(1).folder;

% adaptive threshold
% i1 use 2.5
% i0 use 2
im_t = 2.5*im_mean_R;
% adaptive threshold -- time multiplier
th_time = bg_int_smooth_i5/(bg_int_smooth_i5(1));

Particles = table;
for i = 1:length(list_TLP)
    % read image
    im = imread(fullfile(list_TLP(i).folder,list_TLP(i).name));
    % apply the static mask
    im = uint8(double(im).*static_mask);
    % get the gray image from the red channel
    im_gray = im(:,:,1);
    % complete the binarization
    th = im_t*th_time(i);
    th(th<255*0.05) = 255*0.05; % this line added to avoid too small threshold
    im_bw = im_gray > th;
    % apply the area filter
    bw_A = bwareafilt(im_bw,[50 inf]);
    % remove particles on the edge
    [~,ind] = remove_edge_particle(bw_A,static_mask,0);

    % determine if we want to draw the boundary
    if draw_boundary == 1
        [B,L] = bwboundaries(bw_A,'noholes');
        for k = 1:length(B)
            boundary = B{k};
            for j = 1:length(boundary)
                im(boundary(j,1), boundary(j,2), 1) = 255;
                im(boundary(j,1), boundary(j,2), 2) = 0;
                im(boundary(j,1), boundary(j,2), 3) = 0;
            end
        end
    end

    props = particle_props(i,bw_A,im_gray,im);
    Edges = zeros(height(props),1);
    for k = 1:height(props)
        if ismember(props.Index(k),ind)
            Edges(k,1) = 1;
        end
    end

    Master = zeros(height(props),1);
    for k1 = 1:height(props)
        bbox1 = props.BoundingBox(k1,1:4);
        area_master = 0;
        for k2 = 1:height(props)
            if k2 ~= k1
                bbox2 = props.BoundingBox(k2,1:4);
                isinbbox = bbox_in_bbox(bbox1,bbox2);
                if isinbbox == 1 && props.Area(k2) > area_master
                    Master(k1,1) = k2;
                    area_master = props.Area(k2);
                end
            end
        end
    end

    props = addvars(props,Edges,Master,'After','ColorImage');
    Particles = [Particles;props];

    disp(i);
end

% save('particle_id.mat','Particles')


% 2024/06/19 upload from 2.0 to 2.5 to avoid small particles around the
% edge
% save files as 'particle_id_0619.mat'
