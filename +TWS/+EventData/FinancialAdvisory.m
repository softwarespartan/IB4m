classdef (ConstructOnLoad) FinancialAdvisory < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = FinancialAdvisory(e); this@TWS.EventData.EventWrapper(e); end
    end
end