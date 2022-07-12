-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_exec_total ( nr_seq_exec_item_lote_p bigint, nr_seq_exec_lote_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(2000)	:= '';
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
ie_origem_proced_ww		bigint;
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_requisicao_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_uni_exec_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_requisicao_w			timestamp;
nr_seq_material_w		bigint;
ie_preco_w			varchar(4);
ie_tipo_gat_w			varchar(4);
nr_seq_plano_w			bigint;
nr_seq_prestador_w		bigint;

C01 CURSOR FOR
	SELECT	ds_retorno
	from (
		SELECT  'S' ds_retorno,
			cd_area_procedimento,
			cd_especialidade,
			cd_grupo_proc,
			cd_procedimento,
			nr_seq_material,
			nr_seq_prestador,
			nr_seq_contrato,
			nr_seq_contrato_int,
			nr_seq_uni_origem,
			ie_tipo_gat,
			ie_preco
		from	pls_regra_execucao_total
		where   ie_aplicacao_regra 	= 1
		and (coalesce(cd_procedimento::text, '') = ''	or cd_procedimento	= cd_procedimento_w)
		and (coalesce(ie_origem_proced::text, '') = ''	or ie_origem_proced     = ie_origem_proced_ww)
		and (coalesce(cd_grupo_proc::text, '') = ''	or cd_grupo_proc        = cd_grupo_w)
		and (coalesce(cd_especialidade::text, '') = ''	or cd_especialidade	= cd_especialidade_w)
		and (coalesce(cd_area_procedimento::text, '') = ''	or cd_area_procedimento	= cd_area_w)
		and (coalesce(nr_seq_contrato::text, '') = ''	or nr_seq_contrato	= nr_seq_contrato_w)
		and (coalesce(nr_seq_prestador::text, '') = ''	or nr_seq_prestador	= nr_seq_prestador_w)
		and (coalesce(nr_seq_uni_origem::text, '') = ''	or nr_seq_uni_origem	= nr_seq_uni_exec_w)
		and (coalesce(nr_seq_contrato_int::text, '') = ''	or nr_seq_contrato_int	= nr_seq_intercambio_w)
		and (coalesce(nr_seq_material::text, '') = ''	or nr_seq_material	= nr_seq_material_w)
		and (coalesce(ie_preco::text, '') = ''	or ie_preco		= ie_preco_w)
		and (coalesce(ie_tipo_gat::text, '') = ''	or ie_tipo_gat		= ie_tipo_gat_w)
		and	dt_requisicao_w		between(dt_inicio_vigencia)	and (coalesce(dt_fim_vigencia, clock_timestamp()))
		and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento and (pls_obter_se_controle_estab('RE') = 'S'))
		
union all

		select  'S' ds_retorno,
			cd_area_procedimento,
			cd_especialidade,
			cd_grupo_proc,
			cd_procedimento,
			nr_seq_material,
			nr_seq_prestador,
			nr_seq_contrato,
			nr_seq_contrato_int,
			nr_seq_uni_origem,
			ie_tipo_gat,
			ie_preco
		from	pls_regra_execucao_total
		where   ie_aplicacao_regra 	= 1
		and (coalesce(cd_procedimento::text, '') = ''	or cd_procedimento	= cd_procedimento_w)
		and (coalesce(ie_origem_proced::text, '') = ''	or ie_origem_proced     = ie_origem_proced_ww)
		and (coalesce(cd_grupo_proc::text, '') = ''	or cd_grupo_proc        = cd_grupo_w)
		and (coalesce(cd_especialidade::text, '') = ''	or cd_especialidade	= cd_especialidade_w)
		and (coalesce(cd_area_procedimento::text, '') = ''	or cd_area_procedimento	= cd_area_w)
		and (coalesce(nr_seq_contrato::text, '') = ''	or nr_seq_contrato	= nr_seq_contrato_w)
		and (coalesce(nr_seq_prestador::text, '') = ''	or nr_seq_prestador	= nr_seq_prestador_w)
		and (coalesce(nr_seq_uni_origem::text, '') = ''	or nr_seq_uni_origem	= nr_seq_uni_exec_w)
		and (coalesce(nr_seq_contrato_int::text, '') = ''	or nr_seq_contrato_int	= nr_seq_intercambio_w)
		and (coalesce(nr_seq_material::text, '') = ''	or nr_seq_material	= nr_seq_material_w)
		and (coalesce(ie_preco::text, '') = ''	or ie_preco		= ie_preco_w)
		and (coalesce(ie_tipo_gat::text, '') = ''	or ie_tipo_gat		= ie_tipo_gat_w)
		and	dt_requisicao_w		between(dt_inicio_vigencia)	and (coalesce(dt_fim_vigencia, clock_timestamp()))
		and (pls_obter_se_controle_estab('RE') = 'N')) alias61
	order by	cd_area_procedimento,
			cd_especialidade,
			cd_grupo_proc,
			cd_procedimento,
			nr_seq_material,
			nr_seq_prestador,
			nr_seq_contrato,
			nr_seq_contrato_int,
			nr_seq_uni_origem,
			ie_tipo_gat,
			ie_preco;


