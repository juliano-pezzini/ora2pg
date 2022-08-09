-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE video_server_update ( nr_sequencia_p bigint, ie_option_p text) AS $body$
DECLARE
									

cd_password_w				video_server.CD_PASSWORD%type;
cd_password_encrypt_w		varchar(255);

/*
ie_option_p 
P = update no Password
*/
BEGIN
if (ie_option_p = 'P') then

	select cd_password
	into STRICT cd_password_w
	from video_server
	where nr_sequencia = nr_sequencia_p;

	select wheb_seguranca.encrypt(cd_password_w)
	into STRICT cd_password_encrypt_w
	;

	update	video_server
	set		cd_password 		= cd_password_encrypt_w
	where	nr_sequencia		= nr_sequencia_p;

end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE video_server_update ( nr_sequencia_p bigint, ie_option_p text) FROM PUBLIC;
