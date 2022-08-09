-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_import_mat_v120 ( ds_linha_p text, ie_tipo_p text, nm_usuario_p text, nr_seq_mat_unimed_p INOUT w_pls_material_unimed.nr_sequencia%type, nm_material_p INOUT w_pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inserir os materiais na W_PLS_MATERIAL_UNIMED
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:		FEITO POR LOTE - 10a
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

cd_material_w			bigint;
cd_material_tuss_w		bigint;
cd_unidade_medida_w		varchar(10);
cd_unidade_w			varchar(30);
ie_situacao_w			varchar(1);
nm_material_w			varchar(255);
cd_cnpj_w			varchar(14);
nm_fabricante_w			varchar(255);
nm_importador_w			varchar(255);
nr_registro_anvisa_w		varchar(15);
dt_validade_anvisa_w		timestamp;
ds_motivo_ativo_inativo_w	w_pls_material_unimed.ds_motivo_ativo_inativo%type;
vl_fabrica_w			double precision;
vl_max_consumidor_w		double precision;
dt_inicio_obrigatorio_w		timestamp;
ds_material_w			varchar(2000);
ds_especialidade_w		varchar(255);
ds_classe_w			varchar(255);
ds_apresentacao_w		varchar(2000);
vl_fator_conversao_w		integer;
ie_generico_w			varchar(1);
ds_grupo_farmacologico_w	varchar(255);
ds_classe_farmacologico_w	varchar(255);
ds_forma_farmaceutico_w		varchar(255);
pr_icms_w			double precision;
vl_pmc_w			double precision;
ds_principio_ativo_w		varchar(255);
ie_origem_w			smallint;
dt_exclusao_w			timestamp;
ie_possui_mat_w			bigint := 0;
ie_tipo_ww			varchar(3);			
ie_mat_med_w			varchar(1);
qt_902_w			bigint := 0;
qt_905_w			bigint := 0;
qt_total_902_w			bigint := 0;
qt_total_905_w			bigint := 0;
cd_ref_material_fab_w		varchar(60);
cd_anterior_material_w		bigint;
cd_anterior_medicamento_w	bigint;
vl_tcl_w			smallint;

tp_produto_w			pls_material_unimed.ie_produto%type;
tp_codificacao_w		pls_material_unimed.ie_codificacao%type;
dt_inicio_vigencia_w		pls_material_unimed.dt_inicio_vigencia%type;
dt_fim_vigencia_w		pls_material_unimed.dt_fim_vigencia%type;
dt_fim_implantacao_w		pls_material_unimed.dt_fim_implantacao%type;
vl_preco_unico_w		pls_material_unimed.vl_preco_unico%type;
vl_tc_w				pls_material_unimed.vl_tc%type;

cd_simpro_w			w_pls_mat_unimed_simpro.cd_simpro%type;
ds_produto_simpro_w		w_pls_mat_unimed_simpro.desc_prod_simpro%type;

cd_brasindice_w			w_pls_mat_unimed_bras.cd_brasindice%type;
ds_produto_w			w_pls_mat_unimed_bras.des_produto%type;
ds_apresentacao_bras_w		w_pls_mat_unimed_bras.des_apresentacao%type;
ds_unidade_medida_w		pls_material_unimed.ds_unidade_medida%type;
id_alc_w			w_pls_mat_unimed_trib.id_alc%type;
ie_produto_med_w		w_pls_material_unimed.ie_produto_med%type;
ie_confaz_w			w_pls_material_unimed.ie_confaz%type;

tp_tabela_tiss_w		w_pls_material_unimed.tp_tabela_tiss%type;
cd_material_tiss_w		w_pls_material_unimed.cd_material_tiss%type;
cd_material_tiss_ant_w		w_pls_material_unimed.cd_material_tiss_ant%type;


BEGIN

if (ie_tipo_p in ('902','905')) then
	cd_material_w			:= null;
	cd_unidade_medida_w		:= null;
	ie_situacao_w			:= null;
	nm_material_w			:= null;
	cd_cnpj_w			:= null;
	nm_fabricante_w			:= null;
	nm_importador_w			:= null;
	nr_registro_anvisa_w		:= null;
	dt_validade_anvisa_w		:= null;
	ds_motivo_ativo_inativo_w	:= null;
	vl_fabrica_w			:= null;
	vl_max_consumidor_w		:= null;
	dt_inicio_obrigatorio_w		:= null;
	ds_material_w			:= null;
	ds_especialidade_w		:= null;
	ds_classe_w			:= null;
	ds_apresentacao_w		:= null;
	vl_fator_conversao_w		:= null;
	ie_generico_w			:= null;
	ds_grupo_farmacologico_w	:= null;
	ds_classe_farmacologico_w	:= null;
	ds_forma_farmaceutico_w		:= null;
	pr_icms_w			:= null;
	vl_pmc_w			:= null;
	ds_principio_ativo_w		:= null;
	ie_origem_w			:= null;
	cd_ref_material_fab_w		:= null;
	cd_anterior_material_w		:= null;
	cd_anterior_medicamento_w	:= null;
	cd_material_tuss_w		:= null;
	tp_produto_w			:= null;
	tp_codificacao_w		:= null;
	dt_inicio_vigencia_w		:= null;
	dt_fim_vigencia_w		:= null;
	dt_fim_implantacao_w		:= null;
	vl_preco_unico_w		:= null;
	ds_unidade_medida_w		:= null;
	ie_produto_med_w		:= null;
	ie_confaz_w			:= null;
	vl_tc_w				:= null;
	tp_tabela_tiss_w		:= null;
	cd_material_tiss_w		:= null;
	cd_material_tiss_ant_w		:= null;
end if;

-- Header 
if (ie_tipo_p = '901') then
	--Verificar se o tipo de carga e igual a 3 - Itens Inativos
	if (substr(ds_linha_p,24,1) = 3) then
		--Se for, pegar a data de geracao para ser gravada no lugar da data de exclusao
		dt_exclusao_w	:= coalesce(to_date(trim(both substr(ds_linha_p,16,8)),'yyyy/mm/dd'),clock_timestamp());
	else
		dt_exclusao_w	:= clock_timestamp();
	end if;

-- Material 
elsif (ie_tipo_p = '902') then
	-- Tem que resetar numero da linha filha 
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MAT';
	
	cd_material_w			:= trim(both substr(ds_linha_p,433,10));
	cd_unidade_medida_w		:= trim(both substr(ds_linha_p,20,10));
	cd_cnpj_w			:= trim(both substr(ds_linha_p,30,14));
	nm_fabricante_w			:= trim(both substr(ds_linha_p,44,50));
	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_linha_p, 174, 40));
	vl_fabrica_w			:= somente_numero(trim(both substr(ds_linha_p,214,15)))/10000;
	vl_max_consumidor_w		:= somente_numero(trim(both substr(ds_linha_p, 229, 15)))/10000;
	dt_inicio_obrigatorio_w		:= to_date(trim(both substr(ds_linha_p,244,8)),'yyyy/mm/dd');
	ie_tipo_ww			:= '902';					
	ie_mat_med_w			:= 'S';
	cd_anterior_material_w		:= trim(both substr(ds_linha_p,443,10));
	
	-- 6.2
	nr_registro_anvisa_w		:= trim(both substr(ds_linha_p, 290, 15));
	cd_ref_material_fab_w		:= trim(both substr(ds_linha_p, 305, 60));
	tp_produto_w			:= trim(both substr(ds_linha_p, 365, 1));
	tp_codificacao_w		:= trim(both substr(ds_linha_p, 366, 1));
	
	begin
	dt_inicio_vigencia_w	:= to_date(trim(both substr(ds_linha_p, 367, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_inicio_vigencia_w := null;
	end;
	
	begin
	dt_fim_vigencia_w	:= to_date(trim(both substr(ds_linha_p, 375, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_fim_vigencia_w := null;
	end;
	
	begin
	dt_fim_implantacao_w	:= to_date(trim(both substr(ds_linha_p, 383, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_fim_implantacao_w := null;
	end;
	
	begin
	vl_preco_unico_w	:= somente_numero(trim(both substr(ds_linha_p, 391, 15)))/ 10000;
	exception
	when others then
		vl_preco_unico_w := 0;
	end;
	
	-- 7.0
	ds_unidade_medida_w	:= trim(both substr(ds_linha_p, 406, 3));
	vl_tc_w			:= trim(both substr(ds_linha_p, 409, 2));
	
	tp_tabela_tiss_w	:= trim(both substr(ds_linha_p, 411, 2));
	cd_material_tiss_w	:= trim(both substr(ds_linha_p, 413, 10));
	cd_material_tiss_ant_w	:= trim(both substr(ds_linha_p, 423, 10));
	
	-- No PTU 6.2 o TP_SITUACAO nao e mais informado, desta forma o mais correto e verificarmos se existe uma data fim vigencia e se ela e menor que a data de importacao do material
	-- OS 888249
	if (coalesce(dt_fim_vigencia_w::text, '') = '') or (dt_fim_vigencia_w > to_date(clock_timestamp(),'yyyy/mm/dd hh24:mi:ss')) then
		ie_situacao_w := 'A';
	else
		ie_situacao_w := 'I';
	end if;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	w_pls_material_unimed
	where	cd_material	= cd_material_w;

	-- Verificar se o tipo de carga e igual a 2 - Atualizacoes ultima edicao, se esta sem data de exclusao e se esta inativo
	if (substr(ds_linha_p,24,1) = '2') and (ie_situacao_w = 'I') then
		update 	w_pls_material_unimed
		set	dt_exclusao	= dt_exclusao_w
		where	cd_material	= cd_material_w;
		
	elsif (ie_situacao_w = 'A') then
		update 	w_pls_material_unimed
		set	dt_exclusao	 = NULL
		where	cd_material	= cd_material_w;		
	end if;	
	
	qt_902_w := qt_902_w + 1;

-- Material - SIMPRO
elsif (ie_tipo_p = '903') then
	ie_tipo_ww		:= '903';
	ie_mat_med_w		:= 'S';
	cd_simpro_w		:= trim(both substr(ds_linha_p, 12, 10));
	ds_produto_simpro_w	:= trim(both substr(ds_linha_p, 22, 100));

-- Medicamento
elsif (ie_tipo_p = '905') then
	-- Tem que resetar o numero da linha filha
	qt_linha_filha_p	:= 1;
	ie_tipo_pai_p		:= 'MED';
	ie_tipo_ww		:= '905';
	ie_mat_med_w		:= 'S';
	
	cd_material_w			:= trim(both substr(ds_linha_p,211,10));
	cd_unidade_medida_w		:= trim(both substr(ds_linha_p,20,10));
	cd_cnpj_w			:= trim(both substr(ds_linha_p,58,14));
	ds_motivo_ativo_inativo_w	:= trim(both substr(ds_linha_p,73,40));	
	ie_generico_w			:= trim(both substr(ds_linha_p,119,1));
	cd_anterior_medicamento_w	:= trim(both substr(ds_linha_p,221,10));
	
	-- 6.2
	nr_registro_anvisa_w		:= trim(both substr(ds_linha_p, 144, 15));
	tp_codificacao_w		:= trim(both substr(ds_linha_p, 159, 1));
	
	begin
	vl_fator_conversao_w		:= somente_numero(trim(both substr(ds_linha_p, 136, 8)))/100;
	exception
	when others then
		vl_fator_conversao_w := 0;
	end;
	
	begin
	dt_inicio_vigencia_w		:= to_date(trim(both substr(ds_linha_p, 160, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_inicio_vigencia_w := null;
	end;
	
	begin
	dt_fim_vigencia_w		:= to_date(trim(both substr(ds_linha_p, 168, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_fim_vigencia_w := null;
	end;
	
	begin
	dt_fim_implantacao_w		:= to_date(trim(both substr(ds_linha_p, 176, 8)),'yyyy/mm/dd');
	exception
	when others then
		dt_fim_implantacao_w := null;
	end;
	
	ie_produto_med_w	:= trim(both substr(ds_linha_p, 187, 1));
	
	-- RETIRADO NO PTU 12.0
	ie_confaz_w		:= null;
	
	
	-- 7.0
	ds_unidade_medida_w	:= trim(both substr(ds_linha_p, 184, 3));
	vl_tc_w			:= null;

	tp_tabela_tiss_w	:= trim(both substr(ds_linha_p, 189, 2));
	cd_material_tiss_w	:= trim(both substr(ds_linha_p, 191, 10));
	cd_material_tiss_ant_w	:= trim(both substr(ds_linha_p, 201, 10));
	
	-- No PTU 6.2 o TP_SITUACAO nao e mais informado, desta forma o mais correto e verificarmos se existe uma data fim vigencia e se ela e menor que a data de importacao do material
	-- OS 888249
	if (coalesce(dt_fim_vigencia_w::text, '') = '') or (dt_fim_vigencia_w > to_date(clock_timestamp(),'yyyy/mm/dd hh24:mi:ss')) then
		ie_situacao_w := 'A';
	else
		ie_situacao_w := 'I';
	end if;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_unimed_p
	from	w_pls_material_unimed
	where	cd_material	= cd_material_w;
	
	-- Verificar se o tipo de carga e igual a 2 - Atualizacoes ultima edicao, se esta sem data de exclusao e se esta inativo
	if (ie_situacao_w = 'I') then
		update	w_pls_material_unimed
		set	dt_exclusao	= dt_exclusao_w
		where	cd_material	= cd_material_w;

	elsif (ie_situacao_w = 'A') then
		update	w_pls_material_unimed
		set	dt_exclusao	 = NULL
		where	cd_material	= cd_material_w;		
	end if;	
	
	qt_905_w := qt_905_w + 1;
	
-- Medicamento - Percentual
elsif (ie_tipo_p = '906') then
	-- Retirado no PTU 12.0
	pr_icms_w		:= 0;
	
	vl_pmc_w		:= somente_numero(trim(both substr(ds_linha_p,17,15)))/10000;
	ie_tipo_ww		:= '906';
	ie_mat_med_w		:= 'S';
	vl_tcl_w		:= somente_numero(trim(both substr(ds_linha_p,32,2)));
	
	-- Retirado no PTU 12.0
	id_alc_w		:= 'N';

-- Medicamento - BRASINDICE
elsif (ie_tipo_p = '907') then
	ie_tipo_ww		:= '907';
	ie_mat_med_w		:= 'S';
	cd_brasindice_w		:= trim(both substr(ds_linha_p, 12, 12));
	ds_produto_w		:= trim(both substr(ds_linha_p, 264, 100));
	ds_apresentacao_w	:= trim(both substr(ds_linha_p, 64, 200));
	
-- Trailer
elsif (ie_tipo_p = '909') then
	qt_total_902_w		:= qt_902_w;
	qt_total_905_w 		:= qt_905_w;
else
	-- Linhas filhas 
	if (ie_tipo_pai_p = 'MAT') then
		-- Nome comercial 
		if (qt_linha_filha_p = 1) then
			update	w_pls_material_unimed
			set	nm_material		= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
			
			nm_material_p 	:= trim(both substr(ds_linha_p,1,255));
			
			CALL gravar_processo_longo(nm_material_p ,'PLS_GERAR_IMPORT_MATERIAL_A900',-1);				
		-- Descricao do produto
		elsif (qt_linha_filha_p = 2) then
			nm_material_w := trim(both substr(ds_linha_p,1,255));
		
			update	w_pls_material_unimed
			set	ds_material		= coalesce(nm_material_w,nm_material_p)
			where	nr_sequencia		= nr_seq_mat_unimed_p;
			
			if (coalesce(nm_material_p::text, '') = '') then				
				update	w_pls_material_unimed
				set	nm_material	= nm_material_w
				where	nr_sequencia	= nr_seq_mat_unimed_p;
			end if;
		-- Especialidade do produto
		elsif (qt_linha_filha_p = 3) then
			update	w_pls_material_unimed
			set	ds_especialidade	= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- CLassificacao do produto 
		elsif (qt_linha_filha_p = 4) then
			update	w_pls_material_unimed
			set	ds_classe		= trim(both substr(ds_linha_p,1,255)),
				ds_classe_farmacologico	 = NULL
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Nome tecnico do produto 
		elsif (qt_linha_filha_p = 5) then
			update	w_pls_material_unimed
			set	nm_tecnico		= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Observacoes
		elsif (qt_linha_filha_p = 6) then
			update	w_pls_material_unimed
			set	ds_observacao		= trim(both substr(ds_linha_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Equivalencia Tecnica
		elsif (qt_linha_filha_p = 7) then
			update	w_pls_material_unimed
			set	ds_equiv_tecnica	= trim(both substr(ds_linha_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		end if;
	elsif (ie_tipo_pai_p = 'MED') then	
		-- Descricao do principio ativo
		if (qt_linha_filha_p = 1) then
			update	w_pls_material_unimed
			set	ds_principio_ativo	= trim(both substr(ds_linha_p, 1, 255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
	
		-- Nome e apresentacao comercial do produto
		elsif (qt_linha_filha_p = 2) then
			nm_material_w := trim(both substr(ds_linha_p,1,255));
		
			update	w_pls_material_unimed
			set	nm_material		= coalesce(nm_material_w,nm_material_p)
			where	nr_sequencia		= nr_seq_mat_unimed_p;
			
			nm_material_p := nm_material_w;
			
			CALL gravar_processo_longo(nm_material_p ,'PLS_GERAR_IMPORT_MATERIAL_A900',-1);
		-- Descricao do grupo 
		elsif (qt_linha_filha_p = 3) then
			update	w_pls_material_unimed
			set	ds_grupo_farmacologico	= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Descricao da classe
		elsif (qt_linha_filha_p = 4) then
			update	w_pls_material_unimed
			set	ds_classe_farmacologico	= trim(both substr(ds_linha_p,1,255)),
				ds_classe		 = NULL
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Descricao da forma 
		elsif (qt_linha_filha_p = 5) then
			update	w_pls_material_unimed
			set	ds_forma_farmaceutico	= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		-- Nome do fabricante do produto 
		elsif (qt_linha_filha_p = 6) then
			update	w_pls_material_unimed
			set	nm_fabricante		= trim(both substr(ds_linha_p,1,255))
			where	nr_sequencia		= nr_seq_mat_unimed_p;
		end if;
	end if;
	qt_linha_filha_p := qt_linha_filha_p + 1;
end if;

-- PTU 5.0
if	(((ie_tipo_p = '902') and ((substr(ds_linha_p,282,8) IS NOT NULL AND (substr(ds_linha_p,282,8))::text <> ''))) or
	((ie_tipo_p = '905') and ((substr(ds_linha_p,128,8) IS NOT NULL AND (substr(ds_linha_p,128,8))::text <> '')))) then
	cd_material_tuss_w := cd_material_w;
end if;
	
-- Conversao da unid do PTU para unid do sistema 
if (cd_unidade_medida_w IS NOT NULL AND cd_unidade_medida_w::text <> '') then
	select	max(cd_unidade_medida)
	into STRICT	cd_unidade_w
	from	unidade_medida
	where	cd_unidade_ptu	= cd_unidade_medida_w
	and	ie_situacao	= 'A';
	
	if (cd_unidade_w IS NOT NULL AND cd_unidade_w::text <> '') then
		cd_unidade_medida_w := substr(cd_unidade_w,1,10);
	end if;
end if;
/* Fim conversao de unidades */

--Verifica se o material ja esta cadastrado
select	count(1)
into STRICT	ie_possui_mat_w
from	w_pls_material_unimed
where	cd_material	= cd_material_w  LIMIT 1;
	
if (ie_possui_mat_w = 0) and (ie_mat_med_w	= 'S') then
	if (ie_tipo_p in ('902','905')) then
		
		-- Inserir na tabela W_PLS_MATERIAL_UNIMED 
		insert into w_pls_material_unimed(nr_sequencia,				cd_material,			cd_unidade_medida,
			ie_tipo,				ie_situacao,			dt_atualizacao,
			nm_usuario,				nm_material,			cd_cnpj,
			nm_fabricante,				nm_importador,			nr_registro_anvisa,
			dt_validade_anvisa,			ds_motivo_ativo_inativo,	vl_fabrica,
			vl_max_consumidor,			dt_inicio_obrigatorio,		ds_material,
			ds_especialidade,			ds_classe,			ds_apresentacao,
			vl_fator_conversao,			ie_generico,			ds_grupo_farmacologico,
			ds_classe_farmacologico,		ds_forma_farmaceutico,		pr_icms,
			vl_pmc,					ds_principio_ativo,		ie_origem,
			cd_ref_material_fab,			cd_anterior_material,		cd_anterior_medicamento,
			cd_material_tuss,			tp_produto,			tp_codificacao,
			dt_inicio_vigencia,			dt_fim_vigencia,		dt_fim_implantacao,
			preco_unico,				ds_unidade_medida,		ie_produto_med,
			ie_confaz,				vl_tc,				tp_tabela_tiss,
			cd_material_tiss,			cd_material_tiss_ant)
		values (nextval('w_pls_material_unimed_seq'),	cd_material_w,			coalesce(cd_unidade_medida_w,'UND'),
			ie_tipo_ww,				ie_situacao_w,			clock_timestamp(),
			nm_usuario_p,				nm_material_w,			cd_cnpj_w,
			nm_fabricante_w,			nm_importador_w,		nr_registro_anvisa_w,
			dt_validade_anvisa_w,			ds_motivo_ativo_inativo_w,	vl_fabrica_w,
			vl_max_consumidor_w,			dt_inicio_obrigatorio_w,	ds_material_w,
			ds_especialidade_w,			ds_classe_w,			ds_apresentacao_w,
			vl_fator_conversao_w,			ie_generico_w,			ds_grupo_farmacologico_w,
			ds_classe_farmacologico_w,		ds_forma_farmaceutico_w,	pr_icms_w,
			vl_pmc_w,				ds_principio_ativo_w,		ie_origem_w,
			cd_ref_material_fab_w,			cd_anterior_material_w,		cd_anterior_medicamento_w,
			cd_material_tuss_w,			tp_produto_w,			tp_codificacao_w,
			dt_inicio_vigencia_w,			dt_fim_vigencia_w,		dt_fim_implantacao_w,
			vl_preco_unico_w,			ds_unidade_medida_w,		ie_produto_med_w,
			ie_confaz_w,				vl_tc_w,			tp_tabela_tiss_w,
			cd_material_tiss_w,			cd_material_tiss_ant_w)
		returning nr_sequencia into nr_seq_mat_unimed_p;
		
	end if;
	
	-- MATERIAL SIMPRO
	if (ie_tipo_p = '903') then
		insert into w_pls_mat_unimed_simpro(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			cd_simpro,				desc_prod_simpro)
		values (nextval('w_pls_mat_unimed_simpro_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			cd_simpro_w,				ds_produto_simpro_w);
	end if;
	
	-- MEDICAMENTO ICMS
	if (ie_tipo_p = '906') then		
		insert into w_pls_mat_unimed_trib(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			vl_perc_icm,				vl_pmc,				vl_tcl,
			id_alc)
		values (	nextval('w_pls_mat_unimed_trib_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			pr_icms_w,				vl_pmc_w,			vl_tcl_w,
			id_alc_w);
	end if;
	
	-- MEDICAMENTO BRASINDICE
	if (ie_tipo_p = '907') then
		insert into w_pls_mat_unimed_bras(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			cd_brasindice,				des_produto,			des_apresentacao)
		values (nextval('w_pls_mat_unimed_bras_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			cd_brasindice_w,			ds_produto_w,			ds_apresentacao_bras_w);
	end if;

	ie_mat_med_w	:= 'N';
	
elsif (ie_possui_mat_w > 0) and (ie_mat_med_w	= 'S') then
	if (ie_tipo_p in ('902','905')) then
		-- Update na tabela dos materiais A900, atualizando os dados do material que ja esta cadastrado
		select	max(nr_sequencia)
		into STRICT	nr_seq_mat_unimed_p
		from	w_pls_material_unimed
		where	cd_material	= cd_material_w;
		
		update	w_pls_material_unimed
		set	nm_usuario		= nm_usuario_p,		
			dt_atualizacao		= clock_timestamp(),
			cd_cnpj			= cd_cnpj_w,
			cd_material		= cd_material_w,
			cd_unidade_medida	= coalesce(cd_unidade_medida_w,'UND'),
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
			dt_exclusao		= dt_exclusao_w,
			cd_ref_material_fab	= cd_ref_material_fab_w,
			cd_anterior_material	= coalesce(cd_anterior_material_w,cd_anterior_material),
			cd_anterior_medicamento = coalesce(cd_anterior_medicamento_w,cd_anterior_medicamento),
			cd_material_tuss	= cd_material_tuss_w,
			tp_produto		= tp_produto_w,
			tp_codificacao		= tp_codificacao_w,
			dt_inicio_vigencia	= dt_inicio_vigencia_w,
			dt_fim_vigencia		= dt_fim_vigencia_w,
			dt_fim_implantacao	= dt_fim_implantacao_w,
			preco_unico		= vl_preco_unico_w,
			ds_unidade_medida	= ds_unidade_medida_w,
			ie_produto_med		= ie_produto_med_w,
			ie_confaz		= ie_confaz,
			tp_tabela_tiss 		= tp_tabela_tiss_w,
			cd_material_tiss 	= cd_material_tiss_w,
			cd_material_tiss_ant 	= cd_material_tiss_ant_w
		where	cd_material		= cd_material_w;
	end if;
	
	-- MATERIAL SIMPRO
	if (ie_tipo_p = '903') and (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then
		insert into w_pls_mat_unimed_simpro(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			cd_simpro,				desc_prod_simpro)
		values (nextval('w_pls_mat_unimed_simpro_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			cd_simpro_w,				ds_produto_simpro_w);
	end if;
	
	-- MEDICAMENTO ICMS
	if (ie_tipo_p = '906') and (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then			
		insert into w_pls_mat_unimed_trib(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			vl_perc_icm,				vl_pmc,				vl_tcl,
			id_alc)
		values (	nextval('w_pls_mat_unimed_trib_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			pr_icms_w,				vl_pmc_w,			vl_tcl_w,
			id_alc_w);
	end if;
	
	-- MEDICAMENTO BRASINDICE
	if (ie_tipo_p = '907') and (nr_seq_mat_unimed_p IS NOT NULL AND nr_seq_mat_unimed_p::text <> '') then
		insert into w_pls_mat_unimed_bras(nr_sequencia,				dt_atualizacao,			nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,		nr_seq_mat_unimed,
			cd_brasindice,				des_produto,			des_apresentacao)
		values (nextval('w_pls_mat_unimed_bras_seq'),	clock_timestamp(),			nm_usuario_p,
			clock_timestamp(),				nm_usuario_p,			nr_seq_mat_unimed_p,
			cd_brasindice_w,			ds_produto_w,			ds_apresentacao_bras_w);
	end if;
	
	commit;
	
	ie_mat_med_w	:= 'N';
end if;

exception
when others then
	ds_erro_p := 'Erro ao executar a pls_gerar_import_mat_v120. Erro: ' || sqlerrm;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_import_mat_v120 ( ds_linha_p text, ie_tipo_p text, nm_usuario_p text, nr_seq_mat_unimed_p INOUT w_pls_material_unimed.nr_sequencia%type, nm_material_p INOUT w_pls_material_unimed.nm_material%type, ie_tipo_pai_p INOUT text, qt_linha_filha_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
