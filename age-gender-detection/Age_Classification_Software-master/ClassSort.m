function [NextStage] = ClassSort(C,Labels,ConEdge,ConOLPP,EdgeCANNIn,OLPPCANNIn)

%EdgeCSVM,EdgeCANN,OLPPCSVM,OLPPCANN,ANNEdgeOut,ANNOLPPOut,ConfidenceEdge,ConfidenceOLPP
%C(1),EdgeCANN,C(2),OLPPCANN,C(3),C(4),ConEdge,ConOLPP

EdgeANN = (max(EdgeCANNIn)/2)+0.5; 
OLPPANN = (max(OLPPCANNIn)/2)+0.5;
%(Either A or B will always be empty set)
[A,locM1] = find(C==-1); [B,loc1] = find(C==1);

%If all agree 
if isequal(C(1),C(2),C(3),C(4))   
    if C(:) == -1 %Case1
        NextStage = Labels(1);
    elseif C(:) == 1 %Case2
        NextStage = Labels(end);
    end
end
%If discrepencies in agreement 
if length(A) ~= length(C) && length(B) ~= length(C)
    if length(C(A) == -1) > length(C(B) == 1) 
        NextStage = Labels(1);
    elseif length(C(B)==1) > length(C(A)==-1)
        NextStage = Labels(end);
    else
        %Class types
        for i = 1:2
            if locM1(i) == 1 
                ClasType{i,1} = 'EdgeSVM';
            elseif locM1(i) == 2
                ClasType{i,1} = 'OLPPSVM';
            elseif locM1(i) == 3 
                ClasType{i,1} = 'EdgeANN';
            elseif locM1(i) == 4
                ClasType{i,1} = 'OLPPANN';
            end

            if loc1(i) == 1 
                ClasType{i,2} = 'EdgeSVM';
            elseif loc1(i) == 2
                ClasType{i,2} = 'OLPPSVM';
            elseif loc1(i) == 3 
                ClasType{i,2} = 'EdgeANN';
            elseif loc1(i) == 4
                ClasType{i,2} = 'OLPPANN';
            end
        end
        ANNThr = 0.90;
        SVMThr = 0.05;
        
        if strcmp(ClasType{1,1},'EdgeSVM')&&strcmp(ClasType{2,1},'EdgeANN')
            %If corresponding SVM agrees with ANN and wins
            %{
            if ConEdge < 0.4 || ConEdge < 1-ConOLPP
                if EdgeANN > ANNThr && OLPPANN > ANNThr
                    NextStage = Labels(1);
                else
                    if EdgeANN > OLPPANN || EdgeANN == OLPPANN
                        NextStage = Labels(1);
                    else
                        if abs(ConEdge - (1-ConOLPP)) > SVMThr
                            NextStage = Labels(1);
                        else
                            NextStage = Labels(end);
                        end
                    end
                end
            elseif ConOLPP > 0.6 || 1-ConOLPP < ConEdge
                if OLPPANN > ANNThr && EdgeANN > ANNThr
                    NextStage = Labels(end);
                else
                    if OLPPANN > EdgeANN || EdgeANN == OLPPANN
                        NextStage = Labels(end);
                    else
                        if abs((1-ConOLPP)-ConEdge) > SVMThr
                            NextStage = Labels(end);
                        else
                            NextStage = Labels(1);
                        end
                    end
                end
                %}
            if ConEdge < 0.4 || EdgeANN > OLPPANN && EdgeANN == OLPPANN
                if ConEdge < 1-ConOLPP
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            elseif ConOLPP > 0.6 || OLPPANN > EdgeANN && EdgeANN == OLPPANN
                if 1-ConOLPP < ConEdge
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
                
            %If SVM is good but ANN loses Young
            elseif ConEdge < 0.4 && EdgeANN < OLPPANN
                if ConEdge > 1-ConOLPP
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
            %If SVM is bad but ANN wins Young
            elseif ConEdge > 0.4 && EdgeANN > OLPPANN
                if ConEdge < 1-ConOLPP
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            
            %If SVM is good but ANN loses Old
            elseif ConOLPP > 0.6 && OLPPANN < EdgeANN
                if 1-ConOLPP > ConEdge
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            %If SVM is bad but ANN wins Old
            elseif ConOLPP < 0.6 && OLPPANN > EdgeANN
                if 1-ConOLPP < ConEdge
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
                %}
            end            
        end    
        %------------------------------------------------------------------
        if strcmp(ClasType{1,1},'OLPPSVM')&&strcmp(ClasType{2,1},'OLPPANN')
            %If corresponding SVM agrees with ANN and wins
                %{
            if ConOLPP < 0.4 || ConOLPP < 1-ConEdge 
                if OLPPANN > ANNThr && EdgeANN > ANNThr
                    NextStage = Labels(1);
                else
                    if OLPPANN > EdgeANN || EdgeANN == OLPPANN
                        NextStage = Labels(1);
                    else
                        if abs(ConOLPP - (1-ConEdge)) > SVMThr
                            NextStage = Labels(1);
                        else
                            NextStage = Labels(end);
                        end
                    end
                end
            elseif ConEdge > 0.6 || 1-ConEdge < ConOLPP
                if EdgeANN > ANNThr && OLPPANN > ANNThr
                    NextStage = Labels(end);
                else
                    if EdgeANN > OLPPANN || EdgeANN == OLPPANN
                        NextStage = Labels(end);
                    else
                        if abs((1-ConEdge)-ConOLPP) > SVMThr
                            NextStage = Labels(end);
                        else
                            NextStage = Labels(1);
                        end
                    end
                end
                %}
            if ConOLPP < 0.4 && OLPPANN > EdgeANN 
                if ConOLPP < 1-ConEdge
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            elseif ConEdge > 0.6 && EdgeANN > OLPPANN 
                if 1-ConEdge < ConOLPP
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
                
            %If SVM is good but ANN loses Young
            elseif ConOLPP < 0.4 && OLPPANN < EdgeANN
                if ConOLPP > 1-ConEdge
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
            %If SVM is bad but ANN wins Young
            elseif ConOLPP > 0.4 && OLPPANN > EdgeANN
                if ConOLPP < 1-ConEdge
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            
            %If SVM is good but ANN loses Old
            elseif ConEdge > 0.6 && EdgeANN < OLPPANN
                if 1-ConEdge > ConOLPP
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            %If SVM is bad but ANN wins Old
            elseif ConEdge < 0.6 && EdgeANN > OLPPANN
                if 1-ConEdge < ConOLPP
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
                %}
            end
        end  
        %------------------------------------------------------------------
        %When ANNs agree one way and SVMs agree the other
        if strcmp(ClasType{1,1},'EdgeANN') && strcmp(ClasType{2,1},'OLPPANN')
            %if ANNs agree young
            if ConEdge < 0.6 || ConOLPP < 0.6
                NextStage = Labels(1);
            elseif ConEdge > 0.6 || ConOLPP > 0.6
                if EdgeANN > 0.90 && OLPPANN > 0.90
                    NextStage = Labels(1);
                else
                    NextStage = Labels(end);
                end
            end
        elseif strcmp(ClasType{1,1},'EdgeSVM') && strcmp(ClasType{2,1},'OLPPSVM')
            %if SVMs agree young   
            if ConEdge > 0.4 || ConOLPP > 0.4
                if EdgeANN > 0.9 || OLPPANN > 0.9
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end
            elseif ConEdge < 0.4 || ConOLPP < 0.4
                if EdgeANN > 0.90 && OLPPANN > 0.90
                    NextStage = Labels(end);
                else
                    NextStage = Labels(1);
                end                
            end
        end
        %------------------------------------------------------------------
        %When ANN and SVM of different training datas agree
        if strcmp(ClasType{1,1},'OLPPSVM') && strcmp(ClasType{2,1},'EdgeANN')
            %{
            if ConOLPP < 0.4 || ConOLPP < 1-ConEdge
                if EdgeANN > ANNThr && OLPPANN > ANNThr 
                    NextStage = Labels(1);
                else
                    if EdgeANN > OLPPANN || EdgeANN == OLPPANN
                        NextStage = Labels(1);
                    else
                        if abs(ConOLPP - (1-ConEdge)) > SVMThr
                            NextStage = Labels(1);
                        else
                            NextStage = Labels(end);
                        end
                    end
                end
            elseif ConEdge > 0.6 || 1-ConEdge < ConOLPP
                if OLPPANN > ANNThr && EdgeANN > ANNThr
                    NextStage = Labels(end);
                else
                    if OLPPANN > EdgeANN || OLPPANN == EdgeANN
                        NextStage = Labels(end);
                    else
                        if abs((1-ConEdge)-ConOLPP) > SVMThr
                            NextStage = Labels(end);
                        else
                            NextStage = Labels(1);
                        end
                    end
                end
            end
            %}
            
            %if this matchup agrees young
            if ConOLPP < 0.4 && EdgeANN > 0.95
                NextStage = Labels(1);
            else
                NextStage = Labels(end);                
            end
            
            if ConOLPP < 0.4 || EdgeANN > 0.95
                if ConOLPP < 1-ConEdge
                    NextStage = Labels(1);
                elseif ConOLPP > 1-ConEdge
                    NextStage = Labels(end);    
                elseif EdgeANN > OLPPANN
                    NextStage = Labels(end);
                elseif OLPPANN > EdgeANN
                    NextStage = Labels(1);
                    
                elseif ConOLPP < 1-ConEdge && EdgeANN < OLPPANN
                    NextStage = Labels(1);
                elseif ConOLPP > 1-ConEdge && EdgeANN < OLPPANN
                    NextStage = Labels(2);
                end
            else
                NextStage = Labels(end);
            end
            %}
        elseif strcmp(ClasType{1,1},'EdgeSVM') && strcmp(ClasType{2,1},'OLPPANN')
            %{
            if ConEdge < 0.4 || ConEdge < 1-ConOLPP
                if OLPPANN > ANNThr && EdgeANN > ANNThr 
                    NextStage = Labels(1);
                else
                    if OLPPANN > EdgeANN || OLPPANN == EdgeANN
                        NextStage = Labels(1);
                    else
                        if abs(ConEdge - (1-ConOLPP)) > SVMThr
                            NextStage = Labels(1);
                        else
                            NextStage = Labels(end);
                        end
                    end
                end
            elseif ConOLPP > 0.6 || 1-ConOLPP < ConEdge
                if EdgeANN > ANNThr && OLPPANN > ANNThr
                    NextStage = Labels(end);
                else
                    if EdgeANN > OLPPANN || EdgeANN == OLPPANN
                        NextStage = Labels(end);
                    else
                        if abs((1-ConOLPP)-ConEdge) > SVMThr
                            NextStage = Labels(end);
                        else
                            NextStage = Labels(1);
                        end
                    end
                end
            end
            %}
            
            %if this matchup agrees young
            if ConEdge < 0.4 && OLPPANN > 0.95
                NextStage = Labels(1);
            else
                NextStage = Labels(end);                
            end
            
            if ConEdge < 0.4 || OLPPANN > 0.95
                if ConEdge < 1-ConOLPP
                    NextStage = Labels(1);
                elseif ConEdge > 1-ConOLPP
                    NextStage = Labels(end);    
                elseif OLPPANN > EdgeANN
                    NextStage = Labels(end);
                elseif EdgeANN > OLPPANN
                    NextStage = Labels(1);
                    
                elseif ConEdge < 1-ConOLPP && OLPPANN < EdgeANN
                    NextStage = Labels(1);
                elseif ConEdge > 1-ConOLPP && OLPPANN < EdgeANN
                    NextStage = Labels(2);
                end
            else
                NextStage = Labels(end);
            end
            %}
        end
    end
end
end




