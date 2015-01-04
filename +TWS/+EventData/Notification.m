classdef (ConstructOnLoad) Notification < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = Notification(e); this@TWS.EventData.EventWrapper(e); end
    end
end