classdef CircularBuffer < handle
    
    properties (GetAccess = 'public', SetAccess = 'private')
        buf;
        logger;
    end
    
    methods
        
        function this = CircularBuffer(sz)
            
            % first things first
            this.logger = TWS.Logger.getInstance(class(this));
            
            % enforece bufsz type and limits
            if ~isa(sz,'double') || sz ~= floor(sz) || sz < 1
                
                % yell and scream
                this.logger.error([TWS.Logger.this,'> ','arg2 -- must be positive nonzero integer']);
                
                % raise formal matlab error
                error('arg2 -- must be positive nonzero integer');
            end
            
            % init buffer with size
            this.buf = org.apache.commons.collections.buffer.CircularFifoBuffer(sz); 
        end
    end
end

