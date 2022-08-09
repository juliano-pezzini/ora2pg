-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_pj_solicitacao ( nr_seq_solicitacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_cgc_p INOUT text) AS $body$
DECLARE


cd_cgc_solicitacao_w		varchar(14);
qt_registros_w			bigint;

nm_pessoa_fisica_w		pls_solicitacao_comercial.nm_pessoa_fisica%type;
cd_cep_w			varchar(15);
ds_endereco_w			varchar(40);
ds_municipio_w			varchar(40);
sg_uf_municipio_w		pls_solicitacao_comercial.sg_uf_municipio%type;
ds_complemento_w		varchar(255);
nr_telefone_w			varchar(15);
nr_endereco_w			varchar(10);
ds_email_w			varchar(60);
nm_contato_w			varchar(255);
cd_tipo_pessoa_w		smallint;
nr_ddi_w			varchar(3);
nr_ddd_w			varchar(3);


BEGIN

select	max(cd_cgc)
into STRICT	cd_cgc_solicitacao_w
from	pls_solicitacao_comercial
where	nr_sequencia	= nr_seq_solicitacao_p;

if (coalesce(cd_cgc_solicitacao_w,'0') = '0') then /* Não é possível gerar a pessoa jurídica. Favor informar o CNPJ na solicitação de lead. */
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 192753, null );
end if;

select	count(*)
into STRICT	qt_registros_w
from	pessoa_juridica
where	cd_cgc	= cd_cgc_solicitacao_w;

if (qt_registros_w > 0) then /* Já existe um cadastro com o CNPJ ' || cd_cgc_solicitacao_w || '. Verifique. */
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 192754, 'CD_CGC_SOLICITACAO=' || cd_cgc_solicitacao_w );
else
	select	nm_pessoa_fisica,
		cd_cep,
		ds_endereco,
		substr(obter_desc_municipio_ibge(cd_municipio_ibge),1,40),
		sg_uf_municipio,
		ds_complemento,
		nr_telefone,
		nr_endereco,
		ds_email,
		nm_contato,
		nr_ddi,
		nr_ddd
	into STRICT	nm_pessoa_fisica_w,
		cd_cep_w,
		ds_endereco_w,
		ds_municipio_w,
		sg_uf_municipio_w,
		ds_complemento_w,
		nr_telefone_w,
		nr_endereco_w,
		ds_email_w,
		nm_contato_w,
		nr_ddi_w,
		nr_ddd_w
	from	pls_solicitacao_comercial
	where	nr_sequencia	= nr_seq_solicitacao_p;

	if (coalesce(cd_cep_w::text, '') = '') then /* Favor informar o CEP para a solicitação de lead! */
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 192748, null );
	end if;

	if (coalesce(sg_uf_municipio_w::text, '') = '') then /* Favor informar o UF para a solicitação de lead! */
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 192749, null );
	end if;

	if (coalesce(ds_municipio_w::text, '') = '') then /* Favor informar o município para a solicitação de lead! */
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 192750, null );
	end if;

	if (coalesce(ds_endereco_w::text, '') = '') then /* Favor informar o endereço para a solicitação de lead! */
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 192751, null );
	end if;

	select	max(cd_tipo_pessoa)
	into STRICT	cd_tipo_pessoa_w
	from	tipo_pessoa_juridica
	where	ie_situacao	= 'A';

	insert into pessoa_juridica(	cd_cgc,
					ds_razao_social,
					nm_fantasia,
					cd_cep,
					ds_endereco,
					ds_bairro,
					ds_municipio,
					sg_estado,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_complemento,
					nr_telefone,
					nr_endereco,
					ds_email,
					nm_pessoa_contato,
					cd_tipo_pessoa,
					ie_prod_fabric,
					ie_situacao,
					nr_ddd_telefone,
					nr_ddi_telefone)
				values (	cd_cgc_solicitacao_w,
					nm_pessoa_fisica_w,
					nm_pessoa_fisica_w,
					cd_cep_w,
					ds_endereco_w,
					' ',
					ds_municipio_w,
					sg_uf_municipio_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_complemento_w,
					nr_telefone_w,
					nr_endereco_w,
					ds_email_w,
					nm_contato_w,
					cd_tipo_pessoa_w,
					'N',
					'A',
					nr_ddd_w,
					nr_ddi_w);
end if;

cd_cgc_p	:= cd_cgc_solicitacao_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pj_solicitacao ( nr_seq_solicitacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_cgc_p INOUT text) FROM PUBLIC;
