function fname = this(  )
    
    % init empty
    fname = '';

    % get the current call stack
    stk = dbstack(); 

    % if no stack then return
    if isempty(stk); return; end

    % if only a single call on the stack
    if numel(stk) == 1; stk =stk(1); else stk = stk(2); end

    % return the name of function that call this function
    fname = [stk.name,':',num2str(stk.line)]; 
end

