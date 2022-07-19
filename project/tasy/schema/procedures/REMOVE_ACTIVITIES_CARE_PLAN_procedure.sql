-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remove_activities_care_plan ( NR_ATENDIMENTO_P CP_ACTIVITY_HIST.NR_ATENDIMENTO%type, NR_SEQ_PROC_P PE_PRESCR_PROC.NR_SEQ_PROC%type, NR_SEQ_PRESCR_P PE_PRESCR_PROC.NR_SEQ_PRESCR%type ) AS $body$
BEGIN

    if (NR_ATENDIMENTO_P IS NOT NULL AND NR_ATENDIMENTO_P::text <> '') and (NR_SEQ_PROC_P IS NOT NULL AND NR_SEQ_PROC_P::text <> '') and (NR_SEQ_PRESCR_P IS NOT NULL AND NR_SEQ_PRESCR_P::text <> '')  then

        delete from CP_ACTIVITY_HIST
        where NR_ATENDIMENTO = NR_ATENDIMENTO_P
          and NR_SEQ_PE_PRESCR_PROC in (
                    SELECT NR_SEQUENCIA from PE_PRESCR_PROC WHERE NR_SEQ_PRESCR = NR_SEQ_PRESCR_P and NR_SEQ_PROC = NR_SEQ_PROC_P
                );

    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remove_activities_care_plan ( NR_ATENDIMENTO_P CP_ACTIVITY_HIST.NR_ATENDIMENTO%type, NR_SEQ_PROC_P PE_PRESCR_PROC.NR_SEQ_PROC%type, NR_SEQ_PRESCR_P PE_PRESCR_PROC.NR_SEQ_PRESCR%type ) FROM PUBLIC;

