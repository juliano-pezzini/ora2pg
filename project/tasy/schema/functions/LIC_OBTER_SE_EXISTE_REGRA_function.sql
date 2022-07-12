-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_existe_regra ( cd_conta_contabil_p text, nr_seq_tipo_compra_p bigint, nr_seq_mod_compra_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_w			varchar(1) := 'N';
qt_existe_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_conta_valor
where	((coalesce(cd_conta_contabil::text, '') = '') and (coalesce(cd_conta_contabil_p::text, '') = '') or (cd_conta_contabil IS NOT NULL AND cd_conta_contabil::text <> '') and (cd_conta_contabil = cd_conta_contabil_p))
and	((coalesce(nr_seq_tipo_compra::text, '') = '') and (coalesce(nr_seq_tipo_compra_p::text, '') = '') or (nr_seq_tipo_compra IS NOT NULL AND nr_seq_tipo_compra::text <> '') and (nr_seq_tipo_compra = nr_seq_tipo_compra_p))
and	((coalesce(nr_seq_mod_compra::text, '') = '') and (coalesce(nr_seq_mod_compra_p::text, '') = '') or (nr_seq_mod_compra IS NOT NULL AND nr_seq_mod_compra::text <> '') and (nr_seq_mod_compra = nr_seq_mod_compra_p))
and	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A';

if (qt_existe_w > 0) then
	ie_existe_w := 'S';
end if;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_existe_regra ( cd_conta_contabil_p text, nr_seq_tipo_compra_p bigint, nr_seq_mod_compra_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

