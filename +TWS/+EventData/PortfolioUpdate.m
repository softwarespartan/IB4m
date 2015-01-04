classdef (ConstructOnLoad) PortfolioUpdate < event.EventData & TWS.EventData.EventWrapper 
    methods
        function this = PortfolioUpdate(e); this@TWS.EventData.EventWrapper(e); end
    end
end

