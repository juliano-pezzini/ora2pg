-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-- DESCARREGA O VETOR DE PLANOS
CREATE OR REPLACE PROCEDURE pls_mov_benef_pck.inserir_plano ( ie_descarregar_vetor_p text) AS $body$
BEGIN
	if	((nr_indice_w >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_vetor_p = 'S')) then
		if (tb_nr_seq_plano_w.count > 0) then
			forall i in tb_nr_seq_plano_w.first .. tb_nr_seq_plano_w.last
			
				insert	into	pls_mov_benef_plano(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_mov_contrato,
						nr_seq_plano,
						cd_plano_intercambio,
						cd_segmentacao,
						cd_plano_origem,
						nr_protocolo_ans,
						ds_plano_origem,
						ie_tipo_contratacao,
						ie_abrangencia,
						ie_regulamentacao,
						cd_operadora_ans
					)
					values (	nextval('pls_mov_benef_plano_seq'),
						clock_timestamp(),
						current_setting('pls_mov_benef_pck.nm_usuario_w')::usuario.nm_usuario%type,
						clock_timestamp(),
						current_setting('pls_mov_benef_pck.nm_usuario_w')::usuario.nm_usuario%type,
						tb_nr_seq_mov_contrato_w(i),
						tb_nr_seq_plano_w(i),
						tb_cd_plano_intercambio_w(i),
						tb_cd_segmentacao_w(i),
						tb_cd_plano_origem_w(i),
						tb_nr_protocolo_ans_w(i),
						tb_ds_plano_origem_w(i),
						tb_ie_tipo_contratacao_w(i),
						tb_ie_abrangencia_w(i),
						tb_ie_regulamentacao_w(i),
						tb_cd_operadora_ans_w(i)
					);
			commit;
		end if;
		
		CALL CALL CALL pls_mov_benef_pck.limpar_vetores();
	else
		nr_indice_w	:= nr_indice_w + 1;
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_pck.inserir_plano ( ie_descarregar_vetor_p text) FROM PUBLIC;
