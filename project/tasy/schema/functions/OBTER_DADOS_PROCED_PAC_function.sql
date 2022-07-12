-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_proced_pac ( nr_sequencia_p bigint, ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
DP - Descrição do procedimento
*/
ds_retorno_w		varchar(255) := null;
ds_procedimento_w	varchar(255);
cd_procedimento_w	bigint;


BEGIN

select	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,255),
	cd_procedimento
into STRICT	ds_procedimento_w,
	cd_procedimento_w
from	procedimento_paciente
where	nr_sequencia	=	nr_sequencia_p;

if (ie_opcao_p = 'DP') then
	ds_retorno_w := ds_procedimento_w;
else
	ds_retorno_w	:= cd_procedimento_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_proced_pac ( nr_sequencia_p bigint, ie_opcao_p text ) FROM PUBLIC;
