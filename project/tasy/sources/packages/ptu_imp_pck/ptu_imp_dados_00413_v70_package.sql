-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_dados_00413_v70 ( nm_beneficiario_p ptu_resp_nomes_benef.nm_beneficiario%type, nm_empresa_p ptu_resp_nomes_benef.nm_empresa_abrev%type, cd_unimed_p ptu_resp_nomes_benef.cd_unimed%type, cd_usuario_plano_p ptu_resp_nomes_benef.cd_usuario_plano%type, nm_compl_benef_p ptu_resp_nomes_benef.nm_compl_benef%type, nm_plano_p ptu_resp_nomes_benef.nm_plano%type, ie_tipo_acomodacao_p ptu_resp_nomes_benef.ie_tipo_acomodacao%type, ie_abrangencia_p ptu_resp_nomes_benef.ie_abrangencia%type, ie_sexo_p ptu_resp_nomes_benef.ie_sexo%type, nr_via_cartao_p ptu_resp_nomes_benef.nr_via_cartao%type, cd_rede_atend_p ptu_resp_nomes_benef.cd_rede_atendimento%type, ie_tipo_plano_p ptu_resp_nomes_benef.ie_tipo_plano%type, dt_nascimento_p ptu_resp_nomes_benef.dt_nascimento%type, dt_inclusao_benef_p ptu_resp_nomes_benef.dt_inclusao_benef%type, dt_exclusao_benef_p ptu_resp_nomes_benef.dt_exclusao_benef%type, dt_validade_carteira_p ptu_resp_nomes_benef.dt_validade_carteira%type, nm_social_p ptu_resp_nomes_benef.nm_social%type, nr_seq_resp_benef_p ptu_resp_nomes_benef.nr_seq_resp_benef%type, nm_usuario_p usuario.nm_usuario%type, nr_idade_p ptu_resp_nomes_benef.nr_idade%type, id_plano_p ptu_resp_nomes_benef.id_plano%type) AS $body$
DECLARE

					
--Importar dados de respota dos intens da transacao 00413 - Resposta Consulta de Dados de Beneficiarios.


dt_nascimento_w			ptu_resp_nomes_benef.dt_nascimento%type;
dt_inclusao_benef_w		ptu_resp_nomes_benef.dt_inclusao_benef%type;
dt_exclusao_benef_w		ptu_resp_nomes_benef.dt_exclusao_benef%type;
dt_validade_carteira_w		ptu_resp_nomes_benef.dt_validade_carteira%type;


BEGIN

if (coalesce(dt_nascimento_p,'X')	<> 'X') then
	dt_nascimento_w	:= to_date(dt_nascimento_p, 'dd/mm/rrrr');
end if;

if (coalesce(dt_inclusao_benef_p,'X')	<> 'X') then
	dt_inclusao_benef_w	:= to_date(dt_inclusao_benef_p, 'dd/mm/rrrr');
end if;

if (coalesce(dt_exclusao_benef_p,'X')	<> 'X') then
	dt_exclusao_benef_w	:= to_date(dt_exclusao_benef_p, 'dd/mm/rrrr');
end if;

if (coalesce(dt_validade_carteira_p,'X')	<> 'X') then
	dt_validade_carteira_w	:= to_date(dt_validade_carteira_p, 'dd/mm/rrrr');
end if;

insert	into ptu_resp_nomes_benef(nr_sequencia, nr_seq_resp_benef, nm_beneficiario,
	dt_nascimento, nm_empresa_abrev, cd_unimed,
	cd_usuario_plano, nm_compl_benef, nm_plano,
	dt_atualizacao, nm_usuario, ie_tipo_acomodacao,
	ie_abrangencia, cd_local_cobranca, dt_validade_carteira,
	dt_inclusao_benef, dt_exclusao_benef, ie_sexo,
	nr_via_cartao, nm_usuario_nrec, dt_atualizacao_nrec,
	cd_rede_atendimento, ie_tipo_plano, nm_tipo_acomodacao,
	nm_social, nr_idade, id_plano)
values (nextval('ptu_resp_nomes_benef_seq'), nr_seq_resp_benef_p, nm_beneficiario_p,
	dt_nascimento_w, nm_empresa_p, cd_unimed_p,
	lpad(cd_usuario_plano_p,13,'0'), nm_compl_benef_p, nm_plano_p,
	clock_timestamp(), nm_usuario_p, ie_tipo_acomodacao_p,
	ie_abrangencia_p, 0, dt_validade_carteira_w,
	dt_inclusao_benef_w, dt_exclusao_benef_w, ie_sexo_p,
	nr_via_cartao_p, nm_usuario_p, clock_timestamp(),
	cd_rede_atend_p, ie_tipo_plano_p, CASE WHEN ie_tipo_acomodacao_p='A' THEN 'Coletiva' WHEN ie_tipo_acomodacao_p='B' THEN 'Individual' WHEN ie_tipo_acomodacao_p='C' THEN  expressao_pck.obter_desc_expressao(293950) END ,
	nm_social_p, nr_idade_p, id_plano_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_dados_00413_v70 ( nm_beneficiario_p ptu_resp_nomes_benef.nm_beneficiario%type, nm_empresa_p ptu_resp_nomes_benef.nm_empresa_abrev%type, cd_unimed_p ptu_resp_nomes_benef.cd_unimed%type, cd_usuario_plano_p ptu_resp_nomes_benef.cd_usuario_plano%type, nm_compl_benef_p ptu_resp_nomes_benef.nm_compl_benef%type, nm_plano_p ptu_resp_nomes_benef.nm_plano%type, ie_tipo_acomodacao_p ptu_resp_nomes_benef.ie_tipo_acomodacao%type, ie_abrangencia_p ptu_resp_nomes_benef.ie_abrangencia%type, ie_sexo_p ptu_resp_nomes_benef.ie_sexo%type, nr_via_cartao_p ptu_resp_nomes_benef.nr_via_cartao%type, cd_rede_atend_p ptu_resp_nomes_benef.cd_rede_atendimento%type, ie_tipo_plano_p ptu_resp_nomes_benef.ie_tipo_plano%type, dt_nascimento_p ptu_resp_nomes_benef.dt_nascimento%type, dt_inclusao_benef_p ptu_resp_nomes_benef.dt_inclusao_benef%type, dt_exclusao_benef_p ptu_resp_nomes_benef.dt_exclusao_benef%type, dt_validade_carteira_p ptu_resp_nomes_benef.dt_validade_carteira%type, nm_social_p ptu_resp_nomes_benef.nm_social%type, nr_seq_resp_benef_p ptu_resp_nomes_benef.nr_seq_resp_benef%type, nm_usuario_p usuario.nm_usuario%type, nr_idade_p ptu_resp_nomes_benef.nr_idade%type, id_plano_p ptu_resp_nomes_benef.id_plano%type) FROM PUBLIC;
