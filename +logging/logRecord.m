classdef logRecord
% logRecord Encapsulate information to be logged
%   Detailed explanation goes here
    
    properties (SetAccess = immutable)
        name; % name of the logger used to log the event
        level; % saved as numerical code
        created; % creation time, saved as datetime object
        pathname; % full pathname of file that called for creation of this record
        lineno; % linenumber in file that called for creation of this record
        message;
        func; 
    end
    
    methods
        function record = logRecord(name,level,pathname,func,lineno,message)
        % Construct a new logRecord object
            record.name = name;
            record.level = level;
            record.pathname = pathname;
            record.func = func;
            record.lineno = lineno;
            record.message = message;
            
            record.created = now;
        end
    end
    
end