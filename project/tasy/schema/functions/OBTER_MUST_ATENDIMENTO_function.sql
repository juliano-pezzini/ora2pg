-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_must_atendimento (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE



QT_PONTUACAO_w	bigint;

C01 CURSOR FOR
	SELECT	QT_PONTUACAO
	from	escala_must
	where	nr_atendimento	= nr_atendimento_p
	order by dt_avaliacao;


BEGIN

open C01;
loop
fetch C01 into
	QT_PONTUACAO_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return	QT_PONTUACAO_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_must_atendimento (nr_atendimento_p bigint) FROM PUBLIC;

