-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macros_mensagem_evento (ie_evento_mensagem_p text) RETURNS varchar AS $body$
DECLARE


ds_macros_w	varchar(2000);
ds_enter_w	varchar(10) := chr(13) || chr(10);


BEGIN
if (ie_evento_mensagem_p = 'ELP') then
	ds_macros_w :=	'@cliente = Nome do paciente.' || ds_enter_w ||
				'@estab = Nome do estabelecimento.';
end if;

return ds_macros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macros_mensagem_evento (ie_evento_mensagem_p text) FROM PUBLIC;

