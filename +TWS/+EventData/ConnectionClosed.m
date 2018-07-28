classdef (ConstructOnLoad) ConnectionClosed < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = ConnectionClosed(e); this@TWS.EventData.EventWrapper(e); end
    end
end