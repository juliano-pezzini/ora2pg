-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_importar_mat_unimed_v50 ( ds_conteudo_pai_p text, ie_tipo_p text, dt_vigencia_p timestamp, ds_versao_tiss_p text, nm_usuario_p text, cd_material_p INOUT pls_material_unimed.cd_material%type, nr_seq_mat_unimed_p INOUT pls_material_unimed.nr_sequencia%type, nm_material_p INOUT pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_material_w			varchar(2000);
ds_motivo_ativo_inativo_w	varchar(255);
nm_fabricante_w			varchar(255);
nm_importador_w			varchar(255);
nm_material_w			varchar(255);
ds_classe_w			varchar(255);
cd_unidade_w			varchar(30)	:= null;
nr_registro_anvisa_w		varchar(20);
cd_cnpj_w			varchar(14);
cd_unidade_medida_w		varchar(10);
ie_tipo_ww			varchar(3);
ie_situacao_w			varchar(1);
ie_generico_w			varchar(1);
ie_mat_med_w			varchar(1)	:= 'N';
vl_fabrica_w			double precision;
vl_max_consumidor_w		double precision;
vl_pmc_w			double precision;
qt_902_w			bigint	:= 0;
qt_905_w			bigint	:= 0;
qt_total_902_w			bigint	:= 0;
qt_total_905_w			bigint	:= 0;
nr_seq_linhas_w			bigint	:= 0;
nr_seq_temp_pai_w		bigint;
pr_icms_w			double precision;
ie_possui_mat_w			integer;
vl_fator_conversao_w		integer;
ie_possui_dt_excl_w		integer;
ie_origem_w			smallint;
dt_inicio_obrigatorio_w		timestamp;
dt_validade_anvisa_w		timestamp;
dt_exclusao_w			timestamp;
cd_ref_material_fab_w		varchar(30);
cd_anterior_material_w		integer;
cd_anterior_medicamento_w	integer;
vl_tcl_w			smallint;
cd_material_tuss_w		bigint;


BEGIN
--Varre a tabela temporária, em busca dos registros 'PAI'
select	count(1)
into STRICT	ie_possui_mat_w
from	pls_material
where	cd_material	= cd_material_p  LIMIT 1;

select	count(1)
into STRICT	ie_possui_dt_excl_w
from	pls_material
where	cd_material	= cd_material_p  LIMIT 1;

-- Header
if (ie_tipo_p = '901') then
	--Verificar se o tipo de carga é igual a 3 - Itens Inativos
	if (substr(ds_conteudo_pai_p, 24, 1) = 3) then
		--Se for, pegar a data de geração para ser gravada no lugar da data de exclusão
		dt_exclusao_w	:= coalesce(to_date(trim(both substr(ds_conteudo_pai_p, 16, 8)),'yyyy/mm/dd'), clock_timestamp());
	else
		dt_exclusao_w	:= clock_timestamp();
	end if;
-- Material
elsif (ie_tipo_p = '902') then
	-- Tem que resetar numero da linha filha
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MAT';

	cd_material_p			:= trim(both substr(ds_conteudo_pai_p, 12, 8));
	cd_unidade_medida_w		:= trim(both substr(ds_conteudo_pai_p, 20, 10));
	cd_cnpj_w			:= trim(both substr(ds_conteudo_pai_p, 30, 14));
	nm_fabricante_w			:= trim(both substr(ds_conteudo_pai_p, 44, 50));
	nm_importador_w			:= trim(both substr(ds_conteudo_pai_p, 94, 50));
	ie_origem_w			:= trim(both substr(ds_conteudo_pai_p, 144, 1));
	nr_registro_anvisa_w		:= trim(both substr(ds_conteudo_pai_p, 145, 20));
	cd_ref_material_fab_w		:= trim(both substr(ds_conteudo_pai_p, 252, 30));
	cd_anterior_material_w		:= trim(both substr(ds_conteudo_pai_p, 282, 8));

	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	pls_material_unimed
	where	cd_material	= cd_material_p;

	select	CASE WHEN substr(ds_conteudo_pai_p, 173, 1)='1' THEN 'A'  ELSE 'I' END
	into STRICT	ie_situacao_w
	;

	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_conteudo_pai_p, 174, 40));
	dt_validade_anvisa_w		:= to_date(trim(both substr(ds_conteudo_pai_p, 165, 8)),'yyyy/mm/dd');
	vl_fabrica_w			:= somente_numero(trim(both substr(ds_conteudo_pai_p, 214, 15)))/ 10000;
	vl_max_consumidor_w		:= somente_numero(trim(both substr(ds_conteudo_pai_p, 229, 13)))/ 100;
	dt_inicio_obrigatorio_w		:= to_date(trim(both substr(ds_conteudo_pai_p, 244, 8)),'yyyy/mm/dd');
	ie_tipo_ww			:= '902';
	ie_mat_med_w			:= 'S';

	-- Verificar se o tipo de carga é igual a 2 - Atualizações última edição, se está sem data de exclusão e se está inativo
	if (substr(ds_conteudo_pai_p,24,1) = '2') and (ie_possui_dt_excl_w = 0) and (ie_situacao_w = 'I') then
		dt_exclusao_w	:= dt_exclusao_w;

		--Verificar se o material existe na tabela PLS_MATERIAL
		if (ie_possui_mat_w > 0) then
			update 	pls_material
			set	dt_exclusao	= dt_exclusao_w
			where	cd_material	= cd_material_p;
		end if;
	elsif (ie_possui_dt_excl_w > 0) and (ie_possui_mat_w > 0) and (ie_situacao_w = 'A') then
		update 	pls_material
		set	dt_exclusao	 = NULL
		where	cd_material	= cd_material_p;
	end if;

	qt_902_w	:= qt_902_w + 1;
