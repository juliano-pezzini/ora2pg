-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_interv_solic_med_onc ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, nr_seq_atendimento_p bigint, cd_material_p text, ds_erro_p INOUT text) AS $body$
DECLARE



ds_erro_w			varchar(2000) := '';
cd_material_w			integer;
qt_dias_intervalo_w		bigint;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
cd_material_regra_w		integer;
cd_estabelecimento_w		smallint;
nr_atendimento_w			bigint;
cd_grupo_material_prescr_w		smallint;
cd_subgrupo_material_prescr_w	smallint;
cd_classe_material_prescr_w		integer;
dt_ultima_prescricao_w		timestamp;
dt_prescricao_w			timestamp;
ds_material_w			varchar(255);
ie_considera_kit_w		varchar(2);
ie_todas_atend_w		varchar(2);
ds_material_prob_w		varchar(2000) := '';
cd_convenio_w			integer;
ds_justificativa_w			varchar(255);
qt_permitida_w			double precision	:= 1;
qt_executada_periodo_w		double precision;
cd_setor_atendimento_w		bigint;
cd_protocolo_w			bigint;
nr_seq_medicacao_w		bigint;

C01 CURSOR FOR
	SELECT	distinct cd_material,
			ds_material,
			null
	from	material
	where	cd_material	= cd_material_p;

C02 CURSOR FOR
	SELECT	qt_dias_intervalo,
		cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		cd_material,
		coalesce(qt_permitida,1),
		coalesce(ie_considera_kit,'S'),
		coalesce(ie_todas_atend,'N')
	from	REGRA_INTERV_MED_ONC
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	coalesce(cd_grupo_material,coalesce(cd_grupo_material_prescr_w,0))	= coalesce(cd_grupo_material_prescr_w,0)
	and	coalesce(cd_subgrupo_material,coalesce(cd_subgrupo_material_prescr_w,0))	= coalesce(cd_subgrupo_material_prescr_w,0)
	and	coalesce(cd_classe_material,coalesce(cd_classe_material_prescr_w,0))	= coalesce(cd_classe_material_prescr_w,0)
	and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_w,0))		= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(cd_protocolo,coalesce(cd_protocolo_w,0))				= coalesce(cd_protocolo_w,0)
	and	coalesce(nr_seq_medicacao,coalesce(nr_seq_medicacao_w,0))		 	= coalesce(nr_seq_medicacao_w,0)
	and	((coalesce(cd_convenio::text, '') = '') or (cd_convenio = cd_convenio_w))
	order by
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_convenio,0);


BEGIN



select	b.cd_estabelecimento,
	b.cd_setor_atendimento,
	a.dt_real,
	cd_protocolo,
	nr_seq_medicacao
into STRICT	cd_estabelecimento_w,
	cd_setor_atendimento_w,
	dt_prescricao_w,
	cd_protocolo_w,
	nr_seq_medicacao_w
from	paciente_atendimento a,
	paciente_setor b
where	b.nr_seq_paciente	= a.nr_seq_paciente
and	a.nr_seq_atendimento	= nr_seq_atendimento_p;

nr_atendimento_w	:= obter_ultimo_atendimento(cd_pessoa_fisica_p);
cd_convenio_w		:= 0;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	cd_convenio_w		:= obter_convenio_atendimento(nr_atendimento_w);

end if;

