function [isValid, errors] = validateEmail(emailAddress)
    % VALIDATEEMAIL Validates email address format and structure
    %   This function checks email addresses against standard patterns and returns
    %   validation status with detailed error messages.
    %
    %   Syntax:
    %       [isValid, errors] = validateEmail(emailAddress)
    %
    %   Inputs:
    %       emailAddress  (1,1) string  - Email address to validate
    %
    %   Outputs:
    %       isValid       (1,1) logical - True if email is valid, false otherwise
    %       errors        (n,1) string  - Array of error messages (empty if valid)

    %% Input Validation
    arguments
        emailAddress (1,1) string {mustBeNonzeroLengthText}
    end

    %% Initialize Outputs
    isValid = true;
    errors = string.empty();

    %% Email Format Validation
    % Basic email pattern: localpart@domain.extension
    emailPattern = ...
        "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]" + ...
        "{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}" + ...
        "[a-zA-Z0-9])?)*$";

    if ~matches(emailAddress, emailPattern)
        isValid = false;
        errors = [errors; "Email format is invalid"];
    end

    %% Length Validation
    maxEmailLength = 254;  % RFC 5321 standard
    if strlength(emailAddress) > maxEmailLength
        isValid = false;
        errors = [errors; ...
            "Email exceeds maximum length of " + maxEmailLength + " characters"];
    end

    %% Local Part Validation (before @)
    [localPart, ~] = strtok(emailAddress, "@");
    maxLocalLength = 64;  % RFC 5321 standard
    if strlength(localPart) > maxLocalLength
        isValid = false;
        errors = [errors; ...
            "Local part exceeds maximum length of " + maxLocalLength];
    end

    %% Domain Validation (after @)
    if contains(emailAddress, "@")
        parts = split(emailAddress, "@");
        if length(parts) == 2
            domain = parts(2);
            if ~contains(domain, ".")
                isValid = false;
                errors = [errors; "Domain must contain at least one dot"];
            end
            if startsWith(domain, ".") || endsWith(domain, ".")
                isValid = false;
                errors = [errors; "Domain cannot start or end with a dot"];
            end
        end
    end

    %% Check for Consecutive Dots
    if contains(emailAddress, "..")
        isValid = false;
        errors = [errors; "Email cannot contain consecutive dots"];
    end

end