-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE atendimento AS (nr_atendimento bigint,
								cd_pessoa_fisica	varchar(10));


CREATE OR REPLACE PROCEDURE panorama_leito_pck.inserepanocorrencia (nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, pIeConcluido text) AS $body$
DECLARE


        type vetor_atendimento is table of atendimento index by integer;

        vetor_atend_w	vetor_atendimento;
        i	            bigint;
        k	            bigint;
        i_vetor_w	    bigint;

BEGIN
        /* Alimentar o vetor primeiro */

        vetor_atend_w.delete;
        i_vetor_w	:= 1;
        for	r_c_atendimento in current_setting('panorama_leito_pck.c_atendimentos')::CURSOR(nr_seq_interno_p(nr_seq_interno_p) loop
            vetor_atend_w[i_vetor_w].nr_atendimento := r_c_atendimento.nr_atendimento;
            vetor_atend_w[i_vetor_w].cd_pessoa_fisica := r_c_atendimento.cd_pessoa_fisica;
            i_vetor_w	:= i_vetor_w + 1;
        end loop;

        /* Passar varias vezes no vetor */

        i := vetor_atend_w.count;
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,3);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_alerta_3(Vetor_atend_w[k].nr_atendimento, Vetor_atend_w[k].cd_pessoa_fisica, pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 3;
			commit;
		
			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,17);
        end if;
		
		/*for k in 1.. i loop
            gerar_w_ocor_alta_medica_17(Vetor_atend_w(k).nr_atendimento,cd_estabelecimento_p,nm_usuario_p,pIeConcluido);
            commit;
        end loop;*/
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 17;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,2);
		end if;

		/*for k in 1.. i loop
            gerar_w_ocor_aniversario_2(Vetor_atend_w(k).nr_atendimento,Vetor_atend_w(k).cd_pessoa_fisica);
            commit;
        end loop;*/
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 2;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,16);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_bacteria_conf_16(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 16;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,5);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_exame_enf_5(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 5;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,4);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_exame_lab_4(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 4;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,10);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_exame_lab_res_10(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,cd_estabelecimento_p,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 10;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,57);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_exame_nonlab_57(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 57;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,12);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_descont_12(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 12;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,1);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_nao_chec_1(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,cd_estabelecimento_p,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 1;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,14);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_n_conf_enf_14(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 14;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,15);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_n_conf_farm_15(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 15;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,13);
		end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_susp_med_13(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 13;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,6);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_it_susp_sol_6(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 6;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,19);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_leito_reserv_19(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 19;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,9);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_protocolo_9(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 9;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,11);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_res_critico_11(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,cd_estabelecimento_p,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 11;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,8);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_teste_bac_8(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 8;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,18);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_transf_solic_18(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 18;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,21);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_21(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 21;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,24);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_24(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 24;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,50);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_50(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 50;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,51);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_51(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 51;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,52);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_52(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 52;
			commit;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,20);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pendencias_20(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 20;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,53);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_ocor_pac_away_53(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;

		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 53;

			insert into w_panorama_etapa(ie_panorama_conc,ie_etapa,dt_inicio_etapa,dt_fim_etapa,ie_icone) values ('N','OCO',clock_timestamp(),null,54);
        end if;
		
		for k in 1.. i loop
            CALL panorama_leito_pck.gerar_w_surgery_status_54(Vetor_atend_w[k].nr_atendimento,Vetor_atend_w[k].cd_pessoa_fisica,pIeConcluido);
            commit;
        end loop;
		
		if (current_setting('panorama_leito_pck.ie_gerar_log')::varchar(1) = 'S') then
			update w_panorama_etapa set dt_fim_etapa = clock_timestamp() where ie_etapa = 'OCO' and coalesce(dt_fim_etapa::text, '') = '' and ie_icone = 54;
			commit;
		end if;
		
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE panorama_leito_pck.inserepanocorrencia (nr_seq_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, pIeConcluido text) FROM PUBLIC;
