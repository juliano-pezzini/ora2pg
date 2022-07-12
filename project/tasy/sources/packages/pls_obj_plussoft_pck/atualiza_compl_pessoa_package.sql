-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.atualiza_compl_pessoa ( cd_pessoa_fisica_p INOUT pessoa_fisica.cd_pessoa_fisica%type, cd_cgc_p INOUT pessoa_juridica.cd_cgc%type, nr_seq_vendedor_p pls_vendedor.nr_sequencia%type, nr_seq_agente_motivador_p pls_agente_motivador.nr_sequencia%type, nr_seq_origem_agente_p pls_agente_motivador_orig.nr_sequencia%type, nr_seq_segurado_indic_p pls_solicitacao_comercial.nr_seq_segurado_indic%type, cd_pessoa_indicacao_p pls_solicitacao_comercial.cd_pessoa_indicacao%type, ds_observacao_p pls_solicitacao_comercial.ds_observacao%type, ds_naturalidade_p text, cd_nacionalidade_p text, ie_grau_instrucao_p text, nr_pis_pasep_p text, nr_cartao_nac_sus_p text, dt_emissao_ci_p timestamp, ds_orgao_emissor_ci_p text, sg_emissora_ci_p text, nm_pais_p text, cd_declaracao_nasc_vivo_p text, nm_contato_p text, nm_mae_p text, --Parametros de saida
 ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE

/*  IE_RETORNO_P : 0 - Operacao realizada     1 - Erro  */
				
ie_retorno_w				smallint;
qt_registro_w				bigint;
nr_sequencia_w				bigint;
ds_mensagem_erro_w			varchar(255);
ds_pais_res_w				pais.nr_sequencia%type;
cd_municipio_ibge_res_w			sus_municipio.cd_municipio_ibge%type;
cd_nacionalidade_w			nacionalidade.cd_nacionalidade%type;


BEGIN
-- Inicializa como Operacao nao realizada ate concretizar a transacao
ie_retorno_w := 0;
ds_mensagem_erro_w := '';

--Pais residencial
begin
select	max(nr_sequencia)
into STRICT	ds_pais_res_w
from	pais
where	nm_pais = nm_pais_p;
exception
when others then
	ds_pais_res_w := null;
end;
--Naturalidade (CD_MUNICIPIO_IBGE)
begin
select	cd_municipio_ibge
into STRICT	cd_municipio_ibge_res_w
from	sus_municipio
where	ds_municipio = ds_naturalidade_p;
exception
when others then
	cd_municipio_ibge_res_w := null;
end;
--Nacionalidade
begin
select	cd_nacionalidade
into STRICT	cd_nacionalidade_w
from	nacionalidade
where	ds_nacionalidade = cd_nacionalidade_p;
exception
when others then
	cd_nacionalidade_w := null;
end;

--PF
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	count(1)
	into STRICT	qt_registro_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
	--Verifica se existe PF
	if (qt_registro_w > 0) then
		--A pessoa nao pode ser PF e PJ ao mesmo tempo
		cd_cgc_p := null;
		--Caso PF exista chamar rotina que gera as solicitacoes de alteracao cadastral
		SELECT * FROM pls_obj_plussoft_pck.salvar_alteracoes_pf_pj_compl(	cd_pessoa_fisica_p, cd_cgc_p, nr_seq_vendedor_p, nr_seq_agente_motivador_p, nr_seq_origem_agente_p, nr_seq_segurado_indic_p, cd_pessoa_indicacao_p, ds_observacao_p, cd_municipio_ibge_res_w, cd_nacionalidade_w, ie_grau_instrucao_p, nr_pis_pasep_p, nr_cartao_nac_sus_p, dt_emissao_ci_p, ds_orgao_emissor_ci_p, sg_emissora_ci_p, ds_pais_res_w, cd_declaracao_nasc_vivo_p, nm_contato_p, nm_mae_p, 'plusoft', ie_retorno_w, ds_mensagem_erro_w) INTO STRICT 	cd_pessoa_fisica_p, cd_cgc_p, ie_retorno_w, ds_mensagem_erro_w;
	--Caso nao exista cadastra uma nova PF
	else
		--Erro
		ie_retorno_w := 1;
		ds_mensagem_erro_w := wheb_mensagem_pck.get_texto(1110363);
	end if;
--PJ
elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
	select	count(1)
	into STRICT	qt_registro_w
	from	pessoa_juridica
	where	cd_cgc = cd_cgc_p;
	
	--Verifica se existe PJ
	if (qt_registro_w > 0) then
		--A pessoa nao pode ser PF e PJ ao mesmo tempo
		cd_pessoa_fisica_p := null;
		--Caso PJ exista chamar rotina que gera as solicitacoes de alteracao cadastral
		SELECT * FROM pls_obj_plussoft_pck.salvar_alteracoes_pf_pj_compl(	cd_pessoa_fisica_p, cd_cgc_p, nr_seq_vendedor_p, nr_seq_agente_motivador_p, nr_seq_origem_agente_p, nr_seq_segurado_indic_p, cd_pessoa_indicacao_p, ds_observacao_p, cd_municipio_ibge_res_w, cd_nacionalidade_w, ie_grau_instrucao_p, nr_pis_pasep_p, nr_cartao_nac_sus_p, dt_emissao_ci_p, ds_orgao_emissor_ci_p, sg_emissora_ci_p, ds_pais_res_w, cd_declaracao_nasc_vivo_p, nm_contato_p, nm_mae_p, 'plusoft', ie_retorno_w, ds_mensagem_erro_w) INTO STRICT 	cd_pessoa_fisica_p, cd_cgc_p, ie_retorno_w, ds_mensagem_erro_w;
	--Caso nao exista cadastra uma nova PJ
	else
		--Erro
		ie_retorno_w := 1;
		ds_mensagem_erro_w := wheb_mensagem_pck.get_texto(1110557);
	end if;
--Nova PF
else
	--Erro
	ie_retorno_w := 1;
	ds_mensagem_erro_w := wheb_mensagem_pck.get_texto(1110363);
end if;
--Retorno
ie_retorno_p := ie_retorno_w;
--Mensagem
ds_mensagem_erro_p := ds_mensagem_erro_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.atualiza_compl_pessoa ( cd_pessoa_fisica_p INOUT pessoa_fisica.cd_pessoa_fisica%type, cd_cgc_p INOUT pessoa_juridica.cd_cgc%type, nr_seq_vendedor_p pls_vendedor.nr_sequencia%type, nr_seq_agente_motivador_p pls_agente_motivador.nr_sequencia%type, nr_seq_origem_agente_p pls_agente_motivador_orig.nr_sequencia%type, nr_seq_segurado_indic_p pls_solicitacao_comercial.nr_seq_segurado_indic%type, cd_pessoa_indicacao_p pls_solicitacao_comercial.cd_pessoa_indicacao%type, ds_observacao_p pls_solicitacao_comercial.ds_observacao%type, ds_naturalidade_p text, cd_nacionalidade_p text, ie_grau_instrucao_p text, nr_pis_pasep_p text, nr_cartao_nac_sus_p text, dt_emissao_ci_p timestamp, ds_orgao_emissor_ci_p text, sg_emissora_ci_p text, nm_pais_p text, cd_declaracao_nasc_vivo_p text, nm_contato_p text, nm_mae_p text,  ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) FROM PUBLIC;