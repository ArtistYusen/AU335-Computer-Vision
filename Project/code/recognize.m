function licenseNumber = easy(path)

%% 字符分割

    % 灰度、滤波与二值化
    licensePlate = imread(path);
    licensePlateGray = im2gray(licensePlate);
    licensePlateBlur = imgaussfilt(licensePlateGray,8);   
    Threshold = graythresh(licensePlateBlur);
    licensePlateBW = imbinarize(licensePlateBlur,Threshold);

    % 判断是否需要反色处理
    grayAvg = sum(licensePlateBW,"all");
    total = size(licensePlateBW,1)*size(licensePlateBW,2);
    grayPercentageThreshold = .5;
    
    % 新能源汽车需反色
    if grayAvg/total > grayPercentageThreshold
        licensePlateBW = ~licensePlateBW;
    end
    
    % 确定兴趣域
    whiteCountPerRow = sum(licensePlateBW,2);
    regions = whiteCountPerRow > 10; %TODO
    startIdx = find(diff(regions)==1);
    endIdx = find(diff(regions)==-1);
    licenseNumberBW = licensePlateBW(startIdx:endIdx,:);
    licenseNumberROI = licensePlateBW(2:end-1,2:end-1);
    whiteCountPerColumn = sum(licenseNumberROI,1);
    
    % 字符分割及错误分割的处理
    whiteCountPerColumnThreshold = 5;
    wrongDivisionThreshold = 15;

    % 存在字符的区域
    regions = whiteCountPerColumn > whiteCountPerColumnThreshold;
    
    % 处理错误的分割（分割了原子字符）
    startIdx = find(diff(regions)==1);
    endIdx = find(diff(regions)==-1);
    wrongDivisionIdx = find(startIdx(2:end)-endIdx(1:end-1) < wrongDivisionThreshold);
    regions(endIdx(wrongDivisionIdx):startIdx(wrongDivisionIdx+1)) = 1;
    
    % 向后差分判断分割域
    startIdx = find(diff(regions)==1);
    endIdx = find(diff(regions)==-1);
    regions = endIdx-startIdx;
    widthThreshold = mean(regions);

    % 丢弃分隔符
    del = find(regions<widthThreshold);
    startIdx(del) = [];
    endIdx(del) = [];
    regions(del) = [];
    
    %% *字符识别*
    % 导入模板字符
    templateDir = fullfile('./templates');
    templates = dir(fullfile(templateDir,'*.bmp'));
    
    candidateImage = cell(length(templates),2);
    for p=1:length(templates)
        [~,fileName] = fileparts(templates(p).name);
        candidateImage{p,1} = fileName;
        templatesIm = imread(fullfile(templates(p).folder,templates(p).name));
        candidateImage{p,2} = imbinarize(uint8(templatesIm));
    end
    
    % 车牌识别
    licenseNumber = '';
    for p=1:length(regions)
        % Extract the letter
        letterImage = licenseNumberROI(:,startIdx(p):endIdx(p));
        % Compare to templates
        distance = zeros(1,length(templates));
        for t=1:length(templates)    
            candidateImageRe = imresize(candidateImage{t,2},size(letterImage));
            distance(t) = abs(sum((letterImage-candidateImageRe).^2,"all"));
        end
        [~,idx] = min(distance);
        letter = candidateImage{idx,1};
        licenseNumber(end+1) = letter;
    end

    figure,imshow(licensePlate),title(licenseNumber)
    
end