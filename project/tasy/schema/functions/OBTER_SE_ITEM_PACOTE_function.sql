-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_pacote ( nr_sequencia_p bigint, ie_tipo_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1):= 'N';



BEGIN


if (ie_tipo_item_p = 1) then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from 	atendimento_pacote
	where 	nr_seq_proc_origem = nr_sequencia_p;

	if (ds_retorno_w = 'N') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	procedimento_paciente
		where	nr_sequencia = nr_sequencia_p
		and	(nr_seq_proc_pacote IS NOT NULL AND nr_seq_proc_pacote::text <> '');
	end if;

elsif (ie_tipo_item_p = 2) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	material_atend_paciente
	where	nr_sequencia = nr_sequencia_p
	and	(nr_seq_proc_pacote IS NOT NULL AND nr_seq_proc_pacote::text <> '');

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_pacote ( nr_sequencia_p bigint, ie_tipo_item_p bigint) FROM PUBLIC;

