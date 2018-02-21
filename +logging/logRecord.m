classdef logRecord
% logRecord Encapsulate information to be logged
%   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        name; % name of the logger used to log the event
        level; % saved as numerical code
        levelName;
        created; % creation time, saved as datetime object
        func; % the calling function
        pathname; % full pathname of file that called for creation of this record
        lineno; % linenumber in file that called for creation of this record
        message; % the message to log
    end
    
    methods
        function record = logRecord(name,level,levelName,message,func,pathname,lineno)
            % Construct a new logRecord object
        
            % Input validation
        
            % Create record
            record.name = name;
            record.level = level;
            record.levelName = levelName;
            record.pathname = pathname;
            record.func = func;
            record.lineno = lineno;
            record.message = message;
            
            record.created = now;
        end
    end
    
end