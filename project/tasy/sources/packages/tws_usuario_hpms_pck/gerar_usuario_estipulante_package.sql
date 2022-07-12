-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tws_usuario_hpms_pck.gerar_usuario_estipulante ( nm_usuario_web_p usuario.nm_usuario%type, ds_email_p wsuite_usuario.ds_email%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_grupo_contrato_p pls_grupo_contrato.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_subestipulante_p pls_sub_estipulante.nr_sequencia%type, nr_seq_perfil_p wsuite_perfil.nr_sequencia%type, ds_seqs_cont_grupo_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_usuario_p INOUT wsuite_usuario.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Criar usuario estipulante nas tabelas do security e TWS.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ x ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros: TWS
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


C01 CURSOR FOR
 	SELECT	a.id id_application,
		(SELECT d.id from datasource d where  d.nm_datasource = 'WTASY' and d.id_application = a.id) id_data_source,
		(select c.id from client c where  c.nm_client = 'stipulator' and c.id_application = a.id) id_client,
		(select r.id from role r where  r.nm_role = 'stipulator' and r.id_application = a.id) id_role				
	from	application a
	where   nm_application = 'hpms';
	
id_subject_w			subject.id%type;
application_w			application.id%type;
ds_login_w			subject.ds_login%type;	
ds_senha_w			subject.ds_password%type;
ds_salt_w			subject.ds_salt%type;
nr_seq_grupo_contrato_web_w	pls_grupo_contrato_web.nr_sequencia%type;
ds_hash_ativacao_w		wsuite_usuario.ds_hash_ativacao%type;

BEGIN

select	count(1)
into STRICT	application_w			
from	application a
where   nm_application = 'hpms';

select	max(a.id)
into STRICT	id_subject_w
from    subject a,
	subject_client b,
	client c
where   b.id_subject = a.id
and     b.id_client = c.id
and     a.ds_replacement_login = nm_usuario_web_p
and     c.nm_client = 'stipulator';

if (application_w = 0 ) then
	/* Aplicacao HPMS nao encontrada */


	CALL wheb_mensagem_pck.exibir_mensagem_abort(1090118);
end if;


if ( coalesce(id_subject_w::text, '') = '') and	
	((nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') or (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') or (nr_seq_grupo_contrato_p IS NOT NULL AND nr_seq_grupo_contrato_p::text <> '')) then
	
	nr_seq_grupo_contrato_web_w := tws_usuario_hpms_pck.gerar_grupo_contrato_web(	nr_seq_grupo_contrato_p, cd_pessoa_fisica_p, nm_usuario_web_p, nr_seq_contrato_p, nr_seq_intercambio_p, ds_seqs_cont_grupo_p, nr_seq_subestipulante_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_grupo_contrato_web_w);		
		
	if (nr_seq_grupo_contrato_web_w IS NOT NULL AND nr_seq_grupo_contrato_web_w::text <> '') then
		for c01_w in C01 loop	
		
			if ( coalesce(c01_w.id_application::text, '') = '' or  coalesce(c01_w.id_data_source::text, '') = '' or coalesce(c01_w.id_client::text, '') = '' or  coalesce(c01_w.id_role::text, '') = '' ) then			
				/* Configuracao HPMS nao encontrada */


				CALL wheb_mensagem_pck.exibir_mensagem_abort(1090119);
			end if;
			
			select 	replace(replace(dbms_random.string('P', 15), chr(39), ''), ';', '')
			into STRICT	ds_salt_w
			;

			ds_senha_w	:= obter_sha2(ds_salt_w, 256);
			
			select	'TWS-' || substr('00000000000' || TO_CHAR(nextval('tws_dslogin_sequence')),-11,11)
			into STRICT 	ds_login_w
			;

			ds_hash_ativacao_w	:= wsuite_login_pck.wsuite_generate_hash;
			
			INSERT INTO subject(	id,
						dt_creation,
						dt_modification,
						ds_login,
						nm_subject,
						ds_password,
						ds_salt,
						dt_password_modification,
						vl_auth_type,
						ds_replacement_login,
						ds_alternative_login,
						vl_password_style
				) VALUES (	psa_uuid_generator,
						clock_timestamp(),
						clock_timestamp(),
						ds_login_w,
						( select pf.nm_pessoa_fisica from pessoa_fisica pf where pf.cd_pessoa_fisica = cd_pessoa_fisica_p),
						ds_senha_w,
						ds_salt_w,
						clock_timestamp(),
						0,
						nm_usuario_web_p,
						null,
						1) RETURNING id INTO STRICT id_subject_w;
			
			/* Links the subject to the application*/


			insert into application_subject(id_application, id_subject
			) values (			c01_w.id_application, id_subject_w);			
		
			/* Links the subject to the datasource */


			insert into subject_datasource(	id, dt_creation, dt_modification, id_subject,
								id_datasource, vl_activation_status, vl_attempts_so_far
			) values (				psa_uuid_generator, clock_timestamp(), clock_timestamp(), id_subject_w, 
								c01_w.id_data_source, 0, 0);
		
			/* Links the subject to the client */


			insert into subject_client( 	id, id_subject,  id_client,
							dt_creation, dt_modification, vl_activation_status, vl_attempts_so_far
			) values ( 			psa_uuid_generator, id_subject_w, c01_w.id_client,
							clock_timestamp(), clock_timestamp(), 0, 0);
				
			insert into subject_role( 	id_subject, id_role, dt_creation,
							dt_modification
			) values ( 			id_subject_w, c01_w.id_role, clock_timestamp(),
							clock_timestamp());	
					
			insert	into wsuite_usuario(	nr_sequencia, ie_situacao, cd_estabelecimento,
							nm_usuario_web, cd_pessoa_fisica, dt_atualizacao,
							nm_usuario, dt_atualizacao_nrec,
							id_subject, ds_login, ds_alternative_login,
							dt_ativacao, dt_criacao, ds_email,
							nr_seq_grupo_contrato_web, nr_seq_perfil_wsuite, ds_hash_ativacao
					) values (	nextval('wsuite_usuario_seq'),'I', cd_estabelecimento_p,
							nm_usuario_web_p, cd_pessoa_fisica_p, clock_timestamp(),
							nm_usuario_p,  clock_timestamp(),
							id_subject_w, ds_login_w, null,
							null, clock_timestamp(), ds_email_p,
							nr_seq_grupo_contrato_web_w, nr_seq_perfil_p, ds_hash_ativacao_w) returning nr_sequencia INTO nr_seq_usuario_p;	
							
			commit;		
		end loop;
	end if;
else	
	/* Aplicacao HPMS nao encontrada */


	CALL wheb_mensagem_pck.exibir_mensagem_abort(1090118);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_usuario_hpms_pck.gerar_usuario_estipulante ( nm_usuario_web_p usuario.nm_usuario%type, ds_email_p wsuite_usuario.ds_email%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_grupo_contrato_p pls_grupo_contrato.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_subestipulante_p pls_sub_estipulante.nr_sequencia%type, nr_seq_perfil_p wsuite_perfil.nr_sequencia%type, ds_seqs_cont_grupo_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_usuario_p INOUT wsuite_usuario.nr_sequencia%type) FROM PUBLIC;