-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pfcs_pat_loc_hst_upt ON pfcs_service_request CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pfcs_pat_loc_hst_upt() RETURNS trigger AS $BODY$
DECLARE
nr_seq_location_w           pfcs_service_request.nr_seq_location%type       := NEW.nr_seq_location;
nr_seq_encounter_w          pfcs_service_request.nr_seq_encounter%type      := NEW.nr_seq_encounter;
nr_seq_patient_w            pfcs_service_request.nr_seq_patient%type        := NEW.nr_seq_patient;
cd_service_request_w        pfcs_service_request.cd_service%type            := NEW.cd_service;
si_intent_w                 pfcs_service_request.si_intent%type             := NEW.si_intent;
si_status_w                 pfcs_service_request.si_status%type             := NEW.si_status;
dt_request_w                pfcs_service_request.dt_authored_on%type        := NEW.dt_authored_on;

ie_execute_w                varchar(1);
nr_seq_pat_loc_hist_w       pfcs_patient_loc_hist.nr_sequencia%type;
nr_seq_last_location_w      pfcs_location.nr_sequencia%type;
nr_seq_organization_w       pfcs_organization.nr_sequencia%type;


/*
    This trigger is responsabile for creating a history of patient locations. It will store all the beds that a patient will
    be assigned to during his episode on the hospital and update the entry and exit of each unit based on the flow of events.

    It will also register the bed requests history, so it will be possible to analyse when the request for the bed was made
    and when the patient really got into the bed
*/
BEGIN

