-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_focuslost_vigencia_js ( dt_final_vigencia_p timestamp, dt_inicio_vigencia_p timestamp, qt_dia_internacao_p bigint, ie_completo_p text, cd_convenio_p bigint, ie_atributo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_final_vig_ret_p INOUT timestamp) AS $body$
DECLARE

 
ie_calcula_vigencia_w	varchar(1);
ie_dias_vigencia_w		varchar(1);
qt_adicional_w		integer := 0;		
qt_dias_validade_guia_w	integer;			
			 

BEGIN 
 
ie_calcula_vigencia_w := Obter_param_Usuario(916, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_calcula_vigencia_w);
 
if (ie_completo_p = 'S') then 
	 
	if	((ie_calcula_vigencia_w = 'S') or (ie_calcula_vigencia_w = 'R')) then 
		 
		select	coalesce(max(ie_cons_dia_int_vig),'N') 
		into STRICT	ie_dias_vigencia_w 
		from 	convenio_estabelecimento 
    where	cd_convenio = cd_convenio_p 
    and  	cd_estabelecimento = cd_estabelecimento_p;
		 
		if (coalesce(ie_dias_vigencia_w,'N') = 'S') then 
			qt_adicional_w := -1;
		end if;
 
		if 	((ie_atributo_p = 'DT_INICIO_VIGENCIA') or (ie_atributo_p = 'QT_DIA_INTERNACAO')) and (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') and (qt_dia_internacao_p IS NOT NULL AND qt_dia_internacao_p::text <> '') then 
			dt_final_vig_ret_p := dt_inicio_vigencia_p + qt_dia_internacao_p + (coalesce(qt_adicional_w,0));
		end if;
	end if;
	 
	if (ie_atributo_p = 'DT_INICIO_VIGENCIA') and (coalesce(qt_dia_internacao_p::text, '') = '') and (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') and (coalesce(dt_final_vig_ret_p::text, '') = '') and (coalesce(dt_final_vigencia_p::text, '') = '') then 
	 
		select	coalesce(max(qt_dias_validade_guia),0) 
		into STRICT	qt_dias_validade_guia_w 
        	from	tiss_parametros_convenio 
        	where	cd_convenio     = cd_convenio_p 
        	and	cd_estabelecimento  = cd_estabelecimento_p;
		 
		if (qt_dias_validade_guia_w > 0) then 
		 
			dt_final_vig_ret_p := dt_inicio_vigencia_p + qt_dias_validade_guia_w;
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_focuslost_vigencia_js ( dt_final_vigencia_p timestamp, dt_inicio_vigencia_p timestamp, qt_dia_internacao_p bigint, ie_completo_p text, cd_convenio_p bigint, ie_atributo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, dt_final_vig_ret_p INOUT timestamp) FROM PUBLIC;

