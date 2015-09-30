classdef (Abstract) Function < handle
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        value;
    end
    
    methods 
        function result = apply(this,x);end %#ok<INUSD,STOUT>
    end
    
    methods
        function B = subsref(A,S)
            
            % check for empty call to function to get the value
            if numel(S) == 1 && strcmp(S.type,'()') && numel(S.subs) == 0; 
                B = A.apply([]);
                
            % if pass an argument then apply
            elseif numel(S) == 1 && strcmp(S.type,'()') && numel(S.subs) == 1
                B = A.apply(S.subs{1});
            
            % otherwise, give the call to built-in impl
            else
                B = builtin('subsref',A,S);
            end
        end
    end
end

