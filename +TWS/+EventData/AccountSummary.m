classdef (ConstructOnLoad) AccountSummary < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = AccountSummary(e); this@TWS.EventData.EventWrapper(e); end
    end
end

