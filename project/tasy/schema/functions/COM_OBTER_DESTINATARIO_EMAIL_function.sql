-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_destinatario_email ( nr_seq_comunicado_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_email_ww			varchar(2000);
ds_email_w			varchar(255);

C01 CURSOR FOR
SELECT	a.ds_email
from	comercial_comunicado_dest a
where	a.nr_seq_comunicado = nr_seq_comunicado_p
and	a.nr_sequencia = nr_sequencia_p
and	a.ie_enviar_email = 'S'
order by 1;


BEGIN

open C01;
loop
fetch C01 into
	ds_email_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_email_ww := ds_email_ww || '<' || ds_email_w || '>;';
	end;
end loop;
close C01;

return ds_email_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_destinatario_email ( nr_seq_comunicado_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

