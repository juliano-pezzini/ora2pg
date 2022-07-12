-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proc_interno (nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ds_procedimento_w	PROCEDIMENTO.DS_PROCEDIMENTO%type;


BEGIN

select	max(ds_proc_exame)
into STRICT	ds_procedimento_w
from	proc_interno
where	nr_sequencia	= nr_seq_proc_interno_p;

return	ds_procedimento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proc_interno (nr_seq_proc_interno_p bigint) FROM PUBLIC;
