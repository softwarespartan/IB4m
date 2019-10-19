classdef (ConstructOnLoad) SymbolSample < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = SymbolSample(e); this@TWS.EventData.EventWrapper(e); end
    end
end

