classdef EventListener < TWS.EventListener
% EVENTLISTENER - TWS.MarketData
    
    properties (GetAccess = 'public', SetAccess = 'private')
        uuid;
        eventTypes = {'com.tws.MarketData'}; 
    end
    
    methods (Access = 'public')
        
        function this = EventListener()
            this.uuid = char(java.util.UUID.randomUUID.toString());
        end
        
        function process(this,event)  %#ok<INUSL>
            disp(event);
        end
    end
end

