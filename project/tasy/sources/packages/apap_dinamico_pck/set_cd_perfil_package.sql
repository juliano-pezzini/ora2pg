-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE apap_dinamico_pck.set_cd_perfil (cd_perfil_p bigint) AS $body$
BEGIN
   PERFORM set_config('apap_dinamico_pck.cd_perfil_w', coalesce(cd_perfil_p,wheb_usuario_pck.get_cd_perfil), false);
   end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_dinamico_pck.set_cd_perfil (cd_perfil_p bigint) FROM PUBLIC;
