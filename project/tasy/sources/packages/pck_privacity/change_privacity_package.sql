-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pck_privacity.change_privacity (p_nm_usuario text, p_nr_atendimento bigint) AS $body$
DECLARE

    v_ie_privacidade varchar(1);
    v_is_exist       smallint;

BEGIN
        select case 
                   when exists (select 0 from atend_paciente_adic where nr_atendimento = p_nr_atendimento)
                   then 1
                   else 0
               end into STRICT v_is_exist
;

        if (v_is_exist = 1) then
        begin 
            select ie_privacidade_av into STRICT v_ie_privacidade from atend_paciente_adic where nr_atendimento = p_nr_atendimento;

            if (coalesce(v_ie_privacidade::text, '') = '' or v_ie_privacidade = 'N') then
                update atend_paciente_adic set ie_privacidade_av = 'S' where nr_atendimento = p_nr_atendimento;
            else
                update atend_paciente_adic set ie_privacidade_av = 'N' where nr_atendimento = p_nr_atendimento;
            end if;
        end;
        else
        begin
            insert into atend_paciente_adic(nr_sequencia, dt_atualizacao, nm_usuario, nr_atendimento, ie_privacidade_av) values (nextval('atend_paciente_adic_seq'), clock_timestamp(), p_nm_usuario, p_nr_atendimento, 'S');
        end;
        end if;
        commit;
    end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pck_privacity.change_privacity (p_nm_usuario text, p_nr_atendimento bigint) FROM PUBLIC;