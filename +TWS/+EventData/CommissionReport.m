classdef (ConstructOnLoad) CommissionReport < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = CommissionReport(e); this@TWS.EventData.EventWrapper(e); end
    end
end