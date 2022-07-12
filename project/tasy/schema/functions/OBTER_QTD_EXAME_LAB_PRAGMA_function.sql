-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_qtd_exame_lab_pragma as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_qtd_exame_lab_pragma ( nr_prescricao_p bigint, nr_seq_interno_p bigint) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_qtd_exame_lab_pragma_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_seq_interno_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_qtd_exame_lab_pragma_atx ( nr_prescricao_p bigint, nr_seq_interno_p bigint) RETURNS bigint AS $body$
DECLARE


qt_exame_lab_w	bigint;
BEGIN

select	count(1)
into STRICT	qt_exame_lab_w
from	prescr_procedimento a, exame_laboratorio b
where	a.nr_prescricao = nr_prescricao_p
and	a.nr_seq_interno <> nr_seq_interno_p
and	coalesce(a.dt_suspensao::text, '') = ''
and	coalesce(a.ie_suspenso, 'N') = 'N'
and	a.nr_seq_exame = b.nr_seq_exame
and	b.ie_anatomia_patologica = 'N';

return qt_exame_lab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_exame_lab_pragma ( nr_prescricao_p bigint, nr_seq_interno_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_qtd_exame_lab_pragma_atx ( nr_prescricao_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;
