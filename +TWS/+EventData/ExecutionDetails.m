classdef (ConstructOnLoad) ExecutionDetails < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = ExecutionDetails(e); this@TWS.EventData.EventWrapper(e); end
    end
end

