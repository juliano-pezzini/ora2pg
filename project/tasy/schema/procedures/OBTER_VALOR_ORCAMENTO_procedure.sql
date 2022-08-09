-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_valor_orcamento as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE obter_valor_orcamento (nr_seq_orcamento_p bigint, vl_orcamento_p INOUT bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM obter_valor_orcamento_atx ( ' || quote_nullable(nr_seq_orcamento_p) || ',' || quote_nullable(vl_orcamento_p) || ' )';
	SELECT v_ret INTO vl_orcamento_p FROM dblink(v_conn_str, v_query) AS p (v_ret bigint);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE obter_valor_orcamento_atx (nr_seq_orcamento_p bigint, vl_orcamento_p INOUT bigint) AS $body$
BEGIN

vl_orcamento_p	:= Obter_Valor_Orc_Pac(nr_seq_orcamento_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valor_orcamento (nr_seq_orcamento_p bigint, vl_orcamento_p INOUT bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE obter_valor_orcamento_atx (nr_seq_orcamento_p bigint, vl_orcamento_p INOUT bigint) FROM PUBLIC;
