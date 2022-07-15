-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_trib_todos_tit_escrit (nr_seq_escrit_p bigint) AS $body$
BEGIN


delete
from w_titulo_pagar_imposto
where  nr_seq_escrit =  nr_seq_escrit_p;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_trib_todos_tit_escrit (nr_seq_escrit_p bigint) FROM PUBLIC;

