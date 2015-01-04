classdef (ConstructOnLoad) HistoricalData < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = HistoricalData(e); this@TWS.EventData.EventWrapper(e); end
    end
end

