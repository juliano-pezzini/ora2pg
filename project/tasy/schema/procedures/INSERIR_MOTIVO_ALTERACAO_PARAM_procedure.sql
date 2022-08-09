-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_motivo_alteracao_param ( cd_funcao_p bigint, ds_motivo_p text, ie_tipo_param_p text, nm_usuario_p text, nr_seq_param_p bigint, vl_parametro_p text, cd_estab_p text, cd_perfil_p text, nm_usuario_param_p text) AS $body$
BEGIN

insert into	motivo_alteracao_param(cd_funcao,
									ds_motivo,
									dt_atualizacao,
									dt_atualizacao_nrec,
									ie_tipo_param,
									nm_usuario,
									nm_usuario_nrec,
									nr_seq_param,
									nr_sequencia,
									vl_parametro,
									cd_estab_alterado,
									cd_perfil,
									nm_usuario_param)
		values (cd_funcao_p,
				ds_motivo_p,
				clock_timestamp(),
				clock_timestamp(),
				ie_tipo_param_p,
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_param_p,
				nextval('motivo_alteracao_param_seq'),
				vl_parametro_p,
				cd_estab_p,
				cd_perfil_p,
				nm_usuario_param_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_motivo_alteracao_param ( cd_funcao_p bigint, ds_motivo_p text, ie_tipo_param_p text, nm_usuario_p text, nr_seq_param_p bigint, vl_parametro_p text, cd_estab_p text, cd_perfil_p text, nm_usuario_param_p text) FROM PUBLIC;
