-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_receber_padrao ( dt_vencimento_p timestamp, nr_seq_trans_fin_contab_p bigint, cd_portador_p bigint, cd_tipo_portador_p bigint, ie_tipo_inclusao_p bigint, ie_tipo_emissao_titulo_p bigint, cd_estabelecimento_p bigint, vl_titulo_p bigint, ie_origem_titulo_p bigint, ie_tipo_titulo_p bigint, ie_pls_p text, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nm_usuario_p text, tx_desc_antecipacao_p bigint, ds_observacao_titulo_p text, cd_pessoa_fisica_p text, cd_cgc_p text, ie_commit_p text, ie_emite_bloqueto_p text, nr_titulo_gerado_p INOUT bigint) AS $body$
DECLARE

										 
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
				   	         ==>	A T EN Ç Ã O	<== 
		 
	Muito cuidado ao utilizar essa rotina em outra função diferente da Gestão Financeira Philips.	 
	 
	Inicialmente essa procedure foi criada para gerar o título através da função Gestão Financeira Philips. Porém, pode ser 
	utilizada para gerar títulos através de outras funções, onde será necessário tratar os parâmetros de entrada, caso ainda não 
	existam, e sua inserção no título. 
	 
	Campos obrigatórios que inicialmente não estão definidos na entrada dessa proc pq são obtido dos parametros do contas a receber 
	ou serão sysdate: 
	- CD_TIPO_TAXA_JURO 
	- CD_TIPO_TAXA_MULTA 
	- CD_MOEDA 
	- DT_EMISSAO 
	- DT_ATUALIZACAO 
	- DT_PAGAMENTO_PREVISTO (Será o mesmo do dt_vencimento) 
	- IE_SITUACAO (Situação inicial de um título é Aberto. Em situações atípicas, procurar o grupo Financeiro) 
	- TX_JUROS 
	- TX_MULTA 
	- VL_SALDO_JUROS 
	- VL_SALDO_MULTA 
	- VL_SALDO_TITULO (Será o valor do título ao ser gerado). 
*/
									 
 
cd_moeda_padrao_w			parametro_contas_receber.cd_moeda_padrao%type;
nr_seq_trans_fin_baixa_w	parametro_contas_receber.nr_seq_trans_fin_baixa%type;
cd_portador_w				parametro_contas_receber.cd_portador%type;
cd_tipo_portador_w			parametro_contas_receber.cd_tipo_portador%type;
pr_juro_padrao_w			parametro_contas_receber.pr_juro_padrao%type;
pr_multa_padrao_w			parametro_contas_receber.pr_multa_padrao%type;
cd_tipo_taxa_juro_w			parametro_contas_receber.cd_tipo_taxa_juro%type;
cd_tipo_taxa_multa_w		parametro_contas_receber.cd_tipo_taxa_multa%type;
cd_estab_financeiro_w		estabelecimento.cd_estab_financeiro%type;
nr_titulo_w					titulo_receber.nr_titulo%type;
ie_param_163_tf_tit_w		varchar(50);
ie_param_134_orig_tit_w		varchar(50);
ie_param_142_tf_tit_w		varchar(50);
										

BEGIN 
 
ie_param_142_tf_tit_w := Obter_Param_Usuario(801, 142, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param_142_tf_tit_w);
ie_param_163_tf_tit_w := Obter_Param_Usuario(801, 163, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param_163_tf_tit_w);
ie_param_134_orig_tit_w := Obter_Param_Usuario(801, 134, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param_134_orig_tit_w);
 
 
select	max(a.cd_moeda_padrao), 
		max(a.nr_seq_trans_fin_baixa), 
		max(a.cd_portador), 
		max(a.cd_tipo_portador), 
		max(a.pr_juro_padrao), 
		max(a.pr_multa_padrao), 
		max(a.cd_tipo_taxa_juro), 
		max(a.cd_tipo_taxa_multa) 
into STRICT	cd_moeda_padrao_w, 
		nr_seq_trans_fin_baixa_w, 
		cd_portador_w, 
		cd_tipo_portador_w, 
		pr_juro_padrao_w, 
		pr_multa_padrao_w, 
		cd_tipo_taxa_juro_w, 
		cd_tipo_taxa_multa_w 
from	parametro_contas_receber a 
where	a.cd_estabelecimento = cd_estabelecimento_p;	
 
