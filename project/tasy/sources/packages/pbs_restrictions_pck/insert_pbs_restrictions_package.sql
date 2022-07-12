-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pbs_restrictions_pck.insert_pbs_restrictions ( nr_pbs_version_p bigint, nm_usuario_p text ) AS $body$
DECLARE


    c03 CURSOR FOR
        SELECT 
            substr(pb.cd_restriction_xml_ref,2) pbs_restriction_code,
            pb.cd_restriction_ref_code cd_authority_code
        from
                pbsload_pres_rules pp,
                pbsload_benf_restrictions pb
        where 
                   pp.nr_program_master_ref=pb.nr_pres_rule_master_ref
        and    pp.nr_pbs_version=pb.nr_pbs_version
        group by 
                    pb.cd_restriction_xml_ref,
                     pb.cd_restriction_ref_code;

         r_c03  c03%rowtype;
         ds_restriction_notes_w  text;
         ds_input_w  text;
         ds_treatment_criteria_w text;
         cd_authority_code_w    pbsload_restrictions.cd_treatment_of%TYPE;
        -- nm_usuario_w			pbs_record.nm_usuario%type := 'TEST';
BEGIN
                open c03;
                loop
                    fetch c03 into r_c03;
                    EXIT WHEN NOT FOUND; /* apply on c03 */
                     SELECT * FROM pbs_restrictions_pck.get_pbs_restriction_text(r_c03.pbs_restriction_code, nr_pbs_version_p, ds_treatment_criteria_w, ds_restriction_notes_w) INTO STRICT ds_treatment_criteria_w, ds_restriction_notes_w;
                    ds_input_w:=ds_restriction_notes_w;
                        begin
                                 select pr.cd_treatment_of  into STRICT cd_authority_code_w
                                 from pbsload_restrictions pr 
                                where pr.cd_res_xml_id=  r_c03.pbs_restriction_code;
                        exception
                                when no_data_found then
                                    cd_authority_code_w := 0;
                                    when too_many_rows then raise;
                        end;
                          insert into pbsimp_restrictions(nr_sequencia,dt_atualizacao,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec,
                            nr_pbs_version,
                           ds_restriction_notes,
                           ds_treatment_criteria,
                           cd_authority_code,
                           restriction_xml_id,
                           ie_situacao)
                       values ( nextval('pbsimp_restrictions_seq'),clock_timestamp(),
                                    nm_usuario_p,
                                    clock_timestamp(),
                                    nm_usuario_p,
                                    nr_pbs_version_p,
                                    ds_restriction_notes_w,
                                   ds_treatment_criteria_w,
                                  cd_authority_code_w,
                                   r_c03.pbs_restriction_code,
                                   'A');
                 end loop;
                close c03;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pbs_restrictions_pck.insert_pbs_restrictions ( nr_pbs_version_p bigint, nm_usuario_p text ) FROM PUBLIC;