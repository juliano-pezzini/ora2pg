-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.split_row (row_p text, delimiter_p text DEFAULT ',') AS $body$
DECLARE

        r_idx       integer;
        r_id        bigint;
        r_list      varchar(32767) := row_p;
        r_curr      varchar(255);
        r_str_idx   integer;

BEGIN
        r_id := 1;
        LOOP
            BEGIN
                r_idx := position(delimiter_p in r_list);

                IF r_idx > 0 THEN
                    current_setting('med_guidance_pkg.r_list_tbl')::split_tbl.extend;
                    r_curr := substr(r_list, 1, r_idx - 1);

                    r_str_idx := position('"' in r_curr);
                    IF r_str_idx > 0 THEN
                        r_curr := substr(r_curr, 2, length(r_curr) - 2);
                    END IF;

                    current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[r_id].ds_split := r_curr;
                    r_list := substr(r_list, r_idx + length(delimiter_p));
                    r_id := r_id + 1;
                ELSE
                    current_setting('med_guidance_pkg.r_list_tbl')::split_tbl.extend;

                    r_str_idx := position('"' in r_list);
                    IF r_str_idx > 0 THEN
                        r_list := substr(r_list, 2, length(r_list) - 2);
                    END IF;

                    current_setting('med_guidance_pkg.r_list_tbl')::split_tbl[r_id].ds_split := r_list;
                    EXIT;
                END IF;
            END;
        END LOOP;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.split_row (row_p text, delimiter_p text DEFAULT ',') FROM PUBLIC;
