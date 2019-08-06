classdef (ConstructOnLoad) HeadTimestamp < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = HeadTimestamp(e); this@TWS.EventData.EventWrapper(e); end
    end
end