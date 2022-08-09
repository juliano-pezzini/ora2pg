-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_prod_empresa_a300_60 ( nr_seq_mov_plano_p ptu_movimentacao_produto.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


dt_mov_inicio_w			timestamp;
dt_mov_fim_w			timestamp;
ie_tipo_mov_w			ptu_movimentacao_produto.ie_tipo_mov%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
cd_cgc_w			pls_contrato.cd_cgc_estipulante%type;
cd_pessoa_fisica_w		pls_contrato.cd_pf_estipulante%type;
dt_cadastro_w			timestamp;
dt_exclusao_w			timestamp;
nr_seq_inter_empresa_w		ptu_mov_produto_empresa.nr_sequencia%type;
ie_tipo_pessoa_w		ptu_mov_produto_empresa.ie_tipo_pessoa%type;
ds_razao_social_w		ptu_mov_produto_empresa.ds_razao_social%type;
nm_fantasia_w			ptu_mov_produto_empresa.nm_empr_abrev%type;
cd_cgc_cpf_w			ptu_mov_produto_empresa.cd_cgc_cpf%type;
nr_inscricao_estadual_w		ptu_mov_produto_empresa.nr_insc_estadual%type;
ds_endereco_w			ptu_mov_produto_empresa.ds_endereco%type;
cd_cep_w			ptu_mov_produto_empresa.cd_cep%type;
ds_complemento_w		ptu_mov_produto_empresa.ds_complemento%type;
ds_bairro_w			ptu_mov_produto_empresa.ds_bairro%type;
ds_municipio_w			ptu_mov_produto_empresa.nm_cidade%type;
sg_estado_w			pessoa_juridica.sg_estado%type;
nr_ddd_telefone_w		ptu_mov_produto_empresa.nr_ddd%type;
nr_telefone_w			ptu_mov_produto_empresa.nr_telefone%type;
nr_fax_w			ptu_mov_produto_empresa.nr_fax%type;
cd_municipio_ibge_w		ptu_mov_produto_empresa.cd_municipio_ibge%type;
cd_empresa_destino_w		ptu_mov_produto_empresa.cd_empresa_origem%type;
nr_seq_lote_w			ptu_mov_produto_lote.nr_sequencia%type;
cd_estabelecimento_w		pls_outorgante.cd_estabelecimento%type;
ie_inseri_reg_w			varchar(1);
ie_tipo_natureza_w		ptu_mov_produto_empresa.ie_natureza_contratacao%type;
nr_seq_classificacao_w		pls_plano.nr_seq_classificacao%type;
qt_regras_exececoes_w		integer := 0;
qt_registros_w			integer := 0;
nr_endereco_w			ptu_mov_produto_empresa.nr_endereco%type;
nr_contrato_w			ptu_mov_produto_empresa.nr_contrato%type;
ie_tipo_movimentacao_w		ptu_mov_produto_lote.ie_tipo_movimento%type;
--------------------------------------------------------------------------------------
cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;
ds_razao_social_oper_w		varchar(40);
nm_fantasia_oper_w		varchar(18);
nr_inscricao_estadual_oper_w	varchar(20);
ds_endereco_oper_w		varchar(100);
cd_cep_oper_w			varchar(8);
ds_complemento_oper_w		varchar(20);
ds_bairro_oper_w		varchar(30);
ds_municipio_oper_w		varchar(30);
sg_estado_oper_w		pessoa_juridica.sg_estado%type;
nr_ddd_telefone_oper_w		varchar(4);
nr_telefone_oper_w		varchar(8);
nr_fax_oper_w			varchar(8);
cd_municipio_ibge_oper_w	varchar(7);
nr_endereco_oper_w		integer;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
ie_tipo_contrat_fornec_w	pls_plano.ie_tipo_contratacao%type;
nr_seq_contrato_lote_w		ptu_mov_produto_lote.nr_seq_contrato%type;
qt_excessoes_w			bigint;
ie_gerar_sca_nao_liberado_w	pls_parametros.ie_gerar_sca_nao_liberado%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pessoa_juridica		d,
		pls_plano_fornecedor	c,
		pls_plano		b,
		pls_prestador		a
	where	c.nr_seq_plano		= b.nr_sequencia
	and	c.nr_seq_prestador	= a.nr_sequencia
	and	d.cd_cgc		= a.cd_cgc
	and	d.cd_operadora_empresa	= cd_empresa_destino_w
	and	b.nr_seq_classificacao	= nr_seq_classificacao_w
	and	b.ie_tipo_operacao	= 'A'
	group by a.nr_sequencia;

C02 CURSOR FOR
	SELECT	e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia nr_seq_contrato
	from	pls_sca_vinculo		b,
		pls_segurado		a,
		pls_plano		c,
		pls_plano_fornecedor	d,
		pls_contrato		e
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_plano		= c.nr_sequencia
	and	a.nr_seq_contrato	= e.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (ie_gerar_sca_nao_liberado_w = 'S'))
	and	d.nr_seq_prestador	= nr_seq_prestador_w
	and	c.nr_seq_classificacao	= nr_seq_classificacao_w
	and (e.nr_sequencia = nr_seq_contrato_lote_w or coalesce(nr_seq_contrato_lote_w::text, '') = '')
	and	(((trunc(b.dt_inicio_vigencia, 'dd') between dt_mov_inicio_w and dt_mov_fim_w) and ((coalesce(b.dt_fim_vigencia::text, '') = '') or (trunc(b.dt_fim_vigencia, 'dd') > dt_mov_inicio_w))) or /* Inclusao */
		((trunc(b.dt_fim_vigencia, 'dd') between dt_mov_inicio_w and dt_mov_fim_w) and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> ''))) /* Exclusao */
	and	((trunc(b.dt_inicio_vigencia,'dd') <> trunc(b.dt_fim_vigencia,'dd') and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> '')) or coalesce(b.dt_fim_vigencia::text, '') = '') /* Nao entrar no lote o que foi incluido e excluido no mesmo mes */
	and	ie_tipo_movimentacao_w	= 'P'
	group by e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia
	
