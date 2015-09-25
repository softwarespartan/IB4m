classdef Buffer < TWS.MarketData.EventListener & TWS.CircularBuffer
    
    methods
        function this = Buffer(sz)
            this@TWS.CircularBuffer(sz);
            this@TWS.MarketData.EventListener();
        end
        
        function process(this,event)
            this.buf.add(event);
        end
    end
end

