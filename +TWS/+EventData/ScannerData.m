classdef (ConstructOnLoad) ScannerData < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = ScannerData(e); this@TWS.EventData.EventWrapper(e); end
    end
end

