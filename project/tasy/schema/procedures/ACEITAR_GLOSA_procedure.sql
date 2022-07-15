-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aceitar_glosa ( ie_glosa_p text, vl_glosado_p bigint, vl_amenor_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
update	convenio_retorno_item
set	ie_glosa = ie_glosa_p,
	vl_amenor = vl_amenor_p,
	vl_glosado = vl_glosado_p	
where	nr_sequencia	=	nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aceitar_glosa ( ie_glosa_p text, vl_glosado_p bigint, vl_amenor_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

