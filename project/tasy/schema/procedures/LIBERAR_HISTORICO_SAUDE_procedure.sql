-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_historico_saude ( nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w	varchar(10);
ds_comando_w	varchar(255);
ds_set_campo_w	varchar(255);


BEGIN

if	(nr_sequencia_p > 0 AND nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') then
	begin
	select 	obter_separador_bv
	into STRICT	ds_sep_bv_w
	;

	if upper(nm_tabela_p) = 'CIH_PAC_FAT_RISCO' then
		ds_set_campo_w := ' nm_usuario_lib = :nm_usuario_liberacao';
	else
		ds_set_campo_w := ' nm_usuario_liberacao = :nm_usuario_liberacao';
	end if;

	ds_comando_w	:=	' update	' || nm_tabela_p ||
				' set		dt_liberacao = sysdate,' ||
				ds_set_campo_w ||
				' where 	nr_sequencia = :nr_sequencia  ';

	CALL exec_sql_dinamico_bv(obter_desc_expressao(320708),ds_comando_w,'nm_usuario_liberacao='||nm_usuario_p || ds_sep_bv_w || 'nr_sequencia=' || to_char(nr_sequencia_p));
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_historico_saude ( nr_sequencia_p bigint, nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;
