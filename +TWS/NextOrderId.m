classdef NextOrderId < handle
    
    properties(GetAccess = 'public',SetAccess='private')
        nextOrderId;
    end
    
    properties(Access = 'private')                      
        lh;
        logger; 
    end
    
    methods (Access = 'private')                        
        
        % make private constructor
        function this = NextOrderId()
            
            % init logger
            this.logger = TWS.Logger.getInstance(class(this));
            
            % create listener for the next order id
            this.lh =  event.listener(                 ...
                TWS.Events.getInstance                ,...
                TWS.Events.NEXTORDERID                ,...
                @(s,e)this.processNextOrderId(e.event) ...
            );
            
            % make req for the next order id event
            TWS.Session.getInstance().eClientSocket.reqIds(true);
            
            % blab about it on the logger
            this.logger.trace([TWS.Logger.this,'>', ' initialization complete, next order ID requested']);
        end
    end
    
    methods (Static)                                    
        
        % singleton
        function instance = getInstance()
            
            % global instance
            persistent localObj
            
            % if there is not already a global instance then make one
            if isempty(localObj) || ~isvalid(localObj)
                localObj = TWS.NextOrderId(); 
            end
            
            % return instance
            instance = localObj;
        end
        
    end
    
    methods
        
        function id = get(this)                         
            id = this.nextOrderId;
        end
        
        function id = get.nextOrderId(this)             
            
            % set the id
            id = this.nextOrderId;
            
            % update id
            this.nextOrderId = this.nextOrderId + 1;
        end
        
        function processNextOrderId(this,event)         
            
            % get the event order id
            this.nextOrderId = event.data.nextOrderId;
            
            % blab about it on the logger
            this.logger.trace([TWS.Logger.this,'>', ' recived next order id:', num2str(this.nextOrderId)]);
        end
        
        function delete(this)                           
            
            % blab
            this.logger.trace([TWS.Logger.this,'>', ' removing listener handle']);
            
            % remove listener for next order id events
            delete(this.lh);
        end
    end
end

