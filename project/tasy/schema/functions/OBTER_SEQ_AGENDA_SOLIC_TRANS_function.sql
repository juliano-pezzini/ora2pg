-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_agenda_solic_trans (nr_seq_solic_trans_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_agenda_w	agenda_integrada.nr_sequencia%type;


BEGIN
if (coalesce(nr_seq_solic_trans_p,0) > 0) then
	begin
		select 	max(nr_sequencia)
		into STRICT	nr_seq_agenda_w
		from 	agenda_integrada
		where 	NR_SEQ_SOLIC_TRANSPORTE = nr_seq_solic_trans_p;
	exception
	when others then
		null;
	end;
end if;

return	nr_seq_agenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_agenda_solic_trans (nr_seq_solic_trans_p bigint) FROM PUBLIC;
