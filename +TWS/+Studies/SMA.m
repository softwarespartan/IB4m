classdef SMA < TWS.Studies.Function 
% ETA.SMA stateful moving average
    
    properties(Access = 'private')
        buf   = [];
        cindx = [];
    end
    
    properties(SetAccess = 'private', GetAccess = 'public')
        alpha   = 0 ;
        count   = 0 ;
        weights = [];
    end
    
    methods
        
        % @Constructor
        function this = SMA(N,alpha)     
            
            % set default depth for recursion
            if nargin ~= 2; error('constructor takes exactly two input arguments: SMA(N,alpha)'); end
            
            % set the averaging weight
            this.alpha = alpha;
            
            % init the buffer
            this.buf = nan(1,N);
            
            % init ciruclar index
            this.cindx = N:-1:1;
        end
        
        % @Override
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly a single argument'); end
            
            % check if empty, if yes -- return the current function value but do not update count
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % mem alloc the result
            result = nan(size(val));
            
            % apply each value in sequence
            for i = 1:numel(val); result(i) = this.doApply(val(i)); end
                
            % and ... we're done
            this.value = result(end);
        end
        
        % @Getter
        function w = get.weights(this)   
            
            % weights vector of size count of size(buf)
            n = min(this.count,numel(this.buf));
            
            % helper variables
            a = this.alpha;  v = 1:n;  
            
            % compute the weights
            w = (n-(v)+1).^a./sum((v).^a);
        end
    end
    
    methods(Access = 'private')
        
        function v = doApply(this,val)
            
            % only insert single value at a time
            if numel(val) ~= 1 || ~isa(val,'double') 
                error('arg1 must be scalar double'); end
            
            % insert the data value
            this.insertData(val);
            
            % return the current value
            v = dot(this.weights,this.getData());
        end
        
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
        
        % @Getter
        function w = getWeights(this)   
                       
            % weights vector of size count of size(buf)
            n = min(this.count,numel(this.buf));
            
            % helper variables
            a = this.alpha;  v = 1:n;  
            
            % compute the weights
            w = (n-(v)+1).^a./sum((v).^a);
        end
    end
end