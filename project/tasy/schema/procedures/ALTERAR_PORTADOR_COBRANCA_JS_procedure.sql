-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_portador_cobranca_js (nr_titulo_p bigint) AS $body$
DECLARE


/*
Procedure executada no afterpost do alteracaoPortador, do titulo receber,
no java.
*/
qt_cobranca_tit_w		bigint;
cd_tipo_portador_w		bigint;
cd_portador_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_cobranca_tit_w
from	cobranca
where	nr_titulo	= nr_titulo_p;

if (qt_cobranca_tit_w > 0) then

	select	max(cd_tipo_portador),
		max(cd_portador)
	into STRICT	cd_tipo_portador_w,
		cd_portador_w
	from	titulo_receber
	where	nr_titulo		= nr_titulo_p;

	update	cobranca
	set	cd_tipo_portador	= cd_tipo_portador_w,
		cd_portador	= cd_portador_w
	where	nr_titulo		= nr_titulo_p;

end if;

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_portador_cobranca_js (nr_titulo_p bigint) FROM PUBLIC;
