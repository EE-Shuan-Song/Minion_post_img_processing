function isinbbox = bbox_in_bbox(bbox1,bbox2)

% this subfunction is to detect if bbox1 is within bbox2
% by default, we assume bbox1 is small and bbox2 is large
% isinbbox is 0-1
% 0 represents "not in bbox"
% 1 represents "in bbox"
% the rest represents the portion of bbox1 in bbox2
% bbox is a bounding box based on regionprops
% bbox1 is the first bounding box to be detected
% bbox2 is the second bounding box


bbox1_x1 = bbox1(1,1) + 0.5; % bbox1 x min
bbox1_y1 = bbox1(1,2) + 0.5; % bbox1 y min
bbox1_x2 = bbox1(1,1) + bbox1(1,3) - 0.5; % bbox1 x max
bbox1_y2 = bbox1(1,2) + bbox1(1,4) - 0.5; % bbox1 y max

bbox2_x1 = bbox2(1,1) + 0.5; % bbox2 x min
bbox2_y1 = bbox2(1,2) + 0.5; % bbox2 y min
bbox2_x2 = bbox2(1,1) + bbox2(1,3) - 0.5; % bbox2 x max
bbox2_y2 = bbox2(1,2) + bbox2(1,4) - 0.5; % bbox2 y max

r_matrix = [(bbox1_x1 >= bbox2_x1)
    (bbox1_x2 <= bbox2_x2)
    (bbox1_y1 >= bbox2_y1)
    (bbox1_y2 <= bbox2_y2)];

if sum(r_matrix) == 4
    isinbbox = 1;
elseif (bbox1_x1 >= bbox2_x1 && bbox1_x1 <= bbox2_x2) || ...
        (bbox1_x2 >= bbox2_x1 && bbox1_x2 <= bbox2_x2)
    if (bbox1_y1 >= bbox2_y1 && bbox1_y1 <= bbox2_y2) || ...
            (bbox1_y2 >= bbox2_y1 && bbox1_y2 <= bbox2_y2)
        w = max([min(bbox1_x2,bbox2_x2) - max(bbox1_x1,bbox2_x1) 0]);
        h = max([min(bbox1_y2,bbox2_y2) - max(bbox1_y1,bbox2_y1) 0]);
        isinbbox = w*h/((bbox1_x2 - bbox1_x1)*(bbox1_y2 - bbox1_y1));
    else
        isinbbox = 0;
    end
else
    isinbbox = 0;
end

end