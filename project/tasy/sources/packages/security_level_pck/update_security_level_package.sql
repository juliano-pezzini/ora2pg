-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE security_level_pck.update_security_level ( ie_last_action_p USER_SECURITY_LEVEL.ie_last_action%type, NM_USUARIO_P usuario.nm_usuario%type, ds_listrules text ) AS $body$
DECLARE

        seqUser     bigint;
        seqUserRule bigint;
        IDs         invalid_list;
        l_count     integer;
        l_array     dbms_utility.lname_array;

BEGIN
        IF (ie_last_action_p IS NOT NULL AND ie_last_action_p::text <> '') AND (LENGTH(ds_listrules) IS NOT NULL AND (LENGTH(ds_listrules))::text <> '') THEN
            dbms_utility.comma_to_table(list => regexp_replace(ds_listrules,'(^|,)','\1x'), tablen => l_count, tab => l_array);
            SELECT nextval('user_security_level_seq') into STRICT seqUser;
            INSERT INTO USER_SECURITY_LEVEL(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NM_USUARIO_READING, DT_LAST_UPDATE, IE_LAST_ACTION)
                VALUES (seqUser, clock_timestamp(), NM_USUARIO_P, null, null, NM_USUARIO_P, clock_timestamp(), ie_last_action_p);
            For i in 1 .. l_count Loop
                SELECT nextval('user_sec_level_rules_seq') into STRICT seqUserRule;
                INSERT INTO USER_SEC_LEVEL_RULES(NR_SEQUENCIA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NR_SEQ_USER_SEC_LEVEL, NR_SEQ_SEC_LEVEL_RULE)
                    VALUES (seqUserRule, clock_timestamp(), NM_USUARIO_P, null, null, seqUser, (Substr(l_array(i),2))::numeric );
            END LOOP;
        END IF;

        IF (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') THEN
            commit;
        END IF;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE security_level_pck.update_security_level ( ie_last_action_p USER_SECURITY_LEVEL.ie_last_action%type, NM_USUARIO_P usuario.nm_usuario%type, ds_listrules text ) FROM PUBLIC;