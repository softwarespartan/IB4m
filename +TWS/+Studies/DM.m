classdef DM < TWS.Studies.Function
% Directional Movement
    
    properties
        lastBar;
    end
    
    methods
        
        function this = DM()
            
            % call parent constructor
            this@TWS.Studies.Function();
            
            % init function value
            this.value = nan;  
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
    
    methods( Access = 'private')
        
        function result = doApply(this,bar)
            
            % init DM
            dm = 0;
            
            % init +DM and -DM
            dmp = 0; dmm = 0;
            
            % is this the first bar?
            if isnan(this.value); result = 0; this.lastBar = bar; return; end
            
            % is the current bar high greater than last bar high ?
            if bar.high > this.lastBar.high; dmp = bar.high - this.lastBar.high; end
            
            % is the current bar low lower than last bar low ? 
            if bar.low < this.lastBar.low; dmm = this.lastBar.low - bar.low; end
            
            % ok figure out if DM possitive (unconventional, i know)
            if dmp > dmm; dm = +dmp; end
            
            % figure out if DM is negative (yes, this is a mod)
            if dmm > dmp; dm = -dmm; end
            
            % update last bar
            this.lastBar = bar;
            
            % set the resutl
            result = dm;
        end
    end
end