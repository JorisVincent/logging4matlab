classdef FileHandler < logging.handlers.StreamHandler
% FILEHANDLER emits logs to a file
%   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        filename;
        permission;
        
    end
    
    methods
        function self = FileHandler(filename,varargin)
            parser = inputParser;
            parser.addRequired('filename');
            parser.addOptional('permission','a');
            parser.parse(filename,varargin{:});
            
            self.filename = parser.Results.filename;
            self.permission = parser.Results.permission;
            
            self.stream = fopen(self.filename,self.permission);
        end
        
        function close(self)
            fclose(self.stream);
        end
    end
    
end