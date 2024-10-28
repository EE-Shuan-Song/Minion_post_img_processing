function [BW2,ind] = remove_edge_particle(BW,static_mask,varargin)
% clean particles at the edge who share the boundary with the mask
% if a large portion of particle area is out of mask, we should not
% consider those particles.
% ind represents the index/labels removed from the raw image

% if option = 1, the cutoff threshold will be the number of equivalent
% diameter
% if option = 0, the cutoff will be 5 pixels

BW = imfill(BW,'holes');
ind = [];

args = convertStringsToChars(varargin);

if isempty(args) 
    Cutoff = 0;
elseif args{1} == 1
    Cutoff = 1;
elseif args{1} == 0
    Cutoff = 0;
else
    error('options have to be 0 or 1');
end

BW_perim = bwperim(static_mask);

[Labels,n] = bwlabel(BW);
p_Area = zeros(n,1);
for i = 1:n
    p_Area(i) = sum(Labels(:) == i);
end

Label_perim = double(Labels).*(-1.*double(BW_perim));
Labels2 = Labels + Label_perim;

p2_Area = zeros(n,1);
for i = 1:n
    p2_Area(i) = sum(Labels2(:) == i);
end

if Cutoff == 1
    for i = 1:n
        if p_Area(i) - p2_Area(i) > sqrt(4*p_Area(i)/pi)
            Labels(Labels == i) = 0;
            ind = [ind;i];
        end
    end
elseif Cutoff == 0
    for i = 1:n
        if p_Area(i) - p2_Area(i) > 5
            Labels(Labels == i) = 0;
            ind = [ind;i];
        end
    end
end

BW2 = Labels > 0;

end
