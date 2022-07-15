-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_glosa ( nm_tabela_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w	varchar(255);
ds_parametros_w	varchar(255);
ds_comando_w	varchar(4000);

BEGIN

ds_sep_bv_w	:= obter_separador_bv;
ds_comando_w	:=	' update '|| nm_tabela_p ||
			'	set	ie_status = ''A'', '			||
			'        		vl_liberado = 0, '			||
			'		dt_liberacao = null, '			||
			'		nr_seq_ret_glosa = null, '		||
			'		nr_seq_item_retorno = null, '		||
			'		nm_usuario = :nm_usuario, '		||
			'		dt_atualizacao = sysdate '		||
			'	where	nr_sequencia = :nr_sequencia '	||
			'	and	ie_status in(''G'') '			||
			'	and	nr_repasse_terceiro is null ';

ds_parametros_w		:= 	'nr_sequencia=' || nr_sequencia_p || ds_sep_bv_w ||
				'nm_usuario=' || nm_usuario_p || ds_sep_bv_w;

CALL exec_sql_dinamico_bv(	'DESFAZER_LIBERACAO_GLOSA',
			ds_comando_w,
			ds_parametros_w);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_glosa ( nm_tabela_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

