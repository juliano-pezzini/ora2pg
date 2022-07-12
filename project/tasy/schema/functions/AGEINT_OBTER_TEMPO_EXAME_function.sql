-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_tempo_exame ( nr_seq_proc_interno_p bigint) RETURNS bigint AS $body$
DECLARE


nr_duracao_w	bigint;


BEGIN

select	coalesce(max(qt_min_cirurgia),0)
into STRICT	nr_duracao_w
from	proc_interno
where	nr_Sequencia	= nr_seq_proc_interno_p;

return	nr_duracao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_tempo_exame ( nr_seq_proc_interno_p bigint) FROM PUBLIC;
