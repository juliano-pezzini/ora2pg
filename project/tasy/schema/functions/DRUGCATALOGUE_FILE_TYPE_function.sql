-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION drugcatalogue_file_type (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE
 file_count bigint;


BEGIN
  
                SELECT

                        COUNT(*)

                INTO STRICT

                        file_count

                FROM

                        aut_dc_file

                WHERE

                        nr_seq_import = nr_sequencia_p;



                IF (file_count = 0) THEN

                        RETURN 1;

                ELSIF (file_count= 1) THEN

                        RETURN 2;

                ELSIF (file_count=2) THEN

                        RETURN 3;

                ELSIF (file_count=3) THEN

                        RETURN 4;

                ELSIF (file_count=4) THEN

                        RETURN 5;

                ELSIF (file_count=5) THEN

                        RETURN 6;

                ELSIF (file_count=6) THEN

                        RETURN 7;

                ELSIF (file_count=7) THEN

                        RETURN 8;

                ELSIF (file_count=8) THEN

                        RETURN 9;

                ELSIF (file_count=9) THEN

                        RETURN 10;

                ELSIF (file_count=10) THEN

                        RETURN 11;
                ELSE

                        RETURN 1;

                END IF;

        END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION drugcatalogue_file_type (nr_sequencia_p bigint) FROM PUBLIC;
