-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gera_beneficiario_eventual ( cd_usuario_plano_conv_p pls_conta_imp.cd_usuario_plano_conv%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, nr_seq_congenere_cart_conv_p pls_conta_imp.nr_seq_congenere_cart_conv%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_segurado_conv_p INOUT pls_protocolo_conta_imp.nr_seq_prestador_conv%type) AS $body$
DECLARE

					
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_operadora_empresa_w		pls_segurado.cd_operadora_empresa%type;
nr_seq_plano_usu_eventual_w	pls_segurado.nr_seq_plano%type;


BEGIN

-- se foi informada a carteirinha e o nome do benefici_rio gera o mesmo

if (cd_usuario_plano_conv_p IS NOT NULL AND cd_usuario_plano_conv_p::text <> '' AND nm_beneficiario_p IS NOT NULL AND nm_beneficiario_p::text <> '') then
	
	-- gera uma pessoa f_sica

	insert 	into pessoa_fisica(
		cd_pessoa_fisica, nm_usuario, dt_atualizacao,
		nm_pessoa_fisica, ie_tipo_pessoa, nm_usuario_nrec,
		dt_atualizacao_nrec
	) values (
		nextval('pessoa_fisica_seq'), nm_usuario_p, clock_timestamp(),
		nm_beneficiario_p, 2, nm_usuario_p, 
		clock_timestamp()
	) returning cd_pessoa_fisica into cd_pessoa_fisica_w;
	
	cd_operadora_empresa_w	:= pls_obter_nome_empresa_cart(cd_usuario_plano_conv_p, 'E', cd_estabelecimento_p);
	nr_seq_plano_usu_eventual_w := pls_obter_nome_empresa_cart(cd_usuario_plano_conv_p, 'P', cd_estabelecimento_p);
	
	-- gera o segurado

	insert 	into pls_segurado(
		nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
		nm_usuario, nm_usuario_nrec, cd_pessoa_fisica,
		dt_inclusao_operadora, nr_seq_plano, ie_tipo_segurado,
		ie_situacao_atend, nr_seq_congenere, cd_estabelecimento,
		ie_local_cadastro, cd_operadora_empresa, ie_pcmso,
		dt_liberacao
	) values (
		nextval('pls_segurado_seq'), clock_timestamp(), clock_timestamp(),
		nm_usuario_p, nm_usuario_p, cd_pessoa_fisica_w,
		clock_timestamp(), nr_seq_plano_usu_eventual_w, 'I',
		'A', nr_seq_congenere_cart_conv_p, cd_estabelecimento_p,
		2, cd_operadora_empresa_w, 'N',
		clock_timestamp()
	) returning nr_sequencia into nr_seq_segurado_conv_p;
	
	-- gera o registro de carteirinha do benefici_rio

	insert 	into pls_segurado_carteira(
		nr_sequencia, cd_usuario_plano, dt_inicio_vigencia,
		ie_situacao, nr_seq_segurado, dt_atualizacao,
		dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
		cd_estabelecimento)
	values (
		nextval('pls_segurado_carteira_seq'), cd_usuario_plano_conv_p, clock_timestamp(),
		'D', nr_seq_segurado_conv_p, clock_timestamp(),
		clock_timestamp(), nm_usuario_p, nm_usuario_p, 
		cd_estabelecimento_p);
	commit;
	
	CALL pls_gerar_ops_congenere_benef(	nr_seq_segurado_conv_p, cd_usuario_plano_conv_p,
					cd_estabelecimento_p, nm_usuario_p, 'S');
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gera_beneficiario_eventual ( cd_usuario_plano_conv_p pls_conta_imp.cd_usuario_plano_conv%type, nm_beneficiario_p pls_conta_imp.nm_beneficiario%type, nr_seq_congenere_cart_conv_p pls_conta_imp.nr_seq_congenere_cart_conv%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_segurado_conv_p INOUT pls_protocolo_conta_imp.nr_seq_prestador_conv%type) FROM PUBLIC;