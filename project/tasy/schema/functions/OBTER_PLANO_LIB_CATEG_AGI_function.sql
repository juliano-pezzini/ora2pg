-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_plano_lib_categ_agi (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE



ie_liberado_w	varchar(01)	:= 'S';
qt_regra_w	bigint;
dt_atendimento_w	timestamp;
cd_estabelecimento_usu_w  usuario_estabelecimento.cd_estabelecimento%type;

c01 CURSOR FOR
  SELECT  cd_estabelecimento
  from    usuario_estabelecimento
  where nm_usuario_param = nm_usuario_p;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	categoria_plano
where	cd_convenio	= cd_convenio_p
and	cd_categoria	= cd_categoria_p
and	ie_situacao	= 'A';

dt_atendimento_w	:= trunc(dt_atendimento_p);

if (qt_regra_w > 0) THEN

	open C01;
	loop
	fetch C01 INTO
		cd_estabelecimento_usu_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
		select	coalesce(max('S'), 'N')
		into STRICT	ie_liberado_w
		from	categoria_plano
		where	cd_convenio	= cd_convenio_p
		and	cd_categoria	= cd_categoria_p
		and	cd_plano	= cd_plano_p
		and 	coalesce(cd_estabelecimento,cd_estabelecimento_usu_w) = cd_estabelecimento_usu_w
		and	ie_situacao	= 'A'
		and	dt_atendimento_w between coalesce(dt_inicio_vigencia,dt_atendimento_w) -1 and fim_dia(coalesce(DT_FINAL_VIGENCIA,dt_atendimento_w));

		IF (ie_liberado_w = 'S') THEN
			RETURN ie_liberado_w;
  		END IF;
	END;
	END LOOP;
	CLOSE c01;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_plano_lib_categ_agi (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp, nm_usuario_p text) FROM PUBLIC;

