-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_maxima_cons (cd_material_p bigint, cd_unidade_medida_dose_p text, qt_dose_p bigint, ie_via_aplicacao_p text, nr_prescricao_p bigint, cd_estabelecimento_p bigint, ie_agrupador_p bigint) RETURNS bigint AS $body$
DECLARE


cd_unidade_medida_consumo_w	varchar(30);
cd_unid_med_limite_w		varchar(30);
qt_limite_pessoa_w		double precision;
qt_conversao_dose_w		double precision;
qt_conversao_dose_limite_w	double precision;
qt_dose_w			double precision;
qt_dose_limite_w		double precision;
cd_pessoa_fisica_w		varchar(30);
ie_dose_limite_w		varchar(15);
nr_seq_agrupamento_w		bigint;
cd_prescritor_w			varchar(50);
cd_setor_atendimento_w		integer;
qt_regra_w			bigint;
qt_idade_w			bigint;
qt_idade_dia_w			double precision;
qt_idade_mes_w			double precision;
qt_peso_w			real;
qt_limite_peso_w		real;
qt_dose_maxima_w		double precision	:= 0;

c01 CURSOR FOR
	SELECT	coalesce(qt_limite_pessoa,0),
		coalesce(ie_dose_limite,'DOSE'),
		cd_unid_med_limite
	from	material_prescr
	where	cd_material							= cd_material_p
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(ie_via_aplicacao, coalesce(ie_via_aplicacao_p,0))		= coalesce(ie_via_aplicacao_p,0)
	and	(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
	and	qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
	and	qt_idade_dia_w between coalesce(qt_idade_min_dia,0) and coalesce(qt_idade_max_dia,55000)
	and	qt_idade_mes_w between coalesce(qt_idade_min_mes,0) and coalesce(qt_idade_max_mes,55000)
	and	((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento	= nr_seq_agrupamento_w))
	and	qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
	and	ie_tipo								= '2'
	and 	coalesce(cd_estabelecimento, cd_estabelecimento_p)			= cd_estabelecimento_p
	and	Obter_se_setor_regra_prescr(nr_sequencia, cd_setor_atendimento_w) = 'S'
	and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_prescritor_w, cd_especialidade) = 'S'))
--	and	nvl(ie_obedecer_limite,'N')					= 'S'
	and	(((coalesce(ie_tipo_item,'TOD') = 'SOL') and (ie_agrupador_p = 4)) or
		 ((coalesce(ie_tipo_item,'TOD') = 'OUT') and (ie_agrupador_p <> 4)) or (coalesce(ie_tipo_item,'TOD') = 'TOD'))
	order by nr_sequencia;


BEGIN

select	max(cd_prescritor),
	max(cd_setor_atendimento),
	(obter_idade_pf(max(cd_pessoa_fisica), clock_timestamp(), 'A'))::numeric ,
	coalesce(max(qt_peso),0),
	max(cd_pessoa_fisica)
into STRICT	cd_prescritor_w,
	cd_setor_atendimento_w,
	qt_idade_w,
	qt_peso_w,
	cd_pessoa_fisica_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA')),
	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'M'))
into STRICT	qt_idade_dia_w,
	qt_idade_mes_w
from	pessoa_fisica b
where	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;

select	max(nr_seq_agrupamento)
into STRICT	nr_seq_agrupamento_w
from	setor_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_w;

select	cd_unidade_medida_consumo,
	cd_unid_med_limite,
	coalesce(qt_limite_pessoa,0),
	coalesce(ie_dose_limite,'DOSE')
into STRICT	cd_unidade_medida_consumo_w,
	cd_unid_med_limite_w,
	qt_limite_pessoa_w,
	ie_dose_limite_w
from	material
where	cd_material	= cd_material_p;

/* Verifica se tem alguma regra para os dados informados */

select	count(*)
into STRICT	qt_regra_w
from	material_prescr
where	cd_material							= cd_material_p
and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
and	coalesce(ie_via_aplicacao, coalesce(ie_via_aplicacao_p,0))		= coalesce(ie_via_aplicacao_p,0)
and	qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
and	qt_idade_dia_w between coalesce(qt_idade_min_dia,0) and coalesce(qt_idade_max_dia,55000)
and	qt_idade_mes_w between coalesce(qt_idade_min_mes,0) and coalesce(qt_idade_max_mes,55000)
and	((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento	= nr_seq_agrupamento_w))
and	qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
and	(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_prescritor_w, cd_especialidade) = 'S'))
and	ie_tipo								= '2'
and	(((coalesce(ie_tipo_item,'TOD') = 'SOL') and (ie_agrupador_p = 4)) or
	 ((coalesce(ie_tipo_item,'TOD') = 'OUT') and (ie_agrupador_p <> 4)) or (coalesce(ie_tipo_item,'TOD') = 'TOD'));
--and	nvl(ie_obedecer_limite,'N')					= 'S';
/* Caso haja alguma regra, faz as consistências */

if (qt_regra_w > 0) then
	open c01;
	loop
	fetch c01 into
		qt_limite_pessoa_w,
		ie_dose_limite_w,
		cd_unid_med_limite_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	cd_unidade_medida_consumo
		into STRICT	cd_unidade_medida_consumo_w
		from	material
		where	cd_material	= cd_material_p;

		if (cd_unidade_medida_consumo_w = cd_unidade_medida_dose_p) then
			qt_conversao_dose_w	:= 1;
		else
			begin
			select	coalesce(max(qt_conversao),1)
			into STRICT	qt_conversao_dose_w
			from	material_conversao_unidade
			where	cd_material		= cd_material_p
			and	cd_unidade_medida	= cd_unidade_medida_dose_p;
			exception
				when others then
					qt_conversao_dose_w	:= 1;
			end;
		end if;

		if (cd_unidade_medida_consumo_w = cd_unid_med_limite_w) then
			qt_conversao_dose_limite_w	:= 1;
		else
			begin
			select	coalesce(max(qt_conversao),1)
			into STRICT	qt_conversao_dose_limite_w
			from	material_conversao_unidade
			where	cd_material		= cd_material_p
			and	cd_unidade_medida	= cd_unid_med_limite_w;
			exception
				when others then
					qt_conversao_dose_limite_w	:= 1;
			end;
		end if;

		qt_dose_w		:= (trunc(qt_dose_p * 1000 / qt_conversao_dose_w)/ 1000);
		qt_dose_limite_w	:= (trunc(qt_limite_pessoa_w * 1000 / qt_conversao_dose_limite_w)/ 1000);

		if (qt_dose_limite_w	> 0) and (qt_dose_limite_w	< coalesce(qt_dose_w,0)) then
			qt_dose_maxima_w	:= qt_dose_limite_w;
		else
			qt_dose_maxima_w	:= 0;
		end if;

		end;
	end loop;
	close c01;
end if;

return	qt_dose_maxima_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_maxima_cons (cd_material_p bigint, cd_unidade_medida_dose_p text, qt_dose_p bigint, ie_via_aplicacao_p text, nr_prescricao_p bigint, cd_estabelecimento_p bigint, ie_agrupador_p bigint) FROM PUBLIC;

