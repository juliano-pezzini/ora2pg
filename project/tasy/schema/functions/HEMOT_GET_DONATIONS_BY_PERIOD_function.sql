-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hemot_get_donations_by_period ( cd_pessoa_fisica_p text, dt_ultima_doacao_p timestamp, dt_doacao_p timestamp, qtt_period_p bigint, period_type_p text ) RETURNS bigint AS $body$
DECLARE

    qtt_registers_w bigint := 0;

BEGIN

    IF (period_type_p = 'HORA') THEN
        SELECT  COUNT(b.dt_coleta)
        INTO STRICT    qtt_registers_w
        FROM    (
                    SELECT  a.dt_coleta
                    FROM    SAN_DOACAO a
                    WHERE   cd_pessoa_fisica = cd_pessoa_fisica_p
                    AND     (a.dt_coleta IS NOT NULL AND a.dt_coleta::text <> '')
                    AND     a.dt_coleta BETWEEN (dt_doacao_p - (qtt_period_p / 24)) AND dt_ultima_doacao_p
                ) b;

    ELSIF (period_type_p = 'DIA') THEN
        SELECT  COUNT(b.dt_coleta)
        INTO STRICT    qtt_registers_w
        FROM (
                    SELECT  a.dt_coleta
                    FROM    SAN_DOACAO a
                    WHERE   cd_pessoa_fisica = cd_pessoa_fisica_p
                    AND     (a.dt_coleta IS NOT NULL AND a.dt_coleta::text <> '')
                    AND     a.dt_coleta BETWEEN(dt_doacao_p - qtt_period_p) AND dt_ultima_doacao_p
                ) b;
    ELSIF (period_type_p = 'MES') THEN
        SELECT  COUNT(b.dt_coleta)
        INTO STRICT    qtt_registers_w
        FROM    (
                    SELECT  a.dt_coleta
                    FROM    SAN_DOACAO a
                    WHERE   cd_pessoa_fisica = cd_pessoa_fisica_p
                    AND     (a.dt_coleta IS NOT NULL AND a.dt_coleta::text <> '')
                    AND     a.dt_coleta BETWEEN (dt_doacao_p - (qtt_period_p * 30)) AND dt_ultima_doacao_p
                ) b;
    END IF;
    RETURN qtt_registers_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hemot_get_donations_by_period ( cd_pessoa_fisica_p text, dt_ultima_doacao_p timestamp, dt_doacao_p timestamp, qtt_period_p bigint, period_type_p text ) FROM PUBLIC;

