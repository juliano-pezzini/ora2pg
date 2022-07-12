-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estagio_pend_exec (nr_seq_estagio_p bigint) RETURNS varchar AS $body$
DECLARE


ie_desenv_w	varchar(1);


BEGIN

select	CASE WHEN count(1)=1 THEN 'S'  ELSE 'N' END
into STRICT	ie_desenv_w
from	man_estagio_processo
where	nr_sequencia		= nr_seq_estagio_p
and	ie_aguarda_cliente	= 'N'
and	((ie_desenv	= 'S') or (ie_tecnologia = 'S') or (ie_design	= 'S') or (ie_infra	= 'S'));

return ie_desenv_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estagio_pend_exec (nr_seq_estagio_p bigint) FROM PUBLIC;

