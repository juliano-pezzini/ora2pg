-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  
    --=========================================== Procedures ===========================================
CREATE OR REPLACE PROCEDURE pfcs_permissions_pck.copy_permissions_to_module ( nr_seq_module_origin_p bigint, nr_seq_module_target_p bigint ) AS $body$
DECLARE

        cd_establishment_w   pfcs_module_permission.cd_establishment%TYPE;
        ie_allowed_w         pfcs_module_permission.ie_allowed%TYPE;
        nm_allowed_user_w    pfcs_module_permission.nm_allowed_user%TYPE;
        nr_seq_profile_w     pfcs_module_permission.nr_seq_profile%TYPE;

BEGIN
        FOR c01_w IN current_setting('pfcs_permissions_pck.cur_permissions')::CURSOR((nr_seq_module_origin_p) LOOP
            cd_establishment_w := c01_w.cd_establishment;
            ie_allowed_w := c01_w.ie_allowed;
            nm_allowed_user_w := c01_w.nm_allowed_user;
            nr_seq_profile_w := c01_w.nr_seq_profile;

            INSERT INTO pfcs_module_permission(
                CD_ESTABLISHMENT,
                DT_ATUALIZACAO,
                IE_ALLOWED,
                NM_ALLOWED_USER,
                NM_USUARIO,
                NR_SEQ_DYNAMIC_MODULE,
                NR_SEQ_PROFILE,
                NR_SEQUENCIA
            ) VALUES (
                cd_establishment_w,
                current_date,
                ie_allowed_w,
                nm_allowed_user_w,
                obter_usuario_ativo,
                nr_seq_module_target_p,
                nr_seq_profile_w,
                nextval('pfcs_module_permission_seq')
            );
        END LOOP;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_permissions_pck.copy_permissions_to_module ( nr_seq_module_origin_p bigint, nr_seq_module_target_p bigint ) FROM PUBLIC;
