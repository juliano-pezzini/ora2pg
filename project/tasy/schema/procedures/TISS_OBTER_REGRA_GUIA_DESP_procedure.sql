-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_regra_guia_desp ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_guia_honorario_p INOUT text) AS $body$
DECLARE


ie_guia_honorario_w	varchar(10);

c01 CURSOR FOR
SELECT	coalesce(ie_regra, 'N')
from	tiss_regra_desp_guia
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_p
and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0);


BEGIN

open c01;
loop
fetch c01 into
	ie_guia_honorario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	ie_guia_honorario_w	:= ie_guia_honorario_w;

end loop;
close c01;

ie_guia_honorario_p	:= coalesce(ie_guia_honorario_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_regra_guia_desp ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_guia_honorario_p INOUT text) FROM PUBLIC;
