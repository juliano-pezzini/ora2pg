-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocor_aut_mat ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_mat_p bigint, nr_seq_req_mat_p bigint, nr_seq_exec_item_p bigint, nr_seq_material_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Rotina utilizada para validar os materiais definidos na regra de ocorrencia combinada
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: Performance
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

/*
IE_TIPO_OCORRENCIA_W	= C - Gera a ocorrencia para o cabecalho
			= I - Gera ocorrencia para os itens
*/
nr_seq_ocor_aut_mat_w		pls_ocor_aut_filtro_mat.nr_sequencia%type;
qt_registros_dut_rol_w		smallint;
--nr_seq_grupo_material_w		Number(10);
ie_gerar_ocorrencia_w		varchar(2)	:= 'N';
ie_grupo_material_w		varchar(2);
ie_tipo_despesa_w		varchar(255);
nr_seq_estrut_mat_w		pls_estrutura_material.nr_sequencia%type;
ds_versao_tiss_material_w	varchar(20);
cd_versao_tiss_operadora_w	varchar(20);
qt_material_vigente_w		bigint;
ie_consiste_qtd_w		varchar(1)	:= 'N';
ie_consiste_sexo_w		varchar(1)	:= 'N';
ie_consiste_idade_w		varchar(1)	:= 'N';
qt_minima_w			bigint;
qt_maxima_w			bigint;
ie_sexo_seg_w			varchar(1);
ie_idade_seg_w			integer;
ie_sexo_exclusivo_w		varchar(2);
qt_idade_minima_w		integer;
qt_idade_maxima_w		integer;
ie_bloqueia_custo_op_w		varchar(5)	:= 'N';
ie_bloqueia_pre_pag_w		varchar(5)	:= 'N';
ie_bloqueia_intercambio_w	varchar(5)	:= 'N';
ie_bloqueia_prod_nao_reg_w	varchar(5)	:= 'N';
ie_bloqueia_prod_reg_w		varchar(5)	:= 'N';
nr_seq_restricao_w		pls_material_restricao.nr_sequencia%type;
dt_item_w			timestamp;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
qt_item_w			double precision;
nr_seq_execucao_w		pls_execucao_req_item.nr_seq_execucao%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_grupo_material,
		ie_valida_dut,
		ie_valida_vig_tiss,
		ie_valida_situacao_mat,
		ie_bloqueio_mat,
		nr_seq_estrutura
	from	pls_ocor_aut_filtro_mat
	where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
	and	ie_situacao		= 'A'
	and (coalesce(nr_seq_material::text, '') = ''	or nr_seq_material	= nr_seq_material_p)
	and (coalesce(ie_tipo_despesa::text, '') = ''	or ie_tipo_despesa	= ie_tipo_despesa_w)
	and	((coalesce(nr_seq_estrut_mat::text, '') = '') or (pls_obter_se_estruturas_mat(nr_seq_estrut_mat, nr_seq_material_p) = 'S'))
	and	((coalesce(ie_consiste_qtd, 'N') = 'N')   or (ie_consiste_qtd = ie_consiste_qtd_w))
	and	((coalesce(ie_consiste_sexo, 'N') = 'N')  or (ie_consiste_sexo = ie_consiste_sexo_w))
	and	((coalesce(ie_consiste_idade, 'N') = 'N') or (ie_consiste_idade = ie_consiste_idade_w));

BEGIN

begin
	select	ie_tipo_despesa
	into STRICT	ie_tipo_despesa_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_p;
exception
when others then
	ie_tipo_despesa_w	:= null;
end;

begin
	select	nr_seq_estrut_mat
	into STRICT	nr_seq_estrut_mat_w
	from	pls_material
	where	nr_sequencia = nr_seq_material_p;
exception
	when no_data_found then
		nr_seq_estrut_mat_w	:= null;
end;


if (nr_seq_guia_mat_p IS NOT NULL AND nr_seq_guia_mat_p::text <> '')	then		
	select	dt_atualizacao
	into STRICT	dt_item_w
	from	pls_guia_plano_mat
	where	nr_sequencia	= nr_seq_guia_mat_p;
	
	select	a.nr_seq_segurado,
		b.qt_solicitada
	into STRICT	nr_seq_segurado_w,
		qt_item_w
	from	pls_guia_plano		a,
		pls_guia_plano_mat	b
	where	b.nr_seq_guia 		= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_guia_mat_p;
	
