-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Processamento de regras de intercâmbio
CREATE OR REPLACE PROCEDURE pls_cta_processo_pck.executa_processo_12 ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, ds_param_extra_processo_p pls_cta_log_exec.ds_param_extra_processo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) AS $body$
DECLARE



ds_param_extra_processo_w	pls_cta_log_exec.ds_param_extra_processo%type;
ie_tipo_tx_w			varchar(5);
ds_param_w			varchar(50);
BEGIN
ds_param_w := null;
-- valor padrão se acaso não for passado nada
ie_tipo_tx_w := 'P';

-- início tratamento para buscar parâmetros extras
ds_param_extra_processo_w := pls_cta_processo_pck.obter_param_extra_proc(12, ds_param_extra_processo_p);

--processo=18,ie_tipo_tabela_p=R
for r_c_param_extra_processo_w in current_setting('pls_cta_processo_pck.c_param_extra_processo')::CURSOR((ds_param_extra_processo_p) loop
	--ie_tipo_tabela_p=R
	for r_c_param_valor_w in current_setting('pls_cta_processo_pck.c_param_valor')::CURSOR((r_c_param_extra_processo_w.ds_valor_vchr2) loop

		case(ds_param_w)
			when 'ie_tipo_tx_p' then
				ie_tipo_tx_w := r_c_param_valor_w.ds_valor_vchr2;
			else
				null;
		end case;

		ds_param_w := r_c_param_valor_w.ds_valor_vchr2;
	end loop;
end loop;
-- fim tratamento para buscar parâmetros extras
CALL pls_taxa_intercambio_pck.pls_gerencia_tx_inter(	nr_seq_lote_conta_p, nr_seq_protocolo_p, nr_seq_lote_processo_p,
						nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p,
						ie_tipo_tx_w, nm_usuario_p, cd_estabelecimento_p,
						nr_seq_analise_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_processo_pck.executa_processo_12 ( nr_seq_lote_conta_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, ds_param_extra_processo_p pls_cta_log_exec.ds_param_extra_processo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) FROM PUBLIC;