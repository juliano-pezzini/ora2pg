-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_classif (ie_classif_agenda_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_grupo_w	bigint;
ds_retorno_w	varchar(255);


BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_seq_grupo_w
from	agenda_classif a,
	agenda_grupo_classif b
where	a.nr_seq_grupo_classif = b.nr_sequencia
and	a.cd_classificacao = ie_classif_agenda_p;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= nr_seq_grupo_w;
else
	select	max(ds_grupo)
	into STRICT	ds_retorno_w
	from	agenda_grupo_classif
	where	nr_sequencia = nr_seq_grupo_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_classif (ie_classif_agenda_p text, ie_opcao_p text) FROM PUBLIC;
