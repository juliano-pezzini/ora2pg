-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_valor_esocial ( nr_seq_lote_p bigint, nr_sequencia_p bigint, nm_campo_p text, ds_valor_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_update_w		varchar(255);
ds_sep_bv_w		varchar(50);


BEGIN

ds_sep_bv_w := obter_separador_bv;

ds_update_w := 	' update	esocial_dados_pagamento 	' ||
		' set	' || nm_campo_p || ' = :ds_valor_p,	' ||
		'	nm_usuario	= :nm_usuario_p,	' ||
		'	dt_atualizacao	= sysdate		' ||
		' where	nr_sequencia	= :nr_sequencia_p 	';

CALL exec_sql_dinamico_bv('Tasy', ds_update_w,	'ds_valor_p=' || ds_valor_p || ds_sep_bv_w ||
						'nm_usuario_p=' || nm_usuario_p || ds_sep_bv_w ||
						'nr_sequencia_p=' || nr_sequencia_p || ds_sep_bv_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_valor_esocial ( nr_seq_lote_p bigint, nr_sequencia_p bigint, nm_campo_p text, ds_valor_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

