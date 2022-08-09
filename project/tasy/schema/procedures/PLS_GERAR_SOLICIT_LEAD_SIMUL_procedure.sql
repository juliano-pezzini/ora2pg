-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_solicit_lead_simul ( nr_seq_simulacao_p bigint, nm_pessoa_solicitacao_p text, nm_contato_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_complemento_p text, cd_municipio_ibge_p text, sg_estado_p text, dt_nascimento_p text, nr_ddi_p text, nr_ddd_p text, nr_telefone_p text, ds_email_p text, nr_celular_p text, nr_acao_origem_p bigint, ie_tipo_contratacao_p text, nr_seq_classificacao_p bigint, nr_seq_agente_motiv_p bigint, cd_pf_vinculado_p text, cd_cgc_vinculado_p text, nr_seq_solicitacao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_solicitacao_w		bigint;
dt_nascimento_w			timestamp;
qt_idade_w			bigint;


BEGIN

select	nextval('pls_solicitacao_comercial_seq')
into STRICT	nr_seq_solicitacao_w
;

if ((elimina_caracteres_especiais(dt_nascimento_p) IS NOT NULL AND (elimina_caracteres_especiais(dt_nascimento_p))::text <> '')) then
	dt_nascimento_w	:=	to_date(dt_nascimento_p);
	/*aaschlote 30/03/2011 OS - 300982*/

	qt_idade_w	:= 	obter_idade(dt_nascimento_w, clock_timestamp(),'A');
else
	dt_nascimento_w	:= null;
	qt_idade_w	:= 0;
end if;


insert into pls_solicitacao_comercial(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		cd_estabelecimento,nm_pessoa_fisica,nm_contato,ie_status,ie_origem_solicitacao,
		cd_cep,ds_endereco,nr_endereco,ds_bairro,ds_complemento,
		cd_municipio_ibge,sg_uf_municipio,dt_nascimento,nr_ddi,nr_ddd,
		nr_telefone,ds_email,nr_celular,ie_tipo_contratacao,nr_acao_origem,
		ie_etapa_solicitacao,nr_seq_agente_motivador,nr_seq_classificacao,cd_pf_vinculado,cd_cnpj_vinculado,
		ds_observacao,dt_solicitacao,qt_idade)
values (	nr_seq_solicitacao_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		cd_estabelecimento_p,substr(nm_pessoa_solicitacao_p,1,60),nm_contato_p,'PE','S',
		cd_cep_p,ds_endereco_p,nr_endereco_p,ds_bairro_p,ds_complemento_p,
		cd_municipio_ibge_p,sg_estado_p,dt_nascimento_w,nr_ddi_p,nr_ddd_p,
		nr_telefone_p,ds_email_p,nr_celular_p,ie_tipo_contratacao_p,nr_acao_origem_p,
		'T',nr_seq_agente_motiv_p,nr_seq_classificacao_p,cd_pf_vinculado_p,cd_cgc_vinculado_p,
		'Gerado a partir da simulação de preço '|| nr_seq_simulacao_p,clock_timestamp(),qt_idade_w);

update	pls_simulacao_preco
set	nr_seq_solicitacao	= nr_seq_solicitacao_w
where	nr_sequencia		= nr_seq_simulacao_p;

nr_seq_solicitacao_p	:= nr_seq_solicitacao_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_solicit_lead_simul ( nr_seq_simulacao_p bigint, nm_pessoa_solicitacao_p text, nm_contato_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_complemento_p text, cd_municipio_ibge_p text, sg_estado_p text, dt_nascimento_p text, nr_ddi_p text, nr_ddd_p text, nr_telefone_p text, ds_email_p text, nr_celular_p text, nr_acao_origem_p bigint, ie_tipo_contratacao_p text, nr_seq_classificacao_p bigint, nr_seq_agente_motiv_p bigint, cd_pf_vinculado_p text, cd_cgc_vinculado_p text, nr_seq_solicitacao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
