%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Unit tests for jsondecode()
%%
%% Code in libinterp/corefcn/jsondecode.cc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Note: This script is intended to also run under Matlab to verify
%%       compatibility.  Preserve Matlab-formatting when making changes.

%%% Test 1: decode null values

%% null, in non-numeric arrays -> Empty double []
%!testif HAVE_RAPIDJSON
%! json = '["str", 5, null, true]';
%! exp  = {'str'; 5; []; true};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% null, in numeric arrays to NaN (extracted from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '[1, 2, null, 3]';
%! exp  = [1; 2; NaN; 3];
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%% corner case: array of null values
%!testif HAVE_RAPIDJSON
%! json = '[null, null, null]';
%! exp  = [NaN; NaN; NaN];
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%%% Test 2: Decode scalar Boolean, Number, and String values

%!testif HAVE_RAPIDJSON
%! assert (isequal (jsondecode ('true'), logical (1)));
%! assert (isa (jsondecode ('true'), 'logical'));
%! assert (isequal (jsondecode ('false'), logical (0)));
%! assert (isa (jsondecode ('false'), 'logical'));
%! assert (isequal (jsondecode ('123.45'), 123.45));
%! assert (isequal (jsondecode ('"hello there"'), 'hello there'));

%%% Test 3: Decode Array of Booleans, Numbers, and Strings values

%% vectors are always rendered as column vectors
%!testif HAVE_RAPIDJSON
%! json = '[true, true, false, true]';
%! exp  = logical ([1; 1; 0; 1]);
%! obs  = jsondecode (json);
%! assert (isa (obs, 'logical'));
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON <*59135>
%! json = '[[true, true], [false, true]]';
%! exp  = logical ([1, 1; 0, 1]);
%! obs  = jsondecode (json);
%! assert (isa (obs, 'logical'));
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '["true", "true", "false", "true"]';
%! exp  = {'true'; 'true'; 'false'; 'true'};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '["foo", "bar", ["foo", "bar"]]';
%! exp  = {'foo'; 'bar'; {'foo'; 'bar'}};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% vectors are always rendered as column vectors
%!testif HAVE_RAPIDJSON
%! json = '[15000, 5, 12.25, 1502302.3012]';
%! exp  = [15000; 5; 12.25; 1502302.3012];
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% row vectors are preserved by adding one level of hierarchy
%% extracted from JSONio
%!testif HAVE_RAPIDJSON
%! json = '[[1,2]]';
%! exp  = [1, 2];
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% If same dimensions -> transform to an array (extracted from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '[[1, 2], [3, 4]]';
%! exp  = [1, 2; 3, 4];
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% extracted from JSONio
%!testif HAVE_RAPIDJSON
%! json = '[[[1, 2], [3, 4]], [[5, 6], [7, 8]]]';
%! exp  = cat (3, [1, 3; 5, 7], [2, 4; 6, 8]);
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% try different dimensions for the array
%!testif HAVE_RAPIDJSON
%! json = '[[[1, 2, -1], [3, 4, null]], [[5, 6, Inf], [7, 8, -Inf]]]';
%! exp  = cat (3, [1, 3; 5, 7], [2, 4; 6, 8], [-1, NaN; Inf, -Inf]);
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%% try different dimensions for the array
%!testif HAVE_RAPIDJSON
%! json = '[[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]]]';
%! exp  = cat (3, [1, 3; 5, 7; 9, 11], [2, 4; 6, 8; 10, 12]);
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%% try higher dimensions for the array
%!testif HAVE_RAPIDJSON
%! json = ['[[[[1,-1], [2,-2]],[[3,-3],[4,-4]]],[[[5,-5],[6,-6]],[[7,-7],', ...
%!         '[8,-8]]],[[[9,-9], [10,-10]],[[11,-11],[12,-12]]],', ...
%!         '[[[13,-13],[14,-14]],[[15,-15],[16,-16]]]]'];
%! var1 = cat (3, [1, 3; 5, 7; 9, 11; 13, 15], [2, 4; 6, 8; 10, 12; 14, 16]);
%! var2 = cat (3, [-1, -3; -5, -7; -9, -11; -13, -15], ...
%!             [-2, -4; -6, -8; -10, -12; -14, -16]);
%! exp  = cat (4, var1, var2);
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '[[true, false], [true, false], [true, false]]';
%! exp  = logical ([1 0; 1 0; 1 0]);
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% If different dimensions -> transform to a cell array (extracted from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '[[1, 2], [3, 4, 5]]';
%! exp  = {[1; 2]; [3; 4; 5]};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% extracted from JSONio
%%!testif HAVE_RAPIDJSON
%! json = '[1, 2, [3, 4]]';
%! exp  = {1; 2; [3; 4]};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '[true, false, [true, false, false]]';
%! exp  = {true; false; logical([1; 0; 0])};
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));
%! assert (isa (obs{1}, 'logical'));
%! assert (isa (obs{2}, 'logical'));
%! assert (isa (obs{3}, 'logical'));

%%% Test 4: decode JSON Objects

%% Check decoding of Boolean, Number, and String values inside an Object
%!testif HAVE_RAPIDJSON
%! json = '{"number": 3.14, "string": "foobar", "boolean": false}';
%! exp  = struct ('number', 3.14, 'string', 'foobar', 'boolean', false);
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));
%! assert (isa (obs.boolean, 'logical'));

