-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inactivate_eudamed_records ( nr_sequencia_p tasy_eudamed.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

										
inactive_status_w CONSTANT varchar(1)	:= 'I';
active_status_w CONSTANT varchar(1)	:= 'A';


BEGIN
	update	tasy_eudamed
	set		ie_situacao = inactive_status_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_inativacao = clock_timestamp(),
			nm_usuario_inativacao = nm_usuario_p
	where	nr_sequencia <> nr_sequencia_p
	and		ie_situacao = active_status_w;
	commit;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inactivate_eudamed_records ( nr_sequencia_p tasy_eudamed.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
