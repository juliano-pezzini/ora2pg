-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_guias_proc ( nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_doc_convenio_w	varchar(20);

C01 CURSOR FOR
	SELECT	nr_doc_convenio
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_p
	and	coalesce(cd_motivo_exc_conta::text, '') = ''
	and	(nr_doc_convenio IS NOT NULL AND nr_doc_convenio::text <> '')
	order by	nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_doc_convenio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w	:= nr_doc_convenio_w;
	elsif (length(ds_retorno_w || ' \ ' || nr_doc_convenio_w) < 255) then
		ds_retorno_w	:= ds_retorno_w || ' \ ' || nr_doc_convenio_w;
	end if;

	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_guias_proc ( nr_interno_conta_p bigint) FROM PUBLIC;

