-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_importar_mat_unimed_v63 ( ds_conteudo_pai_p text, ie_tipo_p text, dt_vigencia_p timestamp, ds_versao_tiss_p text, nm_usuario_p text, cd_material_p INOUT pls_material_unimed.cd_material%type, nr_seq_mat_unimed_p INOUT pls_material_unimed.nr_sequencia%type, nm_material_p INOUT pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_material_w      		varchar(2000);
nm_fabricante_w      		varchar(255);
nm_importador_w      		varchar(255);
nm_material_w      		varchar(255);
ds_classe_w      		varchar(255);
cd_unidade_w      		varchar(30)  := null;
nr_registro_anvisa_w    	varchar(20);
cd_cnpj_w      			varchar(14);
cd_unidade_medida_w    		varchar(10);
ie_tipo_ww      		varchar(3);
ie_situacao_w      		varchar(1);
ie_generico_w      		varchar(1);
ie_mat_med_w      		varchar(1)  := 'N';
vl_fabrica_w     		double precision;
vl_max_consumidor_w    		double precision;
vl_pmc_w      			double precision;
qt_902_w      			bigint  := 0;
qt_905_w      			bigint  := 0;
qt_total_902_w      		bigint  := 0;
qt_total_905_w      		bigint  := 0;
nr_seq_linhas_w      		bigint  := 0;
nr_seq_temp_pai_w    		bigint;
pr_icms_w      			double precision;
ie_possui_mat_w      		integer;
vl_fator_conversao_w    	double precision;
ie_possui_dt_excl_w    		integer;
ie_origem_w      		smallint;
dt_inicio_obrigatorio_w    	timestamp;
dt_validade_anvisa_w    	timestamp;
dt_exclusao_w      		timestamp;
cd_ref_material_fab_w		varchar(60);
cd_anterior_material_w		integer;
cd_anterior_medicamento_w	integer;
vl_tcl_w			smallint;
cd_material_tuss_w		bigint;
tp_produto_w			pls_material_unimed.ie_produto%type;
tp_codificacao_w		pls_material_unimed.ie_codificacao%type;
dt_inicio_vigencia_w		pls_material_unimed.dt_inicio_vigencia%type;
dt_fim_vigencia_w		pls_material_unimed.dt_fim_vigencia%type;
dt_fim_implantacao_w		pls_material_unimed.dt_fim_implantacao%type;
vl_preco_unico_w		pls_material_unimed.vl_preco_unico%type;

cd_simpro_w			pls_material_unimed_simpro.cd_simpro%type;
ds_produto_simpro_w		pls_material_unimed_simpro.ds_produto_simpro%type;

cd_brasindice_w			pls_material_unimed_bras.cd_brasindice%type;
ds_produto_w			pls_material_unimed_bras.ds_produto%type;
ds_apresentacao_w		pls_material_unimed_bras.ds_apresentacao%type;
ds_motivo_ativo_inativo_w	pls_material_unimed.ds_motivo_ativo_inativo%type;
vl_parametro_w			funcao_parametro.vl_parametro%type;
cd_estabelecimento_w		pls_material.cd_estabelecimento%type;


BEGIN
--Varre a tabela temporária, em busca dos registros 'PAI'
select	count(1)
into STRICT  	ie_possui_mat_w
from  	pls_material
where	cd_material	= cd_material_p  LIMIT 1;

select	count(1)
into STRICT	ie_possui_dt_excl_w
from	pls_material
where	cd_material	= cd_material_p  LIMIT 1;

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_material
where	cd_material	= cd_material_p;

-- Header
if (ie_tipo_p = '901') then
	--Verificar se o tipo de carga é igual a 3 - Itens Inativos
	if (substr(ds_conteudo_pai_p, 24, 1) = 3) then
		--Se for, pegar a data de geração para ser gravada no lugar da data de exclusão
		dt_exclusao_w  := coalesce(to_date(trim(both substr(ds_conteudo_pai_p, 16, 8)),'yyyy/mm/dd'), clock_timestamp());
	else
		dt_exclusao_w  := clock_timestamp();
	end if;
-- Material
elsif (ie_tipo_p = '902') then
	-- Tem que resetar numero da linha filha
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MAT';
	ie_tipo_ww		:= '902';
	ie_mat_med_w		:= 'S';

	cd_material_p			:= trim(both substr(ds_conteudo_pai_p, 12, 8));
	cd_unidade_medida_w		:= trim(both substr(ds_conteudo_pai_p, 20, 10));
	cd_cnpj_w			:= trim(both substr(ds_conteudo_pai_p, 30, 14));
	nm_fabricante_w			:= trim(both substr(ds_conteudo_pai_p, 44, 50));
	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_conteudo_pai_p, 174, 40));
	cd_anterior_material_w		:= trim(both substr(ds_conteudo_pai_p, 282, 8));

	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	pls_material_unimed
	where	cd_material	= cd_material_p;

	vl_fabrica_w		:= somente_numero(trim(both substr(ds_conteudo_pai_p, 214, 15)))/ 10000;
	vl_max_consumidor_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 229, 13)))/ 100;

	-- 6.2
	nr_registro_anvisa_w	:= trim(both substr(ds_conteudo_pai_p, 290, 15));
	cd_ref_material_fab_w	:= trim(both substr(ds_conteudo_pai_p, 305, 60));
	tp_produto_w		:= trim(both substr(ds_conteudo_pai_p, 365, 1));
	tp_codificacao_w	:= trim(both substr(ds_conteudo_pai_p, 366, 1));
	dt_inicio_vigencia_w	:= to_date(trim(both substr(ds_conteudo_pai_p, 367, 8)),'yyyy/mm/dd');
	dt_fim_vigencia_w	:= to_date(trim(both substr(ds_conteudo_pai_p, 375, 8)),'yyyy/mm/dd');
	dt_fim_implantacao_w	:= to_date(trim(both substr(ds_conteudo_pai_p, 383, 8)),'yyyy/mm/dd');
	vl_preco_unico_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 391, 15)))/ 10000;

	-- No PTU 6.2 o TP_SITUACAO não é mais informado, desta forma o mais correto é verificarmos se existe uma data fim vigencia e se ela é menor que a data de importação do material
	-- OS 888249
	if (coalesce(dt_fim_vigencia_w::text, '') = '') or (dt_fim_vigencia_w > to_date(clock_timestamp(),'yyyy/mm/dd')) then
		ie_situacao_w := 'A';
	else
		ie_situacao_w := 'I';
	end if;

	-- Verificar se o tipo de carga é igual a 2 - Atualizações última edição, se está sem data de exclusão e se está inativo
	if (substr(ds_conteudo_pai_p,24,1) = '2') and (ie_possui_dt_excl_w = 0) and (ie_situacao_w = 'I') then
		dt_exclusao_w  := dt_exclusao_w;

		--Verificar se o material existe na tabela PLS_MATERIAL
		if (ie_possui_mat_w > 0) then
			update	pls_material
			set	dt_exclusao  = dt_exclusao_w
			where	cd_material  = cd_material_p;
		end if;

	elsif (ie_possui_dt_excl_w > 0) and (ie_possui_mat_w > 0) and (ie_situacao_w = 'A') then
		update	pls_material
		set	dt_exclusao   = NULL
		where	cd_material  = cd_material_p;
	end if;

	qt_902_w  := qt_902_w + 1;

