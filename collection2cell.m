function out = collection2cell(collection)

    % enforce the function signature
    if nargin ~=1 
        error('must privide collection as input arg1');
    end
    
    % enforce parameter types
    if ~isa(collection,'java.util.Collection')
        error('input arg1 must be of type java.util.Collection');
    end
    
    % get an iterator for the set
    iter = collection.iterator();
    
    % init
    out = cell(collection.size,1);  indx = 1;
    
    % iterate over the collection and build output
    while iter.hasNext(); out{indx} = iter.next(); indx = indx + 1; end
end