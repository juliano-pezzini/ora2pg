-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION escala_mods_befins_md_pck.obter_score_rel_pao2_fio2_md (qt_rel_pao2_fio2_p bigint) RETURNS bigint AS $body$
DECLARE

    qt_pto_resp_w smallint;

BEGIN
    if (coalesce(qt_rel_pao2_fio2_p::text, '') = '') then
      qt_pto_resp_w := 0;
    elsif (qt_rel_pao2_fio2_p > 300) then
      qt_pto_resp_w := 0;
    elsif (qt_rel_pao2_fio2_p > 225) and (qt_rel_pao2_fio2_p <= 300) then
	  qt_pto_resp_w := 1;
    elsif (qt_rel_pao2_fio2_p > 150) and (qt_rel_pao2_fio2_p <= 225) then
	  qt_pto_resp_w := 2;
    elsif (qt_rel_pao2_fio2_p > 75) and (qt_rel_pao2_fio2_p <= 150) then
	  qt_pto_resp_w := 3;
    elsif (qt_rel_pao2_fio2_p <= 75) then
	  qt_pto_resp_w := 4;
    end if;
    return qt_pto_resp_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION escala_mods_befins_md_pck.obter_score_rel_pao2_fio2_md (qt_rel_pao2_fio2_p bigint) FROM PUBLIC;
