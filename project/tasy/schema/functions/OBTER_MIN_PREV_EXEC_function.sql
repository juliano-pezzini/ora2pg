-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_min_prev_exec ( nr_sequencia_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_min_prev_w			bigint;


BEGIN

qt_min_prev_w	:= 0;

select coalesce(sum(coalesce(qt_min_prev,0)),0)
into STRICT	qt_min_prev_w
from 	man_ordem_servico_exec
where	nr_seq_ordem		= nr_sequencia_p
and	nm_usuario_exec	= nm_usuario_p;

RETURN qt_min_prev_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_min_prev_exec ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
