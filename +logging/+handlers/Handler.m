classdef (Abstract) Handler < matlab.mixin.SetGet & matlab.mixin.Heterogeneous
% HANDLER defines the abstract interface for all log handlers
%   Detailed explanation goes here
    
    properties (SetAccess = protected)
        level = -Inf;
    end
    
    methods (Abstract)
        emit(self,message);
    end
    
    methods % Setters
        function set.level(self, level)
            self.level = level;
        end
        function setLevel(self, level)
            self.level = level;
        end
    end
    
    methods
        function handle(self,message)
            % TODO Filter, compare to level, format.
            self.emit(message);
        end
    end
end