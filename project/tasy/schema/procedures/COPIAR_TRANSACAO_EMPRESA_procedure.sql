-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_transacao_empresa ( nr_seq_transacao_p bigint, cd_empresa_destino_p bigint, cd_estab_destino_p bigint, cd_estab_origem_p bigint, nm_usuario_p text, ie_dependentes_p text, ds_sigla_p text, ie_incrementa_codigo_p text) AS $body$
DECLARE


nr_sequencia_w				transacao_financeira.nr_sequencia%type;
nr_seq_trans_fin_ref_w	transacao_financeira.nr_seq_trans_fin_ref%type;
cd_transacao_w				transacao_financeira.cd_transacao%type;
nr_seq_grupo_w				grupo_emp_estrutura.nr_seq_grupo%type;
cd_empresa_origem_w		grupo_emp_estrutura.cd_empresa%type;
cd_empresa_controladora_w	grupo_emp_estrutura.cd_empresa%type	:= 0;

  ctb RECORD;

BEGIN

cd_empresa_origem_w	:=	obter_empresa_estab(cd_estab_origem_p);
nr_seq_grupo_w	:=	holding_pck.get_grupo_emp_usuario_vigente(cd_empresa_origem_w);

select	nextval('transacao_financeira_seq')
into STRICT	nr_sequencia_w
;

if (coalesce(ie_incrementa_codigo_p,'N') = 'S') then
	cd_transacao_w	:= nr_sequencia_w;	
end if;

if (coalesce(nr_seq_grupo_w, 0) <> 0) then
	cd_empresa_controladora_w := holding_pck.get_emp_controladora_grupo(nr_seq_grupo_w);
	if (cd_empresa_controladora_w <> cd_empresa_origem_w) then
		select	nr_seq_trans_fin_ref
		into STRICT		nr_seq_trans_fin_ref_w
		from		transacao_financeira
		where	cd_empresa = cd_empresa_origem_w
		and 		nr_sequencia = nr_seq_transacao_p;
	else
		nr_seq_trans_fin_ref_w	:= nr_seq_transacao_p;
	end if;
else
	nr_seq_trans_fin_ref_w	:= 0;
end if;

insert into transacao_financeira(	nr_sequencia,
					cd_transacao,
					ds_transacao,
					dt_atualizacao,
					nm_usuario,
					ie_caixa,
					ie_banco,
					ie_extra_caixa,
					ie_conta_pagar,
					ie_conta_receber,
					ie_saldo_caixa,
					ie_acao,
					nr_seq_trans_banco,
					ie_autenticar,
					cd_conta_financ,
					cd_estabelecimento,
					ie_situacao,
					cd_historico_banco,
					ie_centro_custo,
					ie_contab_banco,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_historico_caixa,
					cd_empresa,
					cd_tipo_recebimento,
					ie_cheque_cr,
					ie_cartao_cr,
					ie_cartao_debito,
					nr_seq_trans_transf,
					ie_especie,
					ie_dev_cheque,
					ie_negociacao_cheque_cr,
					cd_tipo_baixa,
					ds_orientacao,
					NR_SEQ_TRANS_CHEQUE,
					NR_SEQ_TRANS_DEV_ADIANT,
					IE_VARIACAO_CAMBIAL,
					NR_SEQ_TRANS_BANCO_CAIXA,
					IE_PROJ_REC,
					IE_CRED_NAO_IDENT,
					CD_EXTERNO,
					IE_FRANQUIA,
					IE_REGRA_CONTAB_EMPRESA,
					IE_REPASSE_ITEM,
					IE_RECEB_ADIANT,
					ie_contab_cb,
					IE_UTIL_CAIXA,
					IE_ADIANT_PAGO,
					IE_TIT_PAGAR_ADIANT,
					IE_ESTORNAR_CB,
					IE_BAIXA_CARTAO_CR,
					IE_TRANS_TAXA_CAIXA,
					IE_CONTROLE_BANC,
					IE_CONTAB_TESOURARIA,
					IE_SALDO_CB_ACAO_INVERSA,
					ie_titulo_pagar,
					ie_confirmacao_cb,
  					ie_receb_cheque,
  					ie_receb_cartao,
  					ie_estornar_tes,
  					ie_rps_caixa_receb,
  					ie_cgc_caixa_receb,
  					ie_obs_adiantamento,
  					ie_recibo_cb,
  					ie_gerar_tit_rec,
  					ie_conferir_movto_cb,
  					ie_retorno_convenio,
  					ie_emissao_cheque,
  					ie_exige_centro_custo,
  					ie_controle_contrato,
  					ie_saldo_fluxo,
  					ie_emprestimo,
  					ie_troca_valores,
  					ie_dev_adiant_negativo,
					nr_seq_trans_fin_ref)
