function im_mean = adaptive_mean(im,static_mask,varargin)

% bug fixed on 06/17/2024

args = matlab.images.internal.stringToChar(varargin);
matlab.images.internal.errorIfgpuArray(im, varargin{:});
[im,options] = parseInputs(im, args{:});
nhoodSize   = options.NeighborhoodSize;
channel = options.Channel;
% method = options.Methods;

if ismatrix(im)
    im_r = im;
else
    switch channel
        case {'r','R'}
            im_r = im(:,:,1);
        case {'g','G'}
            im_r = im(:,:,2);
        case {'b','B'}
            im_r = im(:,:,3);
        otherwise
            error('Unknown channel: %s', options.Channel);
    end
end

im_size = size(im_r);

% nhoodSize = 2*floor(size(im_r)/16) + 1;
padSize = (nhoodSize-1)/2;

switch options.Methods
    case 'replicate'
        im_pad = padarray(im_r,padSize,'replicate','both');
        mask_pad = padarray(static_mask,padSize,'replicate','both');
    case 'circular'
        im_pad = padarray(im_r,padSize,'circular','both');
        mask_pad = padarray(static_mask,padSize,'circular','both');
    case 'symmetric'
        im_pad = padarray(im_r,padSize,'symmetric','both');
        mask_pad = padarray(static_mask,padSize,'symmetric','both');
end


% figure;imshow(im_pad)
% figure;imshow(mask_pad)
int_im = integralImage(im_pad);
int_mask = integralImage(mask_pad);

% calculate the sum within the neighborhood size
im_sum = int_im(1+nhoodSize(1):end,1+nhoodSize(2):end) + int_im(1:im_size(1),1:im_size(2)) ...
    - int_im(1:im_size(1),1+nhoodSize(2):end) - int_im(1+nhoodSize(1):end,1:im_size(2));

mask_sum = int_mask(1+nhoodSize(1):end,1+nhoodSize(2):end) + int_mask(1:im_size(1),1:im_size(2)) ...
    - int_mask(1:im_size(1),1+nhoodSize(2):end) - int_mask(1+nhoodSize(1):end,1:im_size(2));

im_mean = im_sum./mask_sum;
im_mean = im_mean.*static_mask;

end

function [I, options] = parseInputs(I, varargin)
    % Validate the input image
    validateImage(I);

    % Default options
    options = struct(...
        'NeighborhoodSize', 2 * floor(size(I)/16) + 1, ...
        'Channel', 'g', ...
        'Methods', 'replicate');

beginningOfNameVal = find(cellfun(@isstr,varargin),1);

if isempty(beginningOfNameVal) && isempty(varargin)
    % adaptive_mean(im,static_mask)
    return;
elseif beginningOfNameVal == 2
    Value = varargin{1};
    options.NeighborhoodSize = validateNeighborhoodSize(floor(Value/2)*2+1);
    if length(varargin) == 3
        % adaptive_mean(im,static_mask,64,'R','replicate')
        options.Channel = validateChannel(varargin{2});
        options.Methods = validateMethods(varargin{3});
    elseif length(varargin{2}) == 1
        % adaptive_mean(im,static_mask,64,'R')
        options.Channel = validateChannel(varargin{2});
    else
        % adaptive_mean(im,static_mask,64,'replicate')
        options.Methods = validateMethods(varargin{2});
    end
elseif beginningOfNameVal == 1
    if length(varargin) == 2
        % adaptive_mean(im,static_mask,'R','replicate')
        options.Channel = validateChannel(varargin{1});
        options.Methods = validateMethods(varargin{2});
    elseif length(varargin{1}) == 1
        % adaptive_mean(im,static_mask,'R')
        options.Channel = validateChannel(varargin{1});
    else
        % adaptive_mean(im,static_mask,'replicate')
        options.Methods = validateMethods(varargin{1});
    end
elseif isempty(beginningOfNameVal) && length(varargin) == 1
    Value = varargin{1};
    options.NeighborhoodSize = validateNeighborhoodSize(floor(Value/2)*2+1);
else
    error(message('images:validate:tooManyOptionalArgs'));
end

end


function filtSize = validateNeighborhoodSize(filtSize)

filtSize = images.internal.validateTwoDFilterSize(filtSize);

end

function channelOut = validateChannel(channelIn)
    % Validate Channel
    validChannels = {'r', 'g', 'b', 'R', 'G', 'B'};
    if ~ischar(channelIn) && ~isstring(channelIn)
        error('Channel must be a character or string.');
    end
    if ~ismember(channelIn, validChannels)
        error('Invalid channel specified. Choose from ''r'', ''g'', ''b''.');
    end
    channelOut = lower(char(channelIn));
end

function methodOut = validateMethods(methodIn)
    % Validate method
    validMethods = {'circular', 'replicate', 'symmetric', 'Circular', 'Replicate', 'Symmetric'};
    if ~ischar(methodIn) && ~isstring(methodIn)
        error('Channel must be a character or string.');
    end
    if ~ismember(methodIn, validMethods)
        error('Invalid method or channel specified. Choose from ''circular'', ''replicate'', ''symmetric''.');
    end
    methodOut = lower(char(methodIn));
end

function validateImage(I)

supportedClasses = {'uint8','uint16','uint32','int8','int16','int32','single','double'};
supportedAttribs = {'real','nonsparse','3d'};
validateattributes(I,supportedClasses,supportedAttribs,mfilename,'I');

end