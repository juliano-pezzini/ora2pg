-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_trans_financ_holding ( nr_sequencia_p transacao_financeira.nr_sequencia%type, ie_operacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w  grupo_emp_estrutura.cd_empresa%type;
cd_estab_destino_w  estabelecimento.cd_estabelecimento%type	:= 0;
transacao_financeira_w  transacao_financeira%rowtype;

c01 CURSOR FOR
	SELECT  g.cd_empresa, e.cd_estabelecimento
	from  grupo_emp_estrutura g, estabelecimento e
	where  g.cd_empresa = e.cd_empresa
	and  g.nr_seq_grupo = holding_pck.get_grupo_emp_usuario_vigente(cd_empresa_w)
	and not exists (
		SELECT 1
		from  transacao_financeira x
		where x.cd_empresa  = g.cd_empresa
		and x.cd_estabelecimento = e.cd_estabelecimento
		and x.nr_sequencia = nr_sequencia_p)
	order by g.cd_empresa;

c01_w    c01%rowtype;

c02 CURSOR FOR
  SELECT  t.nr_sequencia,
        t.cd_empresa
  from  transacao_financeira t
  where  t.nr_seq_trans_fin_ref  = nr_sequencia_p;

c02_w    c02%rowtype;


BEGIN

select  t.*
into STRICT  transacao_financeira_w
from  transacao_financeira t
where  nr_sequencia = nr_sequencia_p;

cd_empresa_w  :=  obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento);

