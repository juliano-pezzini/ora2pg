-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-- DESCARREGA O VETOR
CREATE OR REPLACE PROCEDURE pls_mov_benef_pck.inserir_vetor_contrato ( ie_descarregar_vetor_p text) AS $body$
BEGIN

	if	((nr_indice_w >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_vetor_p = 'S')) then
		if (tb_nr_seq_contrato_w.count > 0) then
			forall i in tb_nr_seq_contrato_w.first .. tb_nr_seq_contrato_w.last
				
				insert	into	pls_mov_benef_contrato(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_mov_operadora,
						nr_seq_intercambio,
						nr_seq_contrato,
						nr_contrato,
						dt_contrato,
						dt_rescisao,
						ie_tipo_compartilhamento,
						cd_cnpj,
						ds_razao_social,
						nm_fantasia,
						ds_nome_abrev,
						cd_empresa,
						cd_municipio_ibge,
						cd_cep,
						ds_endereco,
						nr_endereco,
						ds_complemento,
						ds_bairro,
						cd_tipo_logradouro,
						sg_estado,
						nr_ddi_telefone,
						nr_ddd_telefone,
						nr_telefone,
						nr_inscricao_estadual,
						nr_inscricao_municipal,
						ds_email,
						nm_pessoa_contato
					)
					values (	nextval('pls_mov_benef_contrato_seq'),
						clock_timestamp(),
						current_setting('pls_mov_benef_pck.nm_usuario_w')::usuario.nm_usuario%type,
						clock_timestamp(),
						current_setting('pls_mov_benef_pck.nm_usuario_w')::usuario.nm_usuario%type,
						tb_nr_seq_mov_operadora_w(i),
						tb_nr_seq_intercambio_w(i),
						tb_nr_seq_contrato_w(i),
						tb_nr_contrato_w(i),
						tb_dt_contrato_w(i),
						current_setting('pls_mov_benef_pck.tb_dt_rescisao_w')::pls_util_cta_pck.t_date_table(i),
						tb_ie_tipo_compartilhamento_w(i),
						tb_cd_cnpj_w(i),
						tb_ds_razao_social_w(i),
						tb_nm_fantasia_w(i),
						tb_ds_nome_abrev_w(i),
						tb_cd_empresa_w(i),
						tb_cd_municipio_ibge_w(i),
						tb_cd_cep_w(i),
						tb_ds_endereco_w(i),
						current_setting('pls_mov_benef_pck.tb_nr_endereco_w')::pls_util_cta_pck.t_varchar2_table_10(i),
						current_setting('pls_mov_benef_pck.tb_ds_complemento_w')::pls_util_cta_pck.t_varchar2_table_255(i),
						current_setting('pls_mov_benef_pck.tb_ds_bairro_w')::pls_util_cta_pck.t_varchar2_table_50(i),
						current_setting('pls_mov_benef_pck.tb_cd_tipo_logradouro_w')::pls_util_cta_pck.t_varchar2_table_10(i),
						current_setting('pls_mov_benef_pck.tb_sg_estado_w')::pls_util_cta_pck.t_varchar2_table_15(i),
						current_setting('pls_mov_benef_pck.tb_nr_ddi_telefone_w')::pls_util_cta_pck.t_varchar2_table_3(i),
						current_setting('pls_mov_benef_pck.tb_nr_ddd_telefone_w')::pls_util_cta_pck.t_varchar2_table_3(i),
						current_setting('pls_mov_benef_pck.tb_nr_telefone_w')::pls_util_cta_pck.t_varchar2_table_15(i),
						current_setting('pls_mov_benef_pck.tb_nr_inscricao_estadual_w')::pls_util_cta_pck.t_varchar2_table_20(i),
						current_setting('pls_mov_benef_pck.tb_nr_inscricao_municipal_w')::pls_util_cta_pck.t_varchar2_table_20(i),
						current_setting('pls_mov_benef_pck.tb_ds_email_w')::pls_util_cta_pck.t_varchar2_table_60(i),
						current_setting('pls_mov_benef_pck.tb_nm_pessoa_contato_w')::pls_util_cta_pck.t_varchar2_table_255(i)
					);	
			commit;

		end if;
		CALL pls_mov_benef_pck.limpar_vetor_contrato();
	else
		nr_indice_w	:= nr_indice_w + 1;
	end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_pck.inserir_vetor_contrato ( ie_descarregar_vetor_p text) FROM PUBLIC;
