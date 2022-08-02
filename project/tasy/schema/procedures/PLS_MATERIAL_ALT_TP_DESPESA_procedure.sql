-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_material_alt_tp_despesa ( nr_sequencia_p pls_material.nr_sequencia%type, ie_tipo_despesa_p pls_material.ie_tipo_despesa%type, nm_usuario_p pls_material.nm_usuario%type) AS $body$
BEGIN

update	pls_material
set	ie_tipo_despesa	= ie_tipo_despesa_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_material_alt_tp_despesa ( nr_sequencia_p pls_material.nr_sequencia%type, ie_tipo_despesa_p pls_material.ie_tipo_despesa%type, nm_usuario_p pls_material.nm_usuario%type) FROM PUBLIC;

