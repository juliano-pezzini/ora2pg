-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_mov_produto_empresa ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_mov_inicio_w			timestamp;
dt_mov_fim_w			timestamp;
nr_seq_contrato_w		bigint;
nr_seq_inter_empresa_w		bigint;
cd_cgc_estipulante_w		varchar(14);
cd_pf_estipulante_w		varchar(10);
ds_razao_social_w		varchar(40);
nm_fantasia_w			varchar(18);
nr_contrato_w			bigint;
ie_tipo_pessoa_w		smallint;
cd_cgc_cpf_w			varchar(14);
nr_inscricao_estadual_w		varchar(20);
ds_endereco_w			varchar(100);
cd_cep_w			varchar(8);
cd_empresa_origem_w		bigint;
ds_complemento_w		varchar(20);
ds_bairro_w			varchar(30);
ds_municipio_w			varchar(30);
sg_estado_w			pessoa_juridica.sg_estado%type;
nr_ddd_telefone_w		varchar(4);
nr_telefone_w			varchar(8);
nr_fax_w			varchar(8);
dt_contrato_w			timestamp;
dt_rescisao_contrato_w		timestamp;
cd_municipio_ibge_w		varchar(7);

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_contrato	b,
		pls_segurado	a
	where	a.nr_seq_contrato	= b.nr_sequencia
	and	((trunc(a.dt_inclusao_operadora) between trunc(dt_mov_inicio_w) and trunc(dt_mov_fim_w)) or (trunc(a.dt_rescisao) between trunc(dt_mov_inicio_w) and trunc(dt_mov_fim_w)))
	group by b.nr_sequencia;


BEGIN

/* Obter dados do envio */

select	dt_mov_inicio,
	dt_mov_fim
into STRICT	dt_mov_inicio_w,
	dt_mov_fim_w
from	ptu_movimentacao_produto
where	nr_sequencia	= nr_sequencia_p;

open C01;
loop
fetch C01 into
	nr_seq_contrato_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	begin
	/* Obter dados do contrato */

	select	cd_cgc_estipulante,
		cd_pf_estipulante,
		nr_contrato,
		dt_contrato,
		dt_rescisao_contrato
	into STRICT	cd_cgc_estipulante_w,
		cd_pf_estipulante_w,
		nr_contrato_w,
		dt_contrato_w,
		dt_rescisao_contrato_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;

	if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then
		select	substr((ds_razao_social),1,40),
			substr((nm_fantasia),1,18),
			nr_inscricao_estadual,
			substr((ds_endereco),1,40),
			substr((cd_cep),1,8),
			substr((ds_complemento),1,20),
			substr((ds_bairro),1,30),
			substr((ds_municipio),1,30),
			sg_estado,
			nr_ddd_telefone,
			substr(somente_numero(nr_telefone),1,8),
			substr(somente_numero(nr_fax),1,8),
			cd_municipio_ibge
		into STRICT	ds_razao_social_w,
			nm_fantasia_w,
			nr_inscricao_estadual_w,
			ds_endereco_w,
			cd_cep_w,
			ds_complemento_w,
			ds_bairro_w,
			ds_municipio_w,
			sg_estado_w,
			nr_ddd_telefone_w,
			nr_telefone_w,
			nr_fax_w,
			cd_municipio_ibge_w
		from	pessoa_juridica
		where	cd_cgc	= cd_cgc_estipulante_w;

		ie_tipo_pessoa_w	:= 1;
		cd_cgc_cpf_w		:= cd_cgc_estipulante_w;
		cd_empresa_origem_w	:= nr_contrato_w;
	elsif (cd_pf_estipulante_w IS NOT NULL AND cd_pf_estipulante_w::text <> '') then
		ds_razao_social_w	:= 'Unimed';
		nm_fantasia_w		:= 'Unimed';
		ie_tipo_pessoa_w	:= 2;
		cd_empresa_origem_w	:= 8888;

		select	a.nr_cpf,
			substr((b.ds_endereco),1,40),
			substr((b.cd_cep),1,8),
			substr((b.ds_complemento),1,20),
			substr((b.ds_bairro),1,30),
			substr((b.ds_municipio),1,30),
			b.sg_estado,
			b.nr_ddd_telefone,
			substr(somente_numero(b.nr_telefone),1,8),
			substr(somente_numero(b.ds_fax),1,8),
			b.cd_municipio_ibge
		into STRICT	cd_cgc_cpf_w,
			ds_endereco_w,
			cd_cep_w,
			ds_complemento_w,
			ds_bairro_w,
			ds_municipio_w,
			sg_estado_w,
			nr_ddd_telefone_w,
			nr_telefone_w,
			nr_fax_w,
			cd_municipio_ibge_w
		from	compl_pessoa_fisica	b,
			pessoa_fisica		a
		where	a.cd_pessoa_fisica	= cd_pf_estipulante_w
		and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	b.ie_tipo_complemento	= 1;

		if (coalesce(cd_cgc_cpf_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267452,
								'CD_PF_ESTIPULANTE_W=' || cd_pf_estipulante_w);
		end if;
		if (coalesce(cd_cep_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267453,
								'CD_PF_ESTIPULANTE_W=' || cd_pf_estipulante_w);

		end if;
		if (coalesce(ds_endereco_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267454,
								'CD_PF_ESTIPULANTE_W=' || cd_pf_estipulante_w);

		end if;

	end if;

	select	nextval('ptu_mov_produto_empresa_seq')
	into STRICT	nr_seq_inter_empresa_w
	;

	insert into ptu_mov_produto_empresa(nr_sequencia, nr_seq_mov_produto, ds_razao_social,
		nm_empr_abrev, ie_tipo_pessoa, cd_cgc_cpf,
		ds_endereco, cd_cep, cd_empresa_origem,
		dt_atualizacao, nm_usuario,dt_atualizacao_nrec,
		nm_usuario_nrec, cd_filial, nr_insc_estadual,
		ds_complemento, ds_bairro, nm_cidade,
		sg_uf, nr_ddd, nr_telefone,
		nr_fax, dt_inclusao, dt_exclusao,
		cd_municipio_ibge, nr_seq_contrato)
	values (	nr_seq_inter_empresa_w, nr_sequencia_p, ds_razao_social_w,
		nm_fantasia_w, ie_tipo_pessoa_w, cd_cgc_cpf_w,
		ds_endereco_w, cd_cep_w, cd_empresa_origem_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, nr_contrato_w,  nr_inscricao_estadual_w,
		ds_complemento_w, ds_bairro_w, ds_municipio_w,
		sg_estado_w, nr_ddd_telefone_w, nr_telefone_w,
		nr_fax_w, dt_contrato_w, dt_rescisao_contrato_w,
		cd_municipio_ibge_w, nr_seq_contrato_w);

		CALL ptu_gerar_mov_produto_benef(nr_seq_inter_empresa_w,nm_usuario_p);

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_mov_produto_empresa ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

