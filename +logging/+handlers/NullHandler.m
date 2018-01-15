classdef NullHandler < logging.handlers.Handler
% NULLHANDLER is an empty Handler, the default for loggers.
%   Detailed explanation goes here
    
    properties
    end
    
    methods
        function emit(~,~)
            % do nothing.
        end
    end
    
end