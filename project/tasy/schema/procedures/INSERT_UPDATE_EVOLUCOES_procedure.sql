-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_update_evolucoes ( nm_usuario_p text, cd_evolucao_p INOUT bigint, cd_pessoa_fisica_p text default null, ie_tipo_evolucao_p text DEFAULT NULL, ds_evolucao_p text  DEFAULT NULL, nr_atendimento_p bigint default null, ie_exige_liberacao text default null, CD_MEDICO_P text default null, cd_perfil_ativo_p bigint DEFAULT NULL) AS $body$
DECLARE

dt_liberacao_w timestamp := null;
cd_evolucao_w bigint;
ie_existe_evol_w varchar(1);
ie_tipo_evolucao_w varchar(3);
ie_prof_evol_w bigint;
cd_medico_resp_w varchar(10);
ie_usuario_medico_w varchar(1);


BEGIN 
cd_evolucao_w := cd_evolucao_p;
ie_prof_evol_w := obter_param_usuario(281, 336, cd_perfil_ativo_p, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_prof_evol_w);
ie_usuario_medico_w := obter_se_usuario_medico(nm_usuario_p);
 
ie_prof_evol_w := coalesce(ie_prof_evol_w,1);
 
select	coalesce(max('S'),'N') 
into STRICT	ie_existe_evol_w 
from	evolucao_paciente 
where	cd_evolucao = cd_evolucao_p;
 
if (cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '' AND ie_existe_evol_w = 'S') then 
	 update evolucao_paciente 
	 set nm_usuario  = nm_usuario_p, 
	  dt_atualizacao  = clock_timestamp(), 
	  ie_evolucao_clinica = ie_tipo_evolucao_p, 
	  ds_evolucao  = ds_evolucao_p 
	 where cd_evolucao  = cd_evolucao_p;
else 
	if (ie_prof_evol_w = 1) then 
		select	max(ie_tipo_evolucao) 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	nm_usuario = nm_usuario_p;
	elsif (ie_prof_evol_w = 2) and (nr_atendimento_p > 0) then 
		cd_medico_resp_w := obter_medico_resp_atend(nr_atendimento_p,'C');
 
		select	max(ie_tipo_evolucao) 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	cd_pessoa_fisica = cd_medico_resp_w;
	elsif (ie_prof_evol_w = 3) and (ie_usuario_medico_w = 'N') then 
		select	max(ie_tipo_evolucao) 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	cd_pessoa_fisica = cd_medico_p;
	elsif (ie_prof_evol_w = 4) then 
		select	max(ie_tipo_evolucao) 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	cd_pessoa_fisica = cd_medico_p;
	elsif (ie_prof_evol_w = 5) then 
		select	max(ie_tipo_evolucao) 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	nm_usuario = nm_usuario_p;
	end if;
 
	if (ie_tipo_evolucao_w = '') then 
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(12171);
	end if;
 
	 select nextval('evolucao_paciente_seq') 
	 into STRICT cd_evolucao_w 
	;
	 insert into evolucao_paciente(cd_evolucao, 
			 cd_pessoa_fisica, 
			 nm_usuario, 
			 nm_usuario_nrec, 
			 dt_atualizacao, 
			 dt_atualizacao_nrec, 
			 dt_evolucao, 
			 ie_evolucao_clinica, 
			 ds_evolucao, 
			 nr_atendimento, 
			 ie_palm,    
			 cd_medico, 
			 cd_perfil_ativo, 
			 ie_situacao, 
			 ie_tipo_evolucao) 
	  values (cd_evolucao_w, 
			 cd_pessoa_fisica_p, 
			 nm_usuario_p, 
			 nm_usuario_p, 
			 clock_timestamp(), 
			 clock_timestamp(), 
			 clock_timestamp(), 
			 ie_tipo_evolucao_p, 
			 ds_evolucao_p, 
			 nr_atendimento_p, 
			 'S', 
			 cd_medico_p, 
			 cd_perfil_ativo_p, 
			 'A', 
			 ie_tipo_evolucao_w);
end if;
if (ie_exige_liberacao = 'S') then 
	CALL liberar_evolucao(cd_evolucao_w, nm_usuario_p);
end if;
 
cd_evolucao_p := cd_evolucao_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_update_evolucoes ( nm_usuario_p text, cd_evolucao_p INOUT bigint, cd_pessoa_fisica_p text default null, ie_tipo_evolucao_p text DEFAULT NULL, ds_evolucao_p text  DEFAULT NULL, nr_atendimento_p bigint default null, ie_exige_liberacao text default null, CD_MEDICO_P text default null, cd_perfil_ativo_p bigint DEFAULT NULL) FROM PUBLIC;

