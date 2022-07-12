-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prest_excecao ( nr_seq_regra_p bigint, nr_seq_prestador_exec_p bigint, nr_seq_prest_fornec_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255)	:= 'N';
nr_seq_regra_w			bigint;
cd_prestador_fornec_w	pls_prestador.cd_prestador%type;

C01 CURSOR FOR
	SELECT	nr_seq_regra
	from	pls_excecao_prest_pag
	where	((coalesce(nr_seq_prestador_exec::text, '') = '') or (nr_seq_prestador_exec	= nr_seq_prestador_exec_p))
	and		ie_situacao	= 'A'
	and		((coalesce(cd_prestador::text, '') = '') or (cd_prestador = cd_prestador_fornec_w))
	and		nr_seq_regra	= nr_seq_regra_p;

BEGIN

select	max(cd_prestador)
into STRICT	cd_prestador_fornec_w
from	pls_prestador
where	nr_sequencia	= nr_seq_prest_fornec_p;

open C01;
loop
fetch C01 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:= 'S';
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prest_excecao ( nr_seq_regra_p bigint, nr_seq_prestador_exec_p bigint, nr_seq_prest_fornec_p bigint default null) FROM PUBLIC;

