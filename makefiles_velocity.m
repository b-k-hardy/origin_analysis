%%
%  Run this script to generate input files for cheart-image-out on tom
%  
%  In addition, create a folder 'VolMeshes' where your mesh*T/X/B exist, and
%  one folder 'images' where the input *D files are. 
%  
%  Make sure to modify the hard-coded pointers below

%% Code Max
nums = (5:60:1025)';
dir_fp   = 'fp/';
dir_fpbs = 'fpbs/';
dir_fsh  = 'fsh/';

mkdir(dir_fp)
mkdir(dir_fpbs)
mkdir(dir_fsh)

n_fsh = 18;
numd = reshape(nums, n_fsh, []); numd = numd';

%% Loop over all numbers and make files
for n=nums'
        
    ns = num2str(n);
    
    % Make .P file
    fid = fopen([dir_fp 'image' ns '.P'],'w');
    
    fprintf(fid,'!Export-binary\n');
    fprintf(fid,'!OverrideCHeartMemoryBlock\n');
    fprintf(fid,'!Export-file\n');
    fprintf(fid,'images%s.m\n',ns);
    fprintf(fid,'\n');
    fprintf(fid,'!UseBasis={LinBasis3D|TETRAHEDRAL_ELEMENT|NODAL_LAGRANGE1|KEAST_LYNESS4}\n');
    fprintf(fid,'\n');
    fprintf(fid,'!DefTopology={TP1|../../../AAD/mesh-um13/UM13_model_0|LinBasis3D}\n');
    fprintf(fid,'\n');
    fprintf(fid,'!DefVariablePointer={Space|TP1|../../../AAD/try3/X-%s.D|3}\n',ns);
    fprintf(fid,'!DefVariablePointer={Vel  |TP1|../../../AAD/try3/V-%s.D|3}\n',ns);
    fprintf(fid,'\n');
    fprintf(fid,'!ImageVariables={Vel}\n');
    fprintf(fid,'\n');

    fprintf(fid,'!Resolution\n');
    fprintf(fid, '64 92 160\n');
    fprintf(fid,'\n');

    fprintf(fid,'!PixelDimension\n');
    fprintf(fid, '1.5 1.5 1.5\n');
    fprintf(fid,'\n');

    fprintf(fid,'!ImageOrigin\n');
    fprintf(fid,'-74.0 -54.0 -211\n');
    fprintf(fid,'\n');

    fclose(fid);
    
    % Make pbs file
    fid = fopen([dir_fpbs 'runImage' ns '.sh'],'w');
    fprintf(fid,'#!/bin/bash\n');
    fprintf(fid,'\n');
    fprintf(fid,'cd /home/bh21/origin_analysis/image-out_1.5mm_2/images\n'); %Dir for output files
    fprintf(fid,'mpirun -n 1 /home/bh21/software/cheart/source-code/src/dn10-SupportCodes/cheart-image.out /home/bh21/origin_analysis/image-out_1.5mm_2/fp/image%s.P\n',ns);
    fprintf(fid,'\n');
    
    fclose(fid);
    
end

iter = 0;
for n=1:size(numd,1)
    
    fid = fopen([dir_fsh 'runScripts' num2str(n) '.sh'],'w');
    fprintf(fid,'#!/bin/bash\n');
    fprintf(fid,'\n');
    
    fprintf(fid,'for i in ');
    for i=(numd(n,:))'
        fprintf(fid,'%i ',i);
    end
    fprintf(fid,'\n');
    
    fprintf(fid,'do\n');
    fprintf(fid,'  bash /home/bh21/origin_analysis/image-out_1.5mm_2/fpbs/runImage$i.sh\n');
    fprintf(fid,'done\n');
    fprintf(fid,'\n');
    
end

! rm f.tar.gz
! tar -czvf f.tar.gz fp fsh fpbs
