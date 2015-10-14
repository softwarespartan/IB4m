classdef ADX < TWS.Studies.Function
% Average Directional Movement Index
    
    properties (GetAccess = 'public', SetAccess = 'private')
        period; emaDX; DIp; DIm; numBars;
    end
    
    methods
        
        function this = ADX(period)
            
            % call parent constructor
            this@TWS.Studies.Function();
            
            % make sure period is positive integer
            if ~isa(period,'double') || period <= 0 || period ~= floor(period)
                error('input arg1 must be positive integer period');
            end
            
            % init function value and period
            this.value = nan;  this.period = period; this.numBars = 1;
            
            % init directional indicators +/-DI
            this.DIp  = TWS.Studies.DIp(period);
            this.DIm  = TWS.Studies.DIm(period);
            
            % init DX exponential moving average
            this.emaDX  = TWS.Studies.EMA(period);
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

            % compute directional indicators
            dip = this.DIp(bar);  dim = this.DIm(bar);
            
            % compute directional index from indicators
            DX = 0;  if (dip+dim) > 0; DX = abs(dip-dim)/(dip+dim); end
            
            % update DX moving average
            result = this.emaDX(DX*100);
            
            % do not produce ADX until 2*period
            if this.numBars < 2 * this.period; result = nan; end;
            
            % update number of bars
            this.numBars = this.numBars + 1;
        end    
    end  
end