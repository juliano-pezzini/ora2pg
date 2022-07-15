-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_loinc_ligacao (loinc_Num_p text, Parent_Loinc_p text, nm_usuario_p text) AS $body$
DECLARE

nr_seq_loinc_w bigint;
seq_parent_loinc_w bigint;

BEGIN
  select max(nr_sequencia)
    into STRICT seq_parent_loinc_w
    from lab_loinc_dados
   where cd_loinc = Parent_Loinc_p;

  select max(nr_sequencia)
    into STRICT nr_seq_loinc_w
    from lab_loinc_dados
   where cd_loinc = loinc_Num_p;

  if (seq_parent_loinc_w IS NOT NULL AND seq_parent_loinc_w::text <> '' AND nr_seq_loinc_w IS NOT NULL AND nr_seq_loinc_w::text <> '') then
    update lab_loinc_dados set nr_seq_loinc_superior = seq_parent_loinc_w,
                               nm_usuario            = nm_usuario_p,
                               dt_atualizacao        = clock_timestamp()
     where nr_sequencia = nr_seq_loinc_w;
  end if;

  commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_loinc_ligacao (loinc_Num_p text, Parent_Loinc_p text, nm_usuario_p text) FROM PUBLIC;

