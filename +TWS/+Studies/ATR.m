classdef ATR < TWS.Studies.Function
% Average True Range
    
    properties (GetAccess = 'public', SetAccess = 'private')
        buf; previousClose;
    end
    
    methods
        
        function this = ATR(period)
            
            % call parent constructor
            this@TWS.Studies.Function();
            
            % enforce input parameter type of integer
            if ~isa(period,'double') || period ~= floor(period); 
                error('input arg1 must be integer period'); 
            end
            
            % initialize the buffer
            this.buf = TWS.Studies.BUFFER(period);
            
            % init function value and previous close
            this.value = nan;  this.previousClose = nan;
        end
        
        function result = apply(this,bar)
           
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly one argument of type com.tws.Bar'); end
            
            % check if empty - this is standard behavior for TWS.Studies.Function([])
            if isempty(bar); result = this.value; return; end
            
            % enforce input type
            if ~isa(bar,'cell') &&  ~isa(bar,'com.tws.Bar')  &&  ~isa(bar,'com.tws.Bar[]')
                  error('input arg1 must be of type com.tws.Bar'); 
            end
            
            % enforce cell array content type
            if isa(bar,'cell') && ~isa(bar{1},'com.tws.Bar'); error('input arg1 must be of type com.tws.Bar'); end
            
            % make sure either vector or column
            if ~any(size(bar)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end

            % mem alloc for result
            result = nan(size(bar));
            
            % apply values sequentially
            for i = 1:numel(bar); 
                
                % get the i'th bar (F.ix/F.Part)
                if isa(bar,'cell'); bi = bar{i}; else bi = bar(i); end
                
                % calculate the i'th result/function value
                result(i) = this.doApply(bi);  
                
                % set the current function value to last result
                this.value = result(i);
            end
            
            % set the current value of the function to last result
            this.value = result(end);
        end
    end
    
    methods (Access = 'private')
        
        
        function result = doApply(this,bar)
            
            % calculate the true range for current bar
            trueRange = max(                                   ...
                            [                                  ...
                             abs(bar.high-bar.close),          ...
                             abs(this.previousClose-bar.high), ...
                             abs(this.previousClose-bar.low)   ...
                            ]                                  ...
            );
            
            % add the true range to the buffer
            this.buf(trueRange);  
            
            % compute mean over window of values
            result = mean(this.buf());
            
            % update the previous close
            this.previousClose = bar.close;
        end 
    end
end