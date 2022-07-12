-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_dialise_rel ( ie_tipo_dialise_p text, ie_hemodialise_p text, ie_tipo_peritoneal_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);

	function tipo_hemodialise return text is
	;
BEGIN
		if (ie_hemodialise_p = 'S') then
			return ' '|| obter_desc_expressao(489925, '') ||' ';
		else
			return ' '|| obter_desc_expressao(489926, '') ||' ';
		end if;
	end;

	function tipo_peritoneal return varchar2 is

		function desc_peritoneal return varchar2 is
		begin
			if (ie_tipo_peritoneal_p = 'CAPD') then
				return ' ' || obter_desc_expressao(689353, null) || ' ';
			elsif (ie_tipo_peritoneal_p = 'DPA') then
				return ' ' || obter_desc_expressao(689355, null) || ' ';
			elsif (ie_tipo_peritoneal_p = 'DPI') then
				return ' ' || obter_desc_expressao(292175, null) || ' ';
			end if;

			return null;
		end;

	begin
		return ' '|| obter_desc_expressao(314156, '') || desc_peritoneal();
	end;



begin

	if (ie_tipo_dialise_p = 'DI') then
		ds_retorno_w := tipo_hemodialise();
	elsif (ie_tipo_dialise_p = 'DP') then
		ds_retorno_w := initcap(tipo_peritoneal());
	end if;

	return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dialise_rel ( ie_tipo_dialise_p text, ie_hemodialise_p text, ie_tipo_peritoneal_p text) FROM PUBLIC;