%% Check decoding of null values and arrays inside an object & makeValidName
%!testif HAVE_RAPIDJSON
%! json = [ '{"nonnumeric array": ["str", 5, null],' ...
%!          '"numeric array": [1, 2, null]}' ];
%! exp  = struct ('nonnumericArray', {{'str'; 5; []}}, ...
%!                'numericArray', {[1; 2; NaN]});
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%% Check decoding of objects inside an object & makeValidName (from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '{"object": {"  field 1   ": 1, "field-   2": 2, "3field": 3, "": 1}}';
%! exp  = struct ('object', ...
%!                struct ('field1', 1, 'field_2', 2, 'x3field', 3, 'x', 1));
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Check decoding of empty objects, empty arrays, and Inf inside an object
%!testif HAVE_RAPIDJSON
%! json = '{"a": Inf, "b": [], "c": {}}';
%! exp  = struct ('a', Inf, 'b', [], 'c', struct ());
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Check decoding of string arrays inside an object & makeValidName
%% extracted from JSONio
%!testif HAVE_RAPIDJSON
%! json = '{"%string.array": ["Statistical","Parametric","Mapping"]}';
%! exp  = struct ('x_string_array', ...
%!                {{'Statistical'; 'Parametric'; 'Mapping'}});
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% extracted from jsonlab
%!testif HAVE_RAPIDJSON
%! json = ['{' , ...
%!     '"glossary": { ', ...
%!         '"title": "example glossary",', ...
%!     '"GlossDiv": {', ...
%!             '"title": "S",', ...
%!     '"GlossList": {', ...
%!                 '"GlossEntry": {', ...
%!                     '"ID": "SGML",', ...
%!                     '"SortAs": "SGML",', ...
%!                     '"GlossTerm": "Standard Generalized Markup Language",', ...
%!                     '"Acronym": "SGML",', ...
%!                     '"Abbrev": "ISO 8879:1986",', ...
%!                     '"GlossDef": {', ...
%!                         '"para": "A meta-markup language, ', ...
%!                         'used to create markup languages such as DocBook.",', ...
%!                         '"GlossSeeAlso": ["GML", "XML"]', ...
%!                     '},', ...
%!                     '"GlossSee": "markup"', ...
%!                 '}', ...
%!             '}', ...
%!         '}', ...
%!     '}', ...
%! '}'];
%! var1 = struct ('para', ['A meta-markup language, used to create ' ...
%!                         'markup languages such as DocBook.'], ...
%!                'GlossSeeAlso', {{'GML'; 'XML'}});
%! var2 = struct ('ID', 'SGML', 'SortAs', 'SGML', ...
%!                'GlossTerm', 'Standard Generalized Markup Language', ...
%!                'Acronym', 'SGML', 'Abbrev', 'ISO 8879:1986', ...
%!                'GlossDef', var1, 'GlossSee', 'markup');
%! exp  = struct ('glossary', ...
%!                struct ('title', 'example glossary', ...
%!                        'GlossDiv', struct ('title', 'S', ...
%!                                            'GlossList', ...
%!                                            struct ('GlossEntry', var2))));
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%%% Test 5: decode Array of JSON objects

%% Arrays with the same field names in the same order (extracted from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '{"structarray": [{"a":1,"b":2},{"a":3,"b":4}]}';
%! exp  = struct ('structarray', struct ('a', {1; 3}, 'b', {2; 4}));
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Different field names before calling makeValidName, BUT the same after
%% calling it, resulting in structarray.
%! json = [ '[', ...
%!       '{', ...
%!         '"i*d": 0,', ...
%!         '"12name": "Osborn"', ...
%!       '},', ...
%!       '{', ...
%!         '"i/d": 1,', ...
%!         '"12name": "Mcdowell"', ...
%!       '},', ...
%!       '{', ...
%!         '"i+d": 2,', ...
%!         '"12name": "Jewel"', ...
%!       '}', ...
%!     ']'];
%! exp  = struct ('i_d', {0; 1; 2}, ...
%!                'x12name', {'Osborn'; 'Mcdowell'; 'Jewel'});
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Arrays with the same field names in the same order.
%% JSON text is generated from json-generator.com
%!testif HAVE_RAPIDJSON
%! json = ['[', ...
%!   '{', ...
%!     '"x_id": "5ee28980fc9ab3",', ...
%!     '"index": 0,', ...
%!     '"guid": "b229d1de-f94a",', ...
%!     '"latitude": -17.124067,', ...
%!     '"longitude": -61.161831,', ...
%!     '"friends": [', ...
%!       '{', ...
%!         '"id": 0,', ...
%!         '"name": "Collins"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 1,', ...
%!         '"name": "Hays"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 2,', ...
%!         '"name": "Griffin"', ...
%!       '}', ...
%!     ']', ...
%!   '},', ...
%!   '{', ...
%!     '"x_id": "5ee28980dd7250",', ...
%!     '"index": 1,', ...
%!     '"guid": "39cee338-01fb",', ...
%!     '"latitude": 13.205994,', ...
%!     '"longitude": -37.276231,', ...
%!     '"friends": [', ...
%!       '{', ...
%!         '"id": 0,', ...
%!         '"name": "Osborn"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 1,', ...
%!         '"name": "Mcdowell"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 2,', ...
%!         '"name": "Jewel"', ...
%!       '}', ...
%!     ']', ...
%!   '},', ...
%!   '{', ...
%!     '"x_id": "5ee289802422ac",', ...
%!     '"index": 2,', ...
%!     '"guid": "3db8d55a-663e",', ...
%!     '"latitude": -35.453456,', ...
%!     '"longitude": 14.080287,', ...
%!     '"friends": [', ...
%!       '{', ...
%!         '"id": 0,', ...
%!         '"name": "Socorro"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 1,', ...
%!         '"name": "Darla"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 2,', ...
%!         '"name": "Leanne"', ...
%!       '}', ...
%!     ']', ...
%!   '}', ...
%! ']'];
%! var1 = struct ('id', {0; 1; 2}, 'name', {'Collins'; 'Hays'; 'Griffin'});
%! var2 = struct ('id', {0; 1; 2}, 'name', {'Osborn'; 'Mcdowell'; 'Jewel'});
%! var3 = struct ('id', {0; 1; 2}, 'name', {'Socorro'; 'Darla'; 'Leanne'});
%! exp  = struct (...
%!   'x_id', {'5ee28980fc9ab3'; '5ee28980dd7250'; '5ee289802422ac'}, ...
%!   'index', {0; 1; 2}, ...
%!   'guid', {'b229d1de-f94a'; '39cee338-01fb'; '3db8d55a-663e'}, ...
%!   'latitude', {-17.124067; 13.205994; -35.453456}, ...
%!   'longitude', {-61.161831; -37.276231; 14.080287}, ...
%!   'friends', {var1; var2; var3});
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Arrays with the same field names in different order (extracted from JSONio)
%% Results in cell array, rather than struct array
%!testif HAVE_RAPIDJSON
%! json = '{"cellarray": [{"a":1,"b":2},{"b":3,"a":4}]}';
%! exp  = struct ('cellarray', {{struct('a', 1, 'b', 2); ...
%!                               struct('b', 3, 'a', 4)}});
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Arrays with different field names (extracted from JSONio)
%!testif HAVE_RAPIDJSON
%! json = '{"cellarray": [{"a":1,"b":2},{"a":3,"c":4}]}';
%! exp  = struct ('cellarray', {{struct('a', 1, 'b', 2); ...
%!                               struct('a', 3, 'c', 4)}});
%! obs  = jsondecode (json);
%! assert (isequal (obs, exp));

%% Arrays with different field names and a big test
%!testif HAVE_RAPIDJSON
%! json = ['[', ...
%!   '{', ...
%!     '"x_id": "5ee28980fc9ab3",', ...
%!     '"index": 0,', ...
%!     '"guid": "b229d1de-f94a",', ...
%!     '"latitude": -17.124067,', ...
%!     '"longitude": -61.161831,', ...
%!     '"friends": [', ...
%!       '{', ...
%!         '"id": 0,', ...
%!         '"name": "Collins"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 1,', ...
%!         '"name": "Hays"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 2,', ...
%!         '"name": "Griffin"', ...
%!       '}', ...
%!     ']', ...
%!   '},', ...
%!   '{"numeric array": ["str", 5, null], "nonnumeric array": [1, 2, null]},', ...
%!   '{', ...
%!      '"firstName": "John",', ...
%!      '"lastName": "Smith",', ...
%!      '"age": 25,', ...
%!      '"address":', ...
%!      '{', ...
%!          '"streetAddress": "21 2nd Street",', ...
%!          '"city": "New York",', ...
%!          '"state": "NY"', ...
%!      '},', ...
%!      '"phoneNumber":', ...
%!          '{', ...
%!            '"type": "home",', ...
%!            '"number": "212 555-1234"', ...
%!          '}', ...
%!  '}]'];
%! var1 = struct ('x_id', '5ee28980fc9ab3', 'index', 0, ...
%!                'guid', 'b229d1de-f94a', 'latitude', -17.124067, ...
%!                'longitude', -61.161831, ...
%!                'friends', ...
%!                struct ('id', {0; 1; 2}, ...
%!                        'name', {'Collins'; 'Hays'; 'Griffin'}));
%! var2 = struct ('numericArray', {{'str'; 5; []}}, ...
%!                'nonnumericArray', {[1; 2; NaN]});
%! var3 = struct ('firstName', 'John', 'lastName', 'Smith', 'age', 25, ...
%!                'address', ...
%!                struct ('streetAddress', '21 2nd Street', ...
%!                        'city', 'New York', 'state', 'NY'), ...
%!                'phoneNumber', ...
%!                struct ('type', 'home', 'number', '212 555-1234'));
%! exp = {var1; var2; var3};
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%%% Test 6: decode Array of different JSON data types

%!testif HAVE_RAPIDJSON
%! json = ['[null, true, Inf, 2531.023, "hello there", ', ...
%!   '{', ...
%!     '"x_id": "5ee28980dd7250",', ...
%!     '"index": 1,', ...
%!     '"guid": "39cee338-01fb",', ...
%!     '"latitude": 13.205994,', ...
%!     '"longitude": -37.276231,', ...
%!     '"friends": [', ...
%!       '{', ...
%!         '"id": 0,', ...
%!         '"name": "Osborn"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 1,', ...
%!         '"name": "Mcdowell"', ...
%!       '},', ...
%!       '{', ...
%!         '"id": 2,', ...
%!         '"name": "Jewel"', ...
%!       '}', ...
%!     ']', ...
%!   '}]'];
%! var =  struct ('x_id', '5ee28980dd7250', 'index', 1, ...
%!                'guid', '39cee338-01fb', 'latitude', 13.205994, ...
%!                'longitude', -37.276231, ...
%!                'friends', struct ('id', {0; 1; 2}, ...
%!                                   'name', {'Osborn'; 'Mcdowell'; 'Jewel'}));
%! exp = {[]; 1; Inf; 2531.023; 'hello there'; var};
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%% Array of arrays
%!testif HAVE_RAPIDJSON
%! json = ['[["str", Inf, null], [1, 2, null], ["foo", "bar", ["foo", "bar"]],', ...
%!   '[[[1, 2], [3, 4]], [[5, 6], [7, 8]]],' , ...
%!   '[', ...
%!     '{', ...
%!       '"x_id": "5ee28980fc9ab3",', ...
%!       '"index": 0,', ...
%!       '"guid": "b229d1de-f94a",', ...
%!       '"latitude": -17.124067,', ...
%!       '"longitude": -61.161831,', ...
%!       '"friends": [', ...
%!         '{', ...
%!           '"id": 0,', ...
%!           '"name": "Collins"', ...
%!         '},', ...
%!         '{', ...
%!           '"id": 1,', ...
%!           '"name": "Hays"', ...
%!         '},', ...
%!         '{', ...
%!           '"id": 2,', ...
%!           '"name": "Griffin"', ...
%!         '}', ...
%!       ']', ...
%!     '},', ...
%!     '{"numeric array": ["str", 5, null], "nonnumeric array": [1, 2, null]},', ...
%!     '{', ...
%!        '"firstName": "John",', ...
%!        '"lastName": "Smith",', ...
%!        '"age": 25,', ...
%!        '"address":', ...
%!        '{', ...
%!            '"streetAddress": "21 2nd Street",', ...
%!            '"city": "New York",', ...
%!            '"state": "NY"', ...
%!        '},', ...
%!        '"phoneNumber":', ...
%!            '{', ...
%!              '"type": "home",', ...
%!              '"number": "212 555-1234"', ...
%!            '}', ...
%!    '}]]'];
%! var1 = struct ('x_id', '5ee28980fc9ab3', 'index', 0, ...
%!                'guid', 'b229d1de-f94a', 'latitude', -17.124067, ...
%!                'longitude', -61.161831, ...
%!                'friends', struct ('id', {0; 1; 2}, ...
%!                                   'name', {'Collins'; 'Hays'; 'Griffin'}));
%! var2 = struct ('numericArray', {{'str'; 5; []}}, ...
%!                'nonnumericArray', {[1; 2; NaN]});
%! var3 = struct ('firstName', 'John', 'lastName', 'Smith', 'age', 25, ...
%!                'address', ...
%!                struct ('streetAddress', '21 2nd Street', ...
%!                        'city', 'New York', 'state', 'NY'), ...
%!                'phoneNumber', ...
%!                struct ('type', 'home', 'number', '212 555-1234'));
%! exp = {{'str'; Inf; []}; [1; 2; NaN]; {'foo'; 'bar'; {'foo'; 'bar'}};
%!        cat(3, [1, 3; 5, 7], [2, 4; 6, 8]); {var1; var2 ;var3}};
%! obs  = jsondecode (json);
%! assert (isequaln (obs, exp));

%%% Test 7: Check "ReplacementStyle", "Prefix", and "makeValidName" options
%%%         Not Matlab compatible!

%!testif HAVE_RAPIDJSON
%! json = '{"1a": {"1*a": {"1+*/-a": {"1#a": {}}}}}';
%! exp  = struct ('n1a', ...
%!                struct ('n1a', struct ('n1a', struct ('n1a', struct ()))));
%! obs  = jsondecode (json, "ReplacementStyle", "delete", ...
%!                          "Prefix", "_", "Prefix", "n");
%! assert (isequal (obs, exp));

%% Check forwarding of "ReplacementStyle" and "Prefix" options inside arrays
%!testif HAVE_RAPIDJSON
%! json = [ '[', ...
%!       '{', ...
%!         '"i*d": 0,', ...
%!         '"12name": "Osborn"', ...
%!       '},', ...
%!       '{', ...
%!         '"i*d": 1,', ...
%!         '"12name": "Mcdowell"', ...
%!       '},', ...
%!       '{', ...
%!         '"i*d": 2,', ...
%!         '"12name": "Jewel"', ...
%!       '}', ...
%!     ']'];
%! exp  = struct ('i0x2Ad', {0; 1; 2}, ...
%!                'm_12name', {'Osborn'; 'Mcdowell'; 'Jewel'});
%! obs  = jsondecode (json, "ReplacementStyle", "hex", "Prefix", "m_");
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '{"cell*array": [{"1a":1,"b*1":2},{"1a":3,"b/2":4}]}';
%! exp  = struct ('cell_array', {{struct('x_1a', 1, 'b_1', 2); ...
%!                                struct('x_1a', 3, 'b_2', 4)}});
%! obs  = jsondecode (json, "ReplacementStyle", "underscore", "Prefix", "x_");
%! assert (isequal (obs, exp));

%%% Test 8: More tests from https://github.com/apjanke/octave-jsonstuff (bug #60688)

%!testif HAVE_RAPIDJSON
%! assert (isequal (jsondecode ('42'), 42));
%! assert (isequal (jsondecode ('"foobar"'), "foobar"));
%! assert (isequal (jsondecode ('null'), []));
%! assert (isequal (jsondecode ('[]'), []));
%! assert (isequal (jsondecode ('[[]]'), {[]}));
%! assert (isequal (jsondecode ('[[[]]]'), {{[]}}));
%! assert (isequal (jsondecode ('[1, 2, 3]'), [1; 2; 3]));
%! assert (isequaln (jsondecode ('[1, 2, null]'), [1; 2; NaN]));
%! assert (isequal (jsondecode ('[1, 2, "foo"]'), {1; 2; "foo"}));
%! assert (isequal (jsondecode ('{"foo": 42, "bar": "hello"}'), ...
%!         struct("foo",42, "bar","hello")));
%! assert (isequal (jsondecode ('[{"foo": 42, "bar": "hello"}, {"foo": 1.23, "bar": "world"}]'), ...
%!         struct("foo", {42; 1.23}, "bar", {"hello"; "world"})));
%! assert (isequal (jsondecode ('[1, 2]'), [1; 2]));
%! assert (isequal (jsondecode ('[[1, 2]]'), [1 2]));
%! assert (isequal (jsondecode ('[[[1, 2]]]'), cat(3, 1, 2)));
%! assert (isequal (jsondecode ('[[1, 2], [3, 4]]'), [1 2; 3 4]));
%! assert (isequal (jsondecode ('[[[1, 2], [3, 4]]]'), cat(3, [1 3], [2 4])));
%! assert (isequal (jsondecode ('[[[1, 2], [3, 4]], [[5, 6], [7, 8]]]'), ...
%!         cat(3, [1 3; 5 7], [2 4; 6 8])));
%! assert (isequal (jsondecode ('{}'), struct));
%! assert (isequal (jsondecode ('[{}]'), struct));
%! assert (isequal (jsondecode ('[[{}]]'), struct));
%! assert (isequal (jsondecode ('[{}, {}]'), [struct; struct]));
%! assert (isequal (jsondecode ('[[{}, {}]]'), [struct struct]));
%! assert (isequal (jsondecode ('[[[{}, {}]]]'), cat(3, struct, struct)));
%! assert (isequal (jsonencode (42), "42"));
%! assert (isequal (jsonencode ("foo"), '"foo"'));
%! assert (isequal (jsonencode ([1 2 3]), '[1,2,3]'));
%! assert (isequal (jsonencode (NaN), 'null'));
%! assert (isequal (jsonencode ([1 2 NaN]), '[1,2,null]'));
%! assert (isequal (jsonencode ({}), "[]"));

%%% Test 9: And even some more tests for bug #60688.

%!testif HAVE_RAPIDJSON
%! assert (isequal (jsondecode ('[[{"foo": 42}, {"foo": 1.23}], [{"foo": 12}, {"foo": "bar"}]]'), ...
%!         struct("foo", {42 1.23; 12 "bar"})));
%! assert (isequal (jsondecode ('[[{"foo": 42}, {"foo": 1.23}], [{"bar": 12}, {"foo": "bar"}]]'), ...
%!         {struct("foo", {42; 1.23}); {struct("bar", 12); struct("foo", "bar")}}));


%%% Test 10: Decoding of objects inside an object without using makeValidName.
%%%          Not Matlab compatible!       

%!testif HAVE_RAPIDJSON
%! json = ['{"object": {"  hi 1   ": 1, "%string.array": 2,' ...
%!                     '"img/svg+xml": 3, "": 1}}'];
%! exp  = struct ('object', ...
%!                struct ('  hi 1   ', 1, '%string.array', 2, ...
%!                        'img/svg+xml', 3, '', 1));
%! obs  = jsondecode (json, "makeValidName", false);
%! assert (isequal (obs, exp));

%!testif HAVE_RAPIDJSON
%! json = '{"1a": {"1*a": {"1+*/-a": {"1#a": {}}}}}';
%! exp  = struct ('n1a', ...
%!                struct ('n1a', struct ('n1a', struct ('n1a', struct ()))));
%! obs  = jsondecode (json, "ReplacementStyle", "delete", ...
%!                          "makeValidName", false, ...
%!                          "Prefix", "_", ...
%!                          "makeValidName", true, ...
%!                          "Prefix", "n");
%! assert (isequal (obs, exp));
