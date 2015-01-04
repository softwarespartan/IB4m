classdef (ConstructOnLoad) ContractDetails < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = ContractDetails(e); this@TWS.EventData.EventWrapper(e); end
    end
end

