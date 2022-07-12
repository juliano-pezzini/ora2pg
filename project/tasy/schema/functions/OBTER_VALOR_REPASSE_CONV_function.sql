-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_repasse_conv ( nr_repasse_terceiro_p bigint, ie_sus_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_repasse_w		double precision;
vl_repasse_proc_w		double precision;
vl_Liberado_Proc_w	double precision;
vl_repasse_mat_w		double precision;
vl_Liberado_mat_w		double precision;
vl_repasse_item_w		double precision;
vl_glosa_mat_w		double precision;
vl_glosa_proc_w		double precision;
vl_maior_proc_w		double precision;
vl_maior_mat_w		double precision;

/* Opção
R - Repasse
L - Liberado
LP - Valor liberado desconsiderando itens de repasses negativos
G - Glosado
M - Maior
I - Valor líquido dos vencimentos
LI - Valor liberado somente de procedimentos e materiais
*/
BEGIN

select	coalesce(sum(a.vl_repasse),0),
	coalesce(sum(a.vl_liberado),0),
	coalesce(sum(somente_positivo(coalesce(a.vl_repasse,0) - somente_positivo(coalesce(a.vl_liberado,0)))),0),
	coalesce(sum(somente_positivo(coalesce(a.vl_liberado,0) - somente_positivo(coalesce(a.vl_repasse,0)))),0)
into STRICT	vl_repasse_proc_w,
	vl_liberado_proc_w,
	vl_glosa_proc_w,
	vl_maior_proc_w
from 	procedimento_repasse a,
	procedimento_paciente b
where 	a.nr_seq_procedimento	= b.nr_sequencia
and	(('A' = ie_sus_p) or ('S' = ie_sus_p and obter_tipo_convenio(b.cd_convenio) = 3) or ('N' = ie_sus_p and obter_tipo_convenio(b.cd_convenio) <> 3) or ('N' = ie_sus_p and coalesce(b.cd_convenio::text, '') = ''))
and	a.nr_repasse_terceiro	= nr_repasse_terceiro_p;

select	coalesce(sum(a.vl_repasse),0),
	coalesce(sum(a.vl_liberado),0),
	coalesce(sum(somente_positivo(coalesce(a.vl_repasse,0) - somente_positivo(coalesce(a.vl_liberado,0)))),0),
	coalesce(sum(somente_positivo(coalesce(a.vl_liberado,0) - somente_positivo(coalesce(a.vl_repasse,0)))),0)
into STRICT	vl_repasse_mat_w,
	vl_liberado_mat_w,
	vl_glosa_mat_w,
	vl_maior_mat_w
from 	material_repasse a,
	material_atend_paciente b
where	a.nr_seq_material	= b.nr_sequencia
and	(('A' = ie_sus_p) or ('S' = ie_sus_p and obter_tipo_convenio(b.cd_convenio) = 3) or ('N' = ie_sus_p and obter_tipo_convenio(b.cd_convenio) <> 3) or ('N' = ie_sus_p and coalesce(b.cd_convenio::text, '') = ''))
and	nr_repasse_terceiro	= nr_repasse_terceiro_p;

select 	coalesce(sum(vl_repasse),0)
into STRICT	vl_repasse_item_w
from 	repasse_terceiro_item
where 	nr_repasse_terceiro	= nr_repasse_terceiro_p
and	(('A' = ie_sus_p) or ('S' = ie_sus_p and obter_tipo_convenio(cd_convenio) = 3) or ('N' = ie_sus_p and obter_tipo_convenio(cd_convenio) <> 3) or ('N' = ie_sus_p and coalesce(cd_convenio::text, '') = ''));
vl_repasse_w			:= 0;
if (ie_opcao_p	= 'R') then
	vl_repasse_w	:= vl_repasse_proc_w + vl_repasse_mat_w + vl_repasse_item_w;
elsif (ie_opcao_p	= 'L') then
	vl_repasse_w	:= vl_liberado_proc_w + vl_liberado_mat_w + vl_repasse_item_w;
elsif (ie_opcao_p	= 'LP') then
	vl_repasse_w	:= vl_liberado_proc_w + vl_liberado_mat_w + vl_repasse_item_w;
elsif (ie_opcao_p	= 'G') then
	vl_repasse_w	:= vl_glosa_mat_w + vl_glosa_proc_w;
elsif (ie_opcao_p	= 'M') then
	vl_repasse_w	:= vl_maior_mat_w + vl_maior_proc_w;
elsif (ie_opcao_p	= 'I') then
	select	coalesce(sum(vl_liquido),0)
	into STRICT	vl_repasse_w
	from	repasse_terceiro_venc
	where	nr_repasse_terceiro	= nr_repasse_terceiro_p;
elsif (ie_opcao_p	= 'LI') then
	vl_repasse_w	:= vl_liberado_proc_w + vl_liberado_mat_w;
end if;

RETURN vl_repasse_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_repasse_conv ( nr_repasse_terceiro_p bigint, ie_sus_p text, ie_opcao_p text) FROM PUBLIC;