union

	SELECT	e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia nr_seq_contrato
	from	pls_sca_vinculo		b,
		pls_segurado		a,
		pls_plano		c,
		pls_plano_fornecedor	d,
		pls_contrato		e
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_plano		= c.nr_sequencia
	and	a.nr_seq_contrato	= e.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (ie_gerar_sca_nao_liberado_w = 'S'))
	and	d.nr_seq_prestador	= nr_seq_prestador_w
	and	c.nr_seq_classificacao	= nr_seq_classificacao_w
	and (e.nr_sequencia = nr_seq_contrato_lote_w or coalesce(nr_seq_contrato_lote_w::text, '') = '')
	and	dt_mov_inicio_w between trunc(b.dt_inicio_vigencia,'Month') and coalesce(trunc(b.dt_fim_vigencia,'Month'),dt_mov_inicio_w)
		and	((trunc(b.dt_fim_vigencia,'Month') > dt_mov_inicio_w) or (coalesce(b.dt_fim_vigencia::text, '') = ''))
	and	((trunc(b.dt_inicio_vigencia,'dd') <> trunc(b.dt_fim_vigencia,'dd') and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> '')) or coalesce(b.dt_fim_vigencia::text, '') = '')
	and	ie_tipo_movimentacao_w	= 'A'
	group by e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia
	
