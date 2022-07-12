-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE schematics_alt_pck.prc_objeto_schematic_prop (nr_seq_obj_p bigint, nr_seq_obj_val_p bigint) AS $body$
BEGIN
    CALL schematics_alt_pck.prc_objeto_schematic(nr_seq_obj_p);
    CALL schematics_alt_pck.prc_objeto_schematic(nr_seq_obj_val_p);
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematics_alt_pck.prc_objeto_schematic_prop (nr_seq_obj_p bigint, nr_seq_obj_val_p bigint) FROM PUBLIC;