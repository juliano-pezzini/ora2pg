-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_cep_logradouro ( cd_logradouro_dne_p bigint, nm_logradouro_p text, cd_localidade_dne_p bigint, cd_cep_logradouro_p text, sg_uf_p text, ds_complemento_p text, cd_bairro_inicial_dne_p bigint, cd_bairro_final_dne_p bigint, ie_tipo_log_p text, ds_preposicao_p text, ie_log_ativo_p text, nm_usuario_p text) AS $body$
DECLARE


ds_parametros_w		varchar(2000);
ds_insert_w		varchar(2000) := 	':nr_sequencia_p,' ||
						':nm_logradouro_p,' ||
						':nr_seq_loc_p,' ||
						':cd_cep_p,' ||
						':ds_uf_p,' ||
						':ds_complemento_p,' ||
						':cd_bairro_inicial_p,' ||
						':cd_bairro_final_p,' ||
						':ds_tipo_logradouro_p,' ||
						':ds_preposicao_p,' ||
						':ie_log_ativo_p,' ||
						':dt_atualizacao_p,' ||
						':nm_usuario_p';

ds_comando_w		varchar(2000) := ' 	insert	into w_cep_log' ||
							'(	nr_sequencia,' ||
								'nm_logradouro,' ||
								'nr_seq_loc,' ||
								'cd_cep,' ||
								'ds_uf,' ||
								'ds_complemento,' ||
								'cd_bairro_inicial,' ||
								'cd_bairro_final,' ||
								'ds_tipo_logradouro,' ||
								'ds_preposicao,' ||
								'ie_log_ativo,' ||
								'dt_atualizacao,' ||
								'nm_usuario' || ') ' ||
								'values	(' || ds_insert_w || ')';


BEGIN

if (cd_logradouro_dne_p IS NOT NULL AND cd_logradouro_dne_p::text <> '') and (nm_logradouro_p IS NOT NULL AND nm_logradouro_p::text <> '') and (cd_localidade_dne_p IS NOT NULL AND cd_localidade_dne_p::text <> '') then


	ds_parametros_w := 'NR_SEQUENCIA_P=' || cd_logradouro_dne_p || ';' || 'NM_LOGRADOURO_P=' || nm_logradouro_p || ';' || 'NR_SEQ_LOC_P=' || cd_localidade_dne_p || ';'
				|| 'CD_CEP_P=' || cd_cep_logradouro_p || ';' || 'DS_UF_P=' || sg_uf_p || ';' || 'DS_COMPLEMENTO_P=' || ds_complemento_p || ';'
				|| 'CD_BAIRRO_INICIAL_P=' || cd_bairro_inicial_dne_p || ';' || 'CD_BAIRRO_FINAL_P=' || cd_bairro_final_dne_p || ';'
				|| 'DS_TIPO_LOGRADOURO_P=' || ie_tipo_log_p || ';' || 'DS_PREPOSICAO_P=' || ds_preposicao_p || ';' || 'IE_LOG_ATIVO_P=' || ie_log_ativo_p || ';'
				|| 'DT_ATUALIZACAO_P=' || clock_timestamp() || ';' || 'NM_USUARIO_P=' || nm_usuario_p || ';';

	CALL gravar_processo_longo(ds_comando_w,'IMPORTAR_CEP_LOGRADOURO',null);
	CALL Exec_Sql_Dinamico_bv('Insert w_cep_log: ' || cd_logradouro_dne_p, ds_comando_w,ds_parametros_w);

	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_cep_logradouro ( cd_logradouro_dne_p bigint, nm_logradouro_p text, cd_localidade_dne_p bigint, cd_cep_logradouro_p text, sg_uf_p text, ds_complemento_p text, cd_bairro_inicial_dne_p bigint, cd_bairro_final_dne_p bigint, ie_tipo_log_p text, ds_preposicao_p text, ie_log_ativo_p text, nm_usuario_p text) FROM PUBLIC;
