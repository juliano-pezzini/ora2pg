-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Declaring Desc permissions
--Declaring TAG permissions
CREATE OR REPLACE PROCEDURE configura_psa_tws_pack.create_permission_role ( permission_desc_p permission.ds_permission%type, permission_tag_p permission.ds_tag%type, ds_role_p role.ds_role%type, nm_role_p role.nm_role%type, id_datasource_p datasource.id%type, id_application_p application.id%type, ie_default_p role.ie_default%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
id_permission_w       		permission.id%type;
id_role_w   			role.id%type;
id_dsrole_w			datasource_role.id%type;
qt_datasource_role_perm_w	integer;



BEGIN


select 	max(id)
into STRICT	id_permission_w
from	permission
where	ds_permission 	= permission_desc_p
and	ds_tag 		= permission_tag_p
and	id_application 	= id_application_p;


if ( coalesce(id_permission_w::text, '') = '' ) then

	id_permission_w  := psa_uuid_generator;

	insert into permission( id, dt_creation, dt_modification, ds_permission, ds_tag, id_application )
	values ( id_permission_w, clock_timestamp(), clock_timestamp(), permission_desc_p, permission_tag_p, id_application_p );
end if;


select	max(id)
into STRICT	id_role_w
from	role
where	id_application 	= id_application_p
and	nm_role 	= nm_role_p;


if ( coalesce(id_role_w::text, '') = '' ) then

	id_role_w := psa_uuid_generator;

	-- insert unlinked profile role to websuite application
	insert into role(id, dt_creation, dt_modification, ds_role, nm_role, id_application, ie_default)
	values ( id_role_w, clock_timestamp(), clock_timestamp(), ds_role_p, nm_role_p, id_application_p, ie_default_p);

end if;


select	max(id)
into STRICT	id_dsrole_w
from	datasource_role
where	id_datasource 	= id_datasource
and	id_role 	= id_role_w;


if ( coalesce(id_dsrole_w::text, '') = '' ) then

	id_dsrole_w	:= psa_uuid_generator;

	-- link between datasource e role
	insert into datasource_role(id, id_datasource, id_role)
	values ( id_dsrole_w, id_datasource_p, id_role_w);

end if;


 select	count(1)
 into STRICT	qt_datasource_role_perm_w
 from	datasource_role_permission
 where	id_datasource_role = id_dsrole_w
 and	id_permission = id_permission_w;


 if ( qt_datasource_role_perm_w = 0 ) then
	  -- link between datasource_role and permission
	  --permission: schematics:retrieve
	  insert into datasource_role_permission( id_datasource_role, id_permission)
	  values ( id_dsrole_w, id_permission_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE configura_psa_tws_pack.create_permission_role ( permission_desc_p permission.ds_permission%type, permission_tag_p permission.ds_tag%type, ds_role_p role.ds_role%type, nm_role_p role.nm_role%type, id_datasource_p datasource.id%type, id_application_p application.id%type, ie_default_p role.ie_default%type) FROM PUBLIC;
