SELECT
    bigint_field,
    smallint_field,
    numeric_field,
    double_field,
    boolean_field,
    varchar_field,
    char_field,
    text_field,
    date_field,
    time_timezone_field,
    time_field,
    enum_field,
    array_field,
    xml_field,
    json_field,
    composite_field,
    money_field,
    byte_field,
    point_field,
    line_field,
    varbit_field,
    uuid_field
FROM
    public.types_table
WHERE
    bigint_field = 99999999999999999
    AND smallint_field = 30000
    AND numeric_field = 123456.789
    AND double_field = 123.456
    AND boolean_field = false
    AND varchar_field = 'string'
    AND char_field = 'some example string of length 32'
    AND text_field = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
    AND date_field = '2000-01-01'
    AND time_timezone_field = '00:00:00 +03:00'
    AND time_field = '00:00:00'
    AND enum_field = 'first_value'
    AND array_field = '{123, 234, 345, 456, 567}'
    AND xml_field IS DOCUMENT
    AND json_field->>'value'='Close'
	AND (composite_field).example_int = 123
    AND money_field = '1000'
    AND byte_field = '\x45CFF3'
    AND point_field ~=point(1.234, 3.432)
    AND line_field = '((23.312, 86.432),(12.321, 4.321))'
    AND varbit_field = '1010001100110'
    AND uuid_field = '84fdc84e-1dcd-44a6-acb1-09ba31a9e0cd';
