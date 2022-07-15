-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_obter_dias_liberados_cih (nr_seq_cpoe_p bigint, cd_material_p bigint, nm_usuario_p text, ie_objetivo_p text, ie_lib_auto_p text, qt_dias_solicitado_p bigint, nr_dia_util_p bigint, dt_fim_cih_p INOUT timestamp, qt_dias_liberado_p INOUT bigint, dt_inicio_p timestamp default null) AS $body$
DECLARE


ie_justifica_dias_util_w 	varchar(1);
qt_dias_lib_padrao_w		integer;
qt_dia_terapeutico_w		material.qt_dia_terapeutico%type;
qt_dia_profilatico_w		material.qt_dia_profilatico%type;
ie_dias_util_medic_w 	    material.ie_dias_util_medic%type;
qt_dias_liberado_w          cpoe_material.qt_dias_liberado%type;
cd_estabelecimento_w		bigint;
ie_param67_cih_w			varchar(5);
dt_inicio_cih_w             timestamp;


BEGIN

cd_estabelecimento_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
ie_param67_cih_w := Obter_param_Usuario(896, 67, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_param67_cih_w);

select	coalesce(max(qt_dias_lib_padrao),0)
into STRICT	qt_dias_lib_padrao_w
from	parametro_medico
where   cd_estabelecimento = cd_estabelecimento_w;

select	coalesce(obter_dados_medic_atb_var(max(cd_material),cd_estabelecimento_w,max(ie_justifica_dias_util),'JD',null,null,null),'N'),
		coalesce(max(qt_dia_terapeutico),0),
		coalesce(max(qt_dia_profilatico),0),
		coalesce(max(ie_dias_util_medic),'N')
into STRICT	ie_justifica_dias_util_w,
		qt_dia_terapeutico_w,
		qt_dia_profilatico_w,
		ie_dias_util_medic_w
from	material
where	cd_material = cd_material_p;

if	((ie_lib_auto_p = 'S') or (ie_justifica_dias_util_w = 'S')) then
	if (qt_dias_lib_padrao_w > 0) then
		if (ie_objetivo_p	in ('F','P','C')) and (qt_dia_profilatico_w	> 0) and (qt_dias_lib_padrao_w	> qt_dia_profilatico_w) then
			qt_dias_liberado_w	:= qt_dia_profilatico_w;
		elsif (ie_objetivo_p	in ('T','D','E')) and (qt_dia_terapeutico_w	> 0) and (qt_dias_lib_padrao_w	> qt_dia_terapeutico_w) then
			qt_dias_liberado_w	:= qt_dia_terapeutico_w;
		else
			if (coalesce(qt_dias_liberado_w,0) < qt_dias_lib_padrao_w) then
				qt_dias_liberado_w	:= qt_dias_lib_padrao_w;
			end if;
		end if;
	else
		qt_dias_liberado_w	:= qt_dias_solicitado_p;
	end if;

	if (qt_dias_liberado_w = 0) then
		qt_dias_liberado_w	:= null;
	end if;
end if;

if ((ie_param67_cih_w = 'S' AND ( or
      )) or (ie_param67_cih_w = 'N')) then

    if (coalesce(qt_dias_liberado_w, 0) >= 1) then
        dt_inicio_cih_w := cpoe_obter_inicio_cih_detail(nr_seq_cpoe_p, clock_timestamp(), null, dt_inicio_p);
    else
        dt_inicio_cih_w := clock_timestamp();
    end if;

    qt_dias_liberado_p := coalesce(qt_dias_liberado_w, 0);
    dt_fim_cih_p := dt_inicio_cih_w + coalesce(qt_dias_liberado_w, 0) - 1/86400;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_obter_dias_liberados_cih (nr_seq_cpoe_p bigint, cd_material_p bigint, nm_usuario_p text, ie_objetivo_p text, ie_lib_auto_p text, qt_dias_solicitado_p bigint, nr_dia_util_p bigint, dt_fim_cih_p INOUT timestamp, qt_dias_liberado_p INOUT bigint, dt_inicio_p timestamp default null) FROM PUBLIC;

