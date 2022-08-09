-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mapa_automatico ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_refeicao_w			valor_dominio.vl_dominio%type;
ie_copiar_todas_dietas_w	varchar(1);
qt_horas_prescr_w		bigint;
qt_horas_w			bigint;
ie_copiar_dieta_prescr_w	varchar(5);
	
C01 CURSOR FOR 
	SELECT	distinct 
		v.vl_dominio 
	from	valor_dominio v, 
		horario_refeicao_dieta h 
	where	h.cd_refeicao = v.vl_dominio 
	and	v.cd_dominio = 99 
	and	coalesce(h.ie_situacao,'A') = 'A' 
	and	(h.ds_horario_auto IS NOT NULL AND h.ds_horario_auto::text <> '') 
	and	clock_timestamp() >= to_date(to_char(clock_timestamp(),'dd/mm/yyyy')||h.ds_horario_auto,'dd/mm/yyyy hh24:mi:ss') 
	and	clock_timestamp() < to_date(to_char(clock_timestamp(),'dd/mm/yyyy')||h.ds_horario_auto,'dd/mm/yyyy hh24:mi:ss') + 5/1440;
	/*or not exists (	select 	1 
			from	mapa_dieta a 
			where	trunc(a.dt_dieta) = trunc(sysdate) 
			and	a.cd_refeicao = h.cd_refeicao));*/
				 

BEGIN 
 
ie_copiar_todas_dietas_w := obter_param_usuario(1000, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_copiar_todas_dietas_w);
qt_horas_prescr_w := obter_param_usuario(1000, 9, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_horas_prescr_w);
ie_copiar_dieta_prescr_w := obter_param_usuario(1000, 100, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_copiar_dieta_prescr_w);
 
open C01;
loop 
fetch C01 into	 
	cd_refeicao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_copiar_todas_dietas_w <> 'N') or (ie_copiar_dieta_prescr_w = 'S') then 
		qt_horas_w	:= coalesce(qt_horas_prescr_w,0);
	else	 
		qt_horas_w	:= 0;
	end if;
	 
	CALL gerar_mapa_dieta(	0, 
				nm_usuario_p, 
				trunc(clock_timestamp()), 
				cd_refeicao_w, 
				qt_horas_w, 
				cd_estabelecimento_p, 
				'N');
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mapa_automatico ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
