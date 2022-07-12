-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_permite_agora (nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_agora_w	varchar(1);


BEGIN
if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then

	select	coalesce(max(ie_agora),'S')
	into STRICT	ie_permite_agora_w
	from	exame_laboratorio
	where	nr_seq_exame = nr_seq_exame_p;

end if;

return ie_permite_agora_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_permite_agora (nr_seq_exame_p bigint) FROM PUBLIC;

