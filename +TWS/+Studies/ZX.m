classdef ZX < TWS.Studies.Function
% ETA.ZX returns -1, 0, +1 if the given value crosses zero. 
    
    properties(Access = 'private')
        lastInput;
    end

    methods
        
        % @Constructor
        function this = ZX(); end
        
        % @Override
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly a single argument'); end
            
            % check if empty, if yes -- return the no zero crossing
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % check for initialization
            if isempty(this.value);  this.value = 0;  this.lastInput = val(1); end
            
            % mem alloc for result
            result = nan(size(val));
            
            % apply remaining values sequentially
            for i = 1:numel(val)
                
                % going down
                if this.lastInput > 0 && val(i) < 0; this.value = -1; %#ok<ALIGN>
                    
                % going up
                elseif this.lastInput < 0 && val(i) > 0; this.value = +1;
                    
                % no zero crossing
                else this.value = 0; end
                
                % update last value and result
                this.lastInput = val(i); result(i) = this.value;
            end
        end
    end
end