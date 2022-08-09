-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancel_medical_order ( NR_SEQUENCIA_P bigint ) AS $body$
BEGIN

UPDATE PRESCR_MEDICA_ORDEM
SET DT_CANCELAMENTO = clock_timestamp()
WHERE NR_SEQUENCIA = NR_SEQUENCIA_P;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancel_medical_order ( NR_SEQUENCIA_P bigint ) FROM PUBLIC;
