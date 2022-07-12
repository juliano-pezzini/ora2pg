-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_infusion_pump_begin_date (NR_SEQ_BOMBA_INTERFACE_P bigint) RETURNS timestamp AS $body$
DECLARE

    NR_SEQUENCIA_V bigint;
    DATA_INICIO_V TIMESTAMP;

BEGIN
    SELECT NR_SEQUENCIA INTO STRICT NR_SEQUENCIA_V
    FROM BOMBA_INFUSAO_TRANSICAO 
    WHERE NR_SEQ_BOMBA_INTERFACE = NR_SEQ_BOMBA_INTERFACE_P 
        AND (IE_STATUS IN ('ST', 'DS') OR DS_CAMPO = 'DS_MEDICAMENTO') 
    ORDER BY DT_TRANSICAO DESC LIMIT 1;

    SELECT DT_TRANSICAO INTO STRICT DATA_INICIO_V
    FROM BOMBA_INFUSAO_TRANSICAO 
    WHERE NR_SEQ_BOMBA_INTERFACE = NR_SEQ_BOMBA_INTERFACE_P  
        AND NR_SEQUENCIA < NR_SEQUENCIA_V
        AND IE_STATUS NOT IN ('ST', 'DS') 
        AND (DS_CAMPO <> 'DS_MEDICAMENTO' OR coalesce(DS_CAMPO::text, '') = '') 
    ORDER BY NR_SEQUENCIA DESC LIMIT 1;
    RETURN DATA_INICIO_V;
EXCEPTION
    WHEN no_data_found THEN
        RETURN clock_timestamp();
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_infusion_pump_begin_date (NR_SEQ_BOMBA_INTERFACE_P bigint) FROM PUBLIC;
