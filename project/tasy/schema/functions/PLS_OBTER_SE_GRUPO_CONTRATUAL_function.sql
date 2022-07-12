-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_grupo_contratual ( nr_contrato_p bigint, nr_seq_contrato_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1)	:= 'N';
nr_seq_contrato_w		bigint;


BEGIN

select	nr_sequencia
into STRICT	nr_seq_contrato_w
from	pls_contrato
where	nr_contrato	= nr_contrato_p;

if (nr_seq_contrato_w = nr_seq_contrato_grupo_p) then
	ie_retorno_w	:= 'S';
else
	/* Contratos filhos do contrato selecionado*/

	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	pls_contrato	a
	where	a.nr_sequencia in (SELECT b.nr_sequencia from pls_contrato b where b.nr_contrato_principal = nr_seq_contrato_w)
	and	a.nr_sequencia	= nr_seq_contrato_grupo_p;

	if (ie_retorno_w	= 'N') then
		/* Contratos que referenciam o mesmo do contrato selecionado */

		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	pls_contrato	a
		where	a.nr_contrato_principal in (SELECT b.nr_contrato_principal from pls_contrato b where b.nr_sequencia = nr_seq_contrato_w)
		and	a.nr_sequencia	= nr_seq_contrato_grupo_p;

		if (ie_retorno_w	= 'N') then
			/* Contrato referenciado pelo contrato selecionado */

			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	pls_contrato	a
			where	a.nr_sequencia in (SELECT b.nr_contrato_principal from pls_contrato b where b.nr_sequencia = nr_seq_contrato_w)
			and	a.nr_sequencia	= nr_seq_contrato_grupo_p;
		end if;
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_grupo_contratual ( nr_contrato_p bigint, nr_seq_contrato_grupo_p bigint) FROM PUBLIC;

