-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tws_usuario_hpms_pck.gerar_usuario_health_insur ( nm_usuario_tasy_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Procedure utilizada para geracao do usuario para o portal da operadora.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */



C01 CURSOR FOR
 	SELECT	a.id id_application,
		(SELECT d.id from datasource d where  d.nm_datasource = 'WTASY' and d.id_application = a.id) id_data_source,
		(select c.id from client c where  c.nm_client = 'healthInsurance' and c.id_application = a.id) id_client,
		(select r.id from role r where  r.nm_role = 'healthInsurance' and r.id_application = a.id) id_role				
	from	application a
	where   nm_application = 'hpms';
	

C02 CURSOR( 	id_subject_c		subject.id%type,
		id_data_source_c	datasource.id%type,
		id_client_c		client.id%type,
		id_role_c		role.id%type) FOR
 	SELECT (SELECT count(1) from	application_subject a where a.id_subject = id_subject_c and a.id_application = a.id ) app_subject,
		(select count(1) from	subject_datasource s where s.id_subject = id_subject_c and s.id_datasource = id_data_source_c ) sub_datasource,		
		(select count(1) from	subject_client c where c.id_subject = id_subject_c and c.id_client = id_client_c ) sub_client,
		(select count(1) from	subject_role r where r.id_subject = id_subject_c and r.id_role =  id_role_c ) sub_role,
		(select count(1) from	wsuite_usuario w where	w.id_subject = id_subject_c) user_wsuite
	from	application a
	where   nm_application = 'hpms';
	
	
	
id_subject_w	subject.id%type;
application_w	application.id%type;

BEGIN


select	count(1)
into STRICT	application_w			
from	application a
where   nm_application = 'hpms';

select 	max(s.id )
into STRICT	id_subject_w
from   	subject s
where  	s.ds_login = nm_usuario_tasy_p;

if (application_w = 0 ) then
	/* Aplicacao HPMS nao encontrada */


	CALL wheb_mensagem_pck.exibir_mensagem_abort(1090118);
end if;

if (id_subject_w IS NOT NULL AND id_subject_w::text <> '') then

	for c01_w in C01 loop		
		if ( coalesce(c01_w.id_application::text, '') = '' or  coalesce(c01_w.id_data_source::text, '') = '' or coalesce(c01_w.id_client::text, '') = '' or  coalesce(c01_w.id_role::text, '') = '' ) then			
			/* Configuracao HPMS nao encontrada */


			CALL wheb_mensagem_pck.exibir_mensagem_abort(1090119);
		end if;
				
		for c02_w in C02( id_subject_w, c01_w.id_data_source, c01_w.id_client, c01_w.id_role )  loop		
			
			if ( c02_w.app_subject = 0 ) then
				/* Links the subject to the application*/


				insert into application_subject(
					id_application, id_subject
				) values (
					c01_w.id_application, id_subject_w);
			
			end if;			
			
			if ( c02_w.sub_datasource = 0 ) then
				/* Links the subject to the datasource */


				insert into subject_datasource(
				    id, dt_creation, dt_modification, id_subject,
				    id_datasource, vl_activation_status, vl_attempts_so_far
				) values (
				    psa_uuid_generator, clock_timestamp(), clock_timestamp(), id_subject_w, 
				    c01_w.id_data_source, 0, 0);
			end if;
						
			if ( c02_w.sub_client = 0 ) then
				/* Links the subject to the client */


				insert into subject_client(
				    id, id_subject,  id_client,
				    dt_creation, dt_modification, vl_activation_status, vl_attempts_so_far
				) values (
				    psa_uuid_generator, id_subject_w, c01_w.id_client,
				    clock_timestamp(), clock_timestamp(), 0, 0);
			end if;
			
			if ( c02_w.sub_role = 0 ) then			
				insert into subject_role(
				    id_subject, id_role, dt_creation,
				    dt_modification
				) values (
				    id_subject_w, c01_w.id_role, clock_timestamp(),
				    clock_timestamp());	
			end if;
			    			   
			if ( c02_w.user_wsuite = 0 ) then
				insert	into wsuite_usuario(
					nr_sequencia, ie_situacao, cd_estabelecimento,
					nm_usuario_web, cd_pessoa_fisica, dt_atualizacao,
					nm_usuario, dt_atualizacao_nrec,
					id_subject, ds_login, ds_alternative_login,
					dt_ativacao, dt_criacao
				) values (
					nextval('wsuite_usuario_seq'),'A', cd_estabelecimento_p,
					nm_usuario_tasy_p, cd_pessoa_fisica_p, clock_timestamp(),
					nm_usuario_tasy_p,  clock_timestamp(), 
					id_subject_w, nm_usuario_tasy_p, null,
					clock_timestamp(), clock_timestamp());	
			end if;
			
			commit;
		end loop;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_usuario_hpms_pck.gerar_usuario_health_insur ( nm_usuario_tasy_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;
