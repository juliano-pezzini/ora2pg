-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proced_lado_agenda ( nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_procedimentos_w	varchar(4000);
ds_proced_w		varchar(260);
nr_ordem_w		bigint;

c01 CURSOR FOR
SELECT	2 ordem,
			b.ds_procedimento || ' ' || CASE WHEN coalesce(a.ie_lado::text, '') = '' THEN NULL  ELSE ' ' || obter_desc_expressao(292416,'Lado')||': ' END  || substr(obter_valor_dominio(1372,a.ie_lado),1,20)
from		procedimento b,
			agenda_paciente_proc a
where		a.cd_procedimento 	= b.cd_procedimento
and		a.ie_origem_proced 	= b.ie_origem_proced
and		a.nr_sequencia 		= nr_seq_agenda_p
and		coalesce(a.nr_seq_proc_interno::text, '') = ''

union

select	2 ordem,
			b.ds_proc_exame  || ' ' || CASE WHEN coalesce(a.ie_lado::text, '') = '' THEN NULL  ELSE ' ' || obter_desc_expressao(292416,'Lado')||': ' END  || substr(obter_valor_dominio(1372,a.ie_lado),1,20)
from		proc_interno b,
			agenda_paciente_proc a
where		a.nr_seq_proc_interno 	= b.nr_sequencia
and		a.nr_sequencia 			= nr_seq_agenda_p
and		(a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '')
order by
	1;


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	open c01;
	loop
	fetch c01	into
			nr_ordem_w,
			ds_proced_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (coalesce(length(ds_procedimentos_w),0) < 3930) then
			ds_procedimentos_w := ds_procedimentos_w || ds_proced_w || ' - ';
		end if;
		end;
	end loop;
	close c01;
end if;

return ds_procedimentos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proced_lado_agenda ( nr_seq_agenda_p bigint) FROM PUBLIC;

