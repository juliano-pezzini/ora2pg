-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fis_efd_icmsipi_b460_insert ON fis_efd_icmsipi_b460 CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fis_efd_icmsipi_b460_insert() RETURNS trigger AS $BODY$
declare
  -- local variables here
  cd_obs_w fis_efd_icmsipi_0460.cd_obs%type;
BEGIN

  BEGIN
    select max(a.cd_obs)
      into STRICT cd_obs_w
      from fis_efd_icmsipi_b460 a
     where a.nr_seq_controle = NEW.nr_seq_controle;
  end;

  if cd_obs_w is null then
    BEGIN
      select coalesce(max(a.cd_obs),0) + 1
        into STRICT cd_obs_w
        from fis_efd_icmsipi_0460 a
       where a.nr_seq_controle = NEW.nr_seq_controle;

      insert into fis_efd_icmsipi_0460(nr_sequencia,
         dt_atualizacao,
         nm_usuario,
         dt_atualizacao_nrec,
         nm_usuario_nrec,
         cd_reg,
         cd_obs,
         ds_txt,
         nr_seq_controle,
         nr_seq_superior)
      values (nextval('fis_efd_icmsipi_0460_seq'),
         LOCALTIMESTAMP,
         NEW.nm_usuario,
         LOCALTIMESTAMP,
         NEW.nm_usuario_nrec,
         '0460',
         cd_obs_w,
         'Dedução de ISS',
         NEW.nr_seq_controle,
         null);
    end;
  end if;

  NEW.cd_obs := cd_obs_w;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fis_efd_icmsipi_b460_insert() FROM PUBLIC;

CREATE TRIGGER fis_efd_icmsipi_b460_insert
	BEFORE INSERT ON fis_efd_icmsipi_b460 FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fis_efd_icmsipi_b460_insert();

