-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- insert_detalhe
CREATE OR REPLACE PROCEDURE pls_declaracao_ir_pck.insert_detalhe ( tb_nr_seq_segurado_ir_p INOUT pls_util_cta_pck.t_number_table, tb_vl_mensalidade_p INOUT pls_util_cta_pck.t_number_table, tb_vl_copariticipacao_p INOUT pls_util_cta_pck.t_number_table, tb_vl_reembolso_p INOUT pls_util_cta_pck.t_number_table, tb_vl_desconto_p INOUT pls_util_cta_pck.t_number_table, tb_vl_devolucao_p INOUT pls_util_cta_pck.t_number_table, tb_nr_titulo_rec_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_baixa_tit_rec_p INOUT pls_util_cta_pck.t_number_table, tb_nr_titulo_pag_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_baixa_tit_pag_p INOUT pls_util_cta_pck.t_number_table, tb_dt_recebimento_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_segurado_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p text) AS $body$
BEGIN

if (tb_nr_seq_segurado_ir_p.count > 0) then
	forall i in tb_nr_seq_segurado_ir_p.first..tb_nr_seq_segurado_ir_p.last
		insert	into pls_mens_detalhe_ir(	nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_beneficiario_ir,
				vl_mensalidade, vl_coparticipacao, vl_reembolso,
				vl_desconto, vl_devolucao, nr_titulo_rec,
				nr_seq_baixa_tit_rec, nr_titulo_pag, nr_seq_baixa_tit_pag,
				dt_baixa
				)
		values (	nextval('pls_mens_detalhe_ir_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, tb_nr_seq_segurado_ir_p(i),
				coalesce(tb_vl_mensalidade_p(i),0), tb_vl_copariticipacao_p(i), tb_vl_reembolso_p(i),
				tb_vl_desconto_p(i), tb_vl_devolucao_p(i), tb_nr_titulo_rec_p(i),
				tb_nr_seq_baixa_tit_rec_p(i), tb_nr_titulo_pag_p(i), tb_nr_seq_baixa_tit_pag_p(i),
				tb_dt_recebimento_p(i));
	commit;
end if;

tb_nr_seq_segurado_ir_p.delete;
tb_vl_mensalidade_p.delete;
tb_vl_copariticipacao_p.delete;
tb_vl_reembolso_p.delete;
tb_vl_desconto_p.delete;
tb_vl_devolucao_p.delete;
tb_nr_titulo_rec_p.delete;
tb_nr_seq_baixa_tit_rec_p.delete;
tb_nr_titulo_pag_p.delete;
tb_nr_seq_baixa_tit_pag_p.delete;
tb_dt_recebimento_p.delete;
tb_nr_seq_segurado_p.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_declaracao_ir_pck.insert_detalhe ( tb_nr_seq_segurado_ir_p INOUT pls_util_cta_pck.t_number_table, tb_vl_mensalidade_p INOUT pls_util_cta_pck.t_number_table, tb_vl_copariticipacao_p INOUT pls_util_cta_pck.t_number_table, tb_vl_reembolso_p INOUT pls_util_cta_pck.t_number_table, tb_vl_desconto_p INOUT pls_util_cta_pck.t_number_table, tb_vl_devolucao_p INOUT pls_util_cta_pck.t_number_table, tb_nr_titulo_rec_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_baixa_tit_rec_p INOUT pls_util_cta_pck.t_number_table, tb_nr_titulo_pag_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_baixa_tit_pag_p INOUT pls_util_cta_pck.t_number_table, tb_dt_recebimento_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_segurado_p INOUT pls_util_cta_pck.t_number_table, nm_usuario_p text) FROM PUBLIC;