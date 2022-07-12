-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.get_valor_default ( nm_tabela_p tabela_atributo.nm_tabela%type, nm_atributo_p tabela_atributo.nm_atributo%type, nr_seq_visao_p tabela_visao.nr_sequencia%type, ie_aparelho_pa_p atendimento_sinal_vital.ie_aparelho_pa%type, nr_seq_template_p ehr_template.nr_sequencia%type, nr_seq_elemento_p ehr_template_conteudo.nr_sequencia%type, vl_padrao_p tabela_visao_atributo.vl_padrao%type) RETURNS varchar AS $body$
DECLARE

	ie_valor_nulo_w			varchar(15);
	ds_retorno_w			varchar(2000);
	current_setting('apap_dinamico_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type	estabelecimento.cd_estabelecimento%type	:= wheb_usuario_pck.get_cd_estabelecimento;
	current_setting('apap_dinamico_pck.cd_perfil_w')::perfil.cd_perfil%type         	perfil.cd_perfil%type					:= wheb_usuario_pck.get_cd_perfil;
	cd_funcao_w				funcao.cd_funcao%type					:= wheb_usuario_pck.get_cd_funcao;
	current_setting('apap_dinamico_pck.nm_usuario_w')::usuario.nm_usuario%type			usuario.nm_usuario%type					:= wheb_usuario_pck.get_nm_usuario;
	
BEGIN
	select	max(his_rule_value_default_pck.get_valor_default(nm_tabela_p,nm_atributo_p,ie_aparelho_pa_p,nr_seq_template_p,nr_seq_elemento_p))
	into STRICT	ds_retorno_w
	;

	if (coalesce(ds_retorno_w::text, '') = '') and (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') and (nm_atributo_p IS NOT NULL AND nm_atributo_p::text <> '') then
		select	max(Obter_Regra_Atributo2(nm_tabela_p,nm_atributo_p,nr_seq_visao_p,'VLN',current_setting('apap_dinamico_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type,current_setting('apap_dinamico_pck.cd_perfil_w')::perfil.cd_perfil%type,wheb_usuario_pck.get_cd_funcao,current_setting('apap_dinamico_pck.nm_usuario_w')::usuario.nm_usuario%type))
		into STRICT	ie_valor_nulo_w
		;
		if (ie_valor_nulo_w = 'S') then
			ds_retorno_w	:= null;
		else
			select	coalesce(max(Obter_Regra_Atributo2(nm_tabela_p,nm_atributo_p,nr_seq_visao_p,'VLD',current_setting('apap_dinamico_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%type,current_setting('apap_dinamico_pck.cd_perfil_w')::perfil.cd_perfil%type,wheb_usuario_pck.get_cd_funcao,current_setting('apap_dinamico_pck.nm_usuario_w')::usuario.nm_usuario%type)),vl_padrao_p)
			into STRICT	ds_retorno_w
			;
		end if;	
	end if;
	
	

	return	ds_retorno_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.get_valor_default ( nm_tabela_p tabela_atributo.nm_tabela%type, nm_atributo_p tabela_atributo.nm_atributo%type, nr_seq_visao_p tabela_visao.nr_sequencia%type, ie_aparelho_pa_p atendimento_sinal_vital.ie_aparelho_pa%type, nr_seq_template_p ehr_template.nr_sequencia%type, nr_seq_elemento_p ehr_template_conteudo.nr_sequencia%type, vl_padrao_p tabela_visao_atributo.vl_padrao%type) FROM PUBLIC;