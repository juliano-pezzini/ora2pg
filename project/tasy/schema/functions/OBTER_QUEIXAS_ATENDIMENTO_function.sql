-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_queixas_atendimento ( nr_atendimento_p bigint, nr_seq_queixa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(32000);
ds_queixa_w		varchar(255);

C01 CURSOR FOR
	SELECT	substr(obter_desc_queixa(nr_seq_queixa),1,255)
	from	ATEND_PACIENTE_QUEIXA
	where	nr_atendimento	= nr_atendimento_p;


BEGIN

open C01;
loop
fetch C01 into
	ds_queixa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:=ds_queixa_w||','|| ds_retorno_w;
	end;
end loop;
close C01;


ds_retorno_w	:= substr(ds_retorno_w,1,length(ds_retorno_w)-1);

if (nr_seq_queixa_p IS NOT NULL AND nr_seq_queixa_p::text <> '') then
	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w	:= substr(obter_desc_queixa(nr_seq_queixa_p),1,255);
	else
		ds_retorno_w	:= ds_retorno_w||', '||substr(obter_desc_queixa(nr_seq_queixa_p),1,255);
	end if;
end if;

if (coalesce(ds_retorno_w::text, '') = '') then
	select	max(ds_queixa_princ)
	into STRICT	ds_retorno_w
	from	triagem_pronto_atend a
	where	a.nr_sequencia = (
		SELECT	max(nr_sequencia)
		from	triagem_pronto_atend b
		where	a.nr_atendimento = b.nr_atendimento
		and	b.nr_atendimento = nr_atendimento_p);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_queixas_atendimento ( nr_atendimento_p bigint, nr_seq_queixa_p bigint) FROM PUBLIC;
