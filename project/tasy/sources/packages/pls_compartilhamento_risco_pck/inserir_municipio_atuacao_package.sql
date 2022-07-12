-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_compartilhamento_risco_pck.inserir_municipio_atuacao ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_cooperativa_p pls_segurado_repasse.nr_seq_congenere%type, nr_seq_plano_p pls_plano.nr_sequencia%type) AS $body$
BEGIN

if	((pls_compartilhamento_risco_pck.verif_benef_repas_operadora(nr_seq_segurado_p, nr_seq_cooperativa_p, current_setting('pls_compartilhamento_risco_pck.pls_lote_compart_risco_w')::pls_lote_compart_risco%rowtype.dt_referencia) = 0) and (pls_compartilhamento_risco_pck.obter_abrangencia_produto(ie_area_abrangencia_p, nr_seq_cooperativa_p, nr_seq_plano_p) = 'S')) then
	ie_encontrou_w				:= 'S';
	current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(current_setting('pls_compartilhamento_risco_pck.indice_w')::integer)		:= nr_seq_segurado_p;
	current_setting('pls_compartilhamento_risco_pck.tb_nr_seq_operadora_destino_w')::pls_util_cta_pck.t_number_table(current_setting('pls_compartilhamento_risco_pck.indice_w')::integer) := nr_seq_cooperativa_p;
	CALL CALL pls_compartilhamento_risco_pck.inserir_beneficiarios('N');
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_compartilhamento_risco_pck.inserir_municipio_atuacao ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_cooperativa_p pls_segurado_repasse.nr_seq_congenere%type, nr_seq_plano_p pls_plano.nr_sequencia%type) FROM PUBLIC;
