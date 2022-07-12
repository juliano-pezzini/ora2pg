-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ncare_cplan ( cd_pessoa_fisica_p text, dt_atualizacao_p timestamp, start_time_p timestamp, end_time_p timestamp ) RETURNS varchar AS $body$
DECLARE

ds_others_w varchar(3900);
ds_horarios_w varchar(2000);
ds_horarios_ww varchar(2000);WITH RECURSIVE cte AS (

C01 CURSOR FOR
SELECT regexp_substr(REPLACE(ds_horarios_w , ' ', ','), '[^,]+', 1, level) AS times
regexp_substr(REPLACE(ds_horarios_w , ' ', ','), '[^,]+', 1, level) IS NOT NULL  UNION ALL

C01 CURSOR FOR
SELECT regexp_substr(REPLACE(ds_horarios_w , ' ', ','), '[^,]+', 1, level) AS times 
regexp_substr(REPLACE(ds_horarios_w , ' ', ','), '[^,]+', 1, level) IS NOT NULL JOIN cte c ON ()

) SELECT * FROM cte;
;

    c02 CURSOR FOR
    SELECT
        y.ds_horarios
    FROM
        pe_prescr_proc   y,
        pe_prescricao    pe
    WHERE
        y.nr_seq_prescr = pe.nr_sequencia
        AND (y.nr_seq_proc IS NOT NULL AND y.nr_seq_proc::text <> '')
        AND to_date(pe.dt_prescricao, 'dd-mm-yy') = to_date(dt_atualizacao_p, 'dd-mm-yy')
        AND coalesce(pe.dt_suspensao::text, '') = ''
        AND (pe.dt_liberacao IS NOT NULL AND pe.dt_liberacao::text <> '')
        AND pe.cd_pessoa_fisica = cd_pessoa_fisica_p;

BEGIN
OPEN c02;

FETCH c02 INTO ds_horarios_w;

CLOSE c02;

OPEN c01;
loop
    FETCH c01 INTO ds_horarios_ww;
    EXIT WHEN NOT FOUND; /* apply on c01 */
begin SELECT
    rtrim(xmlagg(XMLELEMENT(name e, nscare || chr(10))).extract['//text()'].getclobval(), ',') ncare
INTO STRICT ds_others_w FROM (
SELECT distinct ds_horarios_ww, ds_horarios_ww||' '
||(select  DS_PROCEDIMENTO from PE_PROCEDIMENTO x where x.NR_SEQUENCIA=y.NR_SEQ_PROC)||
CASE WHEN coalesce(y.DS_OBSERVACAO::text, '') = '' THEN null  ELSE ' ('||substr(y.DS_OBSERVACAO,1,150)||') ' END nscare
FROM
    pe_prescr_proc   y,
    pe_prescricao    pe
WHERE
    y.nr_seq_prescr = pe.nr_sequencia
    AND (y.nr_seq_proc IS NOT NULL AND y.nr_seq_proc::text <> '')
    AND to_date(pe.dt_prescricao, 'dd-mm-yy') = to_date(dt_atualizacao_p, 'dd-mm-yy')
    AND ds_horarios_ww >= to_char(start_time_p, 'hh24:mi:ss')
    AND ds_horarios_ww <= to_char(end_time_p, 'hh24:mi:ss')
    AND coalesce(pe.dt_suspensao::text, '') = ''
    AND (pe.dt_liberacao IS NOT NULL AND pe.dt_liberacao::text <> '')
    AND pe.cd_pessoa_fisica = cd_pessoa_fisica_p) alias15
WHERE
    (nscare IS NOT NULL AND nscare::text <> '')
    order by ds_horarios_ww asc;
end;END
loop;

CLOSE c01;

 RETURN ds_others_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ncare_cplan ( cd_pessoa_fisica_p text, dt_atualizacao_p timestamp, start_time_p timestamp, end_time_p timestamp ) FROM PUBLIC;
