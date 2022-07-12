-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_acao_os ( nr_seq_doc_erro_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(255);
qt_histotico_w				bigint;
qt_os_acao_w				bigint;


BEGIN

select	count(*)
into STRICT	qt_histotico_w
from	pessoa_fisica_observacao
where	nr_seq_doc_erro	= nr_seq_doc_erro_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

select	count(*)
into STRICT	qt_os_acao_w
from	pessoa_fisica_observacao
where	nr_seq_doc_erro	= nr_seq_doc_erro_p
and	(nr_seq_os_feedback IS NOT NULL AND nr_seq_os_feedback::text <> '');

if (qt_histotico_w > 0) then
	ds_retorno_w	:= 'F';
end if;

if (qt_os_acao_w > 0) then
	ds_retorno_w	:= 'A';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_acao_os ( nr_seq_doc_erro_p bigint) FROM PUBLIC;

