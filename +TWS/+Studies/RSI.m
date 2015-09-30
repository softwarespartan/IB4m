classdef RSI < TWS.Studies.Function
% ETA.RSI computes stateful relative strength indicator

    properties (Access = 'private')
        emaU; emaD; lastValue;
    end
    
    methods
         
        % @Constructor
        function this = RSI(period)      
            
            % set the default period to 9 days
            if nargin == 0; period = 9; end
            
            % init lastValue to NaN
            this.lastValue = nan;
            
            % init exp smoothers
            this.emaU = TWS.Studies.EMA(period);
            this.emaD = TWS.Studies.EMA(period);
        end
        
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly a single argument'); end
            
            % check if empty, if yes -- return the current function value
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end 
            
%             % mem alloc for result
%             result = nan(size(val));
%             
%             % apply each value sequentially 
%             for i = 1:numel(val)
%                 
%                 % init u and d for this value
%                 u = 0;  d = 0;
%                 
%                 % compute the closing price difference
%                 dv = val(i) - this.lastValue;
%                 
%                 % assign u or d based on sign of dv
%                 if dv > 0; u =     dv ; end
%                 if dv < 0; d = abs(dv); end
%                 
%                 % compute the relative strength
%                 rs = this.emaU(u)/this.emaD(d);
%                 
%                 % finally compute the indicator
%                 result(i) = 100 - 100/(1+rs);
% 
%                  % update last value
%                 this.lastValue = val(i);
%             end

            % init
            u = zeros(size(val)); d = zeros(size(val));  
            
            % compute diff of closing prices
            dv = diff(val);  dv = [val(1)-this.lastValue; dv(:)]';
            
            % compute u and d index
            uIndx = dv>0; dIndx = dv<0;
            
            % insert values of dv into U and D
            u(uIndx) = dv(uIndx); d(dIndx) = abs(dv(dIndx));
            
            % compute relative strength
            rs = this.emaU(u)./this.emaD(d);
            
            % clean up a bit
            rs(rs==inf) = nan;
            
            % compute the indicator
            result = 100 - 100./(1+rs);
            
            % set the current value of the function
            this.value = result(end);
            
            % update last value
            this.lastValue = val(end);
        end
    end
end