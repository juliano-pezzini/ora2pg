-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_ativ_usuario ( nm_usuario_p text, nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_ativ_w	bigint;
ie_prioridade_desen_w	smallint;
dt_inicial		timestamp	:= TRUNC(clock_timestamp());
dt_final_w		timestamp	:= fim_dia(clock_timestamp());


BEGIN


/*SELECT	MAX(NVL(IE_PRIORIDADE_DESEN,0))
INTO	ie_prioridade_desen_w
FROM	man_ordem_ativ_prev
WHERE	nr_seq_ordem_serv = nr_seq_ordem_p
AND	dt_prevista BETWEEN dt_inicial AND dt_final_w
AND 	dt_real IS NULL
AND	nm_usuario_prev	= nm_usuario_p;*/
SELECT	MAX(coalesce(nr_sequencia,0))
INTO STRICT	nr_seq_ativ_w
FROM	man_ordem_ativ_prev
WHERE	nr_seq_ordem_serv = nr_seq_ordem_p
AND	dt_prevista BETWEEN dt_inicial AND dt_final_w
AND 	coalesce(dt_real::text, '') = ''
AND	nm_usuario_prev	= nm_usuario_p
and	coalesce(IE_PRIORIDADE_DESEN,0) = (SELECT	MAX(coalesce(IE_PRIORIDADE_DESEN,0))
					FROM	man_ordem_ativ_prev
					WHERE	nr_seq_ordem_serv = nr_seq_ordem_p
					AND	dt_prevista BETWEEN dt_inicial AND dt_final_w
					AND 	coalesce(dt_real::text, '') = ''
					AND	nm_usuario_prev	= nm_usuario_p);

RETURN	nr_seq_ativ_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_ativ_usuario ( nm_usuario_p text, nr_seq_ordem_p bigint) FROM PUBLIC;
