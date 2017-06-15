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
        logger;
        eventListenerHandle;
    end
    
    properties (Constant)                                           
        
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
        
        % @Constructor
        function this = EventHandler()                              
            
            % init the logger
            this.logger = TWS.Logger.getInstance(class(this));
            
            % init the reqest id counter at zero 
            this.reqId = -1;
            
            % initialize hash map of reqId to array of matlab objs
            this.listenerMap = containers.Map('KeyType','double','ValueType','any');
            
            % init the contract map (reqId --> contract)
            this.contractMap        = java.util.HashMap();
            
            % init the reverse contract map (contract --> reqId)
            this.reverseContractMap = java.util.HashMap();
            
            % init reverse symbol map (contract.m_symbol --> reqId)
            this.reverseSymbolMap   = java.util.HashMap();
            
            % init reverse object map (based on listener.uuid --> reqId)
            this.reverseObjMap      = java.util.HashMap();
                        
            % get TWS session instance
            this.session = TWS.Session.getInstance();
            
            % set up call back for market data events 
            this.eventListenerHandle = event.listener(                                  ...
                                                      TWS.Events.getInstance          , ...
                                                      TWS.Events.MARKETDATA           , ...
                                                      @(s,e)this.notify(e.event)  ...
                                                     );
                                                 
            % blab about initialization
            this.logger.trace([TWS.Logger.this,'>',' has been initialized:', this.uuid]);
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
            
            % create contract string for logging messages
            contractStr = [char(contract.m_symbol),'@',char(contract.m_primaryExch),' [',char(contract.m_secType),']'];
            
            % make sure that the listener is not already listening on this contract
            if this.reverseObjMap.containsKey(listener.uuid)
                
                % get array of rid associated with this listener
                rids = this.reverseObjMap.get(listener.uuid);
                
                % get contract for each rid and compare with input contract
                for i = 1:numel(rids)
                    
                    % get existing contract for this reqId
                    existingContract = this.contractMap.get(rids(i));
                    
                    % if already listening on exisitng contract then new dice
                    if strcmp(existingContract.m_symbol,contract.m_symbol)
                        
                        % create contract string for logging messages
                        contractStr = [char(existingContract.m_symbol),'@',char(existingContract.m_primaryExch),' [',char(existingContract.m_secType),']'];
                        
                        % blab at the logger about already listening ...
                        this.logger.debug([TWS.Logger.this,'> ','object ',listener.uuid,' already registered for ', contractStr]); 
                        
                        % nothing else to do ...
                        return;
                    end
                end
            end
            
            % make sure the contract does not already exist
            if this.reverseContractMap.containsKey(contract) 
            
                % get the request id for this contract
                rid = this.reverseContractMap.get(contract);
                
                % get cell array of listener objs
                listeners = this.listenerMap(rid);
                
                % simply add the listener to existing subscription
                listeners{end+1} = listener;
                
                % set the updated cell array as new value in map
                this.listenerMap(rid) = listeners; 
                
                % add to list of listeners
                this.reverseObjMap.put(listener.uuid,rid);
                
                % blab at the logger about adding listener to existing subscription
                this.logger.debug([TWS.Logger.this,'> ','object ',listener.uuid,' added to existing subscription for ', contractStr]);
                
                % that's all
                return;
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
                    
                    % blab at the logger about already listening ...
                    this.logger.error([TWS.Logger.this,'>',' invalid tick ids', contractStr]);
                    
                    % throw formal matlab error here since [maybe squelch later]
                    error('input arg 2 must be list or array of integer tick ids');
                end
            end
                
            % update the request id
            this.reqId = this.reqId + 1;
            
            % update request id map
            this.listenerMap(this.reqId) = {listener};
            
            % update contract id map
            this.contractMap.put(this.reqId,contract);
            
            % update reverse contract map
            this.reverseContractMap.put(contract,this.reqId);
            
            % update reverse symbol map
            this.reverseSymbolMap.put(contract.m_symbol,this.reqId);
            
            % update the reverse object map
            if this.reverseObjMap.containsKey(listener.uuid)
                
                % ok, we're already in the map just append another reqId for this object
                this.reverseObjMap.put(listener.uuid,[this.reqId,this.reverseObjMap.get(listener.uuid)]);
            else
                
                % new object so initialize a map entry
                this.reverseObjMap.put(listener.uuid,this.reqId);
            end
            
            % make logger call to note  new market data request
            this.logger.debug([TWS.Logger.this,'> ', contractStr,' initializing new market data request with TWS with listener ',listener.uuid]);
            
            % make the official TWS API call for market data request
            this.session.eClientSocket.reqMktData(this.reqId,contract,tickList,false,[]);
            
            % set the output arg
            rid = this.reqId;
        end
        
        function unsubscribe(this,varargin)                         
            
            % input is reqId
            if numel(varargin) == 1 && isa(varargin{1},'double')
                this.unsubscribeForReqId(varargin{1}); return
            end
            
            % input is listener
            if numel(varargin) == 1 && isa(varargin{1},'TWS.EventListener')
                this.unsubscribeForObj(varargin{1}); return
            end
           
            % input is contract
            if numel(varargin) == 1 && isa(varargin{1},'com.ib.client.Contract')
                this.unsubscribeForContract(varargin{1}); return;
            end
           
            % input is contract and object
            if numel(varargin) == 2

                % set the args
                listener = varargin{2}; contract = varargin{1};
               
                % swap the args if needed
                if isa(varargin{1},'TWS.EventListener'); listener = varargin{1}; contract = varargin{2}; end
                
                % remove object for contract
                this.unsubscribeForContractForObj(contract,listener);
            end
        end
        
        function notify(this,event)                                 
            
            % make sure this is actual a reqId in the map first
            if ~this.listenerMap.isKey(event.data.reqId)
                
                % blab about it on the logger
                this.logger.trace([TWS.Logger.this,'> ','reqId not found: ',num2str(event.data.reqId)]); return;
            end
            
            % get the list of handlers for this event
            h=this.listenerMap(event.data.reqId);
            
            % notify each listener of event
            for i = 1:numel(h); h{i}.process(event.data); end
        end
        
        function routingTable(this)                                 
            
            % get list of request ids
            reqIds = this.listenerMap.keys;
            
            % for each rid print contract + listeners
            for i = 1:numel(reqIds)
                
                % get the i'th request id
                rid = reqIds{i};
                
                % get the contract for this rid
                contract = this.contractMap.get(rid);
                
                % get listeners associated with the request id
                listeners = this.listenerMap(rid);
                
                % create contract string for logging messages
                contractStr = [char(contract.m_symbol),'@',char(contract.m_primaryExch),' [',char(contract.m_secType),']'];
                
                % init entry header
                fprintf('%3d: %s\n',rid,contractStr);
                
                % print each listener
                for j = 1:numel(listeners)
                    
                    % get the i'th listener
                    l = listeners{i};
                    
                    % print the listener
                    fprintf('    %s\n',l.uuid);
                end
            end
        end
    end
    
    methods(Access = 'private')   
        
        function unsubscribeForReqId(this,rid)                      
            
            % enforce function signature
            if nargin ~=2 || ~isa(rid,'double')
                
                % yammer on about it in the log
                this.logger.error([TWS.Logger.this,'> ', 'arg 1 must be integer request id']);
                
                % for now, raise formal matlab error
                error('arg1 must be integer request id'); 
            end
            
            % make sure that the request id exists in both maps
            if ~ this.listenerMap.isKey(rid) || ~ this.contractMap.containsKey(rid)
                
                % elaborate on the log
                this.logger.error([TWS.Logger.this,'> ','request id not found: ',num2str(rid)]);
                
                % raise formal matlab error
                error(['request id not found in listener map: ',num2str(rid)]);
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
            
            % go through each listener and remove rid from list
            for i = 1:numel(listeners)
                
                % get the i'th listener
                l = listeners{i};
                
                % get associated request ids
                reqIds = this.reverseObjMap.get(l.uuid);
                
                % remove rid from array of reqIds
                reqIds(reqIds==rid) = [];
                
                % put back the list of request ids
                this.reverseObjMap.put(l.uuid,reqIds);
                
                % remove if emtpy
                if isempty(reqIds); this.reverseObjMap.remove(l.uuid); end
            end
            
            % elaborate on the log
            this.logger.debug([TWS.Logger.this,'> ','request id cancelled with TWS: ',num2str(rid)]);
            
            % make official API call for cancelation
            this.session.eClientSocket.cancelMktData(rid);
        end
        
        function unsubscribeForContract(this,contract)              
            
            % enforce function signature
            if nargin ~= 2 || ~isa(contract,'com.ib.client.Contract')
                
                % yell 
                this.logger.error([TWS.Logger.this,'> ',' arg1 must be com.ib.client.Contract'])
                
                % raise formal matlab error
                error(' arg1 must be com.ib.client.Contract');
            end
            
            % denfensive check that key exists in map
            if ~ this.reverseContractMap.containsKey(contract)
                
                % yammer 
                this.logger.error([TWS.Logger.this,'> ','contract not found: ', char(contract.m_symbol)])
                
                % raise matlab error about it
                error(['contract not found: ', char(contract.m_symbol)]); 
            end
            
            % get the request id associated with this contract
            rid = this.reverseContractMap.get(contract);
            
            % simply call unsubscribe for rid
            this.unsubscribeForReqId(rid);
        end
        
        function unsubscribeForObj(this,obj)                        
            
            % enforce function signature
            if nargin ~= 2 || ~isa(obj,'TWS.EventListener')
                
                % yell 
                this.logger.error([TWS.Logger.this,'> ',' arg1 must be TWS.EventListener'])
                
                % raise formal matlab error
                error(' arg1 must be TWS.EventListener');
            end
            
            % ok, if we can not resolve uuid then we're done
            if ~ this.reverseObjMap.containsKey(obj.uuid)

                % yell about it on the log
                this.logger.error([TWS.Logger.this,'> ','object not found: ',obj.uuid])

                % for now, raise formal matlab error
                error(['object not found: ',obj.uuid]); 
            end
            
            % get list of request ids associated with this object
            reqIds = this.reverseObjMap.get(obj.uuid);
            
            % for each request ...
            for i = 1:numel(reqIds)
                
                % get the i'th request
                rid = reqIds(i);
                
                % get the contract associated with this request id
                contract = this.contractMap.get(rid);
                
                % create contract string for logging messages
                contractStr = [char(contract.m_symbol),'@',char(contract.m_primaryExch),' [',char(contract.m_secType),']'];
            
                % get list of listeners for this request id 
                listeners = this.listenerMap(rid);
                
                % go though list of listeners and remove listener with matching uuid
                indx = strcmp(obj.uuid, cellfun(@(ll)ll.uuid,listeners,'UniformOutput',false));
                
                % sanity check - part 1
                if ~any(indx)   
                
                    % create logger message
                    this.logger.error([TWS.Logger.this,'> ','listener ',obj.uuid,' not found in rid ',num2str(rid)])
                    
                    % raise formal matlab error
                    error(['listener ',obj.uuid,' not found in rid ',num2str(rid)]); 
                end
                
                % sanity check - part 2
                if sum(indx) > 1
                    
                    % create logger message about issue
                    this.logger.debug([TWS.Logger.this,'> ','multiple listeners matching uuid: ',obj.uuid])
                end
                
                % remove the listener
                listeners(indx) = [];
                
                if isempty(listeners)
                    
                    % remove the request id all together 
                    this.unsubscribeForReqId(rid);
                else
                    % set the listeners map to this modified version
                    this.listenerMap(rid) = listeners;
                end
                                
                % make logger call to note  new market data request
                this.logger.debug([TWS.Logger.this,'> ', contractStr,' removed listener ',obj.uuid]);
            end
        end
        
        function unsubscribeForContractForObj(this,contract,obj)    
            
            % enforce function signature
            if nargin ~= 3 || ~isa(contract,'com.ib.client.Contract') || ~isa(obj,'TWS.EventListener')
                
                % yell 
                this.logger.error([TWS.Logger.this,'> ',' arg1 must be com.ib.client.Contract and arg2 must be TWS.EventListener'])
                
                % raise formal matlab error
                error(' arg1 must be com.ib.client.Contract arg2 must be TWS.EventListener');
            end
            
            % create contract string for logging messages
            contractStr = [char(contract.m_symbol),'@',char(contract.m_primaryExch),' [',char(contract.m_secType),']'];
            
            % make sure the contract exists
            if ~this.reverseContractMap.containsKey(contract)
                
                % yell, scream, shout 
                this.logger.error([TWS.Logger.this,'> ',' contract not found: ',contractStr]); return;
            end
            
            % get reqId for this contract
            rid = this.reverseContractMap.get(contract);
            
            % get set of listeners for this request id
            listeners = this.listenerMap(rid);
            
            % go though list of listeners and remove listener with matching uuid
            indx = strcmp(obj.uuid, {listeners.uuid});

            % sanity check - part 1
            if ~any(indx)   

                % create logger message
                this.logger.error([TWS.Logger.this,'> ','listener ',obj.uuid,' not found in rid ',num2str(rid)])

                % raise formal matlab error
                error(['listener ',obj.uuid,' not found in rid ',num2str(rid)]); 
            end

            % sanity check - part 2
            if sum(indx) > 1

                % create logger message about issue
                this.logger.debug([TWS.Logger.this,'> ','multiple listeners matching uuid: ',obj.uuid])
            end

            % remove the listener
            listeners(indx) = [];

            % if there are no more listeners just remove reqId
            if isempty(listeners)

                % remove the request id all together 
                this.unsubscribeForReqId(rid);
            else
                % set the listeners map to this modified version
                this.listenerMap(rid) = listeners;
            end

            % make logger call to note  new market data request
            this.logger.debug([TWS.Logger.this,'> ', contractStr,' removed listener ',obj.uuid]);
        end
    end
    
    methods
        function delete(this)                                       

            % cancell all existing market data requests
            if ~ this.listenerMap.isempty()
                
                % get list of all request ids
                keySet = this.listenerMap.keys();
                
                % cancel each request one by one
                for i = 1:numel(keySet)
                    
                    % make API call for cancel
                    this.session.eClientSocket.cancelMktData(keySet{i}); 
                    
                    % blab about it
                    this.logger.debug([TWS.Logger.this,'> ','reqId ',num2str(keySet{i}),' has been cancelled with TWS']);
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