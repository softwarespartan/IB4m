function out = jeval( fstr,varargin )
    out = feval(str2func(fstr),varargin{:});
end