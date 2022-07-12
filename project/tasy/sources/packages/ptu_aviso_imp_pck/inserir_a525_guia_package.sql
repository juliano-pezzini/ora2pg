-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_imp_pck.inserir_a525_guia ( nr_sequencia_p INOUT ptu_aviso_ret_guia.nr_sequencia%type, nm_usuario_p ptu_aviso_ret_guia.nm_usuario%type, nr_seq_ret_protocolo_p ptu_aviso_ret_guia.nr_seq_ret_protocolo%type, nr_guia_prestador_p ptu_aviso_ret_guia.nr_guia_prestador%type, nr_guia_operadora_p ptu_aviso_ret_guia.nr_guia_operadora%type, nr_carteira_benef_p ptu_aviso_ret_guia.nr_carteira_benef%type, ie_atendimento_rn_p ptu_aviso_ret_guia.ie_atendimento_rn%type, nm_beneficiario_p ptu_aviso_ret_guia.nm_beneficiario%type, nr_cns_benef_p ptu_aviso_ret_guia.nr_cns_benef%type, ie_ident_beneficiario_p ptu_aviso_ret_guia.ie_ident_beneficiario%type, dt_realizacao_p text, vl_glosa_p ptu_aviso_ret_guia.vl_glosa%type, vl_liberado_p ptu_aviso_ret_guia.vl_liberado%type, vl_processado_p ptu_aviso_ret_guia.vl_processado%type) AS $body$
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
dt_realizacao_w	ptu_aviso_ret_guia.dt_realizacao%type;


BEGIN

-- Converte a data, por conta do forma vindo do XML, ele e passado como string no webservice
if (coalesce(dt_realizacao_p, 'X') != 'X') then
	dt_realizacao_w := to_date(dt_realizacao_p, 'yyyy-mm-dd');
else
	dt_realizacao_w := null;
end if;

insert into ptu_aviso_ret_guia(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_ret_protocolo,
				nr_seq_aviso_conta,
				nr_guia_prestador,
				nr_guia_operadora,
				nr_carteira_benef,
				ie_atendimento_rn,
				nm_beneficiario,
				nr_cns_benef,
				ie_ident_beneficiario,
				dt_realizacao,
				vl_glosa,
				vl_liberado,
				vl_processado)
values (nextval('ptu_aviso_ret_guia_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_ret_protocolo_p,
	null,
	nr_guia_prestador_p,
	nr_guia_operadora_p,
	nr_carteira_benef_p,
	ie_atendimento_rn_p,
	nm_beneficiario_p,
	nr_cns_benef_p,
	ie_ident_beneficiario_p,
	dt_realizacao_w,
	vl_glosa_p,
	vl_liberado_p,
	vl_processado_p) returning nr_sequencia into nr_sequencia_p;
	
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_imp_pck.inserir_a525_guia ( nr_sequencia_p INOUT ptu_aviso_ret_guia.nr_sequencia%type, nm_usuario_p ptu_aviso_ret_guia.nm_usuario%type, nr_seq_ret_protocolo_p ptu_aviso_ret_guia.nr_seq_ret_protocolo%type, nr_guia_prestador_p ptu_aviso_ret_guia.nr_guia_prestador%type, nr_guia_operadora_p ptu_aviso_ret_guia.nr_guia_operadora%type, nr_carteira_benef_p ptu_aviso_ret_guia.nr_carteira_benef%type, ie_atendimento_rn_p ptu_aviso_ret_guia.ie_atendimento_rn%type, nm_beneficiario_p ptu_aviso_ret_guia.nm_beneficiario%type, nr_cns_benef_p ptu_aviso_ret_guia.nr_cns_benef%type, ie_ident_beneficiario_p ptu_aviso_ret_guia.ie_ident_beneficiario%type, dt_realizacao_p text, vl_glosa_p ptu_aviso_ret_guia.vl_glosa%type, vl_liberado_p ptu_aviso_ret_guia.vl_liberado%type, vl_processado_p ptu_aviso_ret_guia.vl_processado%type) FROM PUBLIC;