if (ie_operacao_p = 1) then
	open c01;
  	loop
  		fetch c01 into
    		c01_w;
  	EXIT WHEN NOT FOUND; /* apply on c01 */
    	if (coalesce(transacao_financeira_w.cd_estabelecimento, 0) <> 0) then
    		cd_estab_destino_w  := c01_w.cd_estabelecimento;
    	end if;

    	CALL copiar_transacao_empresa(nr_sequencia_p,
        	c01_w.cd_empresa,
        	cd_estab_destino_w, 
        	wheb_usuario_pck.get_cd_estabelecimento,
        	nm_usuario_p,
        	'N',
       		null,
          	'N');

  	end loop;
  	close c01;

  	else
    open c02;
    loop
    fetch c02 into
      c02_w;
    EXIT WHEN NOT FOUND; /* apply on c02 */
      update transacao_financeira
      set	cd_transacao  = transacao_financeira_w.cd_transacao,
			ds_transacao  = substr(transacao_financeira_w.ds_transacao, 1, 250),
			dt_atualizacao  = clock_timestamp(),
			nm_usuario  = nm_usuario_p,
			ie_caixa  = transacao_financeira_w.ie_caixa,
			ie_banco  = transacao_financeira_w.ie_banco,
			ie_extra_caixa  = transacao_financeira_w.ie_extra_caixa,
			ie_conta_pagar  = transacao_financeira_w.ie_conta_pagar,
			ie_conta_receber  = transacao_financeira_w.ie_conta_receber,
			ie_saldo_caixa  = transacao_financeira_w.ie_saldo_caixa,
			ie_acao  = transacao_financeira_w.ie_acao,
			nr_seq_trans_banco  = transacao_financeira_w.nr_seq_trans_banco,
			ie_autenticar  = transacao_financeira_w.ie_autenticar,
			cd_conta_financ  = transacao_financeira_w.cd_conta_financ,
			ie_situacao  = transacao_financeira_w.ie_situacao,
			cd_historico_banco  = transacao_financeira_w.cd_historico_banco,
			ie_centro_custo  = transacao_financeira_w.ie_centro_custo,
			ie_contab_banco  = transacao_financeira_w.ie_contab_banco,
			cd_historico_caixa  = transacao_financeira_w.cd_historico_caixa,
			cd_tipo_recebimento  = transacao_financeira_w.cd_tipo_recebimento,
			ie_cheque_cr  = transacao_financeira_w.ie_cheque_cr,
			ie_cartao_cr  = transacao_financeira_w.ie_cartao_cr,
			ie_cartao_debito  = transacao_financeira_w.ie_cartao_debito,
			nr_seq_trans_transf  = transacao_financeira_w.nr_seq_trans_transf,
			cd_portador  = transacao_financeira_w.cd_portador,
			cd_tipo_portador  = transacao_financeira_w.cd_tipo_portador,
			ie_especie  = transacao_financeira_w.ie_especie,
			ie_dev_cheque  = transacao_financeira_w.ie_dev_cheque,
			ie_negociacao_cheque_cr  = transacao_financeira_w.ie_negociacao_cheque_cr,
			cd_tipo_baixa  = transacao_financeira_w.cd_tipo_baixa,
			ds_orientacao  = transacao_financeira_w.ds_orientacao,
			nr_seq_trans_cheque  = transacao_financeira_w.nr_seq_trans_cheque,
			nr_seq_trans_dev_adiant  = transacao_financeira_w.nr_seq_trans_dev_adiant,
			ie_variacao_cambial  = transacao_financeira_w.ie_variacao_cambial,
			nr_seq_trans_banco_caixa  = transacao_financeira_w.nr_seq_trans_banco_caixa,
			ie_proj_rec   = transacao_financeira_w.ie_proj_rec,
			ie_cred_nao_ident   = transacao_financeira_w.ie_cred_nao_ident,
			cd_externo   = transacao_financeira_w.cd_externo,
			ie_franquia   = transacao_financeira_w.ie_franquia,
			ie_regra_contab_empresa  = transacao_financeira_w.ie_regra_contab_empresa,
			ie_repasse_item  = transacao_financeira_w.ie_repasse_item,
			ie_receb_adiant  = transacao_financeira_w.ie_receb_adiant,
			ie_util_caixa  = transacao_financeira_w.ie_util_caixa,
			ie_adiant_pago  = transacao_financeira_w.ie_adiant_pago,
			ie_tit_pagar_adiant  = transacao_financeira_w.ie_tit_pagar_adiant,
			ie_contab_cb  = transacao_financeira_w.ie_contab_cb,
			ie_estornar_cb  = transacao_financeira_w.ie_estornar_cb,
			ie_baixa_cartao_cr  = transacao_financeira_w.ie_baixa_cartao_cr,
			ie_trans_taxa_caixa  = transacao_financeira_w.ie_trans_taxa_caixa,
			ie_controle_banc  = transacao_financeira_w.ie_controle_banc,
			ie_contab_tesouraria  = transacao_financeira_w.ie_contab_tesouraria,
			ie_confirmacao_cb  = transacao_financeira_w.ie_confirmacao_cb,
			nr_seq_apres  = transacao_financeira_w.nr_seq_apres,
			ie_receb_cheque  = transacao_financeira_w.ie_receb_cheque,
			ie_receb_cartao  = transacao_financeira_w.ie_receb_cartao,
			ie_estornar_tes  = transacao_financeira_w.ie_estornar_tes,
			nr_seq_trans_dev_receb  = transacao_financeira_w.nr_seq_trans_dev_receb,
			ie_rps_caixa_receb  = transacao_financeira_w.ie_rps_caixa_receb,
			ie_cgc_caixa_receb  = transacao_financeira_w.ie_cgc_caixa_receb,
			ie_obs_adiantamento  = transacao_financeira_w.ie_obs_adiantamento,
			ie_recibo_cb  = transacao_financeira_w.ie_recibo_cb,
			ie_agrupa_lote_cb  = transacao_financeira_w.ie_agrupa_lote_cb,
			ie_titulo_pagar  = transacao_financeira_w.ie_titulo_pagar,
			nr_seq_tipo_baixa_perda  = transacao_financeira_w.nr_seq_tipo_baixa_perda,
			ie_saldo_cb_acao_inversa  = transacao_financeira_w.ie_saldo_cb_acao_inversa,
			nr_seq_bandeira  = transacao_financeira_w.nr_seq_bandeira,
			ie_gerar_tit_rec  = transacao_financeira_w.ie_gerar_tit_rec,
			ie_conferir_movto_cb  = transacao_financeira_w.ie_conferir_movto_cb,
			ie_retorno_convenio  = transacao_financeira_w.ie_retorno_convenio,
			ie_emissao_cheque  = transacao_financeira_w.ie_emissao_cheque,
			ie_exige_centro_custo  = transacao_financeira_w.ie_exige_centro_custo,
			ie_controle_contrato  = transacao_financeira_w.ie_controle_contrato,
			cd_grupo  = transacao_financeira_w.cd_grupo,
			nr_seq_classificacao  = transacao_financeira_w.nr_seq_classificacao,
			ie_saldo_fluxo  = transacao_financeira_w.ie_saldo_fluxo,
			ie_emprestimo  = transacao_financeira_w.ie_emprestimo,
			ie_troca_valores  = transacao_financeira_w.ie_troca_valores,
			nr_seq_trans_aplic  = transacao_financeira_w.nr_seq_trans_aplic,
			ie_dev_adiant_negativo  = transacao_financeira_w.ie_dev_adiant_negativo,
			ie_deposito_direto  = transacao_financeira_w.ie_deposito_direto
      where  nr_sequencia = c02_w.nr_sequencia
      and  cd_empresa  = c02_w.cd_empresa;
    end loop;
    close c02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_trans_financ_holding ( nr_sequencia_p transacao_financeira.nr_sequencia%type, ie_operacao_p bigint, nm_usuario_p text) FROM PUBLIC;

