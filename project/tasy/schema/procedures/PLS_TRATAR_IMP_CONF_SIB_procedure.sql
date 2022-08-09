-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tratar_imp_conf_sib ( nr_seq_lote_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_beneficiario_w	w_pls_conferencia_sib.ds_beneficiario%type;
qt_registros_w		integer;
qt_inicial_w		bigint;
qt_final_w		bigint;

ds_nome_w		varchar(255);
ds_sexo_w		varchar(255);
nr_cpf_w		varchar(255);
dt_nascimento_w		varchar(255);
ds_nome_mae_w		varchar(255);
nr_cco_w		varchar(255);
nr_cco_titular_w	varchar(255);
ds_situacao_w		varchar(255);
nr_cns_w		varchar(255);
ds_logradouro_w		varchar(255);
ds_numero_w		varchar(255);
ds_bairro_w		varchar(255);
cd_municipio_ibge_w	varchar(255);
cd_cep_w		varchar(255);
reside_exterior_w	varchar(255);
codigo_beneficiario_w	varchar(255);
relacao_dependencia_w	varchar(255);
dt_contracao_w		varchar(255);
dt_cancelamento_w	varchar(255);
motivo_cancelamento_w	varchar(255);
nr_plano_ans_w		varchar(255);
nr_plano_operadora_w	varchar(255);
ie_cpt_w		varchar(255);
ie_itens_nao_cobert_w	varchar(255);
cnpj_empresa_w		varchar(255);
dt_reativacao_w		varchar(255);
ie_tipo_endereco_w	varchar(255);
dt_atualizacao_w	varchar(255);

C01 CURSOR FOR
	SELECT	ds_beneficiario
	from	w_pls_conferencia_sib;


BEGIN

open C01;
loop
fetch C01 into
	ds_beneficiario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_nome_w		:= '';
	ds_sexo_w		:= '';
	nr_cpf_w		:= '';
	dt_nascimento_w		:= '';
	ds_nome_mae_w		:= '';
	nr_cco_w		:= '';
	ds_situacao_w		:= '';
	nr_cns_w		:= '';
	ds_logradouro_w		:= '';
	ds_numero_w		:= '';
	ds_bairro_w		:= '';
	cd_municipio_ibge_w	:= '';
	cd_cep_w		:= '';
	reside_exterior_w	:= '';
	codigo_beneficiario_w	:= '';
	relacao_dependencia_w	:= '';
	dt_contracao_w		:= '';
	dt_cancelamento_w	:= '';
	motivo_cancelamento_w	:= '';
	nr_plano_ans_w		:= '';
	nr_plano_operadora_w	:= '';
	ie_cpt_w		:= '';
	ie_itens_nao_cobert_w	:= '';
	cnpj_empresa_w		:= '';
	ie_tipo_endereco_w	:= '';
	dt_reativacao_w		:= '';

	if (position('<beneficiario cco="'  ds_beneficiario_w)  > 0) and (position('" situacao' in ds_beneficiario_w) > 0) then
		qt_inicial_w	:= position('<beneficiario cco="' in ds_beneficiario_w)+19;
		qt_final_w	:= position('" situacao' in ds_beneficiario_w)-qt_inicial_w;
		nr_cco_w	:= substr(ds_beneficiario_w,qt_inicial_w,qt_final_w);
	end if;

	if (position('situacao="' in ds_beneficiario_w)  > 0) and (position('" dataAtualizacao' in ds_beneficiario_w) > 0) then
		qt_inicial_w	:= position('situacao="' in ds_beneficiario_w)+10;
		qt_final_w	:= position('" dataAtualizacao' in ds_beneficiario_w)-qt_inicial_w;
		ds_situacao_w	:= substr(ds_beneficiario_w,qt_inicial_w,qt_final_w);
	end if;

	if (position('dataAtualizacao="' in ds_beneficiario_w) > 0) and (position('">' in ds_beneficiario_w) > 0) then
		qt_inicial_w	:= position('dataAtualizacao="' in ds_beneficiario_w)+17;
		qt_final_w	:= position('">' in ds_beneficiario_w)-qt_inicial_w;
		dt_atualizacao_w:= substr(ds_beneficiario_w,qt_inicial_w,qt_final_w);
	end if;

	ds_nome_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<nome>');
	ds_sexo_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<sexo>');
	nr_cpf_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<cpf>');
	dt_nascimento_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<dataNascimento>');
	ds_nome_mae_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<nomeMae>');
	nr_cns_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<cns>');
	ds_logradouro_w		:= rtrim(pls_extrair_dado_tag_xml(ds_beneficiario_w,'<logradouro>'));
	ds_numero_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<numero>');
	ds_bairro_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<bairro>');
	cd_municipio_ibge_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<codigoMunicipio>');
	cd_cep_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<cep>');
	reside_exterior_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<resideExterior>');
	codigo_beneficiario_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<codigoBeneficiario>');
	relacao_dependencia_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<relacaoDependencia>');
	dt_contracao_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<dataContratacao>');
	dt_cancelamento_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<dataCancelamento>');
	motivo_cancelamento_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<motivoCancelamento>');
	nr_plano_ans_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<numeroPlanoANS>');
	nr_plano_operadora_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<numeroPlanoOperadora>');
	ie_cpt_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<coberturaParcialTemporaria>');
	ie_itens_nao_cobert_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<itensExcluidosCobertura>');
	cnpj_empresa_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<cnpjEmpresaContratante>');
	dt_reativacao_w		:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<dataReativacao>');
	ie_tipo_endereco_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<tipoEndereco>');
	nr_cco_titular_w	:= pls_extrair_dado_tag_xml(ds_beneficiario_w,'<ccoBeneficiarioTitular>');

	CALL pls_importar_conferencia_xml(	nr_seq_lote_sib_p,ds_situacao_w,nr_cco_w,nr_cco_titular_w,ds_nome_w,codigo_beneficiario_w,
					relacao_dependencia_w,ds_sexo_w,nr_cpf_w,dt_nascimento_w,dt_contracao_w,
					dt_cancelamento_w,nr_plano_ans_w,nr_plano_operadora_w,motivo_cancelamento_w,ds_nome_mae_w,
					cd_cep_w,ds_logradouro_w,ds_numero_w,ds_bairro_w,cd_municipio_ibge_w,
					reside_exterior_w,ie_cpt_w,ie_itens_nao_cobert_w,cnpj_empresa_w,'',
					cd_estabelecimento_p,nm_usuario_p,nr_cns_w, dt_reativacao_w, ie_tipo_endereco_w,
					dt_atualizacao_w);
	end;
end loop;
close C01;

select	count(1)
into STRICT	qt_registros_w
from	pls_retorno_sib
where	nr_seq_lote_sib	= nr_seq_lote_sib_p;

update	pls_lote_retorno_sib
set	qt_registros_lote	= qt_registros_w
where	nr_sequencia		= nr_seq_lote_sib_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tratar_imp_conf_sib ( nr_seq_lote_sib_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
