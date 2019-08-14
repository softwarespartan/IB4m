classdef (ConstructOnLoad) FundamentalData < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = FundamentalData(e); this@TWS.EventData.EventWrapper(e); end
    end
end