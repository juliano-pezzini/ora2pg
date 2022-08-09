-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE isolar_liberar_isolamento (nm_usuario_p text, ie_status_p text, nr_atendimento_p text) AS $body$
DECLARE

 
				   
nr_seq_interno_w		bigint;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);	
cd_setor_atendimento_w		integer;	
				   

BEGIN 
 
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	 
update	atendimento_paciente 
set	ie_paciente_isolado = ie_status_p, 
	dt_atualizacao	  = clock_timestamp(), 
	nm_usuario	  = nm_usuario_p 
where	nr_atendimento   = nr_atendimento_p;	
	 
	 
	if (ie_status_p = 'N') then 
		begin 
	 
		select cd_unidade_basica, 
			cd_unidade_compl, 
			cd_setor_atendimento 
		into STRICT	cd_unidade_basica_w, 
			cd_unidade_compl_w, 
			cd_setor_atendimento_w 
		from	atend_paciente_unidade 
		where	nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p,'A');
 
		select	nr_seq_interno 
		into STRICT	nr_seq_interno_w 
		from	unidade_atendimento 
		where	cd_unidade_basica		= cd_unidade_basica_w 
		and	cd_unidade_compl		= cd_unidade_compl_w 
		and	cd_setor_atendimento		= cd_setor_atendimento_w;
		 
		CALL gerar_higienizacao_leito_unid(clock_timestamp(), nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento,'IS',nr_seq_interno_w,null);
		end;
	end if;
	 
 
commit;
		 
	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE isolar_liberar_isolamento (nm_usuario_p text, ie_status_p text, nr_atendimento_p text) FROM PUBLIC;
