-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_proc_interno (nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ie_copiar_rep_w		varchar(1);


BEGIN

select	coalesce(max(ie_copiar_rep),'S')
into STRICT	ie_copiar_rep_w
from	proc_interno
where	nr_sequencia	= nr_seq_proc_interno_p;

return	ie_copiar_rep_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_proc_interno (nr_seq_proc_interno_p bigint) FROM PUBLIC;

