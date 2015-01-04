function [buf,lh] = initBufferForEvent(eventList,bufsz)

    % enforce function signature
    if nargin < 1 ; error('must provide event id as char or as cell array of chars'); end
    
    % convert char input into cell if necessary
    if isa(eventList,'char'); eventList = {eventList}; end
    
    % set the default buffer size
    if nargin == 1; bufsz = 32; end
    
    % enforce input types
    if ~isa(eventList,'cell'); error('arg1 -- must be event ID as char or cell array of chars'); end
    
    % enforece bufsz type and limits
    if nargin == 2 ...
            && ( ~isa(bufsz,'double') || bufsz ~= floor(bufsz) || bufsz < 1 )
        error('arg2 -- must be positive nonzero integer');
    end

    % create buffer for notification events 
    buf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz); 
    
    % create listener for each eventId and link callback to buffer
    lh = cellfun(@(eventId)                        ...
             event.listener(                       ...
                            TWS.Events.getInstance,...
                            eventId               ,...
                            @(s,e)buf.add(e.event) ...
                           ),                      ...
             eventList      ,                      ...
            'UniformOutput' , false                ...
    );
end