elsif (nr_seq_req_mat_p IS NOT NULL AND nr_seq_req_mat_p::text <> '')	then	
	select	dt_atualizacao
	into STRICT	dt_item_w
	from	pls_requisicao_mat
	where	nr_sequencia	= nr_seq_req_mat_p;
	
	select	a.nr_seq_segurado,
		b.qt_solicitado
	into STRICT	nr_seq_segurado_w,
		qt_item_w
	from	pls_requisicao		a,
		pls_requisicao_mat	b
	where	b.nr_seq_requisicao	= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_req_mat_p;

elsif (nr_seq_exec_item_p IS NOT NULL AND nr_seq_exec_item_p::text <> '') then	
	select	dt_atualizacao,
		qt_item,
		nr_seq_execucao
	into STRICT	dt_item_w,
		qt_item_w,
		nr_seq_execucao_w
	from	pls_execucao_req_item
	where	nr_sequencia		= nr_seq_exec_item_p;
	
	select	nr_seq_requisicao
	into STRICT	nr_seq_requisicao_w
	from	pls_execucao_requisicao
	where	nr_sequencia	= nr_seq_execucao_w;
	
	
	select	nr_seq_segurado
	into STRICT	nr_seq_segurado_w	
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_w;	
end if;

nr_seq_restricao_w := pls_obter_mat_restricao_data(nr_seq_material_p, dt_item_w, nr_seq_restricao_w);

if (coalesce(nr_seq_restricao_w,0) > 0) then
	select	qt_minima,
		qt_maxima,
		CASE WHEN ie_bloqueia_custo_op='S' THEN 'BCO' END ,
		CASE WHEN ie_bloqueia_pre_pag='S' THEN 'BPP' END ,
		CASE WHEN ie_bloqueia_intercambio='S' THEN 'BI' END ,
		CASE WHEN ie_bloqueia_prod_nao_reg='S' THEN 'BNR' END ,
		CASE WHEN ie_bloqueia_prod_reg='S' THEN 'BR' END ,
		qt_idade_minima,
		qt_idade_maxima,
		ie_sexo_exclusivo
	into STRICT	qt_minima_w,
		qt_maxima_w,
		ie_bloqueia_custo_op_w,
		ie_bloqueia_pre_pag_w,
		ie_bloqueia_intercambio_w,
		ie_bloqueia_prod_nao_reg_w,
		ie_bloqueia_prod_reg_w,
		qt_idade_minima_w,
		qt_idade_maxima_w,
		ie_sexo_exclusivo_w
	from	pls_material_restricao
	where	nr_sequencia	= nr_seq_restricao_w;		
	
	if	((qt_item_w < qt_minima_w) or (qt_item_w > qt_maxima_w)) then
		ie_consiste_qtd_w	:= 'S';
	end if;
end if;

if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
	select	a.ie_sexo,
		obter_idade(a.dt_nascimento, clock_timestamp(), 'A')
	into STRICT	ie_sexo_seg_w,
		ie_idade_seg_w
	from	pessoa_fisica a,
		pls_segurado b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	b.nr_sequencia		= nr_seq_segurado_w;
	
	if (ie_sexo_seg_w	<> ie_sexo_exclusivo_w) then
		ie_consiste_sexo_w	:= 'S';
	end if;

	if (ie_idade_seg_w > qt_idade_maxima_w or ie_idade_seg_w < qt_idade_minima_w) then
		ie_consiste_idade_w	:= 'S';
	end if;
end if;

