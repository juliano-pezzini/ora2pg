-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_geracao_versao () RETURNS timestamp AS $body$
DECLARE

dt_versao_w		timestamp;

c02	  	integer;
retorno_w	integer;
ds_comando_w	varchar(2000);
ds_valor_w	varchar(255);

BEGIN


begin

ds_comando_w := ' select	nvl(max(dt_versao),sysdate-180) ' ||
		' from		tasy_versao.aplicacao_tasy_versao a,' ||
		'		aplicacao_tasy b ' ||
		' where		a.cd_versao = b.cd_versao_atual ' ||
		' and		a.cd_aplicacao_tasy = b.cd_aplicacao_tasy ' ||
		' and		a.cd_aplicacao_tasy	= :cd_aplicacao';

C02 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C02, ds_comando_w, dbms_sql.Native);
DBMS_SQL.DEFINE_COLUMN(C02, 1, dt_versao_w);
DBMS_SQL.BIND_VARIABLE(C02, 'CD_APLICACAO', 'Tasy',255);
retorno_w := DBMS_SQL.execute(c02);
retorno_w := DBMS_SQL.fetch_rows(c02);
DBMS_SQL.COLUMN_VALUE(C02, 1, dt_versao_w);
DBMS_SQL.CLOSE_CURSOR(C02);

exception
when others then
	dt_versao_w := clock_timestamp() - interval '180 days';
end;

return	dt_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_geracao_versao () FROM PUBLIC;
