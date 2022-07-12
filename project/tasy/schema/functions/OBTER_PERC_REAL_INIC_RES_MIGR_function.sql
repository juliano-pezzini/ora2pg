-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_perc_real_inic_res_migr ( nr_seq_projeto_p bigint, dt_resumo_p timestamp) RETURNS bigint AS $body$
DECLARE


pr_real_inic_w	real := 0;


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (dt_resumo_p IS NOT NULL AND dt_resumo_p::text <> '') then
	begin
	select	max(r.pr_final)
	into STRICT	pr_real_inic_w
	from	w_resumo_migracao r
	where	r.nr_seq_projeto = nr_seq_projeto_p
	and	trunc(r.dt_resumo,'dd') = trunc(dt_resumo_p,'dd')
	and	r.dt_resumo < dt_resumo_p;

	if (coalesce(pr_real_inic_w::text, '') = '') then
		begin
		pr_real_inic_w := proj_obter_perc_cron(nr_seq_projeto_p, 'E');
		end;
	end if;
	end;
end if;
return pr_real_inic_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_perc_real_inic_res_migr ( nr_seq_projeto_p bigint, dt_resumo_p timestamp) FROM PUBLIC;
