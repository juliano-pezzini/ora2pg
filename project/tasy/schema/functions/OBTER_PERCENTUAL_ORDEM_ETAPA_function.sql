-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_percentual_ordem_etapa ( nr_seq_cron_etapa_p bigint ) RETURNS bigint AS $body$
DECLARE


pr_etapa_w		bigint;


BEGIN
	pr_etapa_w := 0;

	select	pr_etapa
	into STRICT	pr_etapa_w
	from	proj_cron_etapa
	where	nr_sequencia = nr_seq_cron_etapa_p;

	/*Se retornar zero, não consiste a informação do % etapa ao finalizar atividade na OS*/

	if (pr_etapa_w = 0) then
		pr_etapa_w	:= null;
	end if;

	return	pr_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_percentual_ordem_etapa ( nr_seq_cron_etapa_p bigint ) FROM PUBLIC;
