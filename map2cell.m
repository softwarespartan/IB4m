function out = map2cell(map)
% MAP2CELL convert java.util.Map types to cell array of the form {{k,v},{k,v}, ..., {k,v}}

% enforce function signature
if nargin ~=1; error('input must be single arg of type java.util.Map'); end

% enforce input arg types
if ~isa(map,'java.util.Map'); error('input arg1 must be of type java.util.Map'); end

% init
indx = 0;

% get entry set iterator for kv-pairs
entries = map.entrySet().iterator();

% mem allocate for output cell array of key-value pairs
out = cell(1,map.size());  for i = 1:map.size(); out{i} = cell(1,2); end; 

% iterate kv-pairs
while entries.hasNext()
    
    % update the index
    indx = indx + 1;
    
    % get the next entry
    entry = entries.next();
    
    % stash this kv set in the output cell array
    out{indx}{1} = entry.getKey();  out{indx}{2} = entry.getValue();
end