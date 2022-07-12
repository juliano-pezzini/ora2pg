-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conv_ret_glosa (nr_sequencia_p bigint, nr_seq_ret_item_p bigint, nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_autorizacao_p text, nr_interno_conta_p bigint, ie_emite_conta_p text, ie_complexidade_p text, cd_material_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_procedimento_p bigint, cd_grupo_procedimento_p bigint, cd_area_procedimento_p bigint, cd_especialidade_proced_p bigint, ie_complexidade_aih_p text, ie_tipo_financiamento_p text, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


/*ie_tipo_item_p
0	procedimentos
1	material
*/
qt_retorno_w		bigint	:= 0;
cd_procedimento_w	bigint;
cd_material_w		integer;
ie_origem_proced_w	bigint;
ds_retorno_w		varchar(255)	:= 'N';


BEGIN

if	((cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') or (cd_grupo_procedimento_p IS NOT NULL AND cd_grupo_procedimento_p::text <> '') or (cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') or (cd_especialidade_proced_p IS NOT NULL AND cd_especialidade_proced_p::text <> '')) and (ie_tipo_item_p = '0') then

	select	cd_procedimento,
		ie_origem_proced,
		0
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_material_w
	from	convenio_retorno_glosa
	where	nr_sequencia	= nr_sequencia_p;
elsif	((cd_material_p IS NOT NULL AND cd_material_p::text <> '') or (cd_grupo_material_p IS NOT NULL AND cd_grupo_material_p::text <> '') or (cd_subgrupo_material_p IS NOT NULL AND cd_subgrupo_material_p::text <> '') or (cd_classe_material_p IS NOT NULL AND cd_classe_material_p::text <> '')) and (ie_tipo_item_p = '1') then

	select	0,
		ie_origem_proced,
		cd_material
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_material_w
	from	convenio_retorno_glosa
	where	nr_sequencia	= nr_sequencia_p;
elsif (coalesce(cd_procedimento_p::text, '') = '') and (coalesce(cd_material_p::text, '') = '') then
	select	cd_procedimento,
		ie_origem_proced,
		cd_material
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_material_w
	from	convenio_retorno_glosa
	where	nr_sequencia	= nr_sequencia_p;
end if;

if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (cd_procedimento_w <> 0)  then

	select	count(*)
	into STRICT	qt_retorno_w
	from	procedimento c,
		sus_procedimento f,
		estrutura_procedimento_v b,
		procedimento_paciente d,
		convenio_retorno_glosa a,
		convenio_retorno_item e
	where	a.nr_sequencia		= nr_sequencia_p
	and	a.cd_procedimento	= b.cd_procedimento
	and	a.ie_origem_proced	= b.ie_origem_proced
	and	f.cd_procedimento	= c.cd_procedimento
	and	f.ie_origem_proced	= c.ie_origem_proced
	and	e.nr_sequencia		= a.nr_seq_ret_item
	and	a.cd_procedimento	= coalesce(cd_procedimento_p, a.cd_procedimento)
	and	a.ie_origem_proced	= coalesce(ie_origem_proced_w, a.ie_origem_proced)
	and	a.nr_seq_ret_item	= coalesce(nr_seq_ret_item_p, a.nr_seq_ret_item)
	and	c.cd_procedimento	= a.cd_procedimento
	and	c.ie_origem_proced	= a.ie_origem_proced
	and	d.cd_procedimento	= a.cd_procedimento
	and	d.ie_origem_proced	= a.ie_origem_proced
	and 	d.nr_sequencia 		= a.nr_seq_propaci
	and	coalesce(a.cd_material::text, '') = ''
	and	d.nr_atendimento	= coalesce(nr_atendimento_p, d.nr_atendimento)
	and	e.nr_interno_conta	= coalesce(nr_interno_conta_p, d.nr_interno_conta)
	and	e.cd_autorizacao 	= coalesce(cd_autorizacao_p, e.cd_autorizacao)
	and	coalesce(a.ie_emite_conta, -1) = coalesce(ie_emite_conta_p, coalesce(a.ie_emite_conta, '-1'))
	and	f.ie_complexidade	= coalesce(ie_complexidade_p, f.ie_complexidade)
	and	b.cd_grupo_proc		= coalesce(cd_grupo_procedimento_p, b.cd_grupo_proc)
	and	b.cd_area_procedimento	= coalesce(cd_area_procedimento_p, b.cd_area_procedimento)
	and	b.cd_especialidade	= coalesce(cd_especialidade_proced_p, b.cd_especialidade)
	and	f.ie_tipo_financiamento	= coalesce(ie_tipo_financiamento_p,f.ie_tipo_financiamento)
	and	d.dt_procedimento	between trunc(coalesce(dt_inicial_p, d.dt_procedimento - 1), 'dd') and trunc(coalesce(dt_final_p, d.dt_procedimento + 1)) + 89399/89400
	and	((coalesce(ie_complexidade_aih_p,'X') = 'X') or
		exists (SELECT	1
			from	sus_aih_unif x
			where	x.nr_interno_conta	= d.nr_interno_conta
			and	x.ie_complexidade	= ie_complexidade_aih_p));

elsif (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (cd_material_w <> 0) and (coalesce(ie_complexidade_p::text, '') = '') and (coalesce(ie_complexidade_aih_p::text, '') = '') then

	select	count(*)
	into STRICT	qt_retorno_w
	from	material c,
		estrutura_material_v b,
		material_atend_paciente d,
		convenio_retorno_glosa a,
		convenio_retorno_item e
	where	a.nr_sequencia		= nr_sequencia_p
	and	a.cd_material		= b.cd_material
	and	e.nr_sequencia		= a.nr_seq_ret_item
	and	a.cd_material		= coalesce(cd_material_p, a.cd_material)
	and	b.cd_material		= c.cd_material
	and	d.cd_material		= c.cd_material
	and	d.nr_sequencia 		= a.nr_seq_matpaci
	and	coalesce(a.cd_procedimento::text, '') = ''
	and	d.nr_atendimento	= coalesce(nr_atendimento_p, d.nr_atendimento)
	and	e.nr_interno_conta	= coalesce(nr_interno_conta_p, d.nr_interno_conta)
	and	e.cd_autorizacao 	= coalesce(cd_autorizacao_p, e.cd_autorizacao)
	and	a.nr_seq_ret_item	= coalesce(nr_seq_ret_item_p, a.nr_seq_ret_item)
	and	coalesce(a.ie_emite_conta, -1) = coalesce(ie_emite_conta_p, coalesce(a.ie_emite_conta, '-1'))
	and	b.cd_grupo_material	= coalesce(cd_grupo_material_p, b.cd_grupo_material)
	and	b.cd_subgrupo_material	= coalesce(cd_subgrupo_material_p, b.cd_subgrupo_material)
	and	b.cd_classe_material	= coalesce(cd_classe_material_p, b.cd_classe_material)
	and	d.dt_atendimento	between trunc(coalesce(dt_inicial_p, d.dt_atendimento - 1), 'dd') and trunc(coalesce(dt_final_p, d.dt_atendimento + 1)) + 89399/89400;

end if;

if (qt_retorno_w > 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conv_ret_glosa (nr_sequencia_p bigint, nr_seq_ret_item_p bigint, nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_autorizacao_p text, nr_interno_conta_p bigint, ie_emite_conta_p text, ie_complexidade_p text, cd_material_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_procedimento_p bigint, cd_grupo_procedimento_p bigint, cd_area_procedimento_p bigint, cd_especialidade_proced_p bigint, ie_complexidade_aih_p text, ie_tipo_financiamento_p text, ie_tipo_item_p text) FROM PUBLIC;