-- Material - SIMPRO
elsif (ie_tipo_p = '903') then
	ie_tipo_ww		:= '903';
	ie_mat_med_w		:= 'S';
	cd_simpro_w		:= trim(both substr(ds_conteudo_pai_p, 12, 10));
	ds_produto_simpro_w	:= trim(both substr(ds_conteudo_pai_p, 22, 100));

-- Medicamento
elsif (ie_tipo_p = '905') then
	-- Tem que resetar o numero da linha filha
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MED';
	ie_tipo_ww		:= '905';
	ie_mat_med_w		:= 'S';

	nm_importador_w			:= null;
	nm_fabricante_w			:= null;
	cd_material_p			:= trim(both substr(ds_conteudo_pai_p, 12, 8));
	cd_unidade_medida_w		:= trim(both substr(ds_conteudo_pai_p, 20, 10));
	cd_cnpj_w			:= trim(both substr(ds_conteudo_pai_p, 58, 14));
	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_conteudo_pai_p, 73, 40));
	ie_generico_w			:= trim(both substr(ds_conteudo_pai_p, 119, 1));
	cd_anterior_medicamento_w	:= trim(both substr(ds_conteudo_pai_p, 128, 8));

	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	pls_material_unimed
	where	cd_material	= cd_material_p;

	-- 6.2
	vl_fator_conversao_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 136, 8)))/100;
	nr_registro_anvisa_w	:= trim(both substr(ds_conteudo_pai_p, 144, 15));
	tp_codificacao_w    	:= trim(both substr(ds_conteudo_pai_p, 159, 1));
	dt_inicio_vigencia_w    := to_date(trim(both substr(ds_conteudo_pai_p, 160, 8)),'yyyy/mm/dd');
	dt_fim_vigencia_w    	:= to_date(trim(both substr(ds_conteudo_pai_p, 168, 8)),'yyyy/mm/dd');
	dt_fim_implantacao_w    := to_date(trim(both substr(ds_conteudo_pai_p, 176, 8)),'yyyy/mm/dd');

	-- No PTU 6.2 o TP_SITUACAO não é mais informado, desta forma o mais correto é verificarmos se existe uma data fim vigencia e se ela é menor que a data de importação do material
	-- OS 888249
	if (coalesce(dt_fim_vigencia_w::text, '') = '') or (dt_fim_vigencia_w > to_date(clock_timestamp(),'yyyy/mm/dd')) then
		ie_situacao_w := 'A';
	else
		ie_situacao_w := 'I';
	end if;

	-- Verificar se o tipo de carga é igual a 2 - Atualizações última edição, se está sem data de exclusão e se está inativo
	if (ie_possui_dt_excl_w = 0) and (ie_situacao_w = 'I') then
		dt_exclusao_w  := dt_exclusao_w;

		--Verificar se o material existe na tabela PLS_MATERIAL
		if (ie_possui_mat_w > 0) then
			update  pls_material
			set  dt_exclusao  = dt_exclusao_w
			where  cd_material  = cd_material_p;
		end if;

	elsif (ie_possui_dt_excl_w > 0) and (ie_possui_mat_w > 0) and (ie_situacao_w = 'A') then
		update	pls_material
		set	dt_exclusao   = NULL
		where	cd_material  = cd_material_p;
	end if;

	qt_905_w  := qt_905_w + 1;

