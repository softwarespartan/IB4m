classdef ProxyBuilder < handle
    %PROXYBUILDER Construct a <a href="https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/Proxy.html">java.lang.reflect.Proxy</a> for a given <a href="https://docs.oracle.com/javase/tutorial/java/concepts/interface.html">interface</a>.
    %
    %  Constructor:  PROXYBUILDER(<a href="https://docs.oracle.com/javase/8/docs/api/java/lang/Class.html">java.lang.Class</a>)
    %                PROXYBUILDER('com.fully.qualified.name',<a href="https://docs.oracle.com/javase/8/docs/api/java/lang/ClassLoader.html">java.lang.ClassLoader</a>)
    %
    %  Initializers: init()
    %                initForMethod('methodName')
    %                initForInterface('InterfaceName')
    %
    %  Helpers:      getClassLoader()
    %                getDeclaredClasses()
    %                resolveClassForMethod('methodName')
    
    properties (GetAccess = 'public', SetAccess = 'private')                 
        class
    end
    
    methods (Static, Access = 'private')                                 
        
        function [proxy,invocationHandler] = buildProxy(targetClass)         
            % PROXYBUILDER.BUILDPROXY initialize proxy and invocation handler for interface using external java helper
            
            % enforce function signature
            if nargin ~= 1 || ~isa(targetClass,'java.lang.Class')
                error('input must be single arg of type java.lang.Class');
            end
            
            % ok now that we have a target must ensure it is an interface
            if ~ targetClass.isInterface()
                error(['class ',char(targetClass.getName()),' is not an interface']);
            end
            
            % init with external java proxy builder helper 
            proxy = com.proxy.ProxyBuilder().buildProxy(targetClass);
            
            % finally get the invocation handler
            invocationHandler = java.lang.reflect.Proxy.getInvocationHandler(proxy);
        end
    end
    
    methods (Static)
        function classLoader = getClassLoader()                              
            % PROXYBUILDER.GETCLASSLOADER helper function to return a useful ClassLoader from com.mathworks.jmi.ClassLoaderManager
            
            % this one always seems to work ... 
            classLoader = com.mathworks.jmi.ClassLoaderManager.getClassLoaderManager();
        end
    end
    
    methods
        
        function this = ProxyBuilder(varargin)                               
            
            % enforce the function signature
            if numel(varargin) ~= 1 && numel(varargin) ~= 2
                error('ProxyBuilder constructor takes one or two input args');
            end
            
            % enforce arg type for single arg constructor
            if numel(varargin) == 1
                
                % make sure arg1 is a java Class object
                if ~isa(varargin{1},'java.lang.Class')
                    error('arg1 must be of type java.lang.Class');
                end
                
                % set the class
                this.class = varargin{1};
            end
            
            % enforce input args for double arg constructor
            if numel(varargin) == 2
                
                % make sure arg1 is a string/char
                if ~isa(varargin{1},'char')
                    error('arg1 must be of type char');
                end
                
                % make sure arg2 is a class loader java object 
                if ~isa(varargin{2},'java.lang.ClassLoader')
                    error('arg2 must be of type java.lang.ClassLoader');
                end
                
                % load the class object using the class loader with string
                this.class = varargin{2}.loadClass(varargin{1});
            end
        end
        
        function [proxy,invocationHandler] = init(this)                      
            % PROXYBUILDER.INIT build proxy directly from constructor class object
            
            % if empty no dice
            if isempty(this.class); error('invalid state: no class property found ...'); end
            
            % initialize proxy and invocation handler externally using java helper class
            [proxy,invocationHandler] = ProxyBuilder.buildProxy(this.class);
        end
        
        function [proxy,invocationHandler] = initForMethod(this,varargin)    
            % PROXYBUILDER.INITFORMETHOD build proxy which implements interface containing method
            
            % enforce function signature
            if numel(varargin) ~= 1 && numel(varargin) ~= 2
                error('input must be one or two arguments of type char');
            end
            
            % enforce argument types
            if ~all(cellfun(@(c)isa(c,'char'),varargin))
                error('input args must be of type char');
            end
            
            % figure out who/what implements this method if at all
            targetClass = this.resolveClassForMethod(varargin{1});
            
            % if empty no dice
            if isempty(targetClass); error(['no class found declaring method: ', varargin{1}]); end
            
            % initialize proxy and invocation handler externally using java helper class
            [proxy,invocationHandler] = ProxyBuilder.buildProxy(targetClass);
            
            % map the method invocation if mapping provided
            if numel(varargin) == 2; invocationHandler.invocationMap.put(varargin{1},varargin{2}); end
        end
        
        function [proxy,invocationHandler] = initForInterface(this,interface)
            % PROXYBUILDER.INITFORINTERFACE build proxy for named declared class/interface
            
            % enforce the function signature
            if nargin ~= 2; error('input must be single argument of type char'); end
            
            % enforce input arg type
            if ~ isa(interface,'char'); error('arg1 must be of type char'); end
            
            % look up the named class/interface
            indx = strcmp(interface, this.getDeclaredClasses());

            % make sure we have a match
            if ~any(indx); error(['no matching declared class found for ',interface]); end
            
            % get the target class/interface to build the proxy
            dClasses = this.class.getDeclaredClasses(); targetClass = dClasses(indx);
            
            % initialize proxy and invocation handler externally using java helper class
            [proxy,invocationHandler] = ProxyBuilder.buildProxy(targetClass);
        end
        
        function classes = getDeclaredClasses(this)                          
            % PROXYBUILDER.GETDECLAREDCLASSES returns declared class listing as cell array of chars
            
            % nothing fancy ...
            classes = arrayfun(@(a)char(a.getName()),...
                        this.class.getDeclaredClasses(),'UniformOutput',false);
        end
        
        function class = resolveClassForMethod(this,method)                  
           % PROXYBUILDER.RESOLVECLASSFORMETHOD search for class or declared class which declares method (first match returned)
           
            % init output
            class = [];
            
            % enforce function signature
            if nargin ~= 2
                error('input must be a single argument of type char'); 
            end
            
            % search for method in primary enclosing class
            indx = strcmp( method, ...
                    arrayfun( @(m)char(m.getName()), ...
                        this.class.getDeclaredMethods(),'UniformOutput',0));
                    
            % if found match then we're done
            if any(indx); class = this.class; return; end
                    
            % if no match then search through declared classes for method match
                
            % get list of inner class/interface/etc declarations
            dClasses = this.class.getDeclaredClasses();

            % look through each one
            for i = 1:numel(dClasses)

                % search inner class for method declaration matching method name
                indx = strcmp( method, ...
                         arrayfun( @(m)char(m.getName()), ...
                            dClasses(i).getDeclaredMethods(),'UniformOutput',0));

                % if we have a match then we're done
                if any(indx); class = dClasses(i); return; end
            end
        end
    end
end