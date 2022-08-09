-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE laudo_paciente_marcar_ciente ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, nr_seq_laudo_p bigint, nr_seq_ext_p bigint default 0, nr_seq_result_ext_p bigint default 0) AS $body$
DECLARE

ds_parameter_w      varchar(2000);
nr_atendimento_w    bigint;
cd_pessoa_fisica_w  varchar(10);
nr_seq_interno_w    bigint;
nr_seq_proc_hor_w   bigint;
dt_horario_w	timestamp;
/*
    M - Marcado como ciente
    D - Desmarcado como ciente
*/
BEGIN
    insert into laudo_paciente_ciente(nr_sequencia,
    nr_prescricao,
    nr_seq_prescricao,
    nm_usuario, 
    nm_usuario_nrec, 
    dt_atualizacao,
    dt_atualizacao_nrec,
    nr_seq_laudo,
    nr_seq_ext,
    nr_seq_result_ext,
    ie_tipo_acao)
    values (nextval('laudo_paciente_ciente_seq'), 
    nr_prescricao_p,
    nr_seq_prescricao_p,
    nm_usuario_p, 
    nm_usuario_p, 
    clock_timestamp(),
    clock_timestamp(),
    nr_seq_laudo_p,
    nr_seq_ext_p,
    nr_seq_result_ext_p,
    'M');
    CALL wl_gerar_finalizar_tarefa('EN','F',null,null,nm_usuario_p,null,'S',null,null,null,nr_prescricao_p,nr_seq_prescricao_p);
    begin
    select  a.nr_atendimento,
        a.cd_pessoa_fisica,
        b.nr_seq_interno
    into STRICT    nr_atendimento_w,
        cd_pessoa_fisica_w,
        nr_seq_interno_w
    from    prescr_medica a,
        prescr_procedimento b
    where   a.nr_prescricao = b.nr_prescricao
    and b.nr_prescricao = nr_prescricao_p
    and b.nr_sequencia = nr_seq_prescricao_p;
    exception
    when others then
        nr_atendimento_w := 0;
    end;
    if (nr_atendimento_w > 0) then
        begin
		
		
		select  coalesce(max(nr_sequencia),0),
				coalesce(max(dt_horario),clock_timestamp())
		into STRICT    nr_seq_proc_hor_w,
				dt_horario_w
		from    prescr_proc_hor
		where   nr_prescricao   = nr_prescricao_p
		and     nr_seq_procedimento = nr_seq_prescricao_p;
					
        if (nr_seq_laudo_p IS NOT NULL AND nr_seq_laudo_p::text <> '') then

        ds_parameter_w := '{"CD_PESSOA_FISICA" : "' || cd_pessoa_fisica_w || '"' || 
                    ' , "NR_ATENDIMENTO" : ' || nr_atendimento_w || 
                    ' , "NR_PRESCRICAO" : '  || nr_prescricao_p ||
                    ' , "NR_SEQ_PRESCR" : ' || nr_seq_prescricao_p ||
					' , "NR_SEQ_PROCEDIMENTO" : ' || nr_seq_proc_hor_w  || '}';
							
            CALL execute_bifrost_integration(80,ds_parameter_w);
        else
		
        ds_parameter_w := '{"CD_PESSOA_FISICA" : "' || cd_pessoa_fisica_w || '"' ||
                    ' , "NR_ATENDIMENTO" : ' || nr_atendimento_w || 
                    ' , "NR_PRESCRICAO" : '  || nr_prescricao_p ||
                    ' , "NR_SEQ_PRESCR" : ' || nr_seq_prescricao_p ||
					' , "DT_HORARIO" : ' || pkg_date_utils.get_isoformat(dt_horario_w)  || '}';
							
            CALL execute_bifrost_integration(120,ds_parameter_w);
        end if;
        end;
    end if;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE laudo_paciente_marcar_ciente ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, nr_seq_laudo_p bigint, nr_seq_ext_p bigint default 0, nr_seq_result_ext_p bigint default 0) FROM PUBLIC;