BEGIN

begin
	select	nr_seq_prestador
	into STRICT	nr_seq_prestador_w
	from	pls_lote_execucao_req
	where	nr_sequencia = nr_seq_exec_lote_p;

	select 	cd_procedimento,
		ie_origem_proced,
		nr_seq_requisicao,
		nr_seq_material
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_requisicao_w,
		nr_seq_material_w
	from (SELECT	null cd_procedimento,
			null ie_origem_proced,
			b.nr_seq_requisicao,
			b.nr_seq_material
		from	pls_itens_lote_execucao a,
			pls_requisicao_mat b
		where	b.nr_sequencia = a.nr_seq_req_mat
		and	a.nr_sequencia	= nr_seq_exec_item_lote_p
		and	a.ie_executar		= 'S'
		
union

		SELECT	b.cd_procedimento,
			b.ie_origem_proced,
			b.nr_seq_requisicao,
			null nr_seq_material
		from	pls_itens_lote_execucao a,
			pls_Requisicao_proc b
		where	b.nr_sequencia 	= a.nr_seq_req_proc
		and	a.nr_sequencia	= nr_seq_exec_item_lote_p
		and	a.ie_executar		= 'S') alias0;

exception
when others then
	cd_procedimento_w	:= 0;
	ie_origem_proced_w	:= 0;
	nr_seq_requisicao_w	:= 0;
	nr_seq_material_w	:= 0;
end;

if (nr_seq_requisicao_w	<> 0) then
	select	nr_seq_segurado,
		coalesce(nr_seq_uni_exec,0),
		dt_requisicao,
		ie_tipo_gat
	into STRICT	nr_seq_segurado_w,
		nr_seq_uni_exec_w,
		dt_requisicao_w,
		ie_tipo_gat_w
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_w;
end if;

SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_ww) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_ww;

if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
	begin
		select	coalesce(nr_seq_contrato,0),
			coalesce(nr_seq_intercambio,0),
			coalesce(nr_seq_plano,0)
		into STRICT	nr_seq_contrato_w,
			nr_seq_intercambio_w,
			nr_seq_plano_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		nr_seq_contrato_w	:= 0;
		nr_seq_intercambio_w	:= 0;
		nr_seq_plano_w		:= 0;
	end;

	if (nr_seq_plano_w	<> 0) then
		select	coalesce(ie_preco,0)
		into STRICT	ie_preco_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_plano_w;
	end if;
else
	nr_seq_contrato_w	:= 0;
end if;

open C01;
loop
fetch C01 into
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		ds_retorno_w := 'O procedimento '||cd_procedimento_w||' - '||obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_ww)||', não pode ter sua quantidade alterada !';
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_exec_total ( nr_seq_exec_item_lote_p bigint, nr_seq_exec_lote_p bigint) FROM PUBLIC;

