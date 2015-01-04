classdef (ConstructOnLoad) EventWrapper < event.EventData
    
    properties (GetAccess = 'public', SetAccess = 'private')
        event
    end
    
    methods
        function this = EventWrapper(e)
            this.event = e;
        end
    end
end

