-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sigla_proc_int_classif (nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_classif_w	proc_interno.nr_seq_classif%type;
ds_sigla_w		varchar(20);


BEGIN

ds_sigla_w := '';

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
	begin
	select	coalesce(max(nr_seq_classif),0)
	into STRICT	nr_seq_classif_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p
	and	ie_situacao = 'A';

	if (nr_seq_classif_w > 0) then
		begin
		select	substr(max(ds_sigla),1,1)
		into STRICT	ds_sigla_w
		from	proc_interno_classif
		where	nr_sequencia = nr_seq_classif_w;
		end;
	end if;
	end;
end if;

return	ds_sigla_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sigla_proc_int_classif (nr_seq_proc_interno_p bigint) FROM PUBLIC;

