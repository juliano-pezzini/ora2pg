-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dt_final_indicador_gest_vaga (nr_seq_gestao_vaga_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_final_w      	timestamp;


BEGIN

	if (coalesce(nr_seq_gestao_vaga_p::text, '') = '') then
		begin
			select max(rs.dt_atualizacao)
			into STRICT dt_final_w
			from regulacao_atend ra
			  join regulacao_status rs ON (rs.nr_seq_regulacao_atend = ra.nr_sequencia)
			where ra.nr_seq_gestao_vaga = nr_seq_gestao_vaga_p
				and rs.ie_status in ('AT', 'AG', 'CA', 'NG');

			if (coalesce(dt_final_w::text, '') = '') then
				begin
					select max(gvs.dt_atualizacao)
					into STRICT dt_final_w
					from gestao_vaga gv
					  join gestao_vaga_hist_status gvs ON (gvs.nr_seq_gestao_vaga = gv.nr_sequencia)
					where gvs.ie_status IN ('P', 'D', 'C')
					  and gv.nr_sequencia = nr_seq_gestao_vaga_p;

					if (coalesce(dt_final_w::text, '') = '') then
						dt_final_w := clock_timestamp();
					end if;
				end;
			end if;
		end;
	else
		dt_final_w := clock_timestamp();
	end if;

	return dt_final_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dt_final_indicador_gest_vaga (nr_seq_gestao_vaga_p bigint) FROM PUBLIC;

