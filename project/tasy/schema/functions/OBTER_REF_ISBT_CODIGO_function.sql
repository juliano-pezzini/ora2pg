-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ref_isbt_codigo (ds_codigo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_first_w		varchar(1);
ie_second_w		varchar(1);
ds_length_content_w	bigint;
ie_valid_format_w	boolean;
			

BEGIN
if (ds_codigo_p IS NOT NULL AND ds_codigo_p::text <> '') then

	ie_first_w		:= substr(ds_codigo_p,1,1);
	ie_second_w		:= substr(ds_codigo_p,2,1);
	ds_length_content_w	:= length(ds_codigo_p)-2;
	ie_valid_format_w	:= true;

	case	ie_first_w
		when	chr(61)	
		then	begin
			case	ie_second_w
				when	chr(37)		then
							begin	ds_retorno_w := '002';
								ie_valid_format_w := ds_length_content_w = 4;
							end;
				when	chr(60)		then
							begin	ds_retorno_w := '003';
								ie_valid_format_w := ds_length_content_w = 8;
							end;
				when	chr(62)		then
							begin	ds_retorno_w := '004';
								ie_valid_format_w := ds_length_content_w = 6;
							end;
				when	chr(42)		then
							begin	ds_retorno_w := '006';
								ie_valid_format_w := ds_length_content_w = 6;
							end;
				when	chr(125)	then
							begin	ds_retorno_w := '008';
								ie_valid_format_w := ds_length_content_w = 6;
							end;
				when	chr(123)	then
							begin	ds_retorno_w := '011';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(92)		then
							begin	ds_retorno_w := '012';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(91)		then
							begin	ds_retorno_w := '015';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(34)		then
							begin	ds_retorno_w := '016';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(41)		then
							begin	ds_retorno_w := '017';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(59)		then
							begin	ds_retorno_w := '019';
								ie_valid_format_w := ds_length_content_w = 21;
							end;
				when	chr(39)		then
							begin	ds_retorno_w := '020';
								ie_valid_format_w := ds_length_content_w = 11;
							end;
				when	chr(45)		then
							begin	ds_retorno_w := '021';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(43)		then
							begin	ds_retorno_w := '023';
								--ie_valid_format_w := ds_length_content_w = 5;
							end;
				when	chr(35)		then
							begin	ds_retorno_w := '024';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(93)		then
							begin	ds_retorno_w := '026';
								ie_valid_format_w := ds_length_content_w = 6;
							end;
				when	chr(36)		then
							begin	ds_retorno_w := '028';
								ie_valid_format_w := ds_length_content_w = 16;
							end;
				when	chr(40)		then
							begin	ds_retorno_w := '031';
								ie_valid_format_w := ds_length_content_w = 16;
							end;
				when	chr(44)		then
							begin	ds_retorno_w := '032';
								ie_valid_format_w := ds_length_content_w = 6;
							end;
			else	
				begin
				ds_retorno_w		:= '001';
				--ie_valid_format_w	:= ds_length_content_w+1 = 14;
				end;
			end case;
			end;
			
		when	chr(38)	
		then	begin
			case	ie_second_w
				when	chr(62)		then
							begin	ds_retorno_w := '005';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(42)		then
							begin	ds_retorno_w := '007';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(125)	then
							begin	ds_retorno_w := '009';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(40)		then
							begin	ds_retorno_w := '010';
								ie_valid_format_w := ds_length_content_w = 5;
							end;
				when	chr(92)		then
							begin	ds_retorno_w := '013';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(123)	then
							begin	ds_retorno_w := '014';
								ie_valid_format_w := ds_length_content_w = 16;
							end;
				when	chr(41)		then
							begin	ds_retorno_w := '018';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(45)		then
							begin	ds_retorno_w := '022';
								ie_valid_format_w := ds_length_content_w = 10;
							end;
				when	chr(35)		then
							begin	ds_retorno_w := '025';
							end;
				when	chr(34)		then
							begin	ds_retorno_w := '027';
								ie_valid_format_w := ds_length_content_w = 18;
							end;
				when	chr(36)		then
							begin	ds_retorno_w := '029';
								ie_valid_format_w := ds_length_content_w = 16;
							end;
				when	chr(37)		then
							begin	ds_retorno_w := '030';
								ie_valid_format_w := ds_length_content_w = 13;
							end;
				when	chr(40)		then
							begin	ds_retorno_w := '031';
								ie_valid_format_w := ds_length_content_w = 16;
							end;
				when	chr(43)		then
							begin	ds_retorno_w := '033';
								ie_valid_format_w := ds_length_content_w = 11;
							end;
			end case;
			end;
		else
			begin
			ds_retorno_w := '';
			end;
	end case;
end if;
/*
if	not (ie_valid_format_w) then
	wheb_mensagem_pck.exibir_mensagem_abort(292166);
end if;*/
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ref_isbt_codigo (ds_codigo_p text) FROM PUBLIC;
