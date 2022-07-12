-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_os_producao (nm_usuario_p text, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


cont_w	bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	man_ordem_serv_estagio
where	nm_usuario	= nm_usuario_p
and	nr_seq_estagio	in (2, 31, 1511)
and	trunc(dt_atualizacao, 'dd') = trunc(dt_referencia_p, 'dd');

return	cont_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_os_producao (nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;

