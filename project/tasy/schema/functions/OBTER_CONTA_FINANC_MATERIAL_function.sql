-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_financ_material ( cd_estabelecimento_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_conta_financ_w		bigint;


BEGIN

nr_seq_conta_financ_w := obter_conta_financeira(	'S', cd_estabelecimento_p, cd_material_p, null, null, null, null, null, null, nr_seq_conta_financ_w, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);

return	nr_seq_conta_financ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_financ_material ( cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;