-- Medicamento - PERCENTUAL
elsif (ie_tipo_p = '906') then
	ie_tipo_ww	:= '906';
	ie_mat_med_w	:= 'S';
	pr_icms_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 12, 5)))/ 100;
	vl_pmc_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 17, 15)))/ 10000;
	vl_tcl_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 32, 2)));

-- Medicamento - BRASINDICE
elsif (ie_tipo_p = '907') then
	ie_tipo_ww		:= '907';
	ie_mat_med_w		:= 'S';
	cd_brasindice_w		:= trim(both substr(ds_conteudo_pai_p, 12, 12));
	ds_produto_w		:= trim(both substr(ds_conteudo_pai_p, 264, 100));
	ds_apresentacao_w	:= trim(both substr(ds_conteudo_pai_p, 64, 200));

-- Trailer
elsif (ie_tipo_p = '909') then
	qt_total_902_w  := qt_902_w;
	qt_total_905_w  := qt_905_w;
else
	-- Linhas filhas
	if (ie_tipo_pai_p = 'MAT') then
		-- Nome comercial
		if (qt_linha_filha_p = 1) then
			update	pls_material_unimed
			set	nm_material	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia	= nr_seq_mat_unimed_p;

			nm_material_p	:= trim(both substr(ds_conteudo_pai_p, 1, 255));

			CALL gravar_processo_longo(nm_material_p, 'PLS_IMPORTAR_MAT_UNIMED_A900', 0);

		-- Descricao do produto
		elsif (qt_linha_filha_p = 2) then
			nm_material_w	:= trim(both substr(ds_conteudo_pai_p, 1, 255));

			update	pls_material_unimed
			set	ds_material  = coalesce(nm_material_w, nm_material_p)
			where	nr_sequencia  = nr_seq_mat_unimed_p;

			if (coalesce(nm_material_p::text, '') = '') then
				update	pls_material_unimed
				set	nm_material	= coalesce(nm_material_w, nm_material_p)
				where	nr_sequencia	= nr_seq_mat_unimed_p;
			end if;

		-- Especialidade do produto
		elsif (qt_linha_filha_p = 3) then
			update	pls_material_unimed
			set	ds_especialidade	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- CLassificacao do produto
		elsif (qt_linha_filha_p = 4) then
			update	pls_material_unimed
			set	ds_classe    		= trim(both substr(ds_conteudo_pai_p, 1, 255)),
				ds_classe_farmacologico	 = NULL
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- Apresentacao do produto
		elsif (qt_linha_filha_p = 5) then
			update	pls_material_unimed
			set	ds_apresentacao	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia	= nr_seq_mat_unimed_p;

		-- Observações
		elsif (qt_linha_filha_p = 6) then
			update	pls_material_unimed
			set	ds_observacao	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia	= nr_seq_mat_unimed_p;
		end if;

	elsif (ie_tipo_pai_p = 'MED') then
		-- Descrição do princípio ativo
		if (qt_linha_filha_p = 1) then
			update	pls_material_unimed
			set	ds_principio_ativo	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- Nome e apresentação comercial do produto
		elsif (qt_linha_filha_p = 2) then
			nm_material_w  := trim(both substr(ds_conteudo_pai_p, 1, 255));

			update	pls_material_unimed
			set	nm_material	= coalesce(nm_material_w, nm_material_p)
			where	nr_sequencia	= nr_seq_mat_unimed_p;

			/* Utilizar o principio ativo que veio do arquivo - PTU 6.3
			if	(nm_material_p is null) then
				update  pls_material_unimed
				set	ds_principio_ativo	= nvl(nm_material_w, nm_material_p)
				where	nr_sequencia		= nr_seq_mat_unimed_p;
			end if;*/
			nm_material_p := nm_material_w;

			CALL gravar_processo_longo(nm_material_p, 'PLS_IMPORTAR_MAT_UNIMED_A900', 0);

		-- Descrição do grupo
		elsif (qt_linha_filha_p = 3) then
			update	pls_material_unimed
			set	ds_grupo_farmacologico  = trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- Descrição da classe
		elsif (qt_linha_filha_p = 4) then
			update	pls_material_unimed
			set	ds_classe_farmacologico	= trim(both substr(ds_conteudo_pai_p, 1, 255)),
				ds_classe		 = NULL
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- Descrição da forma
		elsif (qt_linha_filha_p = 5) then
			update	pls_material_unimed
			set	ds_forma_farmaceutico	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;

		-- Nome do fabricante do produto
		elsif (qt_linha_filha_p = 6) then
			update	pls_material_unimed
			set	nm_fabricante	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia	= nr_seq_mat_unimed_p;
		end if;
	end if;

	qt_linha_filha_p  := qt_linha_filha_p + 1;
