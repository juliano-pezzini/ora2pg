-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function lab_desaprovar_exame as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE lab_desaprovar_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL lab_desaprovar_exame_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_seq_prescr_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE lab_desaprovar_exame_atx (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
DECLARE
nr_seq_resultado_w	bigint;



BEGIN
select 	max(nr_seq_resultado)
into STRICT	nr_seq_resultado_w
from	exame_lab_resultado
where	nr_prescricao = nr_prescricao_p;

update 	exame_lab_result_item
set 	dt_aprovacao  = NULL
where  	nr_seq_resultado = nr_seq_resultado_w
and	nr_seq_prescr = nr_seq_prescr_p
and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_desaprovar_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE lab_desaprovar_exame_atx (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;
