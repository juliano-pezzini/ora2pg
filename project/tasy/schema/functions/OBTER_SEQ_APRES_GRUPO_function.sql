-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_apres_grupo ( nr_sequencia_p bigint, nr_seq_apresentacao_p bigint) RETURNS bigint AS $body$
DECLARE


 nr_seq_apresentacao_w  bigint;

BEGIN
 if (coalesce(nr_sequencia_p,0) > 0) then
  select coalesce(max(nr_seq_apresentacao),coalesce(nr_seq_apresentacao_p,999))
  into STRICT nr_seq_apresentacao_w
  from grupo_exame_lab_rotina
  where nr_sequencia = nr_sequencia_p;
 else
  nr_seq_apresentacao_w := 99999;
 end if;

 return nr_seq_apresentacao_w;

 end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_apres_grupo ( nr_sequencia_p bigint, nr_seq_apresentacao_p bigint) FROM PUBLIC;
