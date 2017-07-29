classdef BUFFER < TWS.Studies.Function
    
    properties(Access = 'private')
        buf   = [];
        cindx = [];
        count =  0;
    end
    
    methods (Access = 'public')
        
        % @Constructor
        function this = BUFFER(N)        
            
            % enforce function signature
            if nargin ~= 1; error('constructor takes exactly one input arguments'); end
            
            % enforce input types 
            if N ~= floor(N); error('arg0 - must be integer buffer size'); end
            
            % init the buffer and circular index
            this.buf = nan(1,N);  this.cindx = N:-1:1;
        end 
        
        % @Override
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly one argument'); end
            
            % check if empty, if yes -- return the current function value but do not update count
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % apply each value in sequence
            for i = 1:numel(val); this.insertData(val(i)); end
                
            % assign the current function value and result
            this.value = this.getData();  result = this.value();
        end
    end
    
    methods(Access = 'private')
        
        function insertData(this,val)    
            
            % update the current counter
            this.count = this.count + 1;
            
            % update/shift the circular index
            this.cindx = circshift(this.cindx,[0,1]);

            % insert the data data at the appropriate index
            this.buf(this.cindx(1)) = val;
        end
        
        function d = getData(this)       
            
            % returns data newest --> oldest
            d = this.buf(this.cindx(1:min(numel(this.buf),this.count)));
        end
    end
end