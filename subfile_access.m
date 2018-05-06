[filename path]=uigetfile;
allfiles=dir(path);

for k=3:length(allfiles)
    if allfiles(k).isdir
       
        newpath=strcat(path,'\',allfiles(k).name,'\');
        subfiles=dir(newpath);
        
        for j=3:length(subfiles)
            
            if subfiles(j).name(length(subfiles(j).name)-1:length(subfiles(j).name))=='sx'
                
                disp(subfiles(j).name);
                
                %copyfile(source, destination)
            end                        
        end                                        
    end           
end
