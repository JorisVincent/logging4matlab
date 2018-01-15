classdef StreamHandler < logging.handlers.Handler
% StreamHandler emits logs to a stream (default is stdout)
%   Detailed explanation goes here
    
    properties
        stream;
    end
    
    methods
        function self = StreamHandler(varargin)
            parser = inputParser;
            parser.addOptional('stream',1) % default is stdout (= command window in MATLAB GUI)
            parser.parse(varargin{:});
            
            self.stream = parser.Results.stream;
        end
        
        function emit(self,message)
            fprintf(self.stream,'%s\n',message);
        end
    end
    
end