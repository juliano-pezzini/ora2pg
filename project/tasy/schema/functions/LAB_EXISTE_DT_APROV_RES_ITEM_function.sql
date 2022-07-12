-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function lab_existe_dt_aprov_res_item as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION lab_existe_dt_aprov_res_item ( nr_seq_resultado_p bigint, nr_seq_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM lab_existe_dt_aprov_res_item_atx ( ' || quote_nullable(nr_seq_resultado_p) || ',' || quote_nullable(nr_seq_prescricao_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION lab_existe_dt_aprov_res_item_atx ( nr_seq_resultado_p bigint, nr_seq_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);
BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	exame_lab_result_item a
where	a.nr_seq_resultado = nr_seq_resultado_p
and		a.nr_seq_prescr = nr_seq_prescricao_p
and		(a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '');


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_existe_dt_aprov_res_item ( nr_seq_resultado_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION lab_existe_dt_aprov_res_item_atx ( nr_seq_resultado_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;

