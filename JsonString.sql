--JSON characters that need to be escaped
--\b  Backspace (ascii code 08)
--\f  Form feed (ascii code 0C)
--\n  New line
--\r  Carriage return
--\t  Tab
--\v  Vertical tab
--\'  Apostrophe or single quote
--\"  Double quote
--\\  Backslash caracter

CREATE FUNCTION dbo.JsonString
(@n varchar(max))
RETURNS varchar(max)
AS
BEGIN
	RETURN
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
	@n,CHAR(92),CHAR(92)+CHAR(92))
	,CHAR(8),'\b')
	,CHAR(9),'\t')
	,CHAR(10),'\n')
	,CHAR(11),'\v')
	,CHAR(12),'\f')
	,CHAR(13),'\r')
	,CHAR(39),CHAR(92)+CHAR(39))
	,CHAR(34),CHAR(92)+CHAR(34))
end
