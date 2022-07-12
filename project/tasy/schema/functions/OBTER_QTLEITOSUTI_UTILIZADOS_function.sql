-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtleitosuti_utilizados ( cd_tipo_leito_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_leitos_uti_w	integer;


BEGIN

select	coalesce(sum(qt_diaria),0)
	into STRICT	qt_leitos_uti_w
	from	sus_leito_movto
	where	trunc(dt_referencia,'month')	= trunc(dt_referencia_p,'month')
	and	cd_tipo_leito			= cd_tipo_leito_p;

Return qt_leitos_uti_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtleitosuti_utilizados ( cd_tipo_leito_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

