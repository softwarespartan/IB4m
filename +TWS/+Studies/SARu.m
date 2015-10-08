classdef SARu < TWS.Studies.Function
    
    properties (Access = 'private')
        l1 = nan; l2 = nan; ep = -inf; alpha = 0.02; initAlpha = 0.02; alphaStep = 0.02; maxAlpha = 0.2;
    end
    
    methods
        
        % @Constructor
        function this = SARu( initAlpha, alphaStep, maxAlpha, initValue, initEP )
            
            % call parent constructor
            this@TWS.Studies.Function();
            
            % enforce function signature
            if nargin ~= 0 && nargin ~= 3 && nargin ~= 5; error('constructor takes exactly two or four input args'); end
            
            % init value property from parent class
            this.value = nan;
            
            % if no args then we're done
            if nargin == 0; return; end
            
            % enforce input types
            if ~isa(initAlpha,'double'); error('input arg1 must be of type double'); end
            if ~isa(alphaStep,'double'); error('input arg2 must be of type double'); end
            if ~isa(maxAlpha ,'double'); error('input arg3 must be of type double'); end
            
            % enforce valid inputs
            if initAlpha <= 0 || initAlpha > 1; error('init alpha (arg1) should be in (0,1] '     ); end
            if alphaStep <= 0 || alphaStep > 1; error('alpha step size (arg1) should be in (0,1] '); end
            if maxAlpha  <= 0 || maxAlpha  > 1; error('max alpha (arg2) should be in (0,1] '      ); end
            
            % enforce input types for 4 inputs
            if nargin == 5 && ~isa(initValue,'double'); error('input arg3 must be of type double'); end
            if nargin == 5 && ~isa(initEP   ,'double'); error('input arg4 must be of type double'); end
             
            % enforce valid inputs for initSAR value and initial extreme point
            if nargin == 5 && initValue < 0; error('initValue arg3 can not be negative'); end
            if nargin == 5 && initEP    < 0; error('initEP arg4 can not be negative   '); end
            
            % assign class properties from input
            this.initAlpha = initAlpha;  this.alphaStep = alphaStep;  this.maxAlpha = maxAlpha;
            
            % assign class properties from extended input
            if nargin == 5; this.value = initValue; this.ep = initEP; end
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
        end
    end
    
    methods (Access = 'private')
        
        function result = doApply(this,bar)
            
            % have we seen a bar yet?
            if isnan(this.value)
                
                % set initial values for study given first bar
                this.value = bar.low; this.ep = bar.high;  this.alpha = this.initAlpha; this.l1 = bar.low; 
                
                % set the output value
                result = this.value;
                
                % we're done
                return;
            end
            
             % the signal calculation - the price action has hit/below the stop
            if bar.low  < this.value
                
                % reset all the study parameters
                this.value = bar.low       ; 
                this.ep    = bar.high      ; 
                this.alpha = this.initAlpha; 
                this.l1    = bar.low       ; 
                this.l2    = bar.low       ;
                
                % set the output result
                result = this.value;
                
                % we're done
                return; 
            end
            
            % update SAR with current bar
            this.value = this.value + this.alpha * ( this.ep - this.value );
            
            % make sure that current SAR value is below range of privious two bars
            this.value = min([ this.value, this.l1, this.l2 ]);
            
            % check for new extreme point 
            if bar.high > this.ep
                
                % record new extreme
                this.ep = bar.high; 
                
                % update learning rate
                this.alpha = min([ this.alpha + this.alphaStep, this.maxAlpha ]);
            end
            
            % update the lows/range for previous two bars
            this.l2 = this.l1;  this.l1 = bar.low;
            
            % set output value
            result = this.value;
        end
    end
end