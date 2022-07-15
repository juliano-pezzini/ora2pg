-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_after_liberar_prescricao (nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint default null, nm_usuario_validacao_p text default null) AS $body$
DECLARE


dt_liberacao_medico_w	prescr_medica.dt_liberacao_medico%type;
dt_liberacao_w			prescr_medica.dt_liberacao%type;


BEGIN

if (coalesce(nr_prescricao_p,0) > 0) then

	select 	max(dt_liberacao_medico),
			max(dt_liberacao)
	into STRICT	dt_liberacao_medico_w,
			dt_liberacao_w
	from prescr_medica
	where nr_prescricao = nr_prescricao_p;
	
	CALL consiste_aferese_terapeutica( nr_prescricao_p, cd_estabelecimento_p, nm_usuario_p);	
	
	if (dt_liberacao_medico_w IS NOT NULL AND dt_liberacao_medico_w::text <> '') or (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then			
		CALL gerar_san_sangria_terapeutica( nr_prescricao_p, nm_usuario_p);		
	end if;

	If (coalesce(nr_atendimento_p,0) > 0) then
		CALL cpoe_gerar_dispositivo(nr_prescricao_p,nr_atendimento_p,nm_usuario_p);
	end if;
	
	if (nm_usuario_validacao_p IS NOT NULL AND nm_usuario_validacao_p::text <> '') then
		cpoe_gerar_prescr_medica_compl(nr_prescricao_p,nm_usuario_p,nm_usuario_validacao_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_after_liberar_prescricao (nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint default null, nm_usuario_validacao_p text default null) FROM PUBLIC;