-- Medicamento
elsif (ie_tipo_p = '905') then
	-- Tem que resetar o numero da linha filha
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MED';

	nm_importador_w			:= null;
	nm_fabricante_w			:= null;
	cd_material_p			:= trim(both substr(ds_conteudo_pai_p, 12, 8));
	cd_unidade_medida_w		:= trim(both substr(ds_conteudo_pai_p, 20, 10));
	nr_registro_anvisa_w		:= trim(both substr(ds_conteudo_pai_p, 30, 20));
	cd_cnpj_w			:= trim(both substr(ds_conteudo_pai_p, 58, 14));
	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_conteudo_pai_p, 73, 40));
	vl_fator_conversao_w		:= trim(both substr(ds_conteudo_pai_p, 114, 5));
	ie_generico_w			:= trim(both substr(ds_conteudo_pai_p, 119, 1));
	dt_inicio_obrigatorio_w		:= to_date(trim(both substr(ds_conteudo_pai_p, 120, 8)),'yyyy/mm/dd');
	dt_validade_anvisa_w		:= to_date(trim(both substr(ds_conteudo_pai_p, 50, 8)),'yyyy/mm/dd');
	ie_origem_w			:= trim(both substr(ds_conteudo_pai_p, 113, 1));
	ie_tipo_ww			:= '905';
	cd_anterior_medicamento_w	:= trim(both substr(ds_conteudo_pai_p, 128, 8));

	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	pls_material_unimed
	where	cd_material	= cd_material_p;

	select	CASE WHEN substr(ds_conteudo_pai_p, 72, 1)='1' THEN  'A'  ELSE 'I' END
	into STRICT	ie_situacao_w
	;

	ie_mat_med_w	:= 'S';

	-- Verificar se o tipo de carga é igual a 2 - Atualizações última edição, se está sem data de exclusão e se está inativo
	if (ie_possui_dt_excl_w = 0) and (ie_situacao_w = 'I') then
		dt_exclusao_w	:= dt_exclusao_w;

		--Verificar se o material existe na tabela PLS_MATERIAL
		if (ie_possui_mat_w > 0) then
			update	pls_material
			set	dt_exclusao	= dt_exclusao_w
			where	cd_material	= cd_material_p;
		end if;
	elsif (ie_possui_dt_excl_w > 0) and (ie_possui_mat_w > 0) and (ie_situacao_w = 'A') then
		update	pls_material
		set	dt_exclusao	 = NULL
		where	cd_material	= cd_material_p;
	end if;

	qt_905_w	:= qt_905_w + 1;
