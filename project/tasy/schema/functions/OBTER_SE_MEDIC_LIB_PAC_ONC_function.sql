-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_lib_pac_onc ( cd_pessoa_fisica_p text, cd_material_p bigint, nr_seq_paciente_p bigint default null, nr_seq_material_p bigint default null, ie_opcao_p text default null) RETURNS varchar AS $body$
DECLARE

qt_lib_w				bigint;
qt_dias_tratamento_w	double precision;
qt_prescricao_w			double precision;
nm_usuario_w			varchar(50);
ie_usa_liberacao_w		varchar(50);
cd_estabelecimento_w	bigint;
dt_inicio_validade_w	timestamp;
qt_dose_w				double precision;
nr_seq_paciente_w		bigint;
cd_intervalo_w			varchar(255);


BEGIN

if (coalesce(ie_opcao_p,'P') = 	'P') then

	select	max(qt_dose_prescr),
			max(cd_intervalo)
	into STRICT	qt_dose_w,
			cd_intervalo_w
	from	paciente_protocolo_medic
	where	nr_seq_paciente = nr_seq_paciente_p
	and		nr_seq_material	= nr_seq_material_p;


else

	select	max(qt_dose_prescricao),
			max(nr_seq_paciente),
			max(cd_intervalo)
	into STRICT	qt_dose_w,
			nr_seq_paciente_w,
			cd_intervalo_w
	from	paciente_atend_medic
	where	nr_seq_atendimento = nr_seq_paciente_p
	and		nr_seq_material	= nr_seq_material_p;


end if;


select	count(*)
into STRICT	qt_lib_w
from	lib_material_paciente
where	cd_material	 = cd_material_p
and		cd_pessoa_fisica = cd_pessoa_fisica_p
and		coalesce(qt_dose_diaria,coalesce(qt_dose_w,0)) >= coalesce(qt_dose_w,0)
and		coalesce(cd_intervalo,coalesce(cd_intervalo_w,'XPTO')) = coalesce(cd_intervalo_w,'XPTO')
and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and		coalesce(dt_suspenso::text, '') = ''
and	clock_timestamp() between trunc(dt_inicio_validade,'dd') and fim_dia(coalesce(dt_suspenso,clock_timestamp()));



if (qt_lib_w > 0) then
	return 'S';
else
	return 'N';
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_lib_pac_onc ( cd_pessoa_fisica_p text, cd_material_p bigint, nr_seq_paciente_p bigint default null, nr_seq_material_p bigint default null, ie_opcao_p text default null) FROM PUBLIC;

