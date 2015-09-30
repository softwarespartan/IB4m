classdef WINFUNC < TWS.Studies.Function
    
    properties (GetAccess = 'public',SetAccess = 'private')
        fh ;
        buf;
    end
    
    methods
        
        % @Constructor
        function this = WINFUNC(N,f)
            
            % enforce function signature
            if nargin ~= 2; error('constructor takes exactly two input args'); end
            
            % enforce input types
            if ~isa(N,'double'         ); error('input arg0 must be of type double         '); end
            if ~isa(f,'function_handle'); error('input arg1 must be of type function_handle'); end
            
            % set the function handle and init buffer
            this.fh = f;  this.buf = TWS.Studies.BUFFER(N); 
        end
        
        % @Override
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly one argument'); end
            
            % check if empty
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % mem alloc for result
            result = nan(size(val));
            
            % apply values sequentially
            for i = 1:numel(val); result(i) = this.fh(this.buf(val(i))); end
            
            % apply values and set curent result
            this.value = result(end);
        end
    end
end