-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_atend_pac_unidade_js ( nr_atendimento_p bigint, ie_gerar_passagem_p text, cd_setor_atendimento_p bigint, dt_passagem_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
qt_atend_w		bigint;
nr_seq_interno_w	bigint;


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')then 
	begin 
	 
	select count(*) 
	into STRICT	qt_atend_w 
	from  atend_paciente_unidade 
	where  nr_atendimento = nr_atendimento_p;
	 
	if (ie_gerar_passagem_p = 'S')and (qt_atend_w = 0)then 
		begin 
		 
		CALL gerar_passagem_setor_atend(nr_atendimento_p, cd_setor_atendimento_p, dt_passagem_p, 'S', nm_usuario_p);
		 
		select 	coalesce(max(nr_seq_interno),0) 
		into STRICT	nr_seq_interno_w 
		from 	atend_paciente_unidade 
		where 	nr_atendimento = nr_atendimento_p;
		 
		if (nr_seq_interno_w > 0)then 
			begin 
			 
			CALL atend_paciente_unid_afterpost(nr_seq_interno_w, 'I', nm_usuario_p);
			 
			end;
		end if;
		 
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
-- REVOKE ALL ON PROCEDURE gravar_atend_pac_unidade_js ( nr_atendimento_p bigint, ie_gerar_passagem_p text, cd_setor_atendimento_p bigint, dt_passagem_p timestamp, nm_usuario_p text) FROM PUBLIC;

