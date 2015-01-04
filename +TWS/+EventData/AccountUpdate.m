classdef (ConstructOnLoad) AccountUpdate < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = AccountUpdate(e); this@TWS.EventData.EventWrapper(e); end
    end
end

