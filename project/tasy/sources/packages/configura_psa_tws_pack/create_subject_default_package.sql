-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE configura_psa_tws_pack.create_subject_default ( id_datasource_p datasource.id%type, id_application_p application.id%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: GUEST PROFILE CREATION
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
id_dsrole_guest         	datasource_role.id%type;
id_app_subject       		subject.id%type;
nm_email_subject		subject.ds_email%type;

id_subject_datasource   	subject_datasource.id%TYPE;
qt_application_subject_w 	integer;
qt_subject_datasource_role_w 	integer;


BEGIN

select  max(a.id)
into STRICT	id_dsrole_guest
from    datasource_role a,
        role b
where   a.id_role = b.id
and     b.nm_role = 'guest'
and     b.id_application = id_application_p;


if (id_dsrole_guest IS NOT NULL AND id_dsrole_guest::text <> '') then

	select	max(id)
	into STRICT	id_app_subject
	from	subject
	where	ds_login = 'app-default';


	if ( coalesce(id_app_subject::text, '') = '' ) then

		id_app_subject := psa_uuid_generator;

		insert into subject(id, dt_creation, dt_modification, ds_email, ds_login, nm_subject, ds_password, ds_salt, dt_password_modification,vl_auth_type)
		values ( id_app_subject, clock_timestamp(), clock_timestamp(), nm_email_subject, 'app-default', 'App Default', 'E2CDDCF5F027FE0798C4F87B52009EE29706CE40E8DD4A97B848F7919D649B4A', 'r{K ]qqWmf (g1t', clock_timestamp(),0);
	end if;

	select	max(id)
	into STRICT	id_subject_datasource
	from	subject_datasource
	where	id_subject = id_app_subject
	and	id_datasource = id_datasource_p;

	 if ( coalesce(id_subject_datasource::text, '') = '' ) then

		id_subject_datasource := psa_uuid_generator;

		insert into subject_datasource(id, dt_creation, dt_modification, id_subject, id_datasource, vl_activation_status, vl_attempts_so_far)
		values ( id_subject_datasource, clock_timestamp(), clock_timestamp(), id_app_subject, id_datasource_p,0,0);
	end if;


	select	count(1)
	into STRICT	qt_application_subject_w
	from	application_subject
	where	id_application = id_application_p
	and	id_subject = id_app_subject;


	if ( qt_application_subject_w = 0 ) then

		insert into application_subject( id_application, id_subject)
		values ( id_application_p, id_app_subject );
	end if;

	select	count(1)
	into STRICT	qt_subject_datasource_role_w
	from	subject_datasource_role
	where	id_datasource_role 	= id_dsrole_guest
	and	id_subject 		= id_app_subject;


	if ( qt_subject_datasource_role_w = 0 ) then

		insert into subject_datasource_role(id_subject, id_datasource_role)
		values ( id_app_subject, id_dsrole_guest );
	end if;

end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE configura_psa_tws_pack.create_subject_default ( id_datasource_p datasource.id%type, id_application_p application.id%type) FROM PUBLIC;
