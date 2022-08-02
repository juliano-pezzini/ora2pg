-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE p_cancelar_flowsheet (nr_sequencia_p bigint, nr_atendimento_p bigint, origem_p text) AS $body$
DECLARE


    json_cancelar_flowsheet         philips_json;
    json_origem                     philips_json_list;
    json_origem_linha               philips_json;
    envio_integracao_bb             text;
    retorno_integracao_bb           text;


BEGIN

    json_origem := philips_json_list();
    json_cancelar_flowsheet := philips_json();
    json_cancelar_flowsheet.put('typeID', 'FSDELETE');
    json_cancelar_flowsheet.put('messageDateTime', TO_CHAR((CURRENT_TIMESTAMP AT TIME ZONE 'UTC'), 'MM-DD-YYYY HH24:MI:SS.SSSSS'));

    IF (origem_p = 'A') THEN      -- Sinal Vital (vitalSign)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', 'c51b1ead9ff94248acdc9986d9858f0b');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C2' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', 'dc100b48923c4555869cea761a3f58e7');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C3' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '3c64a7630640464a8f9da89f5213c8b4');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C4' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '5ed47254daad4b74b70e1637a142a451');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C5' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '1d17edd4cb194c26bdd3826909f96cce');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C6' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '0cd403629bcf4cbaabfb8d95da5c2ce1');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C7' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', 'dcd6536206d5472d9f7816c03c24d165');

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('vitalSign', json_origem);

    ELSIF (origem_p = 'B') THEN   -- GCS (gcs)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '492f2179d6f04e938859eb0e0d2db3b0');

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('gcs', json_origem);

    ELSIF (origem_p = 'C') THEN   -- Ramsay (ramsay)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '9012e760fb3241869e5eeceb1138c612');

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('ramsay', json_origem);

    ELSIF (origem_p = 'D') THEN   -- Urine output (urineOutput)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', '12112217b9870720119eaa3f65387365');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('urineOutput', json_origem);

    ELSIF (origem_p = 'E') THEN   -- Sinal Vital Respiratorio (respiratoryVitalSign)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', '74656a0e73084aca9dbc23389ae8ec6a');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C2' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', '033434a10edc4e5c804fd3534495eb56');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C3' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', '90beb6692a004591838e7bc7fac3028f');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C4' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', '667b94436bd941a8b81e05609223aeba');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C5' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', '22cbd97bc47c4e92a9114020a1a20295');

        json_origem.append(json_origem_linha.to_json_value());
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'b79b77f652a54800b975451bccb3567c');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('respFlowsheetColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('respFlowsheetCellID', 'C6' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellLabelID', 'a699fb5ba2fa4837abf73502e6e0c8d5');

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('respiratoryVitalSign', json_origem);

    ELSIF (origem_p = 'F') THEN   -- Richmond (richmond)
        json_origem_linha := philips_json();
        json_origem_linha.put('flowsheetTypeID', 'e0cfa360eb174a8e8b87f6d6d1a065d8');
        json_origem_linha.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
        json_origem_linha.put('fsColumnID', 'FC' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellID', 'C1' || LPAD(origem_p || nr_sequencia_p, 30, 0));
        json_origem_linha.put('cellTypeValueID', '9012e760fb3241869e5eeceb1138c612');

        json_origem.append(json_origem_linha.to_json_value());

        json_cancelar_flowsheet.put('richmond', json_origem);

    END IF;

    IF (json_origem.count > 0) THEN
        dbms_lob.createtemporary(envio_integracao_bb, TRUE);
        json_cancelar_flowsheet.(envio_integracao_bb);
        SELECT BIFROST.SEND_INTEGRATION_CONTENT('Blackboard_Cancel_Flowsheet',envio_integracao_bb,wheb_usuario_pck.get_nm_usuario) into STRICT retorno_integracao_bb;
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE p_cancelar_flowsheet (nr_sequencia_p bigint, nr_atendimento_p bigint, origem_p text) FROM PUBLIC;

