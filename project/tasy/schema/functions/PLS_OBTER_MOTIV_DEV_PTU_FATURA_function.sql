-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_motiv_dev_ptu_fatura (nr_seq_motivo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);

/*IE_OPCAO_P
D - Descrição do motivo */
BEGIN
if (ie_opcao_p = 'D') then
	select	substr(ds_motivo,1,255)
	into STRICT	ds_retorno_w
	from	ptu_motivo_devolucao_a500
	where 	ie_situacao	= 'A'
	and	nr_sequencia	= nr_seq_motivo_p
	order by ds_motivo;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_motiv_dev_ptu_fatura (nr_seq_motivo_p bigint, ie_opcao_p text) FROM PUBLIC;

