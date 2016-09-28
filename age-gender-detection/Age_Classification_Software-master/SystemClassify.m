function [EdgeCSVM,EdgeCANN,OLPPCSVM,OLPPCANN,ANNEdgeOut,ANNOLPPOut,ConfidenceEdge,ConfidenceOLPP,time] ... 
    = SystemClassify(Image,eigvectEdges,eigvectOLPP,OLPPNet,EdgeNet,EdgeSVM,OLPPSVM)
tic;
EdgeCSVM = 10;
OLPPCSVM = 10;

%dir1 = 'C:\Documents and Settings\user3\My Documents\CODING_MAC\Design4BCode';
%dir2 = 'C:\Documents and Settings\user3\My Documents\CODING_MAC\MATLAB Functions';
Thresh = 200;

%Edge Detection
Sharp = imsharpen(Image,'Radius',3,'Amount',2);
Hist = histeq(Sharp); 
%cd(sprintf('%s',dir2));   
[Img,~,~] = SobelEdgeDetectSpacial_lq(Hist,Thresh);
Img = im2double(imresize(Img,[90 90]));
temp = im2double(~Img);
ImEdge = reshape(temp,1,size(temp,1)*size(temp,2));

%OLPP
ImOLPP = im2double(reshape(Image,1,8100));

%Arrange classifers
ImEdgeC = ImEdge*eigvectEdges;
ImOLPPC = ImOLPP*eigvectOLPP;  

%ANN
EdgeCANN = EdgeNet(ImEdgeC'); 
if EdgeCANN(1)>EdgeCANN(2)
    ANNEdgeOut = -1;
else
    ANNEdgeOut = 1;
end
OLPPCANN = OLPPNet(ImOLPPC');
if OLPPCANN(1)>OLPPCANN(2)
    ANNOLPPOut = -1;
else
    ANNOLPPOut = 1;
end

%SVM
EdgeCSVM = svmclassify(EdgeSVM,ImEdgeC);
    SampleScaleShift = bsxfun(@plus,ImEdgeC,EdgeSVM.ScaleData.shift);
    ImEdgeC = bsxfun(@times,SampleScaleShift,EdgeSVM.ScaleData.scaleFactor);
    sv = EdgeSVM.SupportVectors;
    alphaHat = EdgeSVM.Alpha;
    bias = EdgeSVM.Bias;
    kfun = EdgeSVM.KernelFunction;
    kfunargs = EdgeSVM.KernelFunctionArgs;
    f = kfun(sv,ImEdgeC,kfunargs{:})'*alphaHat(:) + bias;
    ConfidenceEdge = f*-1;
    ConfidenceEdge = 1.0 / (1.0 + exp(-ConfidenceEdge));
    
OLPPCSVM = svmclassify(OLPPSVM,ImOLPPC);
    SampleScaleShift = bsxfun(@plus,ImOLPPC,OLPPSVM.ScaleData.shift);
    ImOLPPC = bsxfun(@times,SampleScaleShift,OLPPSVM.ScaleData.scaleFactor);
    sv = OLPPSVM.SupportVectors;
    alphaHat = OLPPSVM.Alpha;
    bias = OLPPSVM.Bias;
    kfun = OLPPSVM.KernelFunction;
    kfunargs = OLPPSVM.KernelFunctionArgs;
    f = kfun(sv,ImOLPPC,kfunargs{:})'*alphaHat(:) + bias;
    ConfidenceOLPP = f*-1;
    ConfidenceOLPP = 1.0 / (1.0 + exp(-ConfidenceOLPP));
%{
if EdgeCSVM == 10
    EdgeCSVM = 10;
end
if OLPPCSVM == 10
    OLPPCSVM = 10;
end
%}
%cd(sprintf('%s',dir1));
time = toc;
end


