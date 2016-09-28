%--------------------------------------------------------------------------
%Complete system
%--------------------------------------------------------------------------

clear all; close all; clc;

MAC = ismac;
LINUX = isunix;
WINDOWS = ispc;

if MAC || LINUX == 1
    dir_content = dir;
elseif WINDOWS == 1
    dir_content = dir;
end

filenames = {dir_content.name};
current_files = filenames;
while true
    if MAC || LINUX == 1
        dir_content = dir;
    elseif WINDOWS == 1
        dir_content = dir;
    end
    
    filenames = {dir_content.name};
    new_files = setdiff(filenames,current_files);
    if ~isempty(new_files)
        pause off;
        disp('Estimating... ');
        Imtemp = imread(sprintf('%s',new_files{1,1}));

        Im = rgb2gray(Imtemp);
        RaceRanges{1,1} = 1:9;  %Black
        RaceRanges{1,2} = 10:18; %White
        files = dir('*.mat');

        %% Load in image and perform Normalisation and race detection

        [Normalised0,ERROR] = ImNormalise(Im);
        AgeShow = cell(size(Normalised0,1),1);
        size(Normalised0)
        for i = 1:size(Normalised0,1)
            Normalised = Normalised0{i};
        
            if ERROR == 1
                disp('Normalisation error. Enter new photo')
                break;
            end

            Race = SortRace(Normalised);
            %Race = 'White';            %remove comment to force desired race
                                    %can be either 'White' or 'Black'
            if strcmp(Race,'Black')
                for j = RaceRanges{1,1}
                    eval(['load ' files(j).name]);
                end
            elseif strcmp(Race,'White')
                for j = RaceRanges{1,2}
                    eval(['load ' files(j).name]);
                end
            end
            %% Classify
            Stage = 1; 
            Break = 0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %First Stage
            [C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP] ... 
                = SystemClassify(Normalised,eigvectEdges{1,1},eigvectOLPP{1,1}, ... 
                OLPPnet{1,1},Edgesnet{1,1},modelsEdges{1,1},modelsOLPP{1,1});

            Stage = ClassSort(C,SVMLabelsOLPP{Stage,1},ConEdge,ConOLPP,EdgeCANN,OLPPCANN);
            if Stage == 16
                Stage = 2;
            elseif Stage == 50
                Stage = 16;
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Second Stage
            [C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP] ... 
                = SystemClassify(Normalised,eigvectEdges{Stage,1},eigvectOLPP{Stage,1}, ... 
                OLPPnet{Stage,1},Edgesnet{Stage,1},modelsEdges{Stage,1},modelsOLPP{Stage,1});

            Stage = ClassSort(C,SVMLabelsOLPP{Stage,1},ConEdge,ConOLPP,EdgeCANN,OLPPCANN);

            if Stage == 16
                Stage = 3;
            elseif Stage == 35
                Stage = 9;
            elseif Stage == 30 
                Stage = 17;
            elseif Stage == 50
                Stage = 18;
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Third Stage
            [C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP] ... 
             = SystemClassify(Normalised,eigvectEdges{Stage,1},eigvectOLPP{Stage,1}, ... 
                OLPPnet{Stage,1},Edgesnet{Stage,1},modelsEdges{Stage,1},modelsOLPP{Stage,1});

            Stage = ClassSort(C,SVMLabelsOLPP{Stage,1},ConEdge,ConOLPP,EdgeCANN,OLPPCANN);  

            if Stage == 16
                Stage = 4;
            elseif Stage == 25
                Stage = 6;
            elseif Stage == 26
                Stage = 10;
            elseif Stage == 35
                Stage = 11;

            elseif Stage == 30
                Stage = 19;
            elseif Stage == 40
                Stage = 20;
            elseif Stage == 41
                Stage = 21;
            elseif Stage == 50
                Stage = 22;
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Fourth Stage
            [C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP] ... 
                = SystemClassify(Normalised,eigvectEdges{Stage,1},eigvectOLPP{Stage,1}, ... 
                OLPPnet{Stage,1},Edgesnet{Stage,1},modelsEdges{Stage,1},modelsOLPP{Stage,1});

            Stage = ClassSort(C,SVMLabelsOLPP{Stage,1},ConEdge,ConOLPP,EdgeCANN,OLPPCANN);

            if Stage == 16  
                Stage = 5;
            elseif Stage == 21
                Stage = 7;
            elseif Stage == 25
                Stage = 8;

            elseif Stage == 26
                Stage = 12;
            elseif Stage == 30
                Stage = 13;
            elseif Stage == 31
                Stage = 14;
            elseif Stage == 35
                Stage = 15;

            elseif Stage == 31 || Stage == 35 || Stage == 36 || Stage == 40
                AgeEst = Stage;
                Break = 1;   
            elseif Stage == 20 || Stage == 41 || Stage ==  45 
                AgeEst = Stage;
                Break = 1; 
            elseif Stage == 46 || Stage == 50
                AgeEst = Stage;
                Break = 1; 
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if Break == 0
                %Fifth Stage
                [C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP] ... 
                    = SystemClassify(Normalised,eigvectEdges{Stage,1},eigvectOLPP{Stage,1}, ... 
                    OLPPnet{Stage,1},Edgesnet{Stage,1},modelsEdges{Stage,1},modelsOLPP{Stage,1});

                Stage = ClassSort(C,SVMLabelsOLPP{Stage,1},ConEdge,ConOLPP,EdgeCANN,OLPPCANN);

                %This one ends here
                if Stage == 16 || Stage == 18
                    AgeEst = Stage;

                elseif Stage == 21 || Stage == 23 || Stage == 24 
                    AgeEst = Stage;

                elseif Stage == 26 || Stage == 28 || Stage == 30
                    AgeEst = Stage;

                elseif Stage == 31 || Stage == 33 || Stage == 35
                    AgeEst = Stage;
                end
            end
        %% Display Image with result
            if strcmp('Black',Race)
                Race_2 = 'African-American';
            elseif strcmp('White',Race)
                Race_2 = 'Caucasion';
            end
            AgeShow{i} = ['Age = ' num2str(AgeEst) ' Race = ' Race_2];
        end
        face_detector = vision.CascadeObjectDetector('FrontalFaceCART');
        face = step(face_detector,Im);
        IFaces = insertObjectAnnotation(Imtemp,'rectangle', ...
            face,AgeShow,'FontSize',15);
        
        figure; imshow(IFaces);
        
        disp(' ');
        current_files = filenames;
    else
        disp('Copy an image to the working directory');
        disp('and press any key to estimate the age');
        disp(' ');
        disp('Or, press ctrl-c to quit anytime');
        disp(' ');
        
        pause on;
        pause;
    end
end