-- Percentual
elsif (ie_tipo_p = '906') then
	pr_icms_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 12, 5)))/ 100;
	vl_pmc_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 17, 15)))/ 10000;
	ie_tipo_ww	:= '906';
	ie_mat_med_w	:= 'S';
	vl_tcl_w	:= somente_numero(trim(both substr(ds_conteudo_pai_p, 32, 2)));

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
			nm_material_w := trim(both substr(ds_conteudo_pai_p, 1, 255));

			update	pls_material_unimed
			set	ds_material	= coalesce(nm_material_w, nm_material_p)
			where	nr_sequencia	= nr_seq_mat_unimed_p;

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
			set	ds_classe		= trim(both substr(ds_conteudo_pai_p, 1, 255)),
				ds_classe_farmacologico	 = NULL
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Apresentacao do produto
		elsif (qt_linha_filha_p = 5) then
			update	pls_material_unimed
			set	ds_apresentacao	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia	= nr_seq_mat_unimed_p;
		end if;
	elsif (ie_tipo_pai_p = 'MED') then
		-- Descrição do principio ativo
		if (qt_linha_filha_p = 1) then
			update	pls_material_unimed
			set	ds_principio_ativo	= trim(both substr(ds_conteudo_pai_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;

			nm_material_p	:= trim(both substr(ds_conteudo_pai_p, 1, 255));

			CALL gravar_processo_longo(nm_material_p, 'PLS_IMPORTAR_MAT_UNIMED_A900', 0);
		-- Nome e apresentação comercial do produto
		elsif (qt_linha_filha_p = 2) then
			nm_material_w	:= trim(both substr(ds_conteudo_pai_p, 1, 255));

			update	pls_material_unimed
			set	nm_material	= coalesce(nm_material_w, nm_material_p)
			where	nr_sequencia	= nr_seq_mat_unimed_p;

			if (coalesce(nm_material_p::text, '') = '') then
				update	pls_material_unimed
				set	ds_principio_ativo	= coalesce(nm_material_w, nm_material_p)
				where	nr_sequencia		= nr_seq_mat_unimed_p;
			end if;
		-- Descrição do grupo
		elsif (qt_linha_filha_p = 3) then
			update	pls_material_unimed
			set	ds_grupo_farmacologico	= trim(both substr(ds_conteudo_pai_p, 1, 255))
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

	qt_linha_filha_p	:= qt_linha_filha_p + 1;
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
where	cd_unidade_ptu	= cd_unidade_medida_w;

if (cd_unidade_w IS NOT NULL AND cd_unidade_w::text <> '') then
	cd_unidade_medida_w	:= substr(cd_unidade_w, 1, 10);
end if;
-- Fim conversão de unidades
if (ds_versao_tiss_p IS NOT NULL AND ds_versao_tiss_p::text <> '') then
	--Verifica se o material já está cadastrado
	select	count(1)
	into STRICT	ie_possui_mat_w
	from	pls_material_unimed
	where	cd_material	= cd_material_p
	and (ds_versao_tiss	= ds_versao_tiss_p or coalesce(ds_versao_tiss::text, '') = '')  LIMIT 1;
else
	--Verifica se o material já está cadastrado
	select	count(1)
	into STRICT	ie_possui_mat_w
	from	pls_material_unimed
	where	cd_material	= cd_material_p  LIMIT 1;
end if;

if (ie_possui_mat_w = 0) and (ie_mat_med_w = 'S') then
	if (ie_tipo_p in ('902','905')) then
		--Insert na tabela dos materiais A900, sendo que cada registro possue o Pai e os registros Filho integrados
		select	nextval('pls_material_unimed_seq')
		into STRICT	nr_seq_mat_unimed_p
		;

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
			ds_versao_tiss)
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
			ds_versao_tiss_p);
	end if;

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
		values (	nextval('pls_mat_unimed_trib_seq'),
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

	ie_mat_med_w	:= 'N';
elsif (ie_possui_mat_w > 0) and (ie_mat_med_w	= 'S') then

	if (ie_tipo_p in ('902','905')) then
		--Update na tabela dos materiais A900, atualizando os dados do material que já está cadastrado
		cd_unidade_medida_w	:= coalesce(cd_unidade_medida_w, 'UND');

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
			cd_anterior_medicamento = cd_anterior_medicamento_w,
			cd_material_tuss	= cd_material_tuss_w,
			ds_versao_tiss		= ds_versao_tiss_p
		where	cd_material		= cd_material_p;
	end if;


	if (ie_tipo_p = '906') then
		select	max(x.nr_sequencia)
		into STRICT	nr_seq_mat_unimed_p
		FROM pls_material_unimed x
LEFT OUTER JOIN pls_mat_unimed_trib c ON (x.nr_sequencia = c.nr_seq_mat_unimed)
WHERE x.cd_material	= cd_material_p and (coalesce(c.vl_pmc,0)	<> vl_pmc_w
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

	ie_mat_med_w	:= 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_importar_mat_unimed_v50 ( ds_conteudo_pai_p text, ie_tipo_p text, dt_vigencia_p timestamp, ds_versao_tiss_p text, nm_usuario_p text, cd_material_p INOUT pls_material_unimed.cd_material%type, nr_seq_mat_unimed_p INOUT pls_material_unimed.nr_sequencia%type, nm_material_p INOUT pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint) FROM PUBLIC;
