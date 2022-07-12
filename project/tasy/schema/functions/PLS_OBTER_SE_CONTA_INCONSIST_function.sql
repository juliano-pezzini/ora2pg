-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_conta_inconsist (nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_inconsistente_w	varchar(1);


BEGIN

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
into STRICT	ie_inconsistente_w
from	pls_proc_conta_inconsist
where	nr_seq_proc_conta	= nr_seq_proc_conta_p;

return	ie_inconsistente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_conta_inconsist (nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type) FROM PUBLIC;

