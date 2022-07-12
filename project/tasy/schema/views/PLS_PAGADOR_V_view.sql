-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_pagador_v (nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_contrato, cd_cgc, cd_pessoa_fisica, ie_tipo_pagador, ie_envia_cobranca, nr_seq_forma_cobranca, cd_banco, cd_agencia_bancaria, ie_digito_agencia, cd_conta, ie_digito_conta, dt_dia_vencimento, ie_endereco_boleto, ie_calc_primeira_mens, cd_condicao_pagamento, dt_primeira_mensalidade, ie_calculo_proporcional, nr_seq_conta_banco, ie_pessoa_comprovante, dt_rescisao, nr_seq_motivo_cancelamento, ie_notificacao, dt_reativacao, ie_bonus_indicacao, ie_taxa_emissao_boleto, dt_suspensao, ie_inadimplencia_via_adic, cd_sistema_anterior, nr_seq_vinculo_sca, nr_seq_pagador_ant, nr_seq_pagador_intercambio, nr_seq_compl_pf_tel_adic, nr_seq_pagador_compl, ie_finalidade, nr_seq_regra_obito, nr_seq_compl_pj, nr_seq_destino_corresp, cd_pessoa, nm_pessoa) AS select	a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_SEQ_CONTRATO,a.CD_CGC,a.CD_PESSOA_FISICA,a.IE_TIPO_PAGADOR,a.IE_ENVIA_COBRANCA,a.NR_SEQ_FORMA_COBRANCA,a.CD_BANCO,a.CD_AGENCIA_BANCARIA,a.IE_DIGITO_AGENCIA,a.CD_CONTA,a.IE_DIGITO_CONTA,a.DT_DIA_VENCIMENTO,a.IE_ENDERECO_BOLETO,a.IE_CALC_PRIMEIRA_MENS,a.CD_CONDICAO_PAGAMENTO,a.DT_PRIMEIRA_MENSALIDADE,a.IE_CALCULO_PROPORCIONAL,a.NR_SEQ_CONTA_BANCO,a.IE_PESSOA_COMPROVANTE,a.DT_RESCISAO,a.NR_SEQ_MOTIVO_CANCELAMENTO,a.IE_NOTIFICACAO,a.DT_REATIVACAO,a.IE_BONUS_INDICACAO,a.IE_TAXA_EMISSAO_BOLETO,a.DT_SUSPENSAO,a.IE_INADIMPLENCIA_VIA_ADIC,a.CD_SISTEMA_ANTERIOR,a.NR_SEQ_VINCULO_SCA,a.NR_SEQ_PAGADOR_ANT,a.NR_SEQ_PAGADOR_INTERCAMBIO,a.NR_SEQ_COMPL_PF_TEL_ADIC,a.NR_SEQ_PAGADOR_COMPL,a.IE_FINALIDADE,a.NR_SEQ_REGRA_OBITO,a.NR_SEQ_COMPL_PJ,a.NR_SEQ_DESTINO_CORRESP,
	b.cd_pessoa_fisica cd_pessoa,
	b.nm_pessoa_fisica nm_pessoa
FROM	pls_contrato_pagador a,
	pessoa_fisica b
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	a.cd_cgc is null

union

select	a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_SEQ_CONTRATO,a.CD_CGC,a.CD_PESSOA_FISICA,a.IE_TIPO_PAGADOR,a.IE_ENVIA_COBRANCA,a.NR_SEQ_FORMA_COBRANCA,a.CD_BANCO,a.CD_AGENCIA_BANCARIA,a.IE_DIGITO_AGENCIA,a.CD_CONTA,a.IE_DIGITO_CONTA,a.DT_DIA_VENCIMENTO,a.IE_ENDERECO_BOLETO,a.IE_CALC_PRIMEIRA_MENS,a.CD_CONDICAO_PAGAMENTO,a.DT_PRIMEIRA_MENSALIDADE,a.IE_CALCULO_PROPORCIONAL,a.NR_SEQ_CONTA_BANCO,a.IE_PESSOA_COMPROVANTE,a.DT_RESCISAO,a.NR_SEQ_MOTIVO_CANCELAMENTO,a.IE_NOTIFICACAO,a.DT_REATIVACAO,a.IE_BONUS_INDICACAO,a.IE_TAXA_EMISSAO_BOLETO,a.DT_SUSPENSAO,a.IE_INADIMPLENCIA_VIA_ADIC,a.CD_SISTEMA_ANTERIOR,a.NR_SEQ_VINCULO_SCA,a.NR_SEQ_PAGADOR_ANT,a.NR_SEQ_PAGADOR_INTERCAMBIO,a.NR_SEQ_COMPL_PF_TEL_ADIC,a.NR_SEQ_PAGADOR_COMPL,a.IE_FINALIDADE,a.NR_SEQ_REGRA_OBITO,a.NR_SEQ_COMPL_PJ,a.NR_SEQ_DESTINO_CORRESP,
	b.cd_cgc cd_pessoa,
	b.ds_razao_social nm_pessoa
from	pls_contrato_pagador a,
	pessoa_juridica b
where	a.cd_cgc	= b.cd_cgc
and	a.cd_pessoa_fisica is null;
