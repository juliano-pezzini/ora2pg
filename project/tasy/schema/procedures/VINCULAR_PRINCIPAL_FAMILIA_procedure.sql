-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_principal_familia (cd_pessoa_fisica_p text default null) AS $body$
BEGIN

  insert into pf_familia(
         dt_atualizacao,
         nm_usuario,
         dt_atualizacao_nrec,
         nm_usuario_nrec,
         cd_pessoa_fisica,
         cd_pessoa_familia,
         nr_sequencia,
         nr_seq_grau_parentesco,
         ie_habitacao)
  values (clock_timestamp(),
         wheb_usuario_pck.get_nm_usuario,
         clock_timestamp(),
         wheb_usuario_pck.get_nm_usuario,
         cd_pessoa_fisica_p,
         cd_pessoa_fisica_p,
         nextval('pf_familia_seq'),
         63,
         'S');


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_principal_familia (cd_pessoa_fisica_p text default null) FROM PUBLIC;
