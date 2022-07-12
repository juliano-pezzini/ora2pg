-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ativ_aberta_atual ( nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ie_ativ_aberta_w	varchar(1);


BEGIN

SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
INTO STRICT	ie_ativ_aberta_w
FROM	man_ordem_serv_ativ
WHERE	nr_seq_ordem_serv	= nr_seq_ordem_p
AND	coalesce(dt_fim_atividade::text, '') = ''
AND	dt_atividade BETWEEN TRUNC(clock_timestamp()) AND fim_dia(clock_timestamp());

RETURN ie_ativ_aberta_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ativ_aberta_atual ( nr_seq_ordem_p bigint) FROM PUBLIC;

