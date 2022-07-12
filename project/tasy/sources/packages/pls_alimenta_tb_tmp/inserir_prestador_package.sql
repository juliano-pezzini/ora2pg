-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Inserir prestador na tabela TMP
CREATE OR REPLACE PROCEDURE pls_alimenta_tb_tmp.inserir_prestador (nr_contador_p INOUT integer, tb_nr_seq_prestador_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_protocolo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_mat_p INOUT pls_util_cta_pck.t_number_table, tb_cd_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_ie_tipo_pessoa_prest_p INOUT pls_util_cta_pck.t_varchar2_table_5, tb_nr_seq_classificacao_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_5, tb_nr_seq_prest_inter_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_proc_partic_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_analise_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_processo_p INOUT pls_util_cta_pck.t_number_table) AS $body$
DECLARE

-- IE_TIPO_PRESTADOR
-- PL = Prestador lote protocolo (lote)
-- PA = Prestador atendimento (protocolo)
-- PS = Prestador solicitante (conta)
-- PE = Prestador executor (conta)
-- PP = Prestador participante (procedimento)
-- PF = Prestador fornecedor (material)
-- PIC = Prestador intercâmbio conta (conta)
-- PIP = Prestador intercâmbio participante (procedimento)
-- PSM = Prestador solicitante imp (conta)
-- PEM = Prestador executor imp (conta)
BEGIN
if (tb_nr_seq_prestador_p.count > 0) then
	forall i in tb_nr_seq_prestador_p.first..tb_nr_seq_prestador_p.last
		insert into pls_cta_prestador_tmp(nr_sequencia,
			nr_seq_prestador,
			nr_seq_lote,
			nr_seq_protocolo,
			nr_seq_conta,
			nr_seq_conta_proc,
			nr_seq_conta_mat,
			cd_prestador,
			ie_tipo_pessoa_prest,
			nr_seq_classificacao,
			ie_tipo_prestador,
			nr_seq_prest_inter,
			nr_seq_proc_partic,
			nr_seq_analise,
			nr_seq_lote_processo)
		values (nextval('pls_cta_prestador_tmp_seq'),
			tb_nr_seq_prestador_p(i),
			tb_nr_seq_lote_p(i),
			tb_nr_seq_protocolo_p(i),
			tb_nr_seq_conta_p(i),
			tb_nr_seq_conta_proc_p(i),
			tb_nr_seq_conta_mat_p(i),
			tb_cd_prestador_p(i),
			tb_ie_tipo_pessoa_prest_p(i),
			tb_nr_seq_classificacao_p(i),
			tb_ie_tipo_prestador_p(i),
			tb_nr_seq_prest_inter_p(i),
			tb_nr_seq_proc_partic_p(i),
			tb_nr_seq_analise_p(i),
			tb_nr_seq_lote_processo_p(i));
	commit;
end if;

nr_contador_p := 0;
tb_nr_seq_prestador_p.delete;
tb_nr_seq_lote_p.delete;
tb_nr_seq_protocolo_p.delete;
tb_nr_seq_conta_p.delete;
tb_nr_seq_conta_proc_p.delete;
tb_nr_seq_conta_mat_p.delete;
tb_cd_prestador_p.delete;
tb_ie_tipo_pessoa_prest_p.delete;
tb_nr_seq_classificacao_p.delete;
tb_ie_tipo_prestador_p.delete;
tb_nr_seq_prest_inter_p.delete;
tb_nr_seq_proc_partic_p.delete;
tb_nr_seq_analise_p.delete;
tb_nr_seq_lote_processo_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alimenta_tb_tmp.inserir_prestador (nr_contador_p INOUT integer, tb_nr_seq_prestador_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_protocolo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_proc_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_conta_mat_p INOUT pls_util_cta_pck.t_number_table, tb_cd_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_50, tb_ie_tipo_pessoa_prest_p INOUT pls_util_cta_pck.t_varchar2_table_5, tb_nr_seq_classificacao_p INOUT pls_util_cta_pck.t_number_table, tb_ie_tipo_prestador_p INOUT pls_util_cta_pck.t_varchar2_table_5, tb_nr_seq_prest_inter_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_proc_partic_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_analise_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_processo_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;
