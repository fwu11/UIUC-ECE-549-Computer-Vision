function bmap= edgeOrientedFilters(im)
    [mag,theta] = orientedFilterMagnitude(im);
    bmap = nonmax(mag.^ 0.7,theta);
    
    %use canny edge detector
    %result = edge(rgb2gray(im),'canny');
    %bmap = mag.*result;
end

