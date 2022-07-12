-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_pacote ( nr_seq_pacote_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


/* ie_tipo_retorno_p
	C - Código do procedimento
	D - Descrição do procedimento
	CD - Código + Descrição do procedimento
*/
cd_procedimento_w		bigint;
ds_procedimento_w		varchar(255);
ds_retorno_w			varchar(255);


BEGIN

select	cd_procedimento,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,255)
into STRICT	cd_procedimento_w,
	ds_procedimento_w
from	pls_pacote
where	nr_sequencia	= nr_seq_pacote_p;

if (ie_tipo_retorno_p	= 'C') then
	ds_retorno_w	:= cd_procedimento_w;
elsif (ie_tipo_retorno_p	= 'D') then
	ds_retorno_w	:= ds_procedimento_w;
elsif (ie_tipo_retorno_p	= 'CD') then
	ds_retorno_w	:= cd_procedimento_w || ' - ' || ds_procedimento_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_pacote ( nr_seq_pacote_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;
