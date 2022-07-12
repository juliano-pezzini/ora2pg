-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE FIX_SEQUENCE_REC AS (
      sequence_name varchar(400),
      drop_sequence varchar(4000),
      create_sequence varchar(4000)
    );


CREATE OR REPLACE PROCEDURE sequence_pck.recreate_sequences () AS $body$
DECLARE


    eCursor EmptyCursorType;

    rec FIX_SEQUENCE_REC;

BEGIN
    CALL sequence_pck.init();
    CALL sequence_pck.update_data_sequence();
    CALL sequence_pck.create_sequence_commands();

    open eCursor for EXECUTE 'select sequence_name, drop_sequence, create_sequence from sequence_info_bkp';
    loop
      fetch eCursor into rec;
      EXIT WHEN NOT FOUND; /* apply on eCursor */

      EXECUTE rec.drop_sequence;
      EXECUTE 'UPDATE sequence_info_bkp SET removed = ''YES'' WHERE sequence_name = :sequence_name' using rec.sequence_name;
      EXECUTE rec.create_sequence;
      EXECUTE 'UPDATE sequence_info_bkp SET created = ''YES'' WHERE sequence_name = :sequence_name'using rec.sequence_name;
      CALL cleanupdb_pck.add_progress(current_setting('sequence_pck.const_cleanupdb')::varchar(20),1);
    END LOOP;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sequence_pck.recreate_sequences () FROM PUBLIC;
