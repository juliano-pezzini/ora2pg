-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cooperativa ( cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_cgc_outorgante_w	pls_outorgante.cd_cgc_outorgante%type;
nr_seq_congenere_w	pls_congenere.nr_sequencia%type;
cd_cooperativa_w	pls_congenere.cd_cooperativa%type;
ie_retorno_w		varchar(1);


BEGIN

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante
where	cd_estabelecimento = coalesce(cd_estabelecimento_p,cd_estabelecimento);

select	max(nr_sequencia)
into STRICT	nr_seq_congenere_w
from	pls_congenere
where	cd_cgc			= cd_cgc_outorgante_w
and	ie_tipo_congenere	= 'CO';

select	max(cd_cooperativa)
into STRICT	cd_cooperativa_w
from	pls_congenere
where	nr_sequencia	= nr_seq_congenere_w;

if (coalesce(cd_cooperativa_w::text, '') = '') then
	ie_retorno_w := 'N'; -- Operadora
else
	ie_retorno_w := 'S'; -- Cooperativa
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cooperativa ( cd_estabelecimento_p bigint) FROM PUBLIC;
