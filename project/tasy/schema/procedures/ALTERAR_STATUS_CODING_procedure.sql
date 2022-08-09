-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_coding ( nr_sequencia_p bigint, nr_case_p text, id_user_resp_p bigint, nr_encounter_p bigint, ds_coding_status_p text, dt_start_audit_p timestamp, nm_usuario_nrec_p text, ds_comment_p text) AS $body$
DECLARE


cd_auditor_w auditoria_conta_paciente.cd_auditor%type;
nm_usuario_w usuario.cd_pessoa_fisica%type;
nr_sequencia_w bigint;
ds_status_w varchar(100);
dt_end_audit_w timestamp;


BEGIN

    select  coalesce(max(nr_sequencia),0)
    into STRICT    nr_sequencia_w
    from    coding_audit_history
    where (
                (nr_encounter_p IS NOT NULL AND nr_encounter_p::text <> '') and nr_encounter = nr_encounter_p
                or ((nr_case_p IS NOT NULL AND nr_case_p::text <> '') or nr_case = nr_case_p)
            )
    and     coalesce(dt_end_audit::text, '') = '';

  

    if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
        update  coding_audit_history
        set     dt_end_audit = clock_timestamp()
        where   nr_sequencia = nr_sequencia_w;
    end if;

    if (nr_sequencia_p > 0 )then
        dt_end_audit_w := clock_timestamp();
		if (nr_case_p > 0)then
			UPDATE EPISODIO_PACIENTE SET DT_FIM_EPISODIO = clock_timestamp() WHERE NR_SEQUENCIA = nr_case_p;
		end if;
    end if;	

    insert into coding_audit_history(
        nr_sequencia,
        id_resp_user, 
        nr_case, 
        nr_encounter, 
        ds_coding_status, 
        dt_start_audit, 
        ds_comment,
        dt_atualizacao,
	nm_usuario,
	dt_end_audit
    ) values (
        nextval('coding_audit_history_seq'),
        id_user_resp_p,
        nr_case_p,
        nr_encounter_p, 
        ds_coding_status_p,
        dt_start_audit_p,
        ds_comment_p,
	clock_timestamp(),
	nm_usuario_nrec_p,
        dt_end_audit_w
        
    );

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_coding ( nr_sequencia_p bigint, nr_case_p text, id_user_resp_p bigint, nr_encounter_p bigint, ds_coding_status_p text, dt_start_audit_p timestamp, nm_usuario_nrec_p text, ds_comment_p text) FROM PUBLIC;
