-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_hemocomponentes ( ds_campo_p text, ds_valor_p text, ds_valores_restricao_p text) AS $body$
DECLARE


ds_sql_w		varchar(2000);
ds_parametros_w	varchar(2000);
ds_sep_bv_w	varchar(10);



BEGIN
ds_sep_bv_w	:= obter_separador_bv;

ds_sql_w	:=
	' update	san_producao'||
	' set	'||ds_campo_p||' = :ds_valor' ||
	' where	nr_sequencia     in '||ds_valores_restricao_p;

ds_parametros_w	:= 'ds_valor=' || ds_valor_p || ds_sep_bv_w;

CALL exec_sql_dinamico_bv('', ds_sql_w, ds_parametros_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_hemocomponentes ( ds_campo_p text, ds_valor_p text, ds_valores_restricao_p text) FROM PUBLIC;
