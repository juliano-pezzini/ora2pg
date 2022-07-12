-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_se_pre_agend_cid (nr_seq_agendamento_w bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(5);

BEGIN

if (nr_seq_agendamento_w IS NOT NULL AND nr_seq_agendamento_w::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	atend_cid_esp_pre_agend
	where	nr_seq_agenda_destino = nr_seq_agendamento_w;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_se_pre_agend_cid (nr_seq_agendamento_w bigint) FROM PUBLIC;
