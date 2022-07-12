-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.limpar_type_dados_conta_a700 ( dados_conta_p INOUT pls_gerar_contas_a700_pck.dados_conta) AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por limpar os campos do type DADOS_CONTA.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

		

BEGIN

if (dados_conta_p.nr_seq_protocolo.count > 0) then

	dados_conta_p.ie_tipo_atendimento_imp.delete;
	dados_conta_p.nr_seq_saida_spsadt.delete;
	dados_conta_p.cd_guia.delete;
	dados_conta_p.cd_guia_referencia.delete;
	dados_conta_p.nm_usuario.delete;
	dados_conta_p.dt_atualizacao.delete;
	dados_conta_p.nm_usuario_nrec.delete;
	dados_conta_p.dt_atualizacao_nrec.delete;
	dados_conta_p.nr_seq_protocolo.delete;
	dados_conta_p.cd_estabelecimento.delete;
	dados_conta_p.nr_seq_prestador_exec.delete;
	dados_conta_p.dt_emissao.delete;
	dados_conta_p.ie_status.delete;
	dados_conta_p.ie_tipo_guia.delete;
	dados_conta_p.nr_seq_segurado.delete;
	dados_conta_p.nr_seq_fatura.delete;
	dados_conta_p.cd_cooperativa.delete;
	dados_conta_p.ie_tipo_conta.delete;
	dados_conta_p.cd_medico_solicitante.delete;
	dados_conta_p.nr_seq_nota_cobranca.delete;
	dados_conta_p.nr_seq_prestador_exec_imp.delete;
	dados_conta_p.nr_seq_prestador_imp.delete;
	dados_conta_p.cd_usuario_plano_imp.delete;
	dados_conta_p.ie_origem_conta.delete;
	dados_conta_p.dt_atendimento.delete;
	dados_conta_p.ie_carater_internacao.delete;
	dados_conta_p.dt_entrada.delete;
	dados_conta_p.dt_alta.delete;
	dados_conta_p.nr_seq_clinica.delete;
	dados_conta_p.nr_seq_saida_int.delete;
	dados_conta_p.ie_indicacao_acidente.delete;
	dados_conta_p.cd_senha.delete;
	dados_conta_p.cd_senha_externa.delete;
	dados_conta_p.nr_seq_tipo_atendimento.delete;
	dados_conta_p.cd_prestador_solic_imp.delete;
	dados_conta_p.nm_prestador_imp.delete;
	dados_conta_p.cd_prestador_exec_imp.delete;
	dados_conta_p.nm_prestador_exec_imp.delete;
	dados_conta_p.dt_atendimento_imp.delete;
	dados_conta_p.ie_tipo_acomodacao_ptu.delete;
	dados_conta_p.ds_indicacao_clinica.delete;
	dados_conta_p.ds_observacao.delete;
	dados_conta_p.ie_gestacao.delete;
	dados_conta_p.ie_aborto.delete;
	dados_conta_p.ie_parto_normal.delete;
	dados_conta_p.ie_complicacao_puerperio.delete;
	dados_conta_p.ie_complicacao_neonatal.delete;
	dados_conta_p.ie_parto_cesaria.delete;
	dados_conta_p.ie_baixo_peso.delete;
	dados_conta_p.ie_atend_rn_sala_parto.delete;
	dados_conta_p.ie_transtorno.delete;
	dados_conta_p.ie_obito_mulher.delete;
	dados_conta_p.qt_obito_precoce.delete;
	dados_conta_p.qt_obito_tardio.delete;
	dados_conta_p.qt_nasc_vivos_termo.delete;
	dados_conta_p.qt_nasc_mortos.delete;
	dados_conta_p.qt_nasc_vivos_prematuros.delete;
	dados_conta_p.nr_seq_serv_pre_pagto.delete;
	dados_conta_p.ie_vinc_internacao.delete;
	dados_conta_p.nr_seq_plano.delete;
	
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.limpar_type_dados_conta_a700 ( dados_conta_p INOUT pls_gerar_contas_a700_pck.dados_conta) FROM PUBLIC;