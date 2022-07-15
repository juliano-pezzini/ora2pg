-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_atend_paci_uni_eup_js ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, dt_passagem_p timestamp, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
vl_parametro_w		varchar(1);
qt_atend_paci_uni_w	bigint;
nr_seq_interno_w	bigint;
			

BEGIN 
 
vl_parametro_w := obter_param_usuario(916, 127, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
 
select  count(*) 
into STRICT	 qt_atend_paci_uni_w 
from   atend_paciente_unidade 
where  nr_atendimento = nr_atendimento_p;
 
if (vl_parametro_w = 'S')and (qt_atend_paci_uni_w = 0)then 
	begin 
	 
	CALL gerar_passagem_setor_atend(	nr_atendimento_p, 
					cd_setor_atendimento_p, 
					dt_passagem_p, 
					'S', 
					nm_usuario_p);
					 
	select 	coalesce(max(nr_seq_interno),0) 
	into STRICT	nr_seq_interno_w 
	from 	atend_paciente_unidade 
	where 	nr_atendimento = nr_atendimento_p;
	 
	if (nr_seq_interno_w > 0)then 
		begin 
		 
		CALL atend_paciente_unid_afterpost(	nr_seq_interno_w, 
						'I', 
						nm_usuario_p);
		 
		end;
	end if;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_atend_paci_uni_eup_js ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, dt_passagem_p timestamp, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

