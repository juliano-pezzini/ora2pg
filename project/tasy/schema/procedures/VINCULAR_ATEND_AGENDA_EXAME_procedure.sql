-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_atend_agenda_exame ( nr_seq_agenda_p bigint, nr_atend_agenda_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w	bigint;
vl_parametro_w		varchar(255);
ie_proc_cpoe_w		varchar(1);


BEGIN 
 
if (nr_seq_agenda_p > 0) then 
	begin	 
	if (coalesce(nr_atend_agenda_p::text, '') = '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
		nr_atendimento_w	:= nr_atendimento_p;
	else 
		nr_atendimento_w	:= null;
	end if;
 
	CALL vincular_atend_agenda(2, nr_seq_agenda_p, nr_atendimento_w, nm_usuario_p);
		 
	if (coalesce(nr_atend_agenda_p::text, '') = '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
		CALL executar_evento_agenda_geral('VA', null, nr_seq_agenda_p, 2, cd_estabelecimento_p, nm_usuario_p);
	end if;
 
	vl_parametro_w := Obter_Param_Usuario(820, 135, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	 
	select 	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
	into STRICT 	ie_proc_cpoe_w 
	from 	cpoe_procedimento 
	where 	nr_seq_agenda = nr_seq_agenda_p;
	 
	if (vl_parametro_w = 'S') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_proc_cpoe_w = 'N') then		 
		CALL gerar_prescricao_atend_exame(nr_atendimento_p, clock_timestamp(),	nr_seq_agenda_p, nm_usuario_p, cd_setor_atendimento_p, 'Usuário'); -- Usuário 
	end if;
	 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_atend_agenda_exame ( nr_seq_agenda_p bigint, nr_atend_agenda_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

