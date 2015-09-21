classdef (Abstract) EventListener < handle
    
    properties (Abstract, GetAccess = 'public', SetAccess = 'private')
        uuid;
        eventTypes;
    end
    
    methods (Abstract)
        process %#ok<NOIN>
    end
end

