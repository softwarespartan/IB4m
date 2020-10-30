classdef (ConstructOnLoad) OptionParameter < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = OptionParameter(e); this@TWS.EventData.EventWrapper(e); end
    end
end

