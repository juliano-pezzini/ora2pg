-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE panorama_leito_pck.gerar_w_pan_info_adicional ( ie_leito_p text, ie_paciente_p text, cd_estabelecimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text) AS $body$
DECLARE

	/*
	Paciente
	 * Idade
	 * Data Nascimento
	 * Sexo
	 * Convenio
	 * Plano
	 * Clinic Description (DS_CLINICA)
	 * Days Admitted (NR_DIAS_INTERNADO)
	 * PatientVaga
	 * Treatment Scales Description (DS_ESCALAS)
	 Verificar porque tras uma string concatenada (function obter_escala_mapa_setor)

	Geral
	 * Status descrition (DS_LEITO)
	 Verificar porque tras uma string concatenada (function obter_desc_leito_mapa_setor)
	 */
	
BEGIN
	
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			insert into w_panorama_etapa(ie_panorama_conc,
				ie_etapa,
				dt_inicio_etapa,
				dt_fim_etapa)
			values ('N',
				'INF',
				clock_timestamp(),
				null);

		   commit;
		end if;
		
        if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then
            delete from w_pan_info_adicional where nr_seq_interno = nr_seq_interno_p;
            commit;

	    delete
	    from   w_pan_info_adicional a
	    where  a.nr_atendimento in ( SELECT b.nr_atendimento
				         from	atendimento_paciente b
					 where  b.nr_atendimento_mae in (select n.nr_atendimento
									 from   unidade_atendimento n
									 where  n.nr_seq_interno = nr_seq_interno_p))
	    and	  coalesce(a.nr_seq_interno::text, '') = '';


	    commit;

            CALL panorama_leito_pck.inserepaninfoadicional('S', nr_seq_interno_p, ie_paciente_p, ie_leito_p, nm_usuario_p, cd_estabelecimento_p);
        end if;

        CALL panorama_leito_pck.inserepaninfoadicional('N', nr_seq_interno_p, ie_paciente_p, ie_leito_p, nm_usuario_p, cd_estabelecimento_p);

        if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then
            update w_pan_info_adicional
            set	ie_concluido = 'S'
            where nr_seq_interno = nr_seq_interno_p;
            commit;
        end if;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update	w_panorama_etapa
			set		dt_fim_etapa = clock_timestamp()
			where	ie_etapa = 'INF'
			and		coalesce(dt_fim_etapa::text, '') = '';

			commit;
		end if;
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE panorama_leito_pck.gerar_w_pan_info_adicional ( ie_leito_p text, ie_paciente_p text, cd_estabelecimento_p bigint, nr_seq_interno_p bigint, nm_usuario_p text) FROM PUBLIC;
