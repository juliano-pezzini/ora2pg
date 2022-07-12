-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_dados_grupo_relac_contr ( nr_seq_contrato_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
N - Nome do grupo contratual
S - Sequencia do grupo contratual
*/
ds_retorno_w			varchar(255);
nr_seq_grupo_w			bigint;


BEGIN

select	max(nr_seq_grupo)
into STRICT	nr_seq_grupo_w
from	pls_contrato_grupo
where	nr_seq_contrato	= nr_seq_contrato_p;

if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
	if (ie_opcao_p = 'N') then
		select	substr(ds_grupo,1,255)
		into STRICT	ds_retorno_w
		from	pls_grupo_contrato
		where	nr_sequencia	= nr_seq_grupo_w;
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w	:= to_char(nr_seq_grupo_w);
	elsif (ie_opcao_p = 'SN') then
		select	nr_seq_grupo_w||' '||substr(ds_grupo,1,255)
		into STRICT	ds_retorno_w
		from	pls_grupo_contrato
		where	nr_sequencia	= nr_seq_grupo_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_dados_grupo_relac_contr ( nr_seq_contrato_p bigint, ie_opcao_p text) FROM PUBLIC;