open C01;
loop
fetch C01 into
	cd_material_w,
	ds_material_w,
	ds_justificativa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_material_prescr_w,
		cd_subgrupo_material_prescr_w,
		cd_classe_material_prescr_w
	from	estrutura_material_v
	where	cd_material	= cd_material_w;

	open c02;
	loop
	fetch c02 into
		qt_dias_intervalo_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w,
		cd_material_regra_w,
		qt_permitida_w,
		ie_considera_kit_w,
		ie_todas_atend_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		qt_dias_intervalo_w	:= qt_dias_intervalo_w;
	end loop;
	close c02;

	dt_ultima_prescricao_w	:= null;

	if (cd_material_regra_w IS NOT NULL AND cd_material_regra_w::text <> '')  then
		begin
		select	max(a.dt_prescricao)
		into STRICT	dt_ultima_prescricao_w
		from	prescr_material b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.nr_prescricao		<> nr_prescricao_p
		and	b.cd_material		= cd_material_w
		and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
		and	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''));
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;

		begin
		if (ie_todas_atend_w = 'N') then
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	prescr_material	b,
				prescr_medica 	a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= cd_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	a.dt_prescricao between (dt_prescricao_w - (qt_dias_intervalo_w )) and dt_prescricao_w
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		else
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	prescr_material	b,
				prescr_medica 	a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= cd_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		end if;
		exception
			when others then
				qt_executada_periodo_w	:= 0;
		end;

	elsif (cd_classe_material_w IS NOT NULL AND cd_classe_material_w::text <> '') then
		begin
		select	max(a.dt_prescricao)
		into STRICT	dt_ultima_prescricao_w
		from	estrutura_material_v c,
			prescr_material b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.nr_prescricao		<> nr_prescricao_p
		and	b.cd_material		= c.cd_material
		and	c.cd_classe_material	= cd_classe_material_w
		and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
		and	coalesce(a.dt_suspensao::text, '') = ''
		and	coalesce(b.ie_suspenso,'N')	<> 'S'
		and	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''));
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;

		begin

		if (ie_todas_atend_w = 'N') then
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_classe_material	= cd_classe_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	a.dt_prescricao between (dt_prescricao_w - (qt_dias_intervalo_w)) and dt_prescricao_w
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		else
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_classe_material	= cd_classe_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		end if;
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;
	elsif (cd_subgrupo_material_w IS NOT NULL AND cd_subgrupo_material_w::text <> '') then
		begin
		select	max(a.dt_prescricao)
		into STRICT	dt_ultima_prescricao_w
		from	estrutura_material_v c,
			prescr_material b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.nr_prescricao		<> nr_prescricao_p
		and	b.cd_material		= c.cd_material
		and	c.cd_subgrupo_material	= cd_subgrupo_material_w
		and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
		and	coalesce(a.dt_suspensao::text, '') = ''
		and	coalesce(b.ie_suspenso,'N')	<> 'S'
		and	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''));
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;

		begin

		if (ie_todas_atend_w = 'N') then
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_subgrupo_material	= cd_subgrupo_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	a.dt_prescricao between (dt_prescricao_w - (qt_dias_intervalo_w)) and dt_prescricao_w
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		else
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_subgrupo_material	= cd_subgrupo_material_w
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		end if;
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;
	elsif (cd_grupo_material_w IS NOT NULL AND cd_grupo_material_w::text <> '') then
		begin
		select	max(a.dt_prescricao)
		into STRICT	dt_ultima_prescricao_w
		from	estrutura_material_v c,
			prescr_material b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	a.nr_prescricao		<> nr_prescricao_p
		and	b.cd_material		= c.cd_material
		and	c.cd_grupo_material	= cd_grupo_material_w
		and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
		and	coalesce(a.dt_suspensao::text, '') = ''
		and	coalesce(b.ie_suspenso,'N')	<> 'S'
		and	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''));
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;

		begin
		if (ie_todas_atend_w = 'N') then
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_grupo_material	= cd_grupo_material_w
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	a.dt_prescricao between (dt_prescricao_w - (qt_dias_intervalo_w)) and dt_prescricao_w
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		else
			select	CASE WHEN b.ie_agrupador=1 THEN coalesce(sum(b.qt_dose),0) WHEN b.ie_agrupador=2 THEN coalesce(sum(b.qt_unitaria),0) END
			into STRICT	qt_executada_periodo_w
			from	estrutura_material_v c,
				prescr_material b,
				prescr_medica a
			where	a.nr_prescricao		= b.nr_prescricao
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and	b.cd_material		= c.cd_material
			and	c.cd_grupo_material	= cd_grupo_material_w
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(b.ie_suspenso,'N')	<> 'S'
			and	((ie_considera_kit_w	= 'S') or (coalesce(b.nr_seq_kit::text, '') = ''))
			and	(((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '')) or (a.nr_prescricao = nr_prescricao_p))
			group by
				b.ie_agrupador;
		end if;
		exception
			when others then
				dt_ultima_prescricao_w	:= null;
		end;
	end if;

	if (dt_ultima_prescricao_w IS NOT NULL AND dt_ultima_prescricao_w::text <> '') and
		(((dt_prescricao_w - dt_ultima_prescricao_w) * 24) < qt_dias_intervalo_w) then
		ds_material_prob_w	:= substr(ds_material_prob_w ||ds_material_w||' - '||qt_dias_intervalo_w||'h / ',1,2000);
	end if;
	if (qt_executada_periodo_w > qt_permitida_w) then
		ds_material_prob_w	:= substr(ds_material_prob_w ||ds_material_w||' - '||qt_dias_intervalo_w||'h / ',1,2000);
	end if;
end loop;
close C01;

if (ds_material_prob_w IS NOT NULL AND ds_material_prob_w::text <> '') and (coalesce(ds_justificativa_w::text, '') = '') then
	ds_erro_w	:= qt_dias_intervalo_w||'h ';
end if;

ds_erro_p	:= ds_erro_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_interv_solic_med_onc ( nr_prescricao_p bigint, cd_pessoa_fisica_p text, nr_seq_atendimento_p bigint, cd_material_p text, ds_erro_p INOUT text) FROM PUBLIC;
