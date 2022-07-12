-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cid_atendimento ( nr_atendimento_p bigint, cd_cid_p text) RETURNS varchar AS $body$
DECLARE



ie_informado_w		varchar(01);


BEGIN

ie_informado_w		:= 'N';
if (cd_cid_p IS NOT NULL AND cd_cid_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_informado_w
	from	diagnostico_doenca
	where	nr_atendimento	= nr_atendimento_p
	and	cd_doenca		= cd_cid_p;
end if;

RETURN ie_informado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cid_atendimento ( nr_atendimento_p bigint, cd_cid_p text) FROM PUBLIC;
