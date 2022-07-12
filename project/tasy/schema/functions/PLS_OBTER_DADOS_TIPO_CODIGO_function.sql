-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_tipo_codigo ( nr_seq_tipo_codigo_p pls_tipo_codigo_contrato.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
'DS' - Descrição do tipo de código
*/
ds_retorno_w		varchar(4000);
ds_tipo_codigo_w	pls_tipo_codigo_contrato.ds_tipo_codigo%type;


BEGIN
if (nr_seq_tipo_codigo_p IS NOT NULL AND nr_seq_tipo_codigo_p::text <> '') then
	select	substr(a.ds_tipo_codigo,1,255)
	into STRICT	ds_tipo_codigo_w
	from	pls_tipo_codigo_contrato a
	where	a.nr_sequencia = nr_seq_tipo_codigo_p;

	if (ie_opcao_p = 'DS') then
		ds_retorno_w := ds_tipo_codigo_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_tipo_codigo ( nr_seq_tipo_codigo_p pls_tipo_codigo_contrato.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;
