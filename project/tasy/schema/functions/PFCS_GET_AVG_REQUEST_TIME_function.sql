-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_avg_request_time ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint DEFAULT null, ie_option_p text default 'REQUEST') RETURNS bigint AS $body$
DECLARE



average_time_w  pfcs_detail_patient.qt_time_awaiting_bed%type;


BEGIN
    select coalesce(
        avg((clock_timestamp() - CASE WHEN ie_option_p='REQUEST' THEN  pat.dt_request WHEN ie_option_p='ENTRANCE' THEN  pat.dt_entrance END
            ) * 1440), 0) 
    into STRICT average_time_w
    from pfcs_detail_patient pat,
        pfcs_detail_bed bed,
        pfcs_panel_detail pd
    where pat.nr_seq_detail = pd.nr_sequencia
        and bed.nr_seq_detail = pd.nr_sequencia
        and pd.nr_seq_indicator = nr_seq_indicator_p
        and pd.nr_seq_operational_level = cd_estabelecimento_p
        and ((coalesce(cd_setor_atendimento_p::text, '') = '') or (isnumber(bed.cd_department) = cd_setor_atendimento_p));

  	RETURN average_time_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_avg_request_time ( nr_seq_indicator_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint DEFAULT null, ie_option_p text default 'REQUEST') FROM PUBLIC;

