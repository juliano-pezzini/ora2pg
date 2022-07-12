-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE panorama_leito_pck.gerar_w_pan_paciente (nr_seq_interno_p bigint) AS $body$
BEGIN
	
	if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
		insert into w_panorama_etapa(ie_panorama_conc,
			ie_etapa,
			dt_inicio_etapa,
			dt_fim_etapa)
		values ('N',
			'PAC',
			clock_timestamp(),
			null);

		commit;
	end if;
	
	if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then
		delete from w_pan_paciente where nr_seq_interno = nr_seq_interno_p;
		commit;
        CALL panorama_leito_pck.inserepanpaciente('N', nr_seq_interno_p);
	end if;

    if (coalesce(nr_seq_interno_p::text, '') = '') then
        PERFORM set_config('panorama_leito_pck.wieconcluido', 'N', false);
    else
        PERFORM set_config('panorama_leito_pck.wieconcluido', 'S', false);
    end if;

    CALL panorama_leito_pck.inserepanpaciente(current_setting('panorama_leito_pck.wieconcluido')::varchar(1), nr_seq_interno_p);
	
	if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
		update	w_panorama_etapa
		set		dt_fim_etapa = clock_timestamp()
		where	ie_etapa = 'PAC'
		and		coalesce(dt_fim_etapa::text, '') = '';

		commit;
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE panorama_leito_pck.gerar_w_pan_paciente (nr_seq_interno_p bigint) FROM PUBLIC;
