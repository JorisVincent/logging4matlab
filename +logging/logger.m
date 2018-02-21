classdef logger < handle
% Logger class for the logging package
%
% Syntax:
%
% Description:
%    Logger class for a Pythonic logging MATLAB package.
%
%    Heavily modified version of logging4matlab, original author: Dominique
%    Orban <dominique.orban@gmail.com>, which is a heavily modified version
%    of 'log4m': http://goo.gl/qDUcvZ.
%
% History:
%    01/12/18  jv   forked github.com/optimizers/logging4matlab.git, 
%                   started modifications.
    
    properties (SetAccess = immutable)
        name;
    end
    
    properties (SetAccess = protected)
        levels = containers.Map(...
            {'ALL','CRITICAL','ERROR','WARNING','INFO','DEBUG','TRACE','NOTSET'},...
            {Inf,50,40,30,20,10,0,-Inf});
        handlers;
    end
    
    properties (Hidden, SetAccess = protected)
        level = -Inf; % default level for logger is NOTSET
    end
    
    properties (Dependent)
        effectiveLevel;
    end
    
    %% Constructor
    methods
        function self = logger(name, varargin)
            % Create a new logger object
            parser = inputParser();
            parser.addRequired('name', @ischar);
            parser.addParameter('level', self.level);
            parser.addParameter('handler', logging.handlers.NullHandler());
            parser.parse(name, varargin{:});
            
            self.name = parser.Results.name;
            self.level = parser.Results.level;
            self.handlers = parser.Results.handler;
        end
    end
    
    %% Logging methods
    methods
        function record = makeRecord(self, level, message, func, pathname, lineno)
            level = self.getLevelNumber(level);
            record = logging.logRecord(self.name, level, self.getLevelString(level), message, func, pathname, lineno);
        end
        
        function log(self, level, message)
            % Log a new message
            %
            % Syntax:
            %   log(logger, level, message)
            %
            % Inputs:
            %    logger - logging.logger object
            %    level  - numeric severity level
            %
            level = self.getLevelNumber(level);
            if level >= self.effectiveLevel
                % Create record
                record = self.makeRecord(level, message, '','',0);
                
                % Send to handlers
                for handler = self.handlers
                	handler.handle(record);
                end
            end
        end
        
        function trace(self, message)
            % Log a message with level TRACE
            [caller_name, ~] = self.findCaller(self);            
            self.log('TRACE', message);
        end
        
        function debug(self, message)
            % Log a message with level DEBUG
            [caller_name, ~] = self.findCaller(self);
            self.log('DEBUG', message);
        end
        
        function info(self, message)
            % Log a message with level INFO
            [caller_name, ~] = self.findCaller(self);
            self.log('INFO', message);
        end
        
        function warning(self, message)
            % Log a message with level WARNING
            [caller_name, ~] = self.findCaller(self);
            self.log('WARNING', message);
        end
        
        function error(self, message)
            % Log a message with level ERROR
            [caller_name, ~] = self.findCaller(self);
            self.log('ERROR', message);
        end
        
        function critical(self, message)
            % Log a message with level CRITICAL
            [caller_name, ~] = self.findCaller(self);
            self.log('CRITICAL', message);
        end
    end
    
    %% Setters, getters
    methods
        function set.level(self, level)
            % Set the level of this logger
            level = self.getLevelNumber(level);
            self.level = level;
        end
        
        function addHandler(self,handler)
            % Add a new handler to this logger
            assert(isa(handler,'logging.handlers.Handler'),'Not a valid handler');
            self.handlers = union(handler,self.handlers);
        end
        
        function level = get.effectiveLevel(self)
            % TODO Get the effective level of this logger
            %  If this logger does not have a level set, go up to the parent
            %  loggers until we find one.
            level = self.level;
        end
        
        function level = getLevelNumber(self, level)
            % Convert stringliteral level to numeric level code
            if ischar(level)
                assert(isKey(self.levels,level),'Level %s not defined for this logger');
                level = self.levels(level);
            end
        end
        function level = getLevelString(self, level)
            % Convert numeric level code to stringliteral level
            if isnumeric(level)
                levelsInv = containers.Map(values(self.levels),keys(self.levels));
                assert(isKey(levelsInv,level),'Level %d does not have a label in this logger');
                level = levelsInv(level);
            elseif ischar(level)
                assert(isKey(self.levels,level),'Level %s not defined for this logger');
            end
        end
    end
    
    %% Static methods
    methods(Static)
        function [name, line] = findCaller(self)
            % Find out who called the logger
%             if nargin > 0 && self.ignoreLogging()
%                 name = [];
%                 line = [];
%                 return
%             end
            [ST, ~] = dbstack();
            offset = min(size(ST, 1), 3);
            name = ST(offset).name;
            line = ST(offset).line;
        end
    end
    
end
