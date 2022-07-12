-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_imp_pck.inserir_a525_protocolo ( nr_sequencia_p INOUT ptu_aviso_ret_protocolo.nr_sequencia%type, nm_usuario_p ptu_aviso_ret_protocolo.nm_usuario%type, nr_seq_ret_arquivo_p ptu_aviso_ret_protocolo.nr_seq_ret_arquivo%type, nr_seq_aviso_protocolo_p ptu_aviso_ret_protocolo.nr_seq_aviso_protocolo%type, nr_registro_ans_p ptu_aviso_ret_protocolo.nr_registro_ans%type, nr_lote_p ptu_aviso_ret_protocolo.nr_lote%type, dt_envio_lote_p text, cd_prestador_p ptu_aviso_ret_protocolo.cd_prestador%type, nr_cpf_prestador_p ptu_aviso_ret_protocolo.nr_cpf_prestador%type, cd_cnpj_prestador_p ptu_aviso_ret_protocolo.cd_cnpj_prestador%type, nm_prestador_p ptu_aviso_ret_protocolo.nm_prestador%type, nr_protocolo_p ptu_aviso_ret_protocolo.nr_protocolo%type, vl_total_protocolo_p ptu_aviso_ret_protocolo.vl_total_protocolo%type, vl_glosa_prot_p ptu_aviso_ret_protocolo.vl_glosa_prot%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Insere os dados do A525 e devolve a chave primaria gerada
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ ]  Objetos do dicionario [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dt_envio_lote_w	ptu_aviso_ret_protocolo.dt_envio_lote%type;

BEGIN

dt_envio_lote_w := to_date(dt_envio_lote_p, 'yyyy-mm-dd');


insert into ptu_aviso_ret_protocolo(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_ret_arquivo,
					nr_seq_aviso_protocolo,
					nr_registro_ans,
					nr_lote,
					dt_envio_lote,
					cd_prestador,
					nr_cpf_prestador,
					cd_cnpj_prestador,
					nm_prestador,
					nr_protocolo,
					vl_total_protocolo,
					vl_glosa_prot)
values (nextval('ptu_aviso_ret_protocolo_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_ret_arquivo_p,
	nr_seq_aviso_protocolo_p,
	nr_registro_ans_p,
	nr_lote_p,
	dt_envio_lote_w,
	cd_prestador_p,
	nr_cpf_prestador_p,
	cd_cnpj_prestador_p,
	nm_prestador_p,
	nr_protocolo_p,
	vl_total_protocolo_p,
	vl_glosa_prot_p) returning nr_sequencia into nr_sequencia_p;
	
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_imp_pck.inserir_a525_protocolo ( nr_sequencia_p INOUT ptu_aviso_ret_protocolo.nr_sequencia%type, nm_usuario_p ptu_aviso_ret_protocolo.nm_usuario%type, nr_seq_ret_arquivo_p ptu_aviso_ret_protocolo.nr_seq_ret_arquivo%type, nr_seq_aviso_protocolo_p ptu_aviso_ret_protocolo.nr_seq_aviso_protocolo%type, nr_registro_ans_p ptu_aviso_ret_protocolo.nr_registro_ans%type, nr_lote_p ptu_aviso_ret_protocolo.nr_lote%type, dt_envio_lote_p text, cd_prestador_p ptu_aviso_ret_protocolo.cd_prestador%type, nr_cpf_prestador_p ptu_aviso_ret_protocolo.nr_cpf_prestador%type, cd_cnpj_prestador_p ptu_aviso_ret_protocolo.cd_cnpj_prestador%type, nm_prestador_p ptu_aviso_ret_protocolo.nm_prestador%type, nr_protocolo_p ptu_aviso_ret_protocolo.nr_protocolo%type, vl_total_protocolo_p ptu_aviso_ret_protocolo.vl_total_protocolo%type, vl_glosa_prot_p ptu_aviso_ret_protocolo.vl_glosa_prot%type) FROM PUBLIC;