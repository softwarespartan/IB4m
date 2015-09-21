classdef (Abstract) EventHandler < handle
    
    properties (Abstract, GetAccess = 'public', SetAccess = 'private')
        uuid;
        eventTypes;
    end
    
    methods (Abstract, Access = 'public')
        notify       %#ok<NOIN>
        subscribe    %#ok<NOIN>
        unsubscribe  %#ok<NOIN>
    end
end

