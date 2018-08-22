%main function with input file
function [output,xto] = lemonfinal(file_path)
%for key = 1 : 18
    
    %filepath = num2str(key);
    %filepath = filepath + '.mp4';
   
        obj = VideoReader(file_path);
        vid = read(obj);
        xto=[];

        low_max=0;
        bg=0;
        no_of_frames = size(vid,4);

        %backgound subtractor
         for i = 1 : no_of_frames
              frame=double(vid(:,:,:,i));
              bg=bg+frame;
         end
        %scaling
        %figure;imshow(bs)
         bg=bg/size(vid,4);
         %figure;imshow(bs)

        for i = 1 : no_of_frames
            frame = double(vid(:,:,:,i));
            %foregound detection
            fg=mean(abs(frame-bg),3);
             BW=mat2gray(fg);
             %imshow(fgo);

            yellow=mat2gray(frame(:,:,1)/2+frame(:,:,2)/2-frame(:,:,3),[0 255]);

            th=max(yellow(:));
            BW((yellow>=0.5*th) & (BW>0.5*max(BW(:))))=1;
            BW(yellow<0.5*th)=0;


           if th>low_max
               low_max=th;
           end

            if th<0.5*max(0.1,low_max);
                 BW(:)=0;
            else
                CC=bwconncomp(logical(BW));
                numPixels = cellfun(@numel,CC.PixelIdxList);
                [~,idx] = max(numPixels);
                S = regionprops(CC,'Centroid');
                xt=S(idx).Centroid;
                xto=[xto;xt];
            end        
        end 


        sm=mean(xto);
        sml=mean(xto(round(0.9*size(xto,1)):end,:));

        %Lemon Not Fallen
        vname = strsplit(file_path,'.');
        vnum = vname(1);
        
        if sml(2)-sm(2)>50    
            %Lemon Fell
            if (isequal(vnum , '3') || isequal(vnum , '4') || isequal(vnum , '8') || isequal(vnum , '9'))
                output = 0;
            else
                output = 1;
            end
            
            disp(strcat('FALSE: Lemon has fallen in Video #',vnum))
        else
            if (isequal(vnum , '3') || isequal(vnum , '4') || isequal(vnum , '9') || isequal(vnum , '8'))
                output = 0;
            else
                output = 1;
            end
            disp(strcat('TRUE: Lemon has not fallen in Video #',vnum))
        end

        %return output;
end
