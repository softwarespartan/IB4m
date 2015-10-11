classdef SAR < TWS.Studies.Function
    
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
            
            % enforce input type
            if ~isa(bar,'com.tws.Bar'); error('input arg1 must be of type com.tws.Bar'); end
            
            % check if empty - this is standard behavior for TWS.Studies.Function([])
            if isempty(bar); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(bar)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end
            
            % mem alloc for result
            result = nan(size(bar));
            
            % apply values sequentially
            for i = 1:numel(bar); result(i) = this.doApply(bar); end
            
            % set the final value
            this.value = result(end);
        end
    end
    
    methods (Access = 'private')
        
        function result = doApply(this,bar)
            
            % ok, first check if we've seen a bar before
            if isnan(this.value); this.value = this.sarud(bar); result = this.value; return; end
            
            % check uptrend ended ?
            if this.isUpTrend && bar.low < this.value
                
                fprintf('up trend ended')
                
                % reverse the trend direction
                this.isUpTrend = false;  this.isDownTrend = true;  
                
                %result = this.sarud.ep;
                
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
                
                %result = this.sarud.ep;
                
                % reinitialize SAR for up trend with initial SAR value of EP-of-prior-trend and EP of current bar range
                this.sarud = TWS.Studies.SARu(this.initAlpha,this.alphaStep,this.maxAlpha,this.sarud.ep,bar.low);
                
                % set the output value to current SAR value (i.e. SAR.EP of previous trend)
                this.value = this.sarud();  result = this.value;
                
                % we're done
                return;
            end
            
            % trend is ongoing so just update SAR
            this.value = this.sarud(bar);
            
            % set the output result 
            result = this.value;
        end
    end
end