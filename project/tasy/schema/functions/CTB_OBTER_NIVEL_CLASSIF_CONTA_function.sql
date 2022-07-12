-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_nivel_classif_conta ( cd_classif_conta_p text) RETURNS bigint AS $body$
DECLARE


i			integer;
k			integer;
ie_separador_conta_w	empresa.ie_sep_classif_conta_ctb%type;


BEGIN
i			:= 1;

ie_separador_conta_w := philips_contabil_pck.get_separador_conta;
if (cd_classif_conta_p IS NOT NULL AND cd_classif_conta_p::text <> '') then
	FOR k in 1..length(cd_classif_conta_p) LOOP
		if (substr(cd_classif_conta_p,k,1) = ie_separador_conta_w) then
			i	:= i + 1;
		end if;
	END LOOP;
end if;
return i;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_nivel_classif_conta ( cd_classif_conta_p text) FROM PUBLIC;
