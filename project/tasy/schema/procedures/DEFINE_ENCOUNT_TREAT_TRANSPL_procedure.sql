-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_encount_treat_transpl ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_count_w      bigint;


BEGIN

select  count(*)
into STRICT    qt_count_w
from    atendimento_paciente_inf
where   nr_atendimento = nr_atendimento_p;

if (qt_count_w > 0) then
        update  atendimento_paciente_inf
        set     ie_trat_transplante = 'S',
                dt_atualizacao = clock_timestamp(),
                nm_usuario = nm_usuario_p
        where   nr_atendimento = nr_atendimento_p;
else
        insert into atendimento_paciente_inf(
                nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                nr_atendimento,
                ie_trat_transplante)
        values (
                nextval('atendimento_paciente_inf_seq'),
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                nr_atendimento_p,
                'S'
        );
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_encount_treat_transpl ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
