-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_atividade ( nr_seq_superior_p bigint, qt_min_ativ_p bigint) RETURNS bigint AS $body$
DECLARE

qt_hora_saldo_w    bigint;
qt_min_ativ_w	   bigint;


BEGIN

SELECT dividir(coalesce(qt_min_ativ_p,0),60)
INTO STRICT qt_min_ativ_w
;

SELECT 	qt_hora_saldo + qt_min_ativ_w
INTO STRICT 	qt_hora_saldo_w
FROM 	proj_cron_etapa
WHERE 	nr_sequencia =  nr_seq_superior_p;

RETURN	qt_hora_saldo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_atividade ( nr_seq_superior_p bigint, qt_min_ativ_p bigint) FROM PUBLIC;
