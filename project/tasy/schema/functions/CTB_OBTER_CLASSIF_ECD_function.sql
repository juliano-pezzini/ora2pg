-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_classif_ecd ( cd_conta_contabil_p text) RETURNS varchar AS $body$
DECLARE


cd_classif_ecd_w			varchar(40);
cd_classif_conta_sup_w		varchar(40);
cd_conta_contabil_sup_w		varchar(20);
cd_empresa_w			bigint;


BEGIN

select	coalesce(max(cd_classif_ecd),'X')
into STRICT	cd_classif_ecd_w
from	conta_contabil_classif_ecd
where	cd_conta_contabil	= cd_conta_contabil_p;

select	coalesce(max(ctb_obter_classif_conta_sup(ctb_obter_classif_conta(cd_conta_contabil,cd_classificacao,clock_timestamp()),clock_timestamp(),cd_empresa)),'X') cd_classif,
	max(cd_empresa)
into STRICT	cd_classif_conta_sup_w,
	cd_empresa_w
from	conta_contabil
where	cd_conta_contabil	= cd_conta_contabil_p;

if (cd_classif_ecd_w = 'X') and (cd_classif_conta_sup_w <> 'X') then

	select	max(b.cd_classif_ecd)
	into STRICT	cd_classif_ecd_w
	from	conta_contabil a,
		conta_contabil_classif_ecd b
	where	a.cd_conta_contabil	= b.cd_conta_contabil
	and	substr(ctb_obter_classif_conta(a.cd_conta_contabil,a.cd_classificacao,clock_timestamp()),1,40)	 = cd_classif_conta_sup_w
	and	a.cd_empresa	 = cd_empresa_w;

end if;

if (cd_classif_ecd_w = 'X') then
	cd_classif_ecd_w	:= '';
end if;

return cd_classif_ecd_w;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_classif_ecd ( cd_conta_contabil_p text) FROM PUBLIC;
