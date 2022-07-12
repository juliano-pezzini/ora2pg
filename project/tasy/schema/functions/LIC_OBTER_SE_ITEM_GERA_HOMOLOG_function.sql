-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_item_gera_homolog ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_gera_w		varchar(1) := 'S';
qt_existe_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_item a
where	a.nr_seq_licitacao	= nr_seq_licitacao_p
and	a.nr_seq_lic_item	= nr_seq_lic_item_p
and exists (
	SELECT	1
	from	reg_lic_homologacao x,
		reg_lic_homol_itens y
	where	x.nr_sequencia	= y.nr_seq_homologacao
	and	y.nr_seq_lic_item	= a.nr_seq_lic_item
	and	x.nr_seq_licitacao	= a.nr_seq_licitacao
	and	y.ie_homologado		<> 'P'
	and	y.nr_seq_fornec_venc = lic_obter_forn_vencedor_item(a.nr_seq_licitacao, a.nr_seq_lic_item));

/*Se o item está com situação diferente de PENDENTE, não gera homologação*/

if (qt_existe_w > 0) then
	ie_gera_w := 'N';
end if;

if (ie_gera_w = 'S') then

	select	count(*)
	into STRICT	qt_existe_w
	from	reg_lic_item a
	where	a.nr_seq_licitacao	= nr_seq_licitacao_p
	and	a.nr_seq_lic_item	= nr_seq_lic_item_p
	and exists (
		SELECT	1
		from    reg_lic_item_fornec x
		where   x.nr_seq_lic_item	= a.nr_seq_lic_item
		and     x.nr_seq_licitacao	= a.nr_seq_licitacao
		and     coalesce(x.ie_qualificado,'S')	= 'N'
		and	x.nr_seq_fornec = lic_obter_forn_vencedor_item(a.nr_seq_licitacao, a.nr_seq_lic_item));

	/*Se o item está desqualificado, NAO GERA HOMOLOGACAO*/

	if (qt_existe_w > 0) then
		ie_gera_w := 'N';
	end if;
end if;

if (ie_gera_w = 'S') then

	select	count(*)
	into STRICT	qt_existe_w
	from	reg_lic_item a
	where	a.nr_seq_licitacao	= nr_seq_licitacao_p
	and	a.nr_seq_lic_item	= nr_seq_lic_item_p
	and not exists (
		SELECT   1
		from     reg_lic_vencedor x
		where    x.nr_seq_lic_item	= a.nr_seq_lic_item
		and      x.nr_seq_licitacao	= a.nr_seq_licitacao);

	/*Se o item nao existe entre os vencedores, NAO GERA HOMOLOGACAO*/

	if (qt_existe_w > 0) then
		ie_gera_w := 'N';
	end if;
end if;

if (ie_gera_w = 'S') then

	select	count(*)
	into STRICT	qt_existe_w
	from	reg_lic_item a
	where	a.nr_seq_licitacao	= nr_seq_licitacao_p
	and	a.nr_seq_lic_item	= nr_seq_lic_item_p
	and	((lic_obter_situacao_fornec(lic_obter_forn_vencedor_item(a.nr_seq_licitacao, a.nr_seq_lic_item)) <> 'A') or (lic_obter_se_aceito_recurso(a.nr_seq_licitacao, a.nr_seq_lic_item) = 'N'));

	/*Se o fornecedor vencedor estiver com situacao pendente ou se tiver algum recurso pendente, NAO GERA HOMOLOGACAO*/

	if (qt_existe_w > 0) then
		ie_gera_w := 'N';
	end if;
end if;

return	ie_gera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_item_gera_homolog ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint) FROM PUBLIC;