union

	select	e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia nr_seq_contrato
	from	pls_sca_vinculo		b,
		pls_segurado		a,
		pls_plano		c,
		pls_plano_fornecedor	d,
		pls_contrato		e
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_plano		= c.nr_sequencia
	and	a.nr_seq_contrato	= e.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (ie_gerar_sca_nao_liberado_w = 'S'))
	and	d.nr_seq_prestador	= nr_seq_prestador_w
	and	c.nr_seq_classificacao	= nr_seq_classificacao_w
	and (e.nr_sequencia = nr_seq_contrato_lote_w or coalesce(nr_seq_contrato_lote_w::text, '') = '')
	and	trunc(b.dt_inicio_vigencia,'Month') <= dt_mov_inicio_w
	and	((trunc(b.dt_inicio_vigencia,'dd') <> trunc(b.dt_fim_vigencia,'dd') and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> '')) or coalesce(b.dt_fim_vigencia::text, '') = '')
	and	ie_tipo_movimentacao_w	= 'M'
	group by e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia
	
union

	select	e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia nr_seq_contrato
	from	pls_sca_vinculo		b,
		pls_segurado		a,
		pls_plano		c,
		pls_plano_fornecedor	d,
		pls_contrato		e
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_plano		= c.nr_sequencia
	and	a.nr_seq_contrato	= e.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (ie_gerar_sca_nao_liberado_w = 'S'))
	and	d.nr_seq_prestador	= nr_seq_prestador_w
	and	c.nr_seq_classificacao	= nr_seq_classificacao_w
	and (e.nr_sequencia = nr_seq_contrato_lote_w or coalesce(nr_seq_contrato_lote_w::text, '') = '')
	and	((trunc(b.dt_inicio_vigencia, 'dd') between dt_mov_inicio_w and dt_mov_fim_w) and ((coalesce(b.dt_fim_vigencia::text, '') = '') or (trunc(b.dt_fim_vigencia, 'dd') > dt_mov_inicio_w)))	
	and	((trunc(b.dt_inicio_vigencia,'dd') <> trunc(b.dt_fim_vigencia,'dd') and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> '')) or coalesce(b.dt_fim_vigencia::text, '') = '') /* Nao entrar no lote o que foi incluido e excluido no mesmo mes */
	and	ie_tipo_movimentacao_w	= 'I'
	group by e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia
	
union

	select	e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia nr_seq_contrato
	from	pls_sca_vinculo		b,
		pls_segurado		a,
		pls_plano		c,
		pls_plano_fornecedor	d,
		pls_contrato		e
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	d.nr_seq_plano		= c.nr_sequencia
	and	a.nr_seq_contrato	= e.nr_sequencia
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (ie_gerar_sca_nao_liberado_w = 'S'))
	and	d.nr_seq_prestador	= nr_seq_prestador_w
	and	c.nr_seq_classificacao	= nr_seq_classificacao_w
	and (e.nr_sequencia = nr_seq_contrato_lote_w or coalesce(nr_seq_contrato_lote_w::text, '') = '')
	and	((trunc(b.dt_fim_vigencia, 'dd') between dt_mov_inicio_w and dt_mov_fim_w) and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> ''))
	and	((trunc(b.dt_inicio_vigencia,'dd') <> trunc(b.dt_fim_vigencia,'dd') and (b.dt_fim_vigencia IS NOT NULL AND b.dt_fim_vigencia::text <> '')) or coalesce(b.dt_fim_vigencia::text, '') = '') /* Nao entrar no lote o que foi incluido e excluido no mesmo mes */
	and	ie_tipo_movimentacao_w	= 'E'
	group by e.nr_contrato,
		e.cd_cgc_estipulante,
		e.cd_pf_estipulante,
		e.dt_contrato,
		e.dt_rescisao_contrato,
		e.nr_sequencia;

BEGIN

select	dt_mov_inicio,
	dt_mov_fim,
	ie_tipo_mov,
	cd_unimed_destino,
	nr_seq_lote
into STRICT	dt_mov_inicio_w,
	dt_mov_fim_w,
	ie_tipo_mov_w,
	cd_empresa_destino_w,
	nr_seq_lote_w
from	ptu_movimentacao_produto
where	nr_sequencia	= nr_seq_mov_plano_p;

select	cd_estabelecimento,
	ie_tipo_movimento,
	nr_seq_classificacao,
	nr_seq_contrato