(SELECT	nr_sequencia_w,
	coalesce(cd_transacao_w,cd_transacao),
	substr(CASE WHEN coalesce(ds_sigla_p::text, '') = '' THEN ds_transacao  ELSE ds_sigla_p||' - '||ds_transacao END , 1, 250),
	clock_timestamp(),
	nm_usuario_p,
	ie_caixa,
	ie_banco,
	ie_extra_caixa,
	ie_conta_pagar,
	ie_conta_receber,
	ie_saldo_caixa,
	ie_acao,
	nr_seq_trans_banco,
	ie_autenticar,
	cd_conta_financ,
	CASE WHEN coalesce(cd_estabelecimento::text, '') = '' THEN  null  ELSE cd_estab_destino_p END ,
	ie_situacao,
	cd_historico_banco,
	ie_centro_custo,
	ie_contab_banco,
	clock_timestamp(),
	nm_usuario_p,
	cd_historico_caixa,
	cd_empresa_destino_p,
	cd_tipo_recebimento,
	ie_cheque_cr,
	ie_cartao_cr,
	ie_cartao_debito,
	nr_seq_trans_transf,
	ie_especie,
	ie_dev_cheque,
	ie_negociacao_cheque_cr,
	cd_tipo_baixa,
	ds_orientacao,
	NR_SEQ_TRANS_CHEQUE,
	NR_SEQ_TRANS_DEV_ADIANT,
	IE_VARIACAO_CAMBIAL,
	NR_SEQ_TRANS_BANCO_CAIXA,
	IE_PROJ_REC,
	IE_CRED_NAO_IDENT,
	CD_EXTERNO,
	IE_FRANQUIA,
	IE_REGRA_CONTAB_EMPRESA,
	IE_REPASSE_ITEM,
	IE_RECEB_ADIANT,
	ie_contab_cb,
	IE_UTIL_CAIXA,
	IE_ADIANT_PAGO,
	IE_TIT_PAGAR_ADIANT,
	IE_ESTORNAR_CB,
	IE_BAIXA_CARTAO_CR,
	IE_TRANS_TAXA_CAIXA,
	IE_CONTROLE_BANC,
	IE_CONTAB_TESOURARIA,
	IE_SALDO_CB_ACAO_INVERSA,
	ie_titulo_pagar,
	ie_confirmacao_cb,
	ie_receb_cheque,
	ie_receb_cartao,
	ie_estornar_tes,
	ie_rps_caixa_receb,
	ie_cgc_caixa_receb,
	ie_obs_adiantamento,
	ie_recibo_cb,
	ie_gerar_tit_rec,
	ie_conferir_movto_cb,
	ie_retorno_convenio,
	ie_emissao_cheque,
	ie_exige_centro_custo,
	ie_controle_contrato,
	ie_saldo_fluxo,
  	ie_emprestimo,
	ie_troca_valores,
	ie_dev_adiant_negativo,
	CASE WHEN nr_seq_trans_fin_ref_w=0 THEN  null  ELSE nr_seq_trans_fin_ref_w END
from	transacao_financeira
where	nr_sequencia	= nr_seq_transacao_p);
/*and	cd_transacao	not in (select	cd_transacao
				from	transacao_financeira
				where	cd_estabelecimento = nvl(cd_estab_destino_p,cd_estabelecimento)));
*/
if (ie_dependentes_p = 'S') then
	/* Campos da transacao */

	insert	into	trans_financ_campo(nr_sequencia,
		nr_seq_trans_financ,
		dt_atualizacao,
		nm_usuario,
		nm_atributo,
		ie_obrigatorio,
		nm_atributo_mut_excl,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_primeiro_focus,
		nr_sequencia_ref)
	SELECT	nextval('trans_financ_campo_seq'),
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nm_atributo,
		ie_obrigatorio,
		nm_atributo_mut_excl,
		clock_timestamp(),
		nm_usuario_p,
		coalesce(ie_primeiro_focus,'N'),
		CASE WHEN nr_seq_grupo_w=0 THEN  null  ELSE nr_sequencia END
	from	trans_financ_campo
	where	nr_seq_trans_financ	= nr_seq_transacao_p;


	/* Usuarios liberados para a transacao */

	insert	into	trans_financ_usuario(nr_sequencia,
		nr_seq_transacao,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario_param,
		cd_perfil,
		nr_sequencia_ref)
	SELECT	nextval('trans_financ_usuario_seq'),
		nr_sequencia_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_param,
		cd_perfil,
		CASE WHEN nr_seq_grupo_w=0 THEN  null  ELSE nr_sequencia END
	from	trans_financ_usuario
	where	nr_seq_transacao	= nr_seq_transacao_p;
		
	insert into trans_financ_contab(
		nr_sequencia,
		nr_seq_trans_financ,
		ie_debito_credito, 
		ie_regra_conta, 
		ie_regra_centro_custo, 
		dt_atualizacao, 
		nm_usuario, 
		cd_conta_contabil,
		cd_centro_custo, 
		nm_atributo,
		cd_historico,
		ie_valor_absoluto, 
		ie_situacao,
		cd_estabelecimento,
		dt_inicio_vigencia, 
		dt_fim_vigencia,
		nr_seq_rateio_ccusto,
		nr_seq_produto, 
		ie_tipo_titulo_pagar,
		nr_sequencia_ref)
	SELECT	nextval('trans_financ_contab_seq'),
		nr_sequencia_w,
		ie_debito_credito, 
		ie_regra_conta,
		ie_regra_centro_custo, 
		clock_timestamp(), 
		nm_usuario_p, 
		CASE WHEN nr_seq_grupo_w=0 THEN  cd_conta_contabil  ELSE holding_pck.get_conta_contab_ref(cd_empresa_destino_p, cd_conta_contabil) END , 
		CASE WHEN nr_seq_grupo_w=0 THEN  cd_centro_custo  ELSE holding_pck.get_centro_custo_ref(cd_empresa_destino_p, cd_centro_custo, cd_estab_destino_p) END ,
		nm_atributo, 
		cd_historico, 
		ie_valor_absoluto, 
		ie_situacao, 
		cd_estab_destino_p, 
		dt_inicio_vigencia, 
		dt_fim_vigencia,
		nr_seq_rateio_ccusto, 
		nr_seq_produto, 
		ie_tipo_titulo_pagar,
		CASE WHEN nr_seq_grupo_w=0 THEN  null  ELSE nr_sequencia END 
	from	trans_financ_contab
	where	nr_seq_trans_financ	= nr_seq_transacao_p
	and	cd_estabelecimento	= cd_estab_origem_p
	and	ie_situacao = 'A'
	and (coalesce(dt_fim_vigencia::text, '') = '' or dt_fim_vigencia > clock_timestamp());
	
	/* Contas contabeis liberadas para a transacao financeira. 
		Como nao era feito para as empresas nao holding, nao sera chamada quando copiar */
	if (nr_seq_grupo_w <> 0) then
		for ctb in (select	holding_pck.get_conta_contab_ref(cd_empresa_destino_p, cd_conta_contabil) cd_conta_contabil,
									nr_sequencia
						from		trans_financ_conta_ctb
						where	nr_seq_trans_financ	= nr_seq_transacao_p)
		loop
			if (coalesce(ctb.cd_conta_contabil, '0') <> '0') then
				insert into trans_financ_conta_ctb(	nr_sequencia,
					nr_seq_trans_financ,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_conta_contabil,
					nr_sequencia_ref
				)
				values (
					nextval('trans_financ_conta_ctb_seq'),
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ctb.cd_conta_contabil,
					ctb.nr_sequencia);
			end if;
		end loop;
	end if;
		
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_transacao_empresa ( nr_seq_transacao_p bigint, cd_empresa_destino_p bigint, cd_estab_destino_p bigint, cd_estab_origem_p bigint, nm_usuario_p text, ie_dependentes_p text, ds_sigla_p text, ie_incrementa_codigo_p text) FROM PUBLIC;
