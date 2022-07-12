-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE configure_psa_tws_pack.create_application_client ( nm_attempts_p client.vl_allowed_login_attempts%type, ds_client_p client.ds_client%type, nm_client_p client.nm_client%type, ds_application_p application.ds_application%type, nm_application_p application.nm_application%type, id_application_p INOUT application.id%type) AS $body$
DECLARE



id_application_v     	application.id%TYPE;
id_client           	client.id%TYPE;
id_datasource	    	datasource.id%type;


BEGIN


/*++++++++++++++++++++++++++++++++++++ CREATE APPLICATION +++++++++++++++++++++++++++++++++++++++*/


 --Cria a aplicacao no Philips Security

 -- APPLICATION

 select	max(id)
 into STRICT	id_application_v
 from	application
 where	nm_application = nm_application_p;

if ( coalesce(id_application_v::text, '') = '' ) then

	id_application_v  := psa_uuid_generator;

	insert into application(id, dt_creation, dt_modification, ds_application, nm_application)
	values ( id_application_v, clock_timestamp(), clock_timestamp(), ds_application_p, nm_application_p );

 end if;


--CLIENT

select	max(id)
into STRICT	id_client
from	client
where	nm_client = nm_client_p;

if ( coalesce(id_client::text, '') = '' ) then

	id_client := psa_uuid_generator;

	insert into client(id, dt_creation, dt_modification, ds_client, nm_client, ds_secret, id_application, vl_authentication_order, vl_allowed_login_attempts)
	values (id_client, clock_timestamp(), clock_timestamp(), ds_client_p, nm_client_p, psa_uuid_generator, id_application_v, 'DS_REPLACEMENT_LOGIN,DS_ALTERNATIVE_LOGIN,DS_LOGIN', nm_attempts_p);

end if;

--SOURCE

select 	max(id)
into STRICT	id_datasource
from	datasource
where	id_application = id_application_v;

if ( coalesce(id_datasource::text, '') = '' ) then

        insert into datasource(	id, dt_creation, dt_modification,
        			ds_datasource, nm_datasource, id_application, vl_allowed_login_attempts)
			values (	generate_uuid, clock_timestamp(), clock_timestamp(),
              			'WTASY', 'WTASY', id_application_v, 5);
end if;

id_application_p 	:= id_application_v;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE configure_psa_tws_pack.create_application_client ( nm_attempts_p client.vl_allowed_login_attempts%type, ds_client_p client.ds_client%type, nm_client_p client.nm_client%type, ds_application_p application.ds_application%type, nm_application_p application.nm_application%type, id_application_p INOUT application.id%type) FROM PUBLIC;