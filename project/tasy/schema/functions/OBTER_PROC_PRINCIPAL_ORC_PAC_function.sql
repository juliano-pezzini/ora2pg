-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_principal_orc_pac ( nr_seq_orcamento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_procedimento_w	varchar(255);
ds_procedimentos_w	varchar(500) := '';

C01 CURSOR FOR
SELECT	substr(obter_desc_procedimento(a.cd_procedimento,a.ie_origem_proced),1,255)
from	orcamento_paciente_proc a
where	nr_sequencia_orcamento = nr_seq_orcamento_p
and	ie_procedimento_principal = 'S';


BEGIN

open C01;
loop
fetch C01 into
	ds_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_procedimentos_w := ds_procedimentos_w || ds_procedimento_w || ' / ';

	end;
end loop;
close C01;

return	substr(ds_procedimentos_w,1,length(ds_procedimentos_w) - 3);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_principal_orc_pac ( nr_seq_orcamento_p bigint) FROM PUBLIC;

