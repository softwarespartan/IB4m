classdef Handler < handle
    
    properties(Constant)
        accountNumber = 'DU207406';
    end
    
    properties(Access = 'private')
        nextOrderIdObj;  
        attrkeys = [                       ...
            'AccountType'                 ,...
            'NetLiquidation'              ,...
            'TotalCashValue'              ,...
            'BuyingPower'                 ,...
            'GrossPositionValue,'          ,...
            'MaintMarginReq,'              ,...
            'AvailableFunds,'              ,...
           ];
    end
    
    % event buffers
    properties(GetAccess = 'public', SetAccess = 'private')
                 errorEventBuf;
              orderExeEventBuf;
            openOrdersEventBuf;
           orderStatusEventBuf;
             positionsEventBuf;
         accountUpdateEventBuf;
        accountSummaryEventBuf;
    end
    
    % listener handles
    properties(Access = 'private')
                 errorEventHandle;
              orderExeEventHandle;
            openOrdersEventHandle;
           orderStatusEventHandle;
             positionsEventHandle;
         accountUpdateEventHandle;
        accountSummaryEventHandle;
    end
    
    properties(Access = 'private')                      
        logger; session;
    end
    
    methods (Access = 'public')                        
        
        % make private constructor
        function this = Handler()
            
            % init logger
            this.logger = TWS.Logger.getInstance(class(this));
            
            % get session
            this.session = TWS.Session.getInstance();
            
            % if not connected, do not initialize
            if ~this.session.eClientSocket.isConnected()
                
                % blab about it on the logger
                this.logger.error([TWS.Logger.this,'>', ' not connected to TWS -- initialization aborted']);
                
                % make an error of it
                error(' not connected to TWS -- initialization aborted');         
            end
            
            % init error listener
            this.errorEventHandle = event.listener(              ...
                TWS.Events.getInstance                          ,...
                TWS.Events.ERROR                                ,...
                @(s,e)this.processErrorEvent(e.event)            ...
            );
            
            % init next order id instance
            this.nextOrderIdObj = TWS.NextOrderId.getInstance();
        
            % create listener for the execution details event
            this.orderExeEventHandle =  event.listener(          ...
                TWS.Events.getInstance                          ,...
                TWS.Events.EXECUTIONDETAILS                     ,...
                @(s,e)this.processExecutionDetailsEvent(e.event) ...
            );
        
            % create listener for the open orders event
            this.openOrdersEventHandle =  event.listener(        ...
                TWS.Events.getInstance                          ,...
                TWS.Events.OPENORDER                            ,...
                @(s,e)this.processOpenOrdersEvent(e.event)       ...
            );
        
            % create listener for the order status event
            this.orderStatusEventHandle =  event.listener(       ...
                TWS.Events.getInstance                          ,...
                TWS.Events.ORDERSTATUS                          ,...
                @(s,e)this.processOrderStatusEvent(e.event)      ...
            );
        
            % create listener for the position events
            this.positionsEventHandle =  event.listener(         ...
                TWS.Events.getInstance                          ,...
                TWS.Events.POSITIONS                            ,...
                @(s,e)this.processPositionsEvent(e.event)        ...
            );
            
            % create listener for account update events
            this.accountUpdateEventHandle =  event.listener(     ...
                TWS.Events.getInstance                          ,...
                TWS.Events.ACCOUNTUPDATE                        ,...
                @(s,e)this.processAccountUpdateEvent(e.event)    ...
            );
        
            % create listener for account summary events
            this.accountSummaryEventHandle =  event.listener(    ...
                TWS.Events.getInstance                          ,...
                TWS.Events.ACCOUNTSUMMARY                       ,...
                @(s,e)this.processAccountSummaryEvent(e.event)   ...
            );
        
            % init buffer size
            bufsz = 256;
            
            % init buffers for events
                     this.errorEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
                  this.orderExeEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
                this.openOrdersEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
               this.orderStatusEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
                 this.positionsEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
             this.accountUpdateEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
            this.accountSummaryEventBuf = org.apache.commons.collections.buffer.CircularFifoBuffer(bufsz);
            
            % request account summary details
            this.session.eClientSocket.reqAccountSummary(0,'All',this.attrkeys);  pause(1);
            
            % request events from tws
            this.session.eClientSocket.reqAllOpenOrders();
            this.session.eClientSocket.reqAccountUpdates(true,this.accountNumber);
            
            % make sure that we can see events from orders in TWS window also
            this.session.eClientSocket.reqAutoOpenOrders(true);
            
            % blab about it on the logger
            this.logger.trace([TWS.Logger.this,'>', ' initialization complete']);
        end
    end
    
    methods
        
        function id = nextOrderId(this)                               
            id = this.nextOrderIdObj.nextOrderId;
        end
        
        function processErrorEvent(this,event)            %#ok<*INUSD>
            this.logger.trace([TWS.Logger.this,'>', ' recived error ']);
            this.errorEventBuf.add(event);
        end
        
        function processExecutionDetailsEvent(this,event) %#ok<*INUSD>
            this.logger.trace([TWS.Logger.this,'>', ' recived execution details']);
            this.orderExeEventBuf.add(event);
        end
        
        function processOpenOrdersEvent(this,event)                   
            this.logger.trace([TWS.Logger.this,'>', ' recived open order event']);
            this.openOrdersEventBuf.add(event);
        end
        
        function processOrderStatusEvent(this,event)                  
            this.logger.trace([TWS.Logger.this,'>', ' recived order status event']);
            this.orderStatusEventBuf.add(event);
        end
        
        function processPositionsEvent(this,event)                    
            this.logger.trace([TWS.Logger.this,'>', ' recived positions event']);
            this.positionsEventBuf.add(event);
        end
        
        function processAccountUpdateEvent(this,event)                
            this.logger.trace([TWS.Logger.this,'>', ' recived account update event']);
            this.accountUpdateEventBuf.add(event);
        end
        
        function processAccountSummaryEvent(this,event)               
            this.logger.trace([TWS.Logger.this,'>', ' recived account update event']);
            this.accountSummaryEventBuf.add(event);
        end
        
        function delete(this)                                         
            
            % blab about it on the logger
            this.logger.trace([TWS.Logger.this,'>', ' removing listener handles']);
            
            % cancel notification requests in TWS
            this.session.eClientSocket.cancelPositions()
            this.session.eClientSocket.reqAutoOpenOrders(false);
            this.session.eClientSocket.reqAccountUpdates(false,this.accountNumber);
            
            % remove listeners
            delete(this.errorEventHandle         );
            delete(this.orderExeEventHandle      );
            delete(this.openOrdersEventHandle    );
            delete(this.orderStatusEventHandle   );
            delete(this.positionsEventHandle     );
            delete(this.accountUpdateEventHandle );
            delete(this.accountSummaryEventHandle);
        end
    end
end