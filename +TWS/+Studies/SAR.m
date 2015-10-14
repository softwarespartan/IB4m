classdef SAR < TWS.Studies.Function
% Parabolic Stop and Reverse (PSAR)    
    
    properties (GetAccess = 'public',SetAccess = 'private')
        sarud; isUpTrend; isDownTrend;  initAlpha = 0.02;  alphaStep = 0.02;  maxAlpha = 0.2;
    end
    
    methods
        
        % @Constructor
        function this = SAR(initAlpha, alphaStep, maxAlpha)
            
            % call parent constructor
            this@TWS.Studies.Function();
            
            % set init params if provided
            if nargin == 3;  this.initAlpha = initAlpha;  this.alphaStep = alphaStep;  this.maxAlpha = maxAlpha;  end

            % init with positive trend (total guess)
            this.sarud = TWS.Studies.SARu(this.initAlpha, this.alphaStep, this.maxAlpha);
            
            % init value
            this.value = nan;
            
            % init trend direction
            this.isUpTrend = true;  this.isDownTrend = false;
        end
        
        % @Override
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
            
            % ok, first check if we've seen a bar before
            if isnan(this.value); this.value = this.sarud(bar); result = this.value; return; end
            
            % check uptrend ended ?
            if this.isUpTrend && bar.low < this.value
                
                % reverse the trend direction
                this.isUpTrend = false;  this.isDownTrend = true;  
                
                % reinitialize SAR for down trend with initial SAR value of EP-of-prior-trend and EP of current bar
                this.sarud = TWS.Studies.SARd(this.initAlpha,this.alphaStep,this.maxAlpha,this.sarud.ep,bar.high);
                
                % set the function value and result
                this.value = this.sarud();  result = this.value;
                
                % we're done
                return;
            end
            
            % check down trend ended ?
            if this.isDownTrend && bar.high > this.value
                
                % reverse the trend direction
                this.isDownTrend = false;  this.isUpTrend = true;
                
                % reinitialize SAR for up trend with initial SAR value of EP-of-prior-trend and EP of current bar range
                this.sarud = TWS.Studies.SARu(this.initAlpha,this.alphaStep,this.maxAlpha,this.sarud.ep,bar.low);
                
                % set the output value to current SAR value (i.e. SAR.EP of previous trend)
                this.value = this.sarud();  result = this.value;
                
                % we're done
                return;
            end
            
            % set the output result 
            result = this.sarud(bar);
        end
    end
end