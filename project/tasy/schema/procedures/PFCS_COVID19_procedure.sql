-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_covid19 ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w    estabelecimento.cd_estabelecimento%type;


c01 CURSOR FOR
SELECT    cd_estabelecimento
from    estabelecimento 
where    ie_situacao = 'A';


BEGIN

CALL pfcs_inserts_diagnosis();

if (coalesce(cd_estabelecimento_p,0) = 0) then
    open c01;
    loop
    fetch c01
    into    cd_estabelecimento_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */
    begin
        CALL pfcs_exame_lab_tempo_result(77, cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_exame_lab_qt_result(78, cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_contact_with_employee(79, cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_contact_with_patient(80, cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_icu_occupancy_covid(83, cd_estabelecimento_w, nm_usuario_p, 'S', 'S');
        CALL pfcs_get_patients_covid(cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_get_pat_comorbidities(cd_estabelecimento_w, nm_usuario_p);
        CALL pfcs_length_patient_stay_day(87, cd_estabelecimento_w, nm_usuario_p);
    end;
    end loop;
    close c01;
else
    begin
        CALL pfcs_exame_lab_tempo_result(77, cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_exame_lab_qt_result(78, cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_contact_with_employee(79, cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_contact_with_patient(80, cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_icu_occupancy_covid(83, cd_estabelecimento_p, nm_usuario_p, 'S', 'S');
        CALL pfcs_get_patients_covid(cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_get_pat_comorbidities(cd_estabelecimento_p, nm_usuario_p);
        CALL pfcs_length_patient_stay_day(87, cd_estabelecimento_p, nm_usuario_p);
    end;
end if;

CALL pfcs_file_pck.pfcs_generate();

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_covid19 ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

