-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_sel_item_rec_glosa ( nr_sequencia_p w_pls_recurso_glosa.nr_sequencia%type, vl_recursado_p w_pls_recurso_glosa.vl_recursado%type, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update	w_pls_recurso_glosa
	set	vl_recursado	= coalesce(vl_recursado_p,vl_recursado)
	where	nr_sequencia	= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_sel_item_rec_glosa ( nr_sequencia_p w_pls_recurso_glosa.nr_sequencia%type, vl_recursado_p w_pls_recurso_glosa.vl_recursado%type, nm_usuario_p text) FROM PUBLIC;