end if;

-- PTU 5.0
if	(((ie_tipo_p = '902') and ((substr(ds_conteudo_pai_p,282,8) IS NOT NULL AND (substr(ds_conteudo_pai_p,282,8))::text <> ''))) or
	((ie_tipo_p = '905') and ((substr(ds_conteudo_pai_p,128,8) IS NOT NULL AND (substr(ds_conteudo_pai_p,128,8))::text <> '')))) then
	cd_material_tuss_w := cd_material_p;
end if;

-- Conversão da unid do PTU para unid do sistema
select	max(cd_unidade_medida)
into STRICT	cd_unidade_w
from	unidade_medida
where	cd_unidade_ptu  = cd_unidade_medida_w;

if (cd_unidade_w IS NOT NULL AND cd_unidade_w::text <> '') then
	cd_unidade_medida_w  := substr(cd_unidade_w, 1, 10);
end if;
-- Fim conversão de unidades
if (ds_versao_tiss_p IS NOT NULL AND ds_versao_tiss_p::text <> '') then
	--Verifica se o material já está cadastrado
	select	count(1)
	into STRICT	ie_possui_mat_w
	from	pls_material_unimed
	where	cd_material  	= cd_material_p
	and (ds_versao_tiss	= ds_versao_tiss_p or coalesce(ds_versao_tiss::text, '') = '')  LIMIT 1;
else
	--Verifica se o material já está cadastrado
	select  count(1)
	into STRICT	ie_possui_mat_w
	from	pls_material_unimed
	where	cd_material	= cd_material_p  LIMIT 1;
end if;

