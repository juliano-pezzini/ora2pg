-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_anexo_agenda (nr_seq_anexo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_agenda_w		bigint;
count_w			bigint;
ds_arquivo_w		autorizacao_convenio_arq.ds_arquivo%type;
ds_retorno_w		varchar(255);


BEGIN

count_w	:= 0;

select 	max(a.nr_seq_agenda),
	max(b.ds_arquivo)
into STRICT	nr_seq_agenda_w,
	ds_arquivo_w
from 	autorizacao_convenio_arq b,
	autorizacao_convenio a
where	a.nr_sequencia	= b.nr_sequencia_autor
and	b.nr_sequencia	= nr_seq_anexo_p;

if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
	select 	count(*)
	into STRICT	count_w
	from 	anexo_agenda
	where	nr_seq_agenda = nr_seq_agenda_w
	and	    ds_arquivo	  = substr(ds_arquivo_w,1,255);
end if;

if (count_w > 0) then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_anexo_agenda (nr_seq_anexo_p bigint) FROM PUBLIC;

