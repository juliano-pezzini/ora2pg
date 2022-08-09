-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_copia_prescricao_regra_js ( dt_inicio_plano_p timestamp, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_regra_p bigint, cd_medico_p text, dt_prescricao_p timestamp, cd_perfil_p bigint, ds_log_p INOUT text, nr_prescr_copia_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_prescricao_nova_w	bigint;
ds_log_w		varchar(255);
qt_dias_w		bigint;

BEGIN
if (dt_inicio_plano_p IS NOT NULL AND dt_inicio_plano_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	 
	select	coalesce(max(nr_prescricao),0), 
		coalesce(max(qt_dias_extensao),1) 
	into STRICT	nr_prescricao_nova_w, 
		qt_dias_w 
	from	prescr_medica 
	where	dt_inicio_prescr	= dt_inicio_plano_p 
	and	nr_atendimento		= nr_atendimento_p 
	and	nm_usuario_original	= nm_usuario_p 
	and	coalesce(coalesce(dt_liberacao_medico, dt_liberacao)::text, '') = '';
	 
	if (nr_prescricao_nova_w = 0) then 
		begin 
		nr_prescricao_nova_w := plt_copia_prescricao_regra( 
			nr_prescricao_p, nr_atendimento_p, nr_seq_regra_p, nm_usuario_p, cd_medico_p, dt_prescricao_p, '', to_char(dt_inicio_plano_p,'hh24:mi'), cd_perfil_p, null, null, nr_prescricao_nova_w, null, null, null);
		ds_log_w	:= obter_desc_expressao(305768)/*'Prescr orig='*/
 || nr_prescricao_nova_w;
		end;
	end if;
	end;
end if;
commit;
ds_log_p		:= ds_log_w;
nr_prescr_copia_p	:= nr_prescricao_nova_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_copia_prescricao_regra_js ( dt_inicio_plano_p timestamp, nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_regra_p bigint, cd_medico_p text, dt_prescricao_p timestamp, cd_perfil_p bigint, ds_log_p INOUT text, nr_prescr_copia_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
