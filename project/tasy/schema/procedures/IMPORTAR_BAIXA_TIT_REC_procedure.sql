-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_baixa_tit_rec (nr_titulo_externo_p text, dt_recebimento_p timestamp, vl_recebido_p bigint, vl_descontos_p bigint, vl_juros_p bigint, vl_multa_p bigint, cd_moeda_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, cd_tipo_recebimento_p bigint, ie_acao_p text, cd_serie_nf_devol_p text, nr_nota_fiscal_devol_p bigint, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_documento_p text, nr_lote_banco_p text, cd_cgc_emp_cred_p text, nr_cartao_cred_p text, nr_seq_trans_fin_p bigint, vl_rec_maior_p bigint, vl_glosa_p bigint, nr_seq_conta_banco_p bigint, vl_despesa_bancaria_p bigint, ds_observacao_p text, nr_seq_trans_caixa_p bigint, cd_centro_custo_desc_p bigint, nr_seq_motivo_desc_p bigint, dt_integracao_externa_p timestamp, vl_perdas_p bigint, dt_autenticacao_p timestamp, vl_outros_acrescimos_p bigint) AS $body$
DECLARE

 
 
nr_sequencia_w			integer;
nr_titulo_w			bigint;


BEGIN 
select	max(nr_titulo) 
into STRICT	nr_titulo_w 
from	titulo_receber 
where	nr_titulo_externo = nr_titulo_externo_p;
 
if (coalesce(nr_titulo_w::text, '') = '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265410,'');
	--Mensagem: Título não encontrado! 
else 
	select 	coalesce(max(nr_sequencia),0) + 1 
	into STRICT	nr_sequencia_w 
	from	titulo_receber_liq 
	where	nr_titulo = nr_titulo_w;
end if;
 
insert	into titulo_receber_liq(nr_titulo, 
	nr_sequencia, 
	dt_recebimento, 
	vl_recebido, 
	vl_descontos, 
	vl_juros, 
	vl_multa, 
	cd_moeda, 
	dt_atualizacao, 
	nm_usuario, 
	cd_tipo_recebimento, 
	ie_acao, 
	cd_serie_nf_devol, 
	nr_nota_fiscal_devol, 
	cd_banco, 
	cd_agencia_bancaria, 
	nr_documento, 
	nr_lote_banco, 
	cd_cgc_emp_cred, 
	nr_cartao_cred, 
	nr_adiantamento, 
	nr_lote_contabil, 
	nr_seq_trans_fin, 
	vl_rec_maior, 
	vl_glosa, 
	nr_seq_retorno, 
	vl_adequado, 
	nr_seq_ret_item, 
	nr_seq_conta_banco, 
	vl_despesa_bancaria, 
	ds_observacao, 
	nr_seq_caixa_rec, 
	ie_lib_caixa, 
	nr_seq_trans_caixa, 
	cd_centro_custo_desc, 
	nr_seq_motivo_desc, 
	nr_bordero, 
	nr_seq_movto_trans_fin, 
	nr_seq_cobranca, 
	dt_integracao_externa, 
	vl_perdas, 
	dt_autenticacao, 
	vl_outros_acrescimos, 
	nr_lote_contab_antecip, 
	nr_lote_contab_pro_rata) 
values (nr_titulo_w, 
	nr_sequencia_w, 
	dt_recebimento_p, 
	vl_recebido_p, 
	vl_descontos_p, 
	vl_juros_p, 
	vl_multa_p, 
	cd_moeda_p, 
	dt_atualizacao_p, 
	nm_usuario_p, 
	cd_tipo_recebimento_p, 
	ie_acao_p, 
	cd_serie_nf_devol_p, 
	nr_nota_fiscal_devol_p, 
	cd_banco_p, 
	cd_agencia_bancaria_p, 
	nr_documento_p, 
	nr_lote_banco_p, 
	cd_cgc_emp_cred_p, 
	nr_cartao_cred_p, 
	null, 
	0, 
	nr_seq_trans_fin_p, 
	vl_rec_maior_p, 
	vl_glosa_p, 
	null, 
	0, 
	null, 
	nr_seq_conta_banco_p, 
	vl_despesa_bancaria_p, 
	ds_observacao_p, 
	null, 
	'S', 
	nr_seq_trans_caixa_p, 
	cd_centro_custo_desc_p, 
	nr_seq_motivo_desc_p, 
	null, 
	null, 
	null, 
	dt_integracao_externa_p, 
	vl_perdas_p, 
	dt_autenticacao_p, 
	vl_outros_acrescimos_p, 
	0, 
	0);
 
CALL atualizar_saldo_tit_rec(nr_titulo_w,nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_baixa_tit_rec (nr_titulo_externo_p text, dt_recebimento_p timestamp, vl_recebido_p bigint, vl_descontos_p bigint, vl_juros_p bigint, vl_multa_p bigint, cd_moeda_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, cd_tipo_recebimento_p bigint, ie_acao_p text, cd_serie_nf_devol_p text, nr_nota_fiscal_devol_p bigint, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_documento_p text, nr_lote_banco_p text, cd_cgc_emp_cred_p text, nr_cartao_cred_p text, nr_seq_trans_fin_p bigint, vl_rec_maior_p bigint, vl_glosa_p bigint, nr_seq_conta_banco_p bigint, vl_despesa_bancaria_p bigint, ds_observacao_p text, nr_seq_trans_caixa_p bigint, cd_centro_custo_desc_p bigint, nr_seq_motivo_desc_p bigint, dt_integracao_externa_p timestamp, vl_perdas_p bigint, dt_autenticacao_p timestamp, vl_outros_acrescimos_p bigint) FROM PUBLIC;
