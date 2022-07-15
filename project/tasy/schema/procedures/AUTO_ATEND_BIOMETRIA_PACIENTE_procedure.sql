-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE auto_atend_biometria_paciente ( cd_pessoa_fisica_p text, ie_dedo_p text, ds_hash_p text) AS $body$
DECLARE


qt_registros_w         smallint;


BEGIN

  select count(1)
  into STRICT  qt_registros_w
  from  pessoa_fisica_biometria
  where cd_pessoa_fisica = cd_pessoa_fisica_p
  and ie_dedo = ie_dedo_p;

  if qt_registros_w > 0 then
  
    update pessoa_fisica_biometria
    set   ds_biometria = ds_hash_p,
          nm_usuario = 'autoAtend',
          dt_atualizacao = clock_timestamp() 
    where cd_pessoa_fisica = cd_pessoa_fisica_p
    and   ie_dedo = ie_dedo_p;

  else
  
    insert into pessoa_fisica_biometria(
      cd_empresa_biometria,
      cd_pessoa_fisica,
      ds_biometria,
      dt_atualizacao,
      dt_atualizacao_nrec,
      ie_dedo,
      nm_usuario,
      nm_usuario_nrec,
      nr_sequencia
    ) values (
      1,
      cd_pessoa_fisica_p,
      ds_hash_p,
      clock_timestamp(),
      clock_timestamp(),
      ie_dedo_p,
      'autoAtend',
      'autoAtend',
      nextval('pessoa_fisica_biometria_seq'));

  end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE auto_atend_biometria_paciente ( cd_pessoa_fisica_p text, ie_dedo_p text, ds_hash_p text) FROM PUBLIC;

