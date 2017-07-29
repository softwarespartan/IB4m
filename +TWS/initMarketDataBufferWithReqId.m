function [buf,lh] = initMarketDataBufferWithReqId(bufsz,reqid)

    % enforce function signature
    if nargin ~= 2 ; error('usage: initMarketDataBufferWithReqId(bufsz,reqid)'); end
        
    % define check for integer argments 
    intArgCheck = @(arg)( isa(arg,'double') && arg == floor(arg) && arg >= 0 );
    
    % enforece bufsz and reqid types and limits
    if ~intArgCheck(bufsz) || ~intArgCheck(reqid); error('arg2, arg3 -- must be positive nonzero integers'); end

    % create buffer for notification events 
    buf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz); 
    
    % define nested callback function
    function callback(~,e); if e.event.data.reqId == reqid; buf.add(e.event); end; end
    
    % create listener with callback tied to reqid and buffer
    lh = event.listener(                        ...
                        TWS.Events.getInstance, ...
                        TWS.Events.MARKETDATA , ...
                        @callback               ...
    );   
end

