-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_check_list_liberado (nr_seq_servico_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ie_ignorar_checklist_w	varchar(1);


BEGIN


SELECT 	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
INTO STRICT	ds_retorno_w
FROM	sl_check_list_unid
WHERE	nr_seq_sl_unid	= nr_seq_servico_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

if (ds_retorno_w = 'N') then

	select	coalesce(max(ie_ignorar_checklist),'N')
	into STRICT	ie_ignorar_checklist_w
	from	unidade_atendimento a,
		sl_unid_atend b
	where	b.nr_seq_unidade = a.nr_seq_interno
	and	b.nr_sequencia	= nr_seq_servico_p;

	if (ie_ignorar_checklist_w = 'S') then
		ds_retorno_w	:= 'S';
	end if;
end if;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_check_list_liberado (nr_seq_servico_p bigint) FROM PUBLIC;
