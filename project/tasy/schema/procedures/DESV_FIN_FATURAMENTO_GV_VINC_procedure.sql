-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desv_fin_faturamento_gv_vinc ( nr_sequencia_p bigint) AS $body$
BEGIN
delete
from	fin_faturamento_gv_vinc
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desv_fin_faturamento_gv_vinc ( nr_sequencia_p bigint) FROM PUBLIC;
