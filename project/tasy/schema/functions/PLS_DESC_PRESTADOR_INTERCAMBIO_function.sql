-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_desc_prestador_intercambio ( nr_seq_nota_cobranca_p bigint, nr_cgc_cpf_req_p text, ie_prestador_p text) RETURNS varchar AS $body$
DECLARE


/*ie_prestador_p	= 'E' = prestador executante da conta
		= 'S' = prestador solicitante */
nm_prestador_requisitante_w	varchar(255);
nm_profissional_prestador_w	varchar(255);
ds_retorno_w			varchar(255);


C01 CURSOR FOR
	SELECT	nm_prestador_requisitante,
		nm_profissional_prestador
	from	ptu_nota_servico
	where	nr_seq_nota_cobr	= nr_seq_nota_cobranca_p
	and	((ie_prestador_p	= 'S' AND nr_cgc_cpf_req		= nr_cgc_cpf_req_p)
	or	(ie_prestador_p	= 'E' AND nr_cgc_cpf		= nr_cgc_cpf_req_p));


BEGIN
open C01;
loop
fetch C01 into
	nm_prestador_requisitante_w,
	nm_profissional_prestador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	null;
	end;
end loop;
close C01;

if (ie_prestador_p = 'E') then
	ds_retorno_w	:= nm_profissional_prestador_w;
elsif (ie_prestador_p = 'S') then
	ds_retorno_w	:= nm_prestador_requisitante_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_desc_prestador_intercambio ( nr_seq_nota_cobranca_p bigint, nr_cgc_cpf_req_p text, ie_prestador_p text) FROM PUBLIC;