into STRICT	cd_estabelecimento_w,
	ie_tipo_movimentacao_w,
	nr_seq_classificacao_w,
	nr_seq_contrato_lote_w
from	ptu_mov_produto_lote
where	nr_sequencia	= nr_seq_lote_w;

select	coalesce(max(ie_gerar_sca_nao_liberado), 'N')
into STRICT	ie_gerar_sca_nao_liberado_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_w;

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_w;

select	substr(ds_razao_social,1,40),
	substr(nm_fantasia,1,18),
	somente_numero(nr_inscricao_estadual),
	substr(ds_endereco,1,40),
	substr(cd_cep,1,8),
	substr(ds_complemento,1,20),
	substr(ds_bairro,1,30),
	substr(ds_municipio,1,30),
	sg_estado,
	nr_ddd_telefone,
	substr(somente_numero(nr_telefone),1,8),
	substr(somente_numero(nr_fax),1,8),
	cd_municipio_ibge || Calcula_Digito('MODULO10',substr(cd_municipio_ibge,1,10)),
	nr_endereco
into STRICT	ds_razao_social_oper_w,
	nm_fantasia_oper_w,
	nr_inscricao_estadual_oper_w,
	ds_endereco_oper_w,
	cd_cep_oper_w,
	ds_complemento_oper_w,
	ds_bairro_oper_w,
	ds_municipio_oper_w,
	sg_estado_oper_w,
	nr_ddd_telefone_oper_w,
	nr_telefone_oper_w,
	nr_fax_oper_w,
	cd_municipio_ibge_oper_w,
	nr_endereco_oper_w
from	pessoa_juridica
where	cd_cgc	= cd_cgc_outorgante_w;

select	count(1)
into STRICT	qt_regras_exececoes_w
from	ptu_regra_excessao_a300
where	nr_seq_classificacao	= nr_seq_classificacao_w
and	ie_situacao		= 'A';

