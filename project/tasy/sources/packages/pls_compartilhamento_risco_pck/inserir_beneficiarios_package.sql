-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_compartilhamento_risco_pck.inserir_beneficiarios ( ie_descarregar_vetor_p text) AS $body$
BEGIN

if	((current_setting('pls_compartilhamento_risco_pck.indice_w')::integer >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_vetor_p = 'S')) then
	if (current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table.count > 0) then
		forall i in current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_segurado_w.last
			insert into pls_compartilhamento_risco(nr_sequencia, nr_seq_lote, nr_seq_operadora_destino,
				nr_seq_segurado, dt_atualizacao, dt_atualizacao_nrec,
				nm_usuario, nm_usuario_nrec, ie_tipo_regra)
			values (nextval('pls_compartilhamento_risco_seq'), nr_seq_lote_copart_risco_p, current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_operadora_destino_w')::pls_util_cta_pck.t_number_table(i),
				current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(i), clock_timestamp(), clock_timestamp(),
				nm_usuario_p, nm_usuario_p, 'E');
		commit;
	end if;
	
	CALL pls_compartilhamento_risco_pck.limpar_vetor_beneficiarios();
else
	PERFORM set_config('pls_compartilhamento_risco_pck.indice_w', current_setting('pls_compartilhamento_risco_pck.indice_w')::integer + 1, false);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_compartilhamento_risco_pck.inserir_beneficiarios ( ie_descarregar_vetor_p text) FROM PUBLIC;
