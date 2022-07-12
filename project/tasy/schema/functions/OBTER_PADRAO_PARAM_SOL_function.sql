-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_padrao_param_sol ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50) := null;
qt_regra_w		bigint;
cd_intervalo_w		varchar(7);
qt_idade_w		double precision;
qt_idade_min_w		double precision;
qt_idade_max_w		double precision;
ie_se_necessario_w	varchar(2);
hr_prim_horario_w	varchar(200);
ie_urgencia_w		varchar(1);
cd_estabelecimento_w	smallint;
cd_material_w		integer;
ie_via_aplicacao_w	varchar(5);
cd_setor_atendimento_w	integer;
cd_pessoa_fisica_w	varchar(10);
qt_peso_w		real;
ie_dispositivo_infusao_w varchar(10);

c01 CURSOR FOR
SELECT	substr(cd_intervalo,1,7),
	hr_prim_horario,
	ie_se_necessario,
	coalesce(ie_gerar_agora,'N'),
	coalesce(Obter_idade_param_prescr(nr_sequencia,'MIN'),0) qt_idade_min,
	coalesce(Obter_idade_param_prescr(nr_sequencia,'MAX'),9999999) qt_idade_max,
	ie_dispositivo_infusao
from	material_prescr
where	cd_material							= cd_material_w
and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
and	coalesce(qt_peso_w,1) between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999999)
and	coalesce(qt_idade_w,1) between coalesce(Obter_idade_param_prescr(nr_sequencia,'MIN'),0) and coalesce(Obter_idade_param_prescr(nr_sequencia,'MAX'),9999999)
and	Obter_se_setor_regra_prescr(nr_sequencia, cd_setor_atendimento_w) = 'S'
and	((coalesce(ie_somente_sn,'N')	= 'N') or (ie_se_necessario_w = 'S'))
and	ie_tipo 							= '1'
and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_w))
and	coalesce(ie_aplica_solucao,'N')	= 'S'
order by coalesce(cd_setor_atendimento,99999) desc,
	qt_idade_min,
	qt_idade_max,
	coalesce(ie_via_aplicacao, 'zzzzzzzz') desc,
	coalesce(qt_peso_min, 99999999) desc,
	nr_sequencia;


BEGIN

select	max(cd_material),
	max(ie_via_aplicacao),
	max(ie_se_necessario)
into STRICT	cd_material_w,
	ie_via_aplicacao_w,
	ie_se_necessario_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p;

select	max(cd_pessoa_fisica),
	max(cd_estabelecimento),
	coalesce(max(cd_setor_atendimento),obter_setor_atendimento(max(nr_atendimento))),
	max(qt_peso)
into STRICT	cd_pessoa_fisica_w,
	cd_estabelecimento_w,
	cd_setor_atendimento_w,
	qt_peso_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA'))
into STRICT	qt_idade_w
from	pessoa_fisica b
where	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;

select	count(*)
into STRICT	qt_regra_w
from	material_prescr
where	cd_material							= cd_material_w
and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
and	coalesce(qt_peso_w,1) between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999999)
and	coalesce(qt_idade_w,1) between coalesce(Obter_idade_param_prescr(nr_sequencia,'MIN'),0) and coalesce(Obter_idade_param_prescr(nr_sequencia,'MAX'),9999999)
and	Obter_se_setor_regra_prescr(nr_sequencia, cd_setor_atendimento_w) = 'S'
and	((coalesce(ie_somente_sn,'N')	= 'N') or (ie_se_necessario_w = 'S'))
and	ie_tipo								= '1'
and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_w))
and	coalesce(ie_aplica_solucao,'N')	= 'S';

if (qt_regra_w > 0) then
	open c01;
	loop
	fetch c01 into
		cd_intervalo_w,
		hr_prim_horario_w,
		ie_se_necessario_w,
		ie_urgencia_w,
		qt_idade_min_w,
		qt_idade_max_w,
		ie_dispositivo_infusao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_opcao_p = 'I') then
			ds_retorno_w	:= cd_intervalo_w;
		elsif (ie_opcao_p = 'H') then
			ds_retorno_w	:= hr_prim_horario_w;
		elsif (ie_opcao_p = 'SN') then
			ds_retorno_w	:= ie_se_necessario_w;
		elsif (ie_opcao_p = 'A') then
			ds_retorno_w	:= ie_urgencia_w;
		elsif (ie_opcao_p = 'DI') then
			ds_retorno_w	:= ie_dispositivo_infusao_w;
		else
			ds_retorno_w	:= '';
		end if;
		end;
	end loop;
	close c01;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_padrao_param_sol ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
