-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apache_update_md_pck.obter_pal_media_md (qt_pad_p bigint, qt_pas_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_pal_media_w bigint;

BEGIN
      begin
        qt_pal_media_w	:= dividir_sem_round_md(((qt_pad_p * 2) + qt_pas_p),3);
      exception
        when others then
          qt_pal_media_w	:= null;
      end;

      return qt_pal_media_w;
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apache_update_md_pck.obter_pal_media_md (qt_pad_p bigint, qt_pas_p bigint ) FROM PUBLIC;
