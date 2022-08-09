-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_paciente_agenda_setor (cd_agenda_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_setor_atendimento_w		bigint;
nr_sequencia_w			bigint;


BEGIN 
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	begin 
 
	select	coalesce(max(CD_SETOR_EXCLUSIVO), 0) 
	into STRICT	cd_setor_atendimento_w 
	from	agenda 
	where	cd_agenda	= cd_agenda_p;
 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_sequencia_w 
	from	agenda_paciente_setor 
	where	cd_setor_atendimento	= cd_setor_atendimento_w 
	and	cd_pessoa_fisica	= cd_pessoa_fisica_p;
 
	if (cd_setor_atendimento_w <> 0) and (nr_sequencia_w = 0) then	 
		begin 
 
		select	nextval('agenda_paciente_setor_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		insert	into agenda_paciente_setor(NR_SEQUENCIA     , 
			CD_PESSOA_FISICA    , 
			CD_SETOR_ATENDIMENTO  , 
			DT_ATUALIZACAO     ,  
			NM_USUARIO       , 
			DT_ATUALIZACAO_NREC  , 
			NM_USUARIO_NREC    ) 
		values (nr_sequencia_w, 
			cd_pessoa_fisica_p, 
			cd_setor_atendimento_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
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
-- REVOKE ALL ON PROCEDURE gravar_paciente_agenda_setor (cd_agenda_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
