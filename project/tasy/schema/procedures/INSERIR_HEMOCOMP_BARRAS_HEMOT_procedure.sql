-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_hemocomp_barras_hemot ( ds_campo_p text, vl_campo_p bigint, vl_restricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_comando_w	varchar(2000);
ds_parametros_w	varchar(2000);
ds_sep_bv_w	varchar(10);


BEGIN

ds_comando_w	:=
	' update	san_producao ' ||
	' set	'||ds_campo_p||'	= :vl_campo_p ' ||
	' where	nr_sequencia	= :nr_sequencia_p ';

ds_sep_bv_w	:= obter_separador_bv;
ds_parametros_w	:=
	'vl_campo_p=' || vl_campo_p || ds_sep_bv_w ||
	'nr_sequencia_p=' || vl_restricao_p || ds_sep_bv_w;

CALL exec_sql_dinamico_bv('', ds_comando_w, ds_parametros_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_hemocomp_barras_hemot ( ds_campo_p text, vl_campo_p bigint, vl_restricao_p bigint, nm_usuario_p text) FROM PUBLIC;

