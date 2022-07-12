-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_max_nr_dia_util (nr_prescricao_p bigint, nr_seq_material_p bigint, qt_dias_liberados_p bigint) RETURNS bigint AS $body$
DECLARE



cd_intervalo_w			prescr_material.cd_intervalo%TYPE;
cd_material_w			prescr_material.cd_material%TYPE;
ie_lib_auto_w			varchar(1) := 'N';
cd_perfil_w             bigint;
cd_estabelecimento_w	bigint;
ie_pend_dias_solic_w	varchar(1) := 'N';
dt_prescricao_w			prescr_medica.dt_prescricao%TYPE;
dt_posterior_w			prescr_medica.dt_prescricao%TYPE;
nr_atendimento_w		prescr_medica.nr_atendimento%TYPE;
nr_dia_util_w			prescr_material.nr_dia_util%TYPE;
cd_pessoa_fisica_w		prescr_medica.cd_pessoa_fisica%TYPE;
qt_dias_sem_antibiotico_w parametro_medico.qt_dias_antibiotico%TYPE;
qt_total_dias_lib_w		prescr_material.qt_total_dias_lib%type;
ie_atb_pessoa_w			varchar(1);
ie_dias_util_medic_w	material.ie_dias_util_medic%type;



BEGIN


cd_perfil_w				:= coalesce(obter_perfil_ativo,0);
cd_estabelecimento_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);


SELECT 	MAX(dt_prescricao),
		MAX(nr_atendimento),
		MAX(cd_pessoa_fisica)
INTO STRICT   	dt_prescricao_w,
		nr_atendimento_w,
		cd_pessoa_fisica_w
FROM   	prescr_medica
WHERE  	nr_prescricao = nr_prescricao_p;


SELECT	coalesce(MAX(ie_atb_pessoa),'N'),
	coalesce(MAX(qt_dias_antibiotico),1)
INTO STRICT	ie_atb_pessoa_w,
	qt_dias_sem_antibiotico_w
FROM	parametro_medico
WHERE	cd_estabelecimento	= cd_estabelecimento_w;

SELECT	MAX(cd_material)
INTO STRICT 	cd_material_w
FROM  	prescr_material
WHERE 	nr_sequencia 		= nr_seq_material_p
AND	  	nr_prescricao 		= nr_prescricao_p;

select	coalesce(max(ie_dias_util_medic),'N')
into STRICT	ie_dias_util_medic_w
from	material
where	cd_material	= cd_material_w;

dt_posterior_w	:=	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prescricao_w) + qt_dias_liberados_p + qt_dias_sem_antibiotico_w;



SELECT	MAX(a.nr_dia_util),
	MAX(a.qt_total_dias_lib)
INTO STRICT	nr_dia_util_w,
	qt_total_dias_lib_w
FROM 	prescr_material a,
		prescr_medica b
WHERE 	a.nr_prescricao   = b.nr_prescricao
AND		a.cd_material 	  = cd_material_w
AND 	a.ie_suspenso	  <> 'S'
--and  	nvl(a.qt_dias_solicitado,0) > 0
AND 	coalesce(ie_ciclo_reprov,'N') = 'N'
AND		((b.dt_inicio_prescr BETWEEN dt_prescricao_w AND dt_posterior_w) OR (b.dt_prescricao BETWEEN dt_prescricao_w AND dt_posterior_w))
AND		((coalesce(ie_atb_pessoa_w,'N') = 'S' AND b.cd_pessoa_fisica	= cd_pessoa_fisica_w) OR (coalesce(ie_atb_pessoa_w,'N') = 'N' AND b.nr_atendimento	= nr_atendimento_w))
ORDER BY 1;


if (ie_dias_util_medic_w = 'O') then
	if (nr_dia_util_w > qt_total_dias_lib_w) then
		nr_dia_util_w :=  (nr_dia_util_w - qt_total_dias_lib_w) + 1;
	elsif (nr_dia_util_w = qt_total_dias_lib_w) then
		nr_dia_util_w := 1;
	end if;
elsif (ie_dias_util_medic_w = 'S') then
	if (nr_dia_util_w > qt_total_dias_lib_w) then
		nr_dia_util_w :=  nr_dia_util_w - qt_total_dias_lib_w;
	end if;
end if;


RETURN nr_dia_util_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_max_nr_dia_util (nr_prescricao_p bigint, nr_seq_material_p bigint, qt_dias_liberados_p bigint) FROM PUBLIC;

