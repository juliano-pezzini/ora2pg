-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function ger_carga_pck.gerar_profissao() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE ger_carga_pck.gerar_profissao ( reg_proc_p INOUT r_reg_proc, profissao_p INOUT profissao) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM ger_carga_pck.gerar_profissao_atx ( ' || quote_nullable(reg_proc_p) || ',' || quote_nullable(profissao_p) || ' )';
	SELECT * FROM dblink(v_conn_str, v_query) AS p (v_ret0 r_reg_proc, v_ret1 profissao) INTO reg_proc_p, profissao_p;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE ger_carga_pck.gerar_profissao_atx ( reg_proc_p INOUT r_reg_proc, profissao_p INOUT profissao) AS $body$
BEGIN
if (reg_proc_p.ie_tipo_proc = 'IMP') then
	select	coalesce(max(cd_profissao),0)+1
	into STRICT	profissao_p.cd_profissao
	from	profissao;

	insert into profissao values (profissao_p.*);
end if;
commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_carga_pck.gerar_profissao ( reg_proc_p INOUT r_reg_proc, profissao_p INOUT profissao) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE ger_carga_pck.gerar_profissao_atx ( reg_proc_p INOUT r_reg_proc, profissao_p INOUT profissao) FROM PUBLIC;
