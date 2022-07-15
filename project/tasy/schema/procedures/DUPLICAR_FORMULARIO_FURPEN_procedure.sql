-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_formulario_furpen ( nr_sequencia_p atend_formulario_furpen.nr_sequencia%TYPE, ie_inativar_p text, ds_justificativa_p atend_formulario_furpen.ds_justificativa%TYPE) AS $body$
DECLARE


ds_justificativa_w atend_formulario_furpen.ds_justificativa%TYPE;
		

BEGIN

INSERT INTO
	atend_formulario_furpen(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		dt_registro,
		ie_situacao_veiculo,
		nm_seg_apelido_prop,
		nr_seq_classif_acidente,
		nr_atendimento,
		nm_prim_apelido_recl,
		nm_seg_apelido_recl,
		nm_reclamante,
		nm_sobrenome_recl,
		ie_tipo_doc_recl,
		nr_doc_recl,
		nr_tel_recl,
		nr_seq_pessoa_end_reclama,
		ds_endereco_recl,
		dt_morte,
		nr_seq_tipo_acidente,
		ie_outro_acidente,
		ds_acidente,
		dt_acidente,
		nr_seq_pessoa_end_local,
		ds_descr_acidente,
		ds_veiculo,
		ds_placa,
		nr_seq_tipo_servico,
		nm_seguradora,
		nr_apolice_seguro,
		ie_interv_autoridade,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		nm_prim_apelido_prop,
		nm_proprietario,
		nm_sobrenome_prop,
		ie_tipo_doc_prop,
		nr_doc_prop,
		nr_seq_pessoa_end_prop,
		ds_endereco_prop,
		nr_tel_prop,
		nm_prim_apelido_cond,
		nm_seg_apelido_cond,
		nm_condutor,
		nm_sobrenome_cond,
		ie_tipo_doc_cond,
		nr_doc_cond,
		nr_seq_pessoa_end_cond,
		ds_endereco_cond,
		nr_tel_cond,
		ie_condicao_vitima,
		ie_parentesco,
		ds_endereco_local,
		nr_registro_ant,
		nr_registro,
		ie_gastos_funerarios,
		ie_morte_vitima,
		ie_incapacidade_perm,
		vl_reclamado,
		ie_situacao,
		dt_liberacao,
		dt_inativacao,
		nm_usuario_inativacao,
		ds_justificativa,
		ds_justificativa_alteracao,
		nr_ddd_tel_cond,
		nr_ddd_tel_prop,
		nr_ddd_tel_recl,
		nr_ddi_tel_cond,
		nr_ddi_tel_prop,
		nr_ddi_tel_recl)
SELECT	nextval('atend_formulario_furpen_seq'),
		clock_timestamp(),
		dt_atualizacao_nrec,
		obter_usuario_ativo,
		nm_usuario_nrec,
		dt_registro,
		ie_situacao_veiculo,
		nm_seg_apelido_prop,
		nr_seq_classif_acidente,
		nr_atendimento,
		nm_prim_apelido_recl,
		nm_seg_apelido_recl,
		nm_reclamante,
		nm_sobrenome_recl,
		ie_tipo_doc_recl,
		nr_doc_recl,
		nr_tel_recl,
		nr_seq_pessoa_end_reclama,
		ds_endereco_recl,
		dt_morte,
		nr_seq_tipo_acidente,
		ie_outro_acidente,
		ds_acidente,
		dt_acidente,
		nr_seq_pessoa_end_local,
		ds_descr_acidente,
		ds_veiculo,
		ds_placa,
		nr_seq_tipo_servico,
		nm_seguradora,
		nr_apolice_seguro,
		ie_interv_autoridade,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		nm_prim_apelido_prop,
		nm_proprietario,
		nm_sobrenome_prop,
		ie_tipo_doc_prop,
		nr_doc_prop,
		nr_seq_pessoa_end_prop,
		ds_endereco_prop,
		nr_tel_prop,
		nm_prim_apelido_cond,
		nm_seg_apelido_cond,
		nm_condutor,
		nm_sobrenome_cond,
		ie_tipo_doc_cond,
		nr_doc_cond,
		nr_seq_pessoa_end_cond,
		ds_endereco_cond,
		nr_tel_cond,
		ie_condicao_vitima,
		ie_parentesco,
		ds_endereco_local,
		nr_registro_ant,
		nr_registro,
		ie_gastos_funerarios,
		ie_morte_vitima,
		ie_incapacidade_perm,
		vl_reclamado,
		'A',
		null,
		null,
		null,
		null,
		ds_justificativa_p,
		nr_ddd_tel_cond,
		nr_ddd_tel_prop,
		nr_ddd_tel_recl,
		nr_ddi_tel_cond,
		nr_ddi_tel_prop,
		nr_ddi_tel_recl
FROM
	atend_formulario_furpen
WHERE
	nr_sequencia = nr_sequencia_p;
	
IF (ie_inativar_p = 'S') THEN
	SELECT
		max(ds_justificativa)
	INTO STRICT
		ds_justificativa_w
	FROM
		atend_formulario_furpen
	WHERE
		nr_sequencia = nr_sequencia_p;

	CALL inativar_informacao('ATEND_FORMULARIO_FURPEN',
						'NR_SEQUENCIA',
						nr_sequencia_p,
						coalesce(ds_justificativa_w, ds_justificativa_p),
						obter_usuario_ativo);
END IF;				
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_formulario_furpen ( nr_sequencia_p atend_formulario_furpen.nr_sequencia%TYPE, ie_inativar_p text, ds_justificativa_p atend_formulario_furpen.ds_justificativa%TYPE) FROM PUBLIC;

