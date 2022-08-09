-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_cep_localidade ( cd_localidade_dne_p bigint, nm_localidade_p text, cd_cep_localidade_p text, sg_uf_p text, ie_tipo_loc_p text, cd_subordinacao_loc_dne_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_parametros_w		varchar(2000);
ds_insert_w		varchar(2000) := 	':nr_sequencia_p,' ||
						':nm_localidade_p,' ||
						':cd_cep_p,' ||
						':ds_uf_p,' ||
						':ie_tipo_p,' ||
						':nr_seq_superior_p,' ||
						':dt_atualizacao_p,' ||
						':nm_usuario_p';



ds_comando_w		varchar(2000) := '	insert	into w_cep_loc ' ||
							'(	nr_sequencia,' ||
								'nm_localidade,' ||
								'cd_cep,' ||
								'ds_uf,' ||
								'ie_tipo,' ||
								'nr_seq_superior,' ||
								'dt_atualizacao,' ||
								'nm_usuario)' ||
								'values	(' || ds_insert_w || ')';


BEGIN

if (sg_uf_p IS NOT NULL AND sg_uf_p::text <> '') and (nm_localidade_p IS NOT NULL AND nm_localidade_p::text <> '') and (cd_localidade_dne_p IS NOT NULL AND cd_localidade_dne_p::text <> '') then

	ds_parametros_w := 'NR_SEQUENCIA_P=' || cd_localidade_dne_p || ';' || 'NM_LOCALIDADE_P=' || nm_localidade_p || ';' || 'CD_CEP_P=' || cd_cep_localidade_p || ';'
				|| 'DS_UF_P=' || sg_uf_p || ';' || 'IE_TIPO_P=' || ie_tipo_loc_p || ';' || 'NR_SEQ_SUPERIOR_P=' || cd_subordinacao_loc_dne_p || ';'
				|| 'DT_ATUALIZACAO_P=' || clock_timestamp() || ';' || 'NM_USUARIO_P=' || nm_usuario_p || ';';

	CALL gravar_processo_longo(ds_comando_w,'IMPORTAR_CEP_LOCALIDADE',null);
	CALL Exec_Sql_Dinamico_bv('Insert w_cep_loc: ' || cd_localidade_dne_p, ds_comando_w,ds_parametros_w);

	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_cep_localidade ( cd_localidade_dne_p bigint, nm_localidade_p text, cd_cep_localidade_p text, sg_uf_p text, ie_tipo_loc_p text, cd_subordinacao_loc_dne_p bigint, nm_usuario_p text) FROM PUBLIC;
