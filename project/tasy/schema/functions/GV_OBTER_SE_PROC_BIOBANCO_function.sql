-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gv_obter_se_proc_biobanco (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ie_pac_biobanco_w	varchar(1);

BEGIN

select	 CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	 ie_pac_biobanco_w
from	 agenda_pac_servico
where	 nr_seq_agenda = nr_seq_agenda_p
and	 exists (SELECT 1
			from	gestao_vaga_biobanco a
			where	a.nr_seq_proc_interno = nr_seq_proc_servico);

return	ie_pac_biobanco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gv_obter_se_proc_biobanco (nr_seq_agenda_p bigint) FROM PUBLIC;