if (ie_possui_mat_w = 0) and (ie_mat_med_w = 'S') then
	-- MATERIAL , MEDICAMENTO
	if (ie_tipo_p in ('902','905')) then
		--Insert na tabela dos materiais A900, sendo que cada registro possue o Pai e os registros Filho integrados
		select	nextval('pls_material_unimed_seq')
		into STRICT	nr_seq_mat_unimed_p
		;

		--verificar se irá gravar o registor anvisa sem o zeros a esquerda
		vl_parametro_w := Obter_Param_Usuario(9900, 18, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, vl_parametro_w);

		if (coalesce(vl_parametro_w, 'N') = 'S') then
			nr_registro_anvisa_w := somente_numero(nr_registro_anvisa_w);
		end if;

		insert into pls_material_unimed(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			cd_cnpj,
			cd_material,
			cd_unidade_medida,
			ds_motivo_ativo_inativo,
			dt_inicio_obrigatorio,
			dt_validade_anvisa,
			ie_generico,
			ie_origem,
			ie_situacao,
			ie_tipo,
			nm_importador,
			nr_registro_anvisa,
			pr_icms,
			vl_fabrica,
			vl_fator_conversao,
			vl_max_consumidor,
			vl_pmc,
			cd_ref_material_fab,
			cd_anterior_material,
			cd_anterior_medicamento,
			cd_material_tuss,
			ds_versao_tiss,
			ie_produto,
			ie_codificacao,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			dt_fim_implantacao,
			vl_preco_unico,
			nm_fabricante,
			cd_estabelecimento)
		values (nr_seq_mat_unimed_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_cnpj_w,
			cd_material_p,
			coalesce(cd_unidade_medida_w, 'UND'),
			ds_motivo_ativo_inativo_w,
			dt_inicio_obrigatorio_w,
			dt_validade_anvisa_w,
			ie_generico_w,
			ie_origem_w,
			ie_situacao_w,
			ie_tipo_ww,
			nm_importador_w,
			nr_registro_anvisa_w,
			pr_icms_w,
			vl_fabrica_w,
			vl_fator_conversao_w,
			vl_max_consumidor_w,
			vl_pmc_w,
			cd_ref_material_fab_w,
			cd_anterior_material_w,
			cd_anterior_medicamento_w,
			cd_material_tuss_w,
			ds_versao_tiss_p,
			tp_produto_w,
			tp_codificacao_w,
			dt_inicio_vigencia_w,
			dt_fim_vigencia_w,
			dt_fim_implantacao_w,
			vl_preco_unico_w,
			nm_fabricante_w,
			wheb_usuario_pck.get_cd_estabelecimento);
	end if;

	-- MATERIAL SIMPRO
	if (ie_tipo_p = '903') then
		insert into pls_material_unimed_simpro(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_mat_unimed,
			cd_simpro,
			ds_produto_simpro)
		values (nextval('pls_material_unimed_simpro_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_mat_unimed_p,
			cd_simpro_w,
			ds_produto_simpro_w);
	end if;

	-- MEDICAMENTO ICMS
	if (ie_tipo_p = '906') then
		insert into pls_mat_unimed_trib(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_mat_unimed,
			vl_perc_icms,
			vl_pmc,
			vl_tcl,
			dt_inicio_vigencia)
		values ( nextval('pls_mat_unimed_trib_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_mat_unimed_p,
			pr_icms_w,
			vl_pmc_w,
			vl_tcl_w,
			dt_vigencia_p);
	end if;

	-- MEDICAMENTO BRASINDICE
	if (ie_tipo_p = '907') then
	insert into pls_material_unimed_bras(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_mat_unimed,
		cd_brasindice,
		ds_produto,
		ds_apresentacao)
	values (nextval('pls_material_unimed_bras_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_mat_unimed_p,
		cd_brasindice_w,
		ds_produto_w,
		ds_apresentacao_w);
	end if;

	ie_mat_med_w  := 'N';
elsif (ie_possui_mat_w > 0) and (ie_mat_med_w  = 'S') then

	-- MATERIAL , MEDICAMENTO
	if (ie_tipo_p in ('902','905')) then
		--Update na tabela dos materiais A900, atualizando os dados do material que já está cadastrado
		cd_unidade_medida_w  := coalesce(cd_unidade_medida_w, 'UND');

		vl_parametro_w := Obter_Param_Usuario(9900, 18, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, vl_parametro_w);

		if (coalesce(vl_parametro_w, 'N') = 'S') then
			nr_registro_anvisa_w := somente_numero(nr_registro_anvisa_w);
		end if;

		update	pls_material_unimed
		set	nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			cd_cnpj			= cd_cnpj_w,
			cd_material		= cd_material_p,
			cd_unidade_medida	= cd_unidade_medida_w,
			ds_motivo_ativo_inativo	= ds_motivo_ativo_inativo_w,
			dt_inicio_obrigatorio	= dt_inicio_obrigatorio_w,
			dt_validade_anvisa	= dt_validade_anvisa_w,
			ie_generico		= ie_generico_w,
			ie_origem		= ie_origem_w,
			ie_situacao		= ie_situacao_w,
			ie_tipo			= ie_tipo_ww,
			nm_importador		= nm_importador_w,
			nr_registro_anvisa	= nr_registro_anvisa_w,
			vl_fabrica		= vl_fabrica_w,
			vl_fator_conversao	= vl_fator_conversao_w,
			vl_max_consumidor	= vl_max_consumidor_w,
			pr_icms			= pr_icms_w,
			vl_pmc			= vl_pmc_w,
			cd_ref_material_fab	= cd_ref_material_fab_w,
			cd_anterior_material	= cd_anterior_material_w,
			cd_anterior_medicamento	= cd_anterior_medicamento_w,
			cd_material_tuss	= cd_material_tuss_w,
			ds_versao_tiss		= ds_versao_tiss_p,
			ie_produto		= tp_produto_w,
			ie_codificacao		= tp_codificacao_w,
			dt_inicio_vigencia	= dt_inicio_vigencia_w,
			dt_fim_vigencia		= dt_fim_vigencia_w,
			dt_fim_implantacao	= dt_fim_implantacao_w,
			vl_preco_unico		= vl_preco_unico_w,
			nm_fabricante		= coalesce(nm_fabricante_w,nm_fabricante) --prioriza a informação que está vindo no arquivo
		where	cd_material		= cd_material_p;
	end if;

	-- MATERIAIS - SIMPRO
	if (ie_tipo_p = '903') then
		select	max(x.nr_sequencia)
		into STRICT	nr_seq_mat_unimed_p
		FROM pls_material_unimed x
LEFT OUTER JOIN pls_material_unimed_simpro c ON (x.nr_sequencia = c.nr_seq_mat_unimed)
WHERE x.cd_material				= cd_material_p and (coalesce(trim(both c.cd_simpro),' ')		<> cd_simpro_w
		or	coalesce(trim(both c.ds_produto_simpro),' ')	<> ds_produto_simpro_w);

		if (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then
			insert into pls_material_unimed_simpro(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_mat_unimed,
				cd_simpro,
				ds_produto_simpro)
			values (nextval('pls_material_unimed_simpro_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_mat_unimed_p,
				cd_simpro_w,
				ds_produto_simpro_w);
		end if;
	end if;

	-- MEDICAMENTO ICMS
	if (ie_tipo_p = '906') then
		select	max(x.nr_sequencia)
		into STRICT	nr_seq_mat_unimed_p
		FROM pls_material_unimed x
LEFT OUTER JOIN pls_mat_unimed_trib c ON (x.nr_sequencia = c.nr_seq_mat_unimed)
WHERE x.cd_material		= cd_material_p and (coalesce(c.vl_pmc,0)	<> vl_pmc_w
		or	coalesce(c.vl_perc_icms,0)	<> pr_icms_w);

		if (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then
			insert into pls_mat_unimed_trib(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_mat_unimed,
				vl_perc_icms,
				vl_pmc,
				vl_tcl,
				dt_inicio_vigencia)
			values (nextval('pls_mat_unimed_trib_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_mat_unimed_p,
				pr_icms_w,
				vl_pmc_w,
				vl_tcl_w,
				dt_vigencia_p);
		end if;
	end if;

	-- MATERIAIS - BRASINDICE
	if (ie_tipo_p = '907') then
		select	max(x.nr_sequencia)
		into STRICT	nr_seq_mat_unimed_p
		FROM pls_material_unimed x
LEFT OUTER JOIN pls_material_unimed_bras c ON (x.nr_sequencia = c.nr_seq_mat_unimed)
WHERE x.cd_material  				= cd_material_p and (coalesce(trim(both c.cd_brasindice),' ')		<> cd_brasindice_w
		or	coalesce(trim(both c.ds_produto),' ')	 	<> ds_produto_w
		or	coalesce(trim(both c.ds_apresentacao),' ')	<> ds_apresentacao_w);

		if (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then
			insert into pls_material_unimed_bras(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_mat_unimed,
				cd_brasindice,
				ds_produto,
				ds_apresentacao)
			values (nextval('pls_material_unimed_bras_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_mat_unimed_p,
				cd_brasindice_w,
				ds_produto_w,
				ds_apresentacao_w);
		end if;
	end if;

	ie_mat_med_w  := 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_importar_mat_unimed_v63 ( ds_conteudo_pai_p text, ie_tipo_p text, dt_vigencia_p timestamp, ds_versao_tiss_p text, nm_usuario_p text, cd_material_p INOUT pls_material_unimed.cd_material%type, nr_seq_mat_unimed_p INOUT pls_material_unimed.nr_sequencia%type, nm_material_p INOUT pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint) FROM PUBLIC;

