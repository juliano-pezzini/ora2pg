-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_dic_objeto_wlistview ( cd_funcao_p bigint, nr_seq_objeto_p bigint, nm_usuario_p text, nr_new_obj_p INOUT bigint) AS $body$
DECLARE


nr_seq_objeto_w	bigint;


BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nr_seq_objeto_p IS NOT NULL AND nr_seq_objeto_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	nextval('dic_objeto_seq')
	into STRICT	nr_seq_objeto_w
	;

	insert into dic_objeto(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_objeto,
		nm_objeto,
		cd_funcao,
		cd_exp_texto,
		ds_sql,
		nr_seq_obj_sup)
	SELECT	nr_seq_objeto_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_objeto,
		nm_objeto,
		cd_funcao_p,
		cd_exp_texto,
		ds_sql,
		nr_seq_obj_sup
	from	dic_objeto
	where	nr_sequencia = nr_seq_objeto_p;

	insert into dic_objeto(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_funcao,
		nr_seq_obj_sup,
		ie_tipo_objeto,
		ie_tipo_dado_objeto,
		cd_exp_campo_tela,
		nm_campo_base,
		ie_tipo_obj_col_wcp,
		ds_opcoes,
		qt_largura,
		ds_mascara,
		nr_seq_apres,
		cd_mascara,
		ie_situacao)
	SELECT	nextval('dic_objeto_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_funcao,
		nr_seq_objeto_w,
		ie_tipo_objeto,
		ie_tipo_dado_objeto,
		cd_exp_campo_tela,
		nm_campo_base,
		ie_tipo_obj_col_wcp,
		ds_opcoes,
		qt_largura,
		ds_mascara,
		nr_seq_apres,
		cd_mascara,
		ie_situacao
	from	dic_objeto
	where	nr_seq_obj_sup = nr_seq_objeto_p;
	end;
end if;
nr_new_obj_p := nr_seq_objeto_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_dic_objeto_wlistview ( cd_funcao_p bigint, nr_seq_objeto_p bigint, nm_usuario_p text, nr_new_obj_p INOUT bigint) FROM PUBLIC;