open C01;
loop
fetch C01 into
	nr_seq_prestador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(CASE WHEN ie_tipo_contratacao='CA' THEN 4 WHEN ie_tipo_contratacao='CE' THEN 3 WHEN ie_tipo_contratacao='I' THEN 2  ELSE 5 END ),
		max(ie_tipo_contratacao)
	into STRICT	ie_tipo_natureza_w,
		ie_tipo_contrat_fornec_w
	from	pls_plano_fornecedor	b,
		pls_plano		a
	where	b.nr_seq_plano		= a.nr_sequencia
	and	b.nr_seq_prestador	= nr_seq_prestador_w;

	open C02;
	loop
	fetch C02 into
		nr_contrato_w,
		cd_cgc_w,
		cd_pessoa_fisica_w,
		dt_cadastro_w,
		dt_exclusao_w,
		nr_seq_contrato_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin					
		ie_inseri_reg_w		:= 'S';		
		nr_inscricao_estadual_w	:= '';
		
		if (coalesce(ie_tipo_contrat_fornec_w::text, '') = '') then
			/* Se nao possui tipo contratacao no SCA, busca do plano do contrato. */

			select	CASE WHEN max(ie_tipo_contratacao)='CA' THEN 4 WHEN max(ie_tipo_contratacao)='CE' THEN 3 WHEN max(ie_tipo_contratacao)='I' THEN 2  ELSE 5 END
			into STRICT	ie_tipo_natureza_w
			from	pls_contrato_plano	b,
				pls_plano		a
			where	b.nr_seq_contrato 	= nr_seq_contrato_w
			and	a.nr_sequencia 		= b.nr_seq_plano;
		end if;
		
		if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then		
			select	1,
				substr(ds_razao_social,1,40),
				substr(nm_fantasia,1,18),
				somente_numero(nr_inscricao_estadual),
				substr(ds_endereco,1,40),
				substr(cd_cep,1,8),
				substr(ds_complemento,1,20),
				substr(ds_bairro,1,30),
				substr(ds_municipio,1,30),
				sg_estado,
				nr_ddd_telefone,
				substr(somente_numero(nr_telefone),1,8),
				substr(somente_numero(nr_fax),1,8),
				cd_municipio_ibge || Calcula_Digito('MODULO10',substr(cd_municipio_ibge,1,10)),
				substr(nr_endereco,1,6)
			into STRICT	ie_tipo_pessoa_w,
				ds_razao_social_w,
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
				cd_municipio_ibge_w,
				nr_endereco_w
			from	pessoa_juridica
			where	cd_cgc	= cd_cgc_w;
			cd_cgc_cpf_w	:= cd_cgc_w;
		elsif (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
			ie_tipo_pessoa_w	:= 1;
			ds_razao_social_w	:= ds_razao_social_oper_w;
			nm_fantasia_w		:= nm_fantasia_oper_w;
			nr_inscricao_estadual_w	:= nr_inscricao_estadual_oper_w;
			ds_endereco_w		:= ds_endereco_oper_w;
			cd_cep_w		:= cd_cep_oper_w;
			ds_complemento_w	:= ds_complemento_oper_w;
			ds_bairro_w		:= ds_bairro_oper_w;
			ds_municipio_w		:= ds_municipio_oper_w;
			sg_estado_w		:= sg_estado_oper_w;
			nr_ddd_telefone_w	:= nr_ddd_telefone_oper_w;
			nr_telefone_w		:= nr_telefone_oper_w;
			nr_fax_w		:= nr_fax_oper_w;
			cd_municipio_ibge_w	:= cd_municipio_ibge_oper_w;
			nr_endereco_w		:= nr_endereco_oper_w;
			cd_pessoa_fisica_w	:= '';
			cd_cgc_cpf_w		:= cd_cgc_outorgante_w;
		end if;
		
		ds_razao_social_w	:= replace(replace(ds_razao_social_w,chr(231),'c'),chr(199),'C');
		ds_razao_social_w	:= replace(ds_razao_social_w,'/',' ');
		ds_razao_social_w	:= elimina_acentuacao(ds_razao_social_w);
		ds_razao_social_w	:= elimina_caractere_especial(ds_razao_social_w);
		
		nm_fantasia_w		:= replace(replace(nm_fantasia_w,chr(231),'c'),chr(199),'C');
		nm_fantasia_w		:= replace(nm_fantasia_w,'/',' ');
		nm_fantasia_w		:= elimina_acentuacao(nm_fantasia_w);
		nm_fantasia_w		:= elimina_caractere_especial(nm_fantasia_w);
		
		ds_municipio_w		:= replace(ds_municipio_w,'/',' ');
		ds_municipio_w		:= elimina_acentuacao(ds_municipio_w);
		ds_municipio_w		:= elimina_caractere_especial(ds_municipio_w);
		ds_municipio_w		:= replace(replace(ds_municipio_w,chr(231),'c'),chr(199),'C');
		
		ds_endereco_w		:= replace(ds_endereco_w,'/',' ');
		ds_endereco_w		:= elimina_acentuacao(ds_endereco_w);
		ds_endereco_w		:= elimina_caractere_especial(ds_endereco_w);
		ds_endereco_w		:= replace(replace(ds_endereco_w,chr(231),'c'),chr(199),'C');
		
		ds_bairro_w		:= replace(ds_bairro_w,'/',' ');
		ds_bairro_w		:= elimina_acentuacao(ds_bairro_w);
		ds_bairro_w		:= elimina_caractere_especial(ds_bairro_w);
		ds_bairro_w		:= replace(replace(ds_bairro_w,chr(231),'c'),chr(199),'C');
		
		ds_complemento_w	:= ELIMINA_CARACTERE_ESPECIAL(ds_complemento_w);
		ds_complemento_w	:= replace(replace(ds_complemento_w,chr(231),'c'),chr(199),'C');
		ds_complemento_w	:= Elimina_Acentuacao(ds_complemento_w);
		ds_complemento_w	:= replace(replace(ds_complemento_w,chr(180),''), '`', '');
		
		nr_ddd_telefone_w 	:= replace(nr_ddd_telefone_w,' ','');
		
		if (coalesce(trim(both cd_cgc_cpf_w)::text, '') = '') then
			cd_cgc_cpf_w	:= 11111111111;
		end if;
		
		select	count(*)
		into STRICT	qt_excessoes_w    
		from 	ptu_prod_lote_restricao a,
			ptu_movimentacao_produto b
		where 	a.nr_seq_lote 		= b.nr_seq_lote
		and   	b.nr_sequencia 		= nr_seq_mov_plano_p     
		and   	a.nr_seq_contrato	= nr_seq_contrato_w; 		

		if (qt_excessoes_w = 0) then
			begin
		
			select	nextval('ptu_mov_produto_empresa_seq')
			into STRICT	nr_seq_inter_empresa_w
			;
			
			begin
			insert	into	ptu_mov_produto_empresa(	nr_sequencia, 		nr_seq_mov_produto, 	ds_razao_social,
					nm_empr_abrev, 		ie_tipo_pessoa, 	cd_cgc_cpf,
					ds_endereco, 		cd_cep, 		cd_empresa_origem,
					dt_atualizacao,		nm_usuario, 		dt_atualizacao_nrec,
					nm_usuario_nrec,	cd_filial, 		nr_insc_estadual,
					ds_complemento, 	ds_bairro, 		nm_cidade,
					sg_uf, 			nr_ddd, 		nr_telefone,
					nr_fax, 		dt_inclusao, 		dt_exclusao,
					cd_municipio_ibge, 	nr_seq_contrato, 	ie_natureza_contratacao,
					nr_endereco, 		nr_contrato		)
			values (	nr_seq_inter_empresa_w, nr_seq_mov_plano_p, 	ds_razao_social_w,
					nm_fantasia_w, 		ie_tipo_pessoa_w, 	cd_cgc_cpf_w,
					ds_endereco_w, 		cd_cep_w, 		cd_empresa_destino_w,
					clock_timestamp(), 		nm_usuario_p, 		clock_timestamp(),
					nm_usuario_p, 		'', 			nr_inscricao_estadual_w,
					ds_complemento_w, 	ds_bairro_w, 		ds_municipio_w,
					sg_estado_w, 		nr_ddd_telefone_w, 	nr_telefone_w,
					nr_fax_w, 		dt_cadastro_w, 		dt_exclusao_w,
					cd_municipio_ibge_w, 	nr_seq_contrato_w, 	ie_tipo_natureza_w,
					nr_endereco_w, 		nr_contrato_w		);
			exception
			when others then
				ie_inseri_reg_w	:= 'N';
				CALL wheb_mensagem_pck.exibir_mensagem_abort(191658,'NM_EMPRESA='|| substr(obter_nome_pf_pj('',cd_cgc_cpf_w),1,255));
			end;
			
			if (ie_inseri_reg_w = 'S') then
				CALL ptu_gerar_produto_benef_a300(nr_seq_inter_empresa_w,ie_gerar_sca_nao_liberado_w,nm_usuario_p);

				if (qt_regras_exececoes_w > 0) then
					CALL ptu_gerar_regras_exece_a300(nr_seq_lote_w,nr_seq_inter_empresa_w,nr_seq_classificacao_w,cd_estabelecimento_w,nm_usuario_p);
				end if;
				
				select	count(1)
				into STRICT	qt_registros_w
				from	ptu_mov_produto_benef
				where	nr_seq_empresa	= nr_seq_inter_empresa_w;
				
				if (qt_registros_w = 0) then
					
					delete	FROM ptu_mov_produto_empresa
					where	nr_sequencia	= nr_seq_inter_empresa_w;
				end if;
			end if;
			
			if (mod(C02%rowcount,500) = 0) then
				commit;
			end if;
			end;
		end if;		
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_prod_empresa_a300_60 ( nr_seq_mov_plano_p ptu_movimentacao_produto.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
