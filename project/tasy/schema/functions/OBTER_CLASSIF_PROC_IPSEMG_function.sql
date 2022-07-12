-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_proc_ipsemg (cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_classif_ipsemg_w	varchar(1);
ds_classif_ipsemg_w	varchar(255);


BEGIN

Select	ie_classif_ipsemg,
	obter_valor_dominio(5653,ie_classif_ipsemg)
into STRICT	ie_classif_ipsemg_w,
	ds_classif_ipsemg_w
from	procedimento_ipsemg
where	cd_procedimento = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;

	if (ie_opcao_p = 'C') then
		RETURN ie_classif_ipsemg_w;
	else
		RETURN ds_classif_ipsemg_w;
	end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_proc_ipsemg (cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_opcao_p text) FROM PUBLIC;