for	r_C01_w in C01 loop
	
	ie_grupo_material_w	:= 'S';
	
	ie_gerar_ocorrencia_w 	:= 'S';
	
	nr_seq_ocor_aut_mat_w	:=  r_C01_w.nr_sequencia;

	/* Valida estrutura de itens cadastrada em OPS - Glosas e Ocorrencias > Cadastros > Estruturas */

	if (r_C01_w.nr_seq_estrutura IS NOT NULL AND r_C01_w.nr_seq_estrutura::text <> '') then
		if (pls_obter_se_estrut_ocorrencia(r_C01_w.nr_seq_estrutura, null, null, nr_seq_material_p) = 'S') then
			ie_gerar_ocorrencia_w := 'S';
		else
			ie_gerar_ocorrencia_w := 'N';
		end if;
	end if;

	if	(r_C01_w.nr_seq_grupo_material IS NOT NULL AND r_C01_w.nr_seq_grupo_material::text <> '' AND ie_gerar_ocorrencia_w = 'S') then
		ie_grupo_material_w	:= pls_se_grupo_preco_material(r_C01_w.nr_seq_grupo_material, nr_seq_material_p);
		
			/* Valida o grupo de material */

		if ( ie_grupo_material_w	= 'S' ) then
			ie_gerar_ocorrencia_w	:= 'S';
		else
			ie_gerar_ocorrencia_w	:= 'N';
		end if;		
	
	end if;
	
	/* Valida diretriz de utilizacao conforme ROL de Procedimento */

	if 	((coalesce(r_C01_w.ie_valida_dut,'N')	= 'S') and (ie_gerar_ocorrencia_w = 'S')) then
		select	count(1)
		into STRICT	qt_registros_dut_rol_w
		from	pls_rol_grupo_mat	a,
			pls_rol_mat_med		b
		where	a.nr_sequencia		= b.nr_seq_rol_grupo
		and	b.nr_seq_material	= nr_seq_material_p
		and	ie_diretriz_utilizacao	= 'S'; --DUT
		
		if ( qt_registros_dut_rol_w	<> 0 ) then
			ie_gerar_ocorrencia_w	:= 'S';
		else
			ie_gerar_ocorrencia_w	:= 'N';
		end if;
	end if;	
	
	/* Valida vigencia TISS */

	if 	((coalesce(r_C01_w.ie_valida_vig_tiss,'N')	= 'S') and (ie_gerar_ocorrencia_w = 'S')) then
	
		begin
			select	ds_versao_tiss
			into STRICT	ds_versao_tiss_material_w
			from	pls_material
			where	nr_sequencia	= nr_seq_material_p;
		exception
		when others then
			ds_versao_tiss_material_w	:= 'X';
		end;

		select 	max(cd_versao_tiss)
		into STRICT	cd_versao_tiss_operadora_w
		from	pls_versao_tiss
		where	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia,clock_timestamp());
		
		if (ds_versao_tiss_material_w <> 'X') and (ds_versao_tiss_material_w <> cd_versao_tiss_operadora_w) then
			ie_gerar_ocorrencia_w	:= 'S';
		else
			ie_gerar_ocorrencia_w	:= 'N';
		end if;
	end if;	
	
	/* Valida situacao material */

	if 	((coalesce(r_C01_w.ie_valida_situacao_mat,'N') = 'S') and (ie_gerar_ocorrencia_w = 'S')) then
	
		select	count(1)
		into STRICT	qt_material_vigente_w
		from	pls_material
		where	nr_sequencia	= nr_seq_material_p
		and	(((dt_exclusao IS NOT NULL AND dt_exclusao::text <> '') 		and ( dt_exclusao < clock_timestamp() ))
		or	 ((dt_limite_utilizacao IS NOT NULL AND dt_limite_utilizacao::text <> '') 	and ( dt_limite_utilizacao < clock_timestamp() )));
		
		if ( qt_material_vigente_w	> 0 ) then
			ie_gerar_ocorrencia_w	:= 'S';
		else
			ie_gerar_ocorrencia_w	:= 'N';
		end if;
	end if;	

	if	(r_C01_w.ie_bloqueio_mat IS NOT NULL AND r_C01_w.ie_bloqueio_mat::text <> '' AND ie_gerar_ocorrencia_w = 'S') then		
		if (r_C01_w.ie_bloqueio_mat = ie_bloqueia_custo_op_w) then
			ie_gerar_ocorrencia_w := 'S';
		elsif (r_C01_w.ie_bloqueio_mat = ie_bloqueia_pre_pag_w) then
			ie_gerar_ocorrencia_w := 'S';
		elsif (r_C01_w.ie_bloqueio_mat = ie_bloqueia_intercambio_w) then
			ie_gerar_ocorrencia_w := 'S';
		elsif (r_C01_w.ie_bloqueio_mat = ie_bloqueia_prod_nao_reg_w) then
			ie_gerar_ocorrencia_w := 'S';
		elsif (r_C01_w.ie_bloqueio_mat = ie_bloqueia_prod_reg_w) then
			ie_gerar_ocorrencia_w := 'S';
		else
			ie_gerar_ocorrencia_w := 'N';
		end if;
	end if;
	
	if (ie_gerar_ocorrencia_w = 'S') then
		exit;
	end if;
end loop; -- C01
ie_gerar_ocorrencia_p	:= ie_gerar_ocorrencia_w;

if (ie_gerar_ocorrencia_w 	= 'S') then
	ie_tipo_ocorrencia_p	:= 'I';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ocor_aut_mat ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_mat_p bigint, nr_seq_req_mat_p bigint, nr_seq_exec_item_p bigint, nr_seq_material_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) FROM PUBLIC;

