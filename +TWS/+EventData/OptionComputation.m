classdef (ConstructOnLoad) OptionComputation < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = OptionComputation(e); this@TWS.EventData.EventWrapper(e); end
    end
end

