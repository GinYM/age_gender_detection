% Gender Classification Function
function class = GenderRec(image)
   load data
   class = 0;
   image = reshape(image,6400,1);
   Tt_DAT = double(image);
   tt_dat = disc_set'*Tt_DAT;
   tt_dat = tt_dat./( repmat(sqrt(sum(tt_dat.*tt_dat)), [par.nDim,1]) );
   class = CRC_RLS(tr_dat,Proj_M,tt_dat,trls);
end