-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tx_juros_multa_cre ( cd_estabelecimento_p bigint, ie_origem_titulo_p text, ie_tipo_titulo_p text, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint) AS $body$
DECLARE


qt_registros_w	integer;
cd_empresa_w	smallint;


C01 CURSOR FOR
SELECT	tx_juros,
	tx_multa
from	taxa_titulo_receber
where	coalesce(cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
and	coalesce(cd_empresa,cd_empresa_w)			= cd_empresa_w
and	coalesce(ie_origem_titulo,ie_origem_titulo_p)	= ie_origem_titulo_p
and	coalesce(ie_tipo_titulo, ie_tipo_titulo_p)		= ie_tipo_titulo_p
and	clock_timestamp() between coalesce(dt_inicio_vigencia, clock_timestamp()) and coalesce(dt_fim_vigencia, clock_timestamp())
order by dt_inicio_vigencia,
	ie_origem_titulo,
	ie_tipo_titulo;


BEGIN

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

select	count(*)
into STRICT	qt_registros_w
from	taxa_titulo_receber;

if (qt_registros_w > 0) then
	open C01;
	loop
	fetch C01 into
		tx_juros_p,
		tx_multa_p;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tx_juros_multa_cre ( cd_estabelecimento_p bigint, ie_origem_titulo_p text, ie_tipo_titulo_p text, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint) FROM PUBLIC;
