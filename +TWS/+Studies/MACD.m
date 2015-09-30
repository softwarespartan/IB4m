classdef MACD < TWS.Studies.Function
% ETA.MACD stateful moving average convergenc divergence 

    properties (Access = 'private')
        emaN1; emaN2; emaN3
    end
    
    methods
        function this = MACD(varargin)
            
            % enforce function signature 
            if numel(varargin) == 1 && numel(varargin{1}) == 3
                if     isa(varargin{1},'cell'  ); N = cell2mat(varargin{1});
                elseif isa(varargin{1},'double'); N =          varargin{1} ; end
            elseif numel(varargin)==3
                N = cell2mat(varargin);
            else
                % default params
                N = [12,26,9];
                %error('constructor takes 1 argument of type cell/double length three or three input args');
            end
            
            % enforce parameter properties
            if ~all(N>0); error('input arguments must all be positive'); end
            
            % enforce parameter property if > 1 then must be integer
            if any(N>1 & N ~= floor(N));error('input args greater than 1 must be integer'); end
            
            % initialize exp moving averages
            this.emaN1 = ETA.EMA(N(1)); this.emaN2 = ETA.EMA(N(2)); this.emaN3 = ETA.EMA(N(3));
        end
        
        function result = apply(this,val)
            
            % enforce function signature
            if nargin ~= 2; error('apply takes exactly a single argument'); end
            
            % check if empty, if yes -- return the current function value
            if isempty(val); result = this.value; return; end;
            
            % make sure either vector or column
            if ~any(size(val)==1); error('arg1 must be 1xN or Nx1 of values to apply sequentially'); end 
            
            % compute the moving averages
            dy = this.emaN1.apply(val) - this.emaN2.apply(val);  dz = this.emaN3.apply(dy);
            
            % pkg the result and current value
            result = [dy(:),dz(:)]';  this.value = result(:,end);
        end
    end
end