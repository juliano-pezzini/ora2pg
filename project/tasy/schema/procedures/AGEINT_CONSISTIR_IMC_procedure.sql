-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consistir_imc ( qt_peso_p bigint, qt_altura_cm_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_imc_w	real;
qt_imc_max_w	real;


BEGIN

select	coalesce(max(qt_imc),0)
into STRICT	qt_imc_max_w
from	parametro_agenda_integrada
where	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;

if (qt_imc_max_w	> 0) then
	if (position(',' in qt_altura_cm_p) > 0) then
		qt_imc_w	:= trunc(obter_imc(qt_peso_p, qt_altura_cm_p * 100),3);
	else
		qt_imc_w	:= trunc(obter_imc(qt_peso_p, qt_altura_cm_p),3);
	end if;

	if (qt_imc_w	> qt_imc_max_w) then
		ds_erro_p	:= wheb_mensagem_pck.get_texto(280655,'QT_IMC='|| qt_imc_w||';QT_IMC_MAX='||qt_imc_max_w);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consistir_imc ( qt_peso_p bigint, qt_altura_cm_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
