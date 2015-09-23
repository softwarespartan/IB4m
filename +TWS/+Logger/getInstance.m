function [logger,configFile] = getInstance(classId,configFile)

    % enforce function signature
    if nargin ~= 1 && nargin ~= 2
        error('input args must be class(obj) and config file path as type char');
    end

    % look up config file ...
    if nargin == 1
        
        % look for config file on the matlab path
        configFile = which('log4j.conf');
        
        % if no file found then we're done
        if isempty(configFile)
            
            % blab about it
            error('could not find file on path: log4j.conf');
        end
    end
        
    % sanity check: make sure the file exists
    if exist(configFile,'file') ~= 2
        
        % blab about it ...
        error(['the file does not exist: ',configFile]);
    end
    
    % init the logger 
    logger = org.apache.log4j.Logger.getLogger(classId);
    
    % configure the logger with properties in the logger config file
    org.apache.log4j.PropertyConfigurator.configure(configFile);
end

