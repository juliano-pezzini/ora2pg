-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tit_nf_cob_escrit (nr_seq_nf_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(01) := 'N';
cd_estabelecimento_w	smallint;


BEGIN

select	coalesce(max(cd_estabelecimento),0)
into STRICT	cd_estabelecimento_w
from	nota_fiscal
where	nr_sequencia = nr_seq_nf_p;

if (cd_estabelecimento_w > 0) then
	select	CASE WHEN max(qt_existe)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from (
		SELECT  count(*) qt_existe
		from	titulo_pagar_escrit t,
			titulo_pagar a
		where	a.nr_seq_nota_fiscal 	= nr_seq_nf_p
		and	a.cd_estabelecimento 	= cd_estabelecimento_w
		and	a.ie_situacao		<> 'C'
		and	a.nr_titulo		= t.nr_titulo
		
union

		SELECT	count(*)
		from	titulo_receber_cobr t,
			titulo_receber a
		where	a.nr_seq_nf_saida    	= nr_seq_nf_p
		and	a.ie_situacao		<> '3'
		and	a.cd_estabelecimento	= cd_estabelecimento_w
		and	t.nr_titulo			= a.nr_titulo) alias4;
end if;

return	coalesce(ds_retorno_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tit_nf_cob_escrit (nr_seq_nf_p bigint) FROM PUBLIC;

