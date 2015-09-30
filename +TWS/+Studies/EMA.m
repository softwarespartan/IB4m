classdef EMA < TWS.Studies.Function 
% ETA.EMA stateful exponential moving average
    
    properties(Access = 'private')
        alpha = 1;
    end
    
    methods
        
        % @Constructor
        function this = EMA(alpha)
            
            % set default depth for recursion
            if nargin ~= 1; error('constructor takes exactly one input argument'); end
            
            % enforce parameter input
            if alpha < 0; error('arg1 must be greater than zero'); end
            
            % if alpha > 1 then use as period
            if alpha > 1; alpha = 2/(alpha+1); end
            
            % set the averaging weight
            this.alpha = alpha;
        end
        
        % @Override
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly a single argument'); end
            
            % check if empty, if yes -- return the current function value
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % check for initialization
            if isempty(this.value); this.value = val(1); end
            
            % mem alloc for result
            result = nan(size(val));
            
            % apply each val(i) sequantialy 
            for i = 1:numel(val)
                
                % compute the forcast estimate
                result(i) = this.alpha*val(i) + (1-this.alpha)*this.value;
                
                % update the current value
                this.value = result(i);
            end
        end
    end
end