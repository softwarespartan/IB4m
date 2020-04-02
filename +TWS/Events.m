classdef (Sealed) Events < handle
   
    properties(Constant)      
        NOTIFICATION       = 'TWS_NOTIFICATION'       ;
        REALTIMEBAR        = 'TWS_REALTIMEBAR'        ;
        HISTORICALDATA     = 'TWS_HISTORICALDATA'     ;
        ACCOUNTSUMMARY     = 'TWS_ACCOUNTSUMMARY'     ;
        ACCOUNTUPDATE      = 'TWS_ACCOUNTUPDATE'      ;
        POSITIONS          = 'TWS_POSITIONS'          ;
        MARKETDATA         = 'TWS_MARKETDATA'         ;
        MARKETMETADATA     = 'TWS_MARKETMETADATA'     ;
        MARKETDEPTH        = 'TWS_MARKETDEPTH'        ;
        CONTRACTDETAILS    = 'TWS_CONTRACTDETAILS'    ;
        OPENORDER          = 'TWS_OPENORDER'          ;
        ORDERSTATUS        = 'TWS_ORDERSTATUS'        ;
        PORTFOLIOUPDATE    = 'TWS_PORTFOLIOUPDATE'    ;
        EXECUTIONDETAILS   = 'TWS_EXECUTIONDETAILS'   ;
        NEXTORDERID        = 'TWS_NEXTORDERID'        ;
        SCANNERDATA        = 'TWS_SCANNERDATA'        ;
        OPTIONCOMPUTATION  = 'TWS_OPTIONCOMPUTATION'  ;
        ERROR              = 'TWS_ERROR'              ;
        TIME               = 'TWS_TIME'               ;
        CONNECTIONCLOSED   = 'TWS_CONNECTIONCLOSED'   ;
        COMMISSIONREPORT   = 'TWS_COMMISSIONREPORT'   ;
        MARKETRULE         = 'TWS_MARKETRULE'         ;
        HEADTIMESTAMP      = 'TWS_HEADTIMESTAMP'      ;
        FINANCIALADVISORY  = 'TWS_FINANCIALADVISORY'  ;
        FUNDAMENTALDATA    = 'TWS_FUNDAMENTALDATA'    ;
        SYMBOLSAMPLE       = 'TWS_SYMBOLSAMPLE'       ;
        TICKBYTICK_ALLLAST = 'TWS_TICKBYTICK_ALLLAST' ;
        TICKBYTICK_BIDASK  = 'TWS_TICKBYTICK_BIDASK'  ;
        TICKBYTICK_MIDPOINT= 'TWS_TICKBYTICK_MIDPOINT';
        
    end
    
    events                      
        TWS_NOTIFICATION       ;
        TWS_REALTIMEBAR        ;
        TWS_HISTORICALDATA     ;
        TWS_ACCOUNTSUMMARY     ;
        TWS_ACCOUNTUPDATE      ;
        TWS_POSITIONS          ;
        TWS_MARKETDATA         ;
        TWS_MARKETMETADATA     ;
        TWS_MARKETDEPTH        ;
        TWS_CONTRACTDETAILS    ;
        TWS_ORDERSTATUS        ;
        TWS_OPENORDER          ;
        TWS_PORTFOLIOUPDATE    ;
        TWS_EXECUTIONDETAILS   ;
        TWS_NEXTORDERID        ;
        TWS_SCANNERDATA        ;
        TWS_OPTIONCOMPUTATION  ;
        TWS_ERROR              ;
        TWS_TIME               ;
        TWS_CONNECTIONCLOSED   ;
        TWS_COMMISSIONREPORT   ;
        TWS_MARKETRULE         ;
        TWS_HEADTIMESTAMP      ;
        TWS_FINANCIALADVISORY  ;
        TWS_FUNDAMENTALDATA    ;
        TWS_SYMBOLSAMPLE       ;
        TWS_TICKBYTICK_ALLLAST ;
        TWS_TICKBYTICK_BIDASK  ;
        TWS_TICKBYTICK_MIDPOINT;
    end
    
    methods (Access = private)
      function this = Events();end
    end
    
    methods (Static)          
      function instance = getInstance
         persistent localInstance
         if isempty(localInstance) || ~isvalid(localInstance)
            localInstance = TWS.Events();
         end
         instance = localInstance;
      end
    end
end