select	max(a.cd_estab_financeiro) 
into STRICT	cd_estab_financeiro_w 
from	estabelecimento a 
where	a.cd_estabelecimento = cd_estabelecimento_p;
 
select	nextval('titulo_seq') 
into STRICT	nr_titulo_w
;
 
nr_titulo_gerado_p := nr_titulo_w;
 
insert into titulo_receber( nr_titulo, 
							cd_estabelecimento, 
							cd_estab_financeiro, 
							cd_moeda, 
							cd_portador, 
							cd_tipo_portador, 
							cd_tipo_taxa_juro, 
							cd_tipo_taxa_multa, 
							dt_atualizacao, 
							dt_emissao, 
							dt_pagamento_previsto, 
							dt_vencimento, 
							ie_origem_titulo, 
							ie_situacao, 
							ie_tipo_emissao_titulo, 
							ie_tipo_inclusao, 
							ie_tipo_titulo, 
							nm_usuario, 
							tx_desc_antecipacao, 
							tx_juros, 
							tx_multa, 
							vl_saldo_juros, 
							vl_saldo_multa, 
							vl_saldo_titulo, 
							vl_titulo, 
							cd_pessoa_fisica, 
							cd_cgc, 
							ds_observacao_titulo, 
							nr_seq_carteira_cobr, 
							nr_seq_conta_banco, 
							nr_seq_trans_fin_contab, 
							nr_seq_trans_fin_baixa, 
							ie_pls ) 
				 values ( nr_titulo_w, 
							cd_estabelecimento_p, 
							coalesce(cd_estab_financeiro_w, cd_estabelecimento_p), 
							cd_moeda_padrao_w, 
							coalesce(cd_portador_p, cd_portador_w), 
							coalesce(cd_tipo_portador_p, cd_tipo_portador_w), 
							cd_tipo_taxa_juro_w, 
							cd_tipo_taxa_multa_w, 
							trunc(clock_timestamp()), 
							trunc(clock_timestamp()), 
							dt_vencimento_p, 
							dt_vencimento_p, 
							coalesce(coalesce(ie_origem_titulo_p, ie_param_134_orig_tit_w),1), --Igual ocorre no newRecord da Manutencao de TIt a receber. 
							'1', -- Situação Aberto 
							ie_tipo_emissao_titulo_p, 
							ie_tipo_inclusao_p, 
							ie_tipo_titulo_p, 
							nm_usuario_p, 
							coalesce(tx_desc_antecipacao_p, 0), 
							coalesce(pr_juro_padrao_w, 0), 
							coalesce(pr_multa_padrao_w, 0), 
							0, --Saldo de juros padrão 0, pois o título está sendo gerado agora, emitido como sysdate 
							0, --Saldo de juros padrão 0, pois o título está sendo gerado agora, emitido como sysdate 
							vl_titulo_p, 
							vl_titulo_p, 
							cd_pessoa_fisica_p, 
							cd_cgc_p, 
							ds_observacao_titulo_p, 
							nr_seq_carteira_cobr_p, 
							nr_seq_conta_banco_p, 
							nr_seq_trans_fin_contab_p, 
						  coalesce(ie_param_142_tf_tit_w,nr_seq_trans_fin_baixa_w), 
							ie_pls_p -- Igual ocorre no newRecord do titulo a receber. 
						);
 
if (coalesce(ie_emite_bloqueto_p,'N') = 'S') then 
	CALL gerar_bloqueto_tit_rec(nr_titulo_w,'MTR');
end if;						
 
if (coalesce(ie_commit_p,'N') = 'S') then 
	commit;
end if;						
						 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_receber_padrao ( dt_vencimento_p timestamp, nr_seq_trans_fin_contab_p bigint, cd_portador_p bigint, cd_tipo_portador_p bigint, ie_tipo_inclusao_p bigint, ie_tipo_emissao_titulo_p bigint, cd_estabelecimento_p bigint, vl_titulo_p bigint, ie_origem_titulo_p bigint, ie_tipo_titulo_p bigint, ie_pls_p text, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nm_usuario_p text, tx_desc_antecipacao_p bigint, ds_observacao_titulo_p text, cd_pessoa_fisica_p text, cd_cgc_p text, ie_commit_p text, ie_emite_bloqueto_p text, nr_titulo_gerado_p INOUT bigint) FROM PUBLIC;
