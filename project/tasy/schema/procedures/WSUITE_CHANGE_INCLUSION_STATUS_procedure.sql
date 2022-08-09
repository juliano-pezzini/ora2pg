-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE wsuite_change_inclusion_status (nr_seq_solic_inclusao_p wsuite_solic_inclusao_pf.nr_sequencia%type, ie_status_p wsuite_solic_inclusao_pf.ie_status%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	CALL wsuite_login_pck.wsuite_change_inclusion_status( nr_seq_solic_inclusao_p, ie_status_p, nm_usuario_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wsuite_change_inclusion_status (nr_seq_solic_inclusao_p wsuite_solic_inclusao_pf.nr_sequencia%type, ie_status_p wsuite_solic_inclusao_pf.ie_status%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
