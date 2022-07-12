-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gerar_int_padrao.get_executando_recebimento () RETURNS varchar AS $body$
BEGIN
if	coalesce(current_setting('gerar_int_padrao.ie_executando_recebimento_w')::varchar(1),'X') not in ('S','N') then
	CALL gerar_int_padrao.set_executando_recebimento('N');
end if;

return current_setting('gerar_int_padrao.ie_executando_recebimento_w')::varchar(1);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerar_int_padrao.get_executando_recebimento () FROM PUBLIC;
