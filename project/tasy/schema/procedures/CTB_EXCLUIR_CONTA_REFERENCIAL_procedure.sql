-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_excluir_conta_referencial ( cd_versao_p bigint, cd_empresa_p bigint, ie_excluir_vinculo_p text, nm_usuario_p text) AS $body$
DECLARE


cd_versao_w				conta_contabil_referencial.cd_versao%type;


BEGIN


begin
select	CASE WHEN cd_versao_p=0 THEN 'X' WHEN cd_versao_p=1 THEN '3.0' WHEN cd_versao_p=2 THEN '3.1' END
into STRICT	cd_versao_w
;
exception when others then
	cd_versao_w	:= null;
end;

if (coalesce(ie_excluir_vinculo_p, 'N') = 'S') then
	begin

	delete	FROM conta_contabil_classif_ecd a
	where	coalesce(a.cd_versao, 'X') = cd_versao_w
	and	exists (	SELECT	1
					from	conta_contabil_referencial x
					where	coalesce(x.cd_versao, 'X') 	= cd_versao_w
					and	x.cd_classificacao	= a.cd_classif_ecd
					and	x.cd_empresa		= cd_empresa_p)
	and	exists (	select	1
			from	conta_contabil y
			where	y.cd_conta_contabil	= a.cd_conta_contabil
			and	y.cd_empresa		= cd_empresa_p);
	end;
end if;

delete	FROM conta_contabil_referencial
where	coalesce(cd_versao, 'X') = cd_versao_w
and	cd_empresa	= cd_empresa_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_excluir_conta_referencial ( cd_versao_p bigint, cd_empresa_p bigint, ie_excluir_vinculo_p text, nm_usuario_p text) FROM PUBLIC;

