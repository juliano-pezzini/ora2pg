-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_acomp_forponto ON atendimento_acompanhante CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_acomp_forponto() RETURNS trigger AS $BODY$
DECLARE
    json_w                          PHILIPS_JSON;
    json_data_w                     text;


    natural_person_code_w           ATENDIMENTO_ACOMPANHANTE.cd_pessoa_fisica%TYPE;

    notes_w                         ATENDIMENTO_ACOMPANHANTE.ds_observacao%TYPE;
    last_updated_date_w             ATENDIMENTO_ACOMPANHANTE.dt_atualizacao%TYPE;
    last_updated_nrec_date_w        ATENDIMENTO_ACOMPANHANTE.dt_atualizacao_nrec%TYPE;
    entry_date_w                    ATENDIMENTO_ACOMPANHANTE.dt_acompanhante%TYPE;
    accurate_entry_date_w           ATENDIMENTO_ACOMPANHANTE.dt_entrada_real%TYPE;
    access_release_date_w           ATENDIMENTO_ACOMPANHANTE.dt_liberacao_acesso%TYPE;

    departure_date_w                ATENDIMENTO_ACOMPANHANTE.dt_saida%TYPE;
    accurate_departure_date_w       ATENDIMENTO_ACOMPANHANTE.dt_saida_real%TYPE;

    last_updated_by_w               ATENDIMENTO_ACOMPANHANTE.nm_usuario%TYPE;
    last_updated_nrec_by_w          ATENDIMENTO_ACOMPANHANTE.nm_usuario_nrec%TYPE;
    departure_by_w                  ATENDIMENTO_ACOMPANHANTE.nm_usuario_saida%TYPE;

    encounter_number_w              ATENDIMENTO_ACOMPANHANTE.nr_atendimento%TYPE;
    access_control_number_w         ATENDIMENTO_ACOMPANHANTE.nr_controle_acesso%TYPE;
    phone_dd_w                      ATENDIMENTO_ACOMPANHANTE.nr_ddi%TYPE;
    civil_id_w                      ATENDIMENTO_ACOMPANHANTE.nr_identidade%TYPE;
    control_number_w                ATENDIMENTO_ACOMPANHANTE.nr_controle%TYPE;
    type_number_w                   ATENDIMENTO_ACOMPANHANTE.nr_seq_tipo%TYPE;
    phone_number_w                  ATENDIMENTO_ACOMPANHANTE.nr_telefone%TYPE;
    action_w                        varchar(1);
    guest_type_w                    varchar(1);

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    IF (
        wheb_usuario_pck.get_ie_executar_trigger = 'S'
        AND wheb_usuario_pck.get_nm_usuario IS NOT NULL
        AND obter_parametro_funcao(8014, 93, obter_usuario_ativo) <> 'P'
    ) THEN

        IF (TG_OP = 'INSERT') THEN

            natural_person_code_w           := NEW.cd_pessoa_fisica;

            notes_w                         := NEW.ds_observacao;
            last_updated_date_w             := NEW.dt_atualizacao;
            last_updated_nrec_date_w        := NEW.dt_atualizacao_nrec;
            entry_date_w                    := NEW.dt_acompanhante;
            accurate_entry_date_w           := NEW.dt_entrada_real;
            access_release_date_w           := NEW.dt_liberacao_acesso;

            departure_date_w                := NEW.dt_saida;
            accurate_departure_date_w       := NEW.dt_saida_real;

            last_updated_by_w               := NEW.nm_usuario;
            last_updated_nrec_by_w          := NEW.nm_usuario_nrec;
            departure_by_w                  := NEW.nm_usuario_saida;

            encounter_number_w              := NEW.nr_atendimento;
            access_control_number_w         := NEW.nr_controle_acesso;
            phone_dd_w                      := NEW.nr_ddi;
            civil_id_w                      := NEW.nr_identidade;
            control_number_w                := NEW.nr_controle;
            type_number_w                   := NEW.nr_seq_tipo;
            phone_number_w                  := NEW.nr_telefone;
            action_w                        := 'I';
        ELSE

            natural_person_code_w           := OLD.cd_pessoa_fisica;

            notes_w                         := OLD.ds_observacao;
            last_updated_date_w             := OLD.dt_atualizacao;
            last_updated_nrec_date_w        := OLD.dt_atualizacao_nrec;
            entry_date_w                    := OLD.dt_acompanhante;
            accurate_entry_date_w           := OLD.dt_entrada_real;
            access_release_date_w           := OLD.dt_liberacao_acesso;

            departure_date_w                := OLD.dt_saida;
            accurate_departure_date_w       := OLD.dt_saida_real;

            last_updated_by_w               := OLD.nm_usuario;
            last_updated_nrec_by_w          := OLD.nm_usuario_nrec;
            departure_by_w                  := OLD.nm_usuario_saida;

            encounter_number_w              := OLD.nr_atendimento;
            access_control_number_w         := OLD.nr_controle_acesso;
            phone_dd_w                      := OLD.nr_ddi;
            civil_id_w                      := OLD.nr_identidade;
            control_number_w                := OLD.nr_controle;
            type_number_w                   := OLD.nr_seq_tipo;
            phone_number_w                  := OLD.nr_telefone;
            action_w                        := 'D';
        END IF;

        IF (control_number_w IS NOT NULL) THEN
          guest_type_w := 'A';

          json_w := philips_json();

          json_w.put('naturalPersonCode', natural_person_code_w);

          json_w.put('notes', notes_w);
          json_w.put('lastUpdatedDate', last_updated_date_w);
          json_w.put('lastUpdatedNrecDate', last_updated_nrec_date_w);
          json_w.put('entryDate', entry_date_w);
          json_w.put('accurateEntryDate', accurate_entry_date_w);
          json_w.put('accessReleaseDate', access_release_date_w);

          json_w.put('departureDate', departure_date_w);
          json_w.put('accurateDepartureDate', accurate_departure_date_w);

          json_w.put('lastUpdatedBy', last_updated_by_w);
          json_w.put('lastUpdatedNrecBy', last_updated_nrec_by_w);
          json_w.put('departureBy', departure_by_w);

          json_w.put('encounterNumber', encounter_number_w);
          json_w.put('accessControlNumber', access_control_number_w);
          json_w.put('phoneDd', phone_dd_w);
          json_w.put('civilId', civil_id_w);
          json_w.put('fiscalId', OBTER_CPF_PESSOA_FISICA(natural_person_code_w));
          json_w.put('controlNumber', control_number_w);
          json_w.put('typeNumber', type_number_w);
          json_w.put('phoneNumber', phone_number_w);
          json_w.put('guestType', guest_type_w);
          json_w.put('action', action_w);

          DBMS_LOB.CREATETEMPORARY(json_data_w, true);
          json_w.(json_data_w);

          json_data_w := bifrost.send_integration_content('forponto.send.request', json_data_w, wheb_usuario_pck.get_nm_usuario);
        END IF;
    END IF;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_acomp_forponto() FROM PUBLIC;

CREATE TRIGGER atendimento_acomp_forponto
	AFTER INSERT OR DELETE ON atendimento_acompanhante FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_acomp_forponto();

