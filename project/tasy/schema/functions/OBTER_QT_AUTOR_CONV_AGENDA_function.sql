-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_autor_conv_agenda ( nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint;


BEGIN

select 	coalesce(max(qt_dia_autorizado),0)
into STRICT 	qt_retorno_w
from 	autorizacao_convenio
where 	nr_seq_agenda = nr_seq_agenda_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_autor_conv_agenda ( nr_seq_agenda_p bigint) FROM PUBLIC;
