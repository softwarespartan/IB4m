classdef EventHandler < TWS.EventHandler
% EVENTHANDLER - TWS.MARKETDATA (singleton)
    
    properties (GetAccess = 'public', SetAccess = 'private')
        uuid       = char(java.util.UUID.randomUUID.toString());
        eventTypes = {'com.tws.MarketData'}; 
    end
    
    properties (GetAccess = 'public', SetAccess = 'private')
        session    ;
        reqId      ;
        listenerMap;
        contractMap;
        
        reverseObjMap;
        reverseSymbolMap;
        reverseContractMap;
    end
    
    properties (Access = 'private')
        eventListenerHandle
    end
    
    properties(Constant)
        
        % list of metadata ticks
        genericTickList = [                                      ...
                           '100,101,105,106,107,125,165,166,'    ...
                           '225,232,221,233,236,258, 47,291,'    ...
                           '293,294,295,318,370,370,377,377,'    ...
                           '381,384,384,387,388,391,407,411,'    ...
                           '428,439,439,456, 59,459,460,499,'    ...
                           '506,511,512,104,513,514,515,516,517' ...
                          ];
    end
    
    methods (Access = 'private')
        
        function this = EventHandler()
            
            % init the reqest id counter at zero 
            this.reqId = -1;
            
            % get session instance
            this.session = TWS.Session.getInstance();
            
            % initialize hash map of reqId to matlab objs
            this.listenerMap = containers.Map('KeyType','double','ValueType','any');
            
            % init the contract map (reqId --> contract)
            this.contractMap        = java.util.HashMap();
            
            % init the reverse contract map (contract --> reqId)
            this.reverseContractMap = java.util.HashMap();
            
            % init reverse symbol map (contract.m_symbol --> reqId)
            this.reverseSymbolMap   = java.util.HashMap();
            
            % init reverse object map (based on listener.uuid --> reqId)
            this.reverseObjMap      = java.util.HashMap();
            
            % set up call back for market data events 
            this.eventListenerHandle = event.listener(                                  ...
                                                      TWS.Events.getInstance          , ...
                                                      TWS.Events.MARKETDATA           , ...
                                                      @(s,e)this.notify(e.event)  ...
                                                     );
        end
    end
   
    methods(Access = 'public')
        
        function rid = subscribe(this, contract, listener, tickList)
            
            % enforece function signature 
            if nargin ~=3 && nargin ~= 4; error('must provide contract and generic tick list'); end
            
            % enforce input arg1 types
            if ~isa(contract,'com.ib.client.Contract'); error('input arg 1 must be of type com.ib.client.Contract'); end
            
            % enforce input arg2 types
            if ~isa(listener,'TWS.MarketData.EventListener'); error('input arg 2 must be of type TWS.MarketData.EventListener'); end
            
            % make sure that the listener is not already listening
            if this.reverseObjMap.containsKey(listener.uuid)
                warning(['object ',listener.uuid,' already registered']); return;
            end
            
            % make sure the contract does not already exist
            if this.reverseContractMap.containsKey(contract); 
            
                % get the request id for this contract
                rid = this.reverseContractMap.get(contract);
                
                % add to list of listeners
                this.reverseObjMap.put(listener.uuid,rid);
                
                % simply add the listener to existing subscription
                this.listenerMap(rid) = [this.listenerMap(rid),listener]; 
                
                % that's all
                return
            end
            
            % set default generic tick list if list not provided
            if nargin == 3; tickList = []; end
            
            % convert tick list from cell array to array if needed
            if isa(tickList,'cell'); tickList = cell2mat(tickList); end
            
            % make sure tick list is a double at this point
            if ~isa(tickList,'double'); error('input arg 2 must be list or array of integer tick ids'); end
            
            % make sure that each tick provided is in the generic tick list
            for i = 1:numel(tickList)
                if ~any(this.genericTickList == tickList(i))
                    error('input arg 2 must be list or array of integer tick ids');
                end
            end
                
            % update the request id
            this.reqId = this.reqId + 1;
            
            % update request id map
            this.listenerMap(this.reqId) = listener;
            
            % update contract id map
            this.contractMap.put(this.reqId,contract);
            
            % update reverse contract map
            this.reverseContractMap.put(contract,this.reqId);
            
            % update reverse symbol map
            this.reverseSymbolMap.put(contract.m_symbol,this.reqId);
            
            % update the reverse object map
            this.reverseObjMap.put(listener.uuid,this.reqId);
            
            % make the official TWS API call for market data request
            this.session.eClientSocket.reqMktData(this.reqId,contract,tickList,false,[]);
            
            % set the output arg
            rid = this.reqId;
        end
        
        function unsubscribe(this,arg)
            
            % enforce number of input args
            if nargin ~= 2; error('input arg 1 must be reqId, com.ib.client.Contract, or TWS.EventListener'); end
            
            % enforce input arg types
            if ~isa(arg,'com.ib.client.Contract') && ~isa(arg,'TWS.EventListener') && ~isa(arg,'double') 
                error('input arg 1 must be reqId, com.ib.client.Contract, or TWS.EventListener'); 
            end
            
            % treat special case when arg is TWS.EventListener
            if isa(arg,'TWS.EventListener')
                
                % ok, if we can not resolve uuid then we're done
                if ~ this.reverseObjMap.containsKey(arg.uuid); error(['object not found: ',arg.uuid]); end
                
                % get the request id associated with this object
                rid = this.reverseObjMap.get(arg.uuid);
                
                % get list of listeners for this request id 
                listeners = this.listenerMap(rid);
                
                % go though list of listeners and remove listener with matching uuid
                indx = strcmp(arg.uuid, {listeners.uuid});
                
                % sanity check - part 1
                if ~any(indx); error(['listener ',arg.uuid,' not found in rid ',num2str(rid)]); end
                
                % sanity check - part 2
                if sum(indx) > 1; warning(['multiple listeners matching uuid: ',arg.uuid]); end
                
                % remove the listener from obj map
                this.reverseObjMap.remove(arg.uuid);
                
                % remove the listener
                listeners(indx) = [];
                
                % finally, set the listeners map to this modified version
                this.listenerMap(rid) = listeners;
                
                % if there are no listeners left, shut down the request in API
                if isempty(listeners)
                    
                    % remove the request id from the listener map
                    this.listenerMap.remove(rid);
                    
                    % make official API call for cancelation
                    this.session.eClientSocket.cancelMktData(rid);
                end
                
                % we're done
                return;
            end
            
            % init request id
            rid = arg;
            
            % translate the input argument into a request id if contract specified
            if isa(arg,'com.ib.client.Contract'); 
                
                % denfensive check that key exists in map
                if ~ this.reverseContractMap.containsKey(arg); error(['contract not found: ', char(arg.m_symbol)]); end
                
                % get the request id associated with this contract
                rid = this.reverseContractMap.get(arg);
            end
            
            % make sure that the request id exists in both maps
            if ~ this.listenerMap.isKey(rid) || ~ this.contractMap.containsKey(rid)
                error(['request id not found: ',num2str(rid)]);
            end
            
            % get the contract for this request id
            contract = this.contractMap.get(rid);
            
            % get list of listeners for this rid
            listeners = this.listenerMap(rid);
            
            % remove request --> listener object mapping
            this.listenerMap.remove(rid);  
            
            % remove symbol look up
            this.reverseSymbolMap.remove(contract.m_symbol);
            
            % remove contract --> request id mapping
            this.reverseContractMap.remove( contract );
            
            % remove request id --> contract mapping 
            this.contractMap.remove(rid);
            
            % remove uuid for each listenr
            cellfun(@(u)this.reverseObjMap.remove(u),{listeners.uuid});
            
            % make official API call for cancelation
            this.session.eClientSocket.cancelMktData(rid);
        end
        
        function notify(this,event)   
            
            % make sure this is actual a reqId in the map first
            if ~this.listenerMap.isKey(event.data.reqId); 
                warning(['reqId not found: ',num2str(event.data.reqId)]); return;
            end
            
            % get the list of handlers for this event
            h=this.listenerMap(event.data.reqId);
            
            % notify each listener of event
            for i = 1:numel(h); h(i).process(event.data); end
        end
    end
    
    methods
        function delete(this)           

            % cancell all existing market data requests
            if ~ this.listenerMap.isempty()
                
                % get list of all request ids
                keySet = this.listenerMap.keys();
                
                % cancel each request one by one
                for i = 1:numel(keySet);
                    
                    % make API call for cancel
                    this.session.eClientSocket.cancelMktData(keySet{i}); 
                    
                    % blab about it
                    disp(['reqId ',num2str(keySet{i}),' has been removed']);
                end
            end

            % clean up TWS API event listener
            if ~isempty(this.eventListenerHandle); delete(this.eventListenerHandle); end
        end
    end
    
    methods (Static)          
        function instance = getInstance() 
            persistent localInstance
            if isempty(localInstance) ; localInstance = TWS.MarketData.EventHandler(); end
            instance = localInstance;
        end
    end 
end