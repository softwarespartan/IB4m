classdef Session < handle
    
    properties (GetAccess = 'public', SetAccess = 'private')
        proxy
        handler
        eClientSocket
        
        eventBuffer
        eventListenerHandle
    end
    
    methods(Access = 'private')        
        
       function this = Session()       
            
            % initialize a message handler for callbacks
            this.handler = com.tws.Handler();
            
            % init proxy builder from com.tws.Handler
            proxyBuilder = ProxyBuilder(this.handler.getClass);

            % create proxy for handling TWS Notifications
            [this.proxy,~] = proxyBuilder.initForMethod('TWSNotification','TWS.processNotification');

            % add the proxy to the handler for notification listeners
            this.handler.addNotificationListener(this.proxy);

            % create a connection object to TWS linked to our message handler
            this.eClientSocket = com.ib.client.EClientSocket(this.handler);
            
            % initialize a circular buffer to stream events
            this.eventBuffer = org.apache.commons.collections.buffer.CircularFifoBuffer(1000);
            
            % subscribe to all TWS notifications
            this.eventListenerHandle = event.listener(                                     ...
                                                      TWS.Events.getInstance             , ...
                                                      TWS.Events.NOTIFICATION            , ...
                                                      @(s,e)this.eventBuffer.add(e.event)  ...
                                                     );
        end 
    end
    
    methods
        
        function list = events(this)   
            
            % get an iterator for event buffer
            iter = this.eventBuffer.iterator();

            % init and alloc
            list = cell(this.eventBuffer.size,1);  indx = 1;

            % iterate over the collection and build output
            while iter.hasNext(); list{indx} = iter.next();  indx = indx + 1; end
        end
        
        function delete(this)          
            
            if ~isempty(this.proxy)
                % remove notification listeners
                this.handler.removeNotificationListener(this.proxy);
            end
            
            if ~isempty(this.eventListenerHandle)
                % clean up matlab event listener
                delete(this.eventListenerHandle);
            end
            
            % terminate the TWS connection
            this.eClientSocket.eDisconnect();
            
            % shutdown the threadpool
            this.handler.shutdown();
        end
    end
    
    methods (Static)          
      function instance = getInstance()
         persistent localInstance
         if isempty(localInstance) || ~isvalid(localInstance)
            localInstance = TWS.Session();
         end
         instance = localInstance;
      end
    end
    
end