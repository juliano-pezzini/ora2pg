-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_regime_atend (nr_atendimento_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_tipo_guia_w		varchar(2);
cd_procedencia_w	integer;
cd_setor_entrada_w	integer;
ie_clinica_w		bigint;
ie_regime_internacao_w	varchar(255);
nr_seq_classif_atend_w	bigint;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type;
qt_horas_internacao_w	double precision;
cd_estabelecimento_w	atendimento_paciente.cd_estabelecimento%type;
ie_hospital_dia_w	tiss_parametros_convenio.ie_hospital_dia%type;

c01 CURSOR FOR
SELECT	coalesce(ie_regime_internacao,'1')
from	tiss_regime_internacao
where	cd_procedencia								= cd_procedencia_w
and	coalesce(cd_setor_entrada, cd_setor_entrada_w)		= cd_setor_entrada_w
and	coalesce(ie_tipo_guia, ie_tipo_guia_w)				= ie_tipo_guia_w
and 	coalesce(ie_clinica, ie_clinica_w)				= ie_clinica_w
and		coalesce(nr_Seq_classif_atend,coalesce(nr_seq_classif_atend_w,0))	= coalesce(nr_seq_classif_atend_w,0)
order by 	cd_procedencia,
	coalesce(ie_clinica,0),
	coalesce(ie_tipo_guia,0),
	coalesce(cd_setor_entrada,0),
	coalesce(nr_Seq_classif_atend,0);

BEGIN

select	max(a.ie_regime_internacao),
	coalesce(max(a.ie_tipo_guia),0),
	max(b.cd_procedencia),
	coalesce(max(b.ie_clinica),0),
	max(nr_Seq_classificacao),
	max(b.ie_tipo_atendimento),
	max(b.cd_estabelecimento)
into STRICT	ds_retorno_w,
	ie_tipo_guia_w,
	cd_procedencia_w,
	ie_clinica_w,
	nr_seq_classif_atend_w,
	ie_tipo_atendimento_w,
	cd_estabelecimento_w
from	atend_categoria_convenio a,
	atendimento_paciente b
where	b.nr_atendimento	= nr_atendimento_p
and	a.cd_convenio		= cd_convenio_p
and	a.nr_seq_interno	= (	SELECT	max(nr_seq_interno)
					from	atend_categoria_convenio
					where	nr_atendimento	= nr_atendimento_p
					and	cd_convenio	= cd_convenio_p);

select	max(coalesce(ie_hospital_dia,'N'))
into STRICT	ie_hospital_dia_w
from	tiss_parametros_convenio
where	cd_convenio = cd_convenio_p
and	cd_estabelecimento = cd_estabelecimento_w;

if (coalesce(ds_retorno_w::text, '') = '') then

	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_entrada_w
	from	atend_paciente_unidade
	where	nr_atendimento		= nr_atendimento_p
	and	dt_entrada_unidade		= (	SELECT	min(dt_entrada_unidade)
						from	atend_paciente_unidade
						where	nr_atendimento	= nr_atendimento_p);

	open c01;
	loop
	fetch c01 into
		ie_regime_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;

	if	((coalesce(ie_regime_internacao_w::text, '') = '') or (ie_hospital_dia_w = 'S')) and (ie_tipo_atendimento_w = 1) then

		select	Sum(Obter_Hora_Entre_datas(a.dt_saida_unidade,a.dt_entrada_unidade))
		into STRICT	qt_horas_internacao_w
		from 	setor_atendimento c,
			atend_paciente_unidade a
		where	a.nr_atendimento 		= nr_atendimento_p
		and	c.cd_setor_atendimento		= a.cd_setor_atendimento
		and 	c.cd_classif_setor in (3,4,8,12);

		if (qt_horas_internacao_w > 0) and (qt_horas_internacao_w <= 12) then

			ie_regime_internacao_w := '2';

		end if;

	end if;

	ds_retorno_w	:= coalesce(ie_regime_internacao_w,'1');

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_regime_atend (nr_atendimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;