CALL wheb_usuario_pck.set_nm_usuario(PFCS_PCK_CONSTANTS.NM_USER_PFCS);
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,PFCS_PCK_CONSTANTS.IE_YES_BR) = PFCS_PCK_CONSTANTS.IE_YES_BR)  then

    -- Necessary to avoid duplications in some cases
    if ( (TG_OP = 'UPDATE')
            and (cd_service_request_w = OLD.cd_service)
            and (si_intent_w = OLD.si_intent)
            and (si_status_w = OLD.si_status)
            and (nr_seq_location_w = OLD.nr_seq_location)
            and (nr_seq_encounter_w = OLD.nr_seq_encounter)
            and (cd_service_request_w not in (PFCS_PCK_CONSTANTS.CD_ADMISSION,PFCS_PCK_CONSTANTS.CD_TRANSFER,PFCS_PCK_CONSTANTS.CD_DISCHARGE))) then
        ie_execute_w := PFCS_PCK_CONSTANTS.IE_NO;
    end if;

    if ( si_status_w in (PFCS_PCK_CONSTANTS.SI_STATUS_COMPLETED,PFCS_PCK_CONSTANTS.SI_STATUS_ACTIVE)
            and (nr_seq_location_w is not null)
            and (nr_seq_patient_w is not null)
            and (nr_seq_encounter_w is not null)
            and (coalesce(ie_execute_w,PFCS_PCK_CONSTANTS.IE_YES) = PFCS_PCK_CONSTANTS.IE_YES) ) then
        -- If it is a completed transfer or discharge, assign a end period for the previous location
        if (cd_service_request_w in (PFCS_PCK_CONSTANTS.CD_TRANSFER,PFCS_PCK_CONSTANTS.CD_DISCHARGE)
                and si_intent_w = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER) then
            select max(t.nr_sequencia),
                max(t.nr_seq_location)
            into STRICT nr_seq_pat_loc_hist_w,
                nr_seq_last_location_w
            from (
                SELECT nr_sequencia,
                    nr_seq_location
                from pfcs_patient_loc_hist
                where nr_seq_encounter = nr_seq_encounter_w
                    and nr_seq_patient = nr_seq_patient_w
                    and ie_situacao = PFCS_PCK_CONSTANTS.IE_ACTIVE
                    and dt_period_end is null
                    and si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
                order by nr_sequencia desc
            ) t LIMIT 1;

            if ( (nr_seq_pat_loc_hist_w is not null)
                    and ( (nr_seq_last_location_w <> nr_seq_location_w)
                        or (cd_service_request_w = PFCS_PCK_CONSTANTS.CD_DISCHARGE) ) ) then
                update pfcs_patient_loc_hist
                set dt_period_end = dt_request_w
                where nr_sequencia = nr_seq_pat_loc_hist_w;
            end if;
        end if;

        -- If it is an admission or transfer, create a new history entry
        if ((cd_service_request_w in (PFCS_PCK_CONSTANTS.CD_ADMISSION,PFCS_PCK_CONSTANTS.CD_TRANSFER))
                and (si_intent_w in (PFCS_PCK_CONSTANTS.SI_INTENT_ORDER,PFCS_PCK_CONSTANTS.SI_INTENT_PLAN))) then
            select max(nr_seq_organization)
            into STRICT nr_seq_organization_w
            from pfcs_location
            where nr_sequencia = nr_seq_location_w;

            insert into pfcs_patient_loc_hist(
                nr_sequencia,
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario,
                nm_usuario_nrec,
                nr_seq_patient,
                nr_seq_encounter,
                nr_seq_location,
                nr_seq_organization,
                dt_period_start,
                dt_request,
                ie_situacao,
                si_intent
            ) values (
                nextval('pfcs_patient_loc_hist_seq'),
                LOCALTIMESTAMP,
                LOCALTIMESTAMP,
                PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                PFCS_PCK_CONSTANTS.NM_USER_PFCS,
                nr_seq_patient_w,
                nr_seq_encounter_w,
                nr_seq_location_w,
                nr_seq_organization_w,
                CASE WHEN si_intent_w = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER THEN dt_request_w ELSE null END,
                CASE WHEN si_intent_w = PFCS_PCK_CONSTANTS.SI_INTENT_PLAN THEN dt_request_w ELSE null END,
                PFCS_PCK_CONSTANTS.IE_ACTIVE,
                si_intent_w
            );

            if (si_intent_w = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER) then
                update pfcs_encounter
                set nr_seq_location = nr_seq_location_w
                where nr_sequencia = nr_seq_encounter_w
                    and coalesce(nr_seq_location,0) <> nr_seq_location_w;
            end if;
        end if;
    end if;

    if ( (cd_service_request_w = PFCS_PCK_CONSTANTS.CD_DISCHARGE)
            and (si_intent_w = PFCS_PCK_CONSTANTS.SI_INTENT_PLAN)
            and (coalesce(ie_execute_w,PFCS_PCK_CONSTANTS.IE_YES) = PFCS_PCK_CONSTANTS.IE_YES) ) then
        if (si_status_w = PFCS_PCK_CONSTANTS.SI_STATUS_REVOKED) then
            dt_request_w := null;
        end if;
        update pfcs_encounter
        set dt_discharge_order = dt_request_w
        where nr_sequencia = nr_seq_encounter_w;
    end if;

    if (si_status_w =  PFCS_PCK_CONSTANTS.SI_STATUS_REVOKED and OLD.si_status = PFCS_PCK_CONSTANTS.SI_STATUS_COMPLETED and
     coalesce(ie_execute_w,PFCS_PCK_CONSTANTS.IE_YES) = PFCS_PCK_CONSTANTS.IE_YES ) then

        select max(t.nr_sequencia)
            into STRICT nr_seq_pat_loc_hist_w
            from (
                SELECT nr_sequencia
                from pfcs_patient_loc_hist
                where nr_seq_encounter = nr_seq_encounter_w
                    and nr_seq_patient = nr_seq_patient_w
                    and ie_situacao = PFCS_PCK_CONSTANTS.IE_ACTIVE
                    and si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
                order by nr_sequencia desc) t;

        if (cd_service_request_w in (PFCS_PCK_CONSTANTS.CD_ADMISSION,PFCS_PCK_CONSTANTS.CD_TRANSFER)) then
         nr_seq_last_location_w := null;

            update pfcs_patient_loc_hist
            set
                si_intent = pfcs_pck_constants.si_status_revoked
            where
                nr_sequencia = nr_seq_pat_loc_hist_w;

            if (cd_service_request_w = PFCS_PCK_CONSTANTS.CD_TRANSFER) then
                select max(t.nr_sequencia),
                    max(t.nr_seq_location)
                into STRICT nr_seq_pat_loc_hist_w,
                    nr_seq_last_location_w
                from (
                    SELECT nr_sequencia,
                        nr_seq_location
                    from pfcs_patient_loc_hist
                    where nr_seq_encounter = nr_seq_encounter_w
                        and nr_seq_patient = nr_seq_patient_w
                        and ie_situacao = PFCS_PCK_CONSTANTS.IE_ACTIVE
                        and si_intent = PFCS_PCK_CONSTANTS.SI_INTENT_ORDER
                    order by nr_sequencia desc) t;
            end if;

            update pfcs_encounter
            set
                nr_seq_location =  nr_seq_last_location_w
            where nr_sequencia = nr_seq_encounter_w;
        end if;

        if (cd_service_request_w in (PFCS_PCK_CONSTANTS.CD_DISCHARGE, PFCS_PCK_CONSTANTS.CD_TRANSFER)) then
            update  pfcs_patient_loc_hist
            set     dt_period_end  = NULL
            where   nr_sequencia = nr_seq_pat_loc_hist_w;

            if (cd_service_request_w = PFCS_PCK_CONSTANTS.CD_DISCHARGE) then
                NEW.cd_service := PFCS_PCK_CONSTANTS.CD_TRANSFER;
            end if;
        end if;

    end if;
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pfcs_pat_loc_hst_upt() FROM PUBLIC;

CREATE TRIGGER pfcs_pat_loc_hst_upt
	BEFORE INSERT OR UPDATE ON pfcs_service_request FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pfcs_pat_loc_hst_upt();

