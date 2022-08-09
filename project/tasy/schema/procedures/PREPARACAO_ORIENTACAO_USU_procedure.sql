-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE preparacao_orientacao_usu (nr_sequencia_p bigint, ds_orientacao_preparo_p text, nr_seq_proc_interno_p bigint, ie_local_p text, nm_usuario_p text, nm_orientacao_preparo_p text) AS $body$
DECLARE


nr_sequencia_w ageint_orient_preparo.nr_sequencia%type;

C01 CURSOR FOR
  SELECT nr_seq_proc_interno
  from ageint_orient_prep_regra
  where nr_seq_orient_preparo = nr_sequencia_w;

BEGIN

if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and (ie_local_p = 'U') then
  select nr_seq_orient_preparo
  into STRICT nr_sequencia_w
  from ageint_orient_prep_regra
  where nr_seq_proc_interno = nr_seq_proc_interno_p;

  if (ie_local_p = 'U') then
    update ageint_orient_preparo
    set ds_orientacao_preparo = ds_orientacao_preparo_p,
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp()
    where nr_sequencia = nr_sequencia_w;
  end if;

elsif (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and (ie_local_p = 'P') then

  update proc_interno
  set ds_orientacao_usuario = ds_orientacao_preparo_p,
    nm_usuario = nm_usuario_p,
    dt_atualizacao = clock_timestamp()
  where nr_sequencia = nr_seq_proc_interno_p;

elsif (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_local_p = 'C') then
  nr_sequencia_w := nr_sequencia_p;

end if;

if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
  for c01_w in C01 loop
    if (c01_w.nr_seq_proc_interno IS NOT NULL AND c01_w.nr_seq_proc_interno::text <> '') then
      update proc_interno
      set ds_orientacao_usuario = ds_orientacao_preparo_p,
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp()
      where nr_sequencia = c01_w.nr_seq_proc_interno;
    end if;
  end loop;
end if;

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_local_p = 'E') then

  insert into ageint_orient_prep_regra(
    dt_atualizacao,
    dt_atualizacao_nrec,
    nm_usuario,
    nm_usuario_nrec,
    nr_seq_orient_preparo,
    nr_sequencia,
    nr_seq_proc_interno,
    ie_consulta,
    cd_estabelecimento
  ) values (
    clock_timestamp(),
    clock_timestamp(),
    nm_usuario_p,
    nm_usuario_p,
    nr_sequencia_p,
    nextval('ageint_orient_prep_regra_seq'),
    nr_seq_proc_interno_p,
    'N',
    obter_estabelecimento_ativo()
  );

  update proc_interno
  set ds_orientacao_usuario = ds_orientacao_preparo_p,
    nm_usuario = nm_usuario_p,
    dt_atualizacao = clock_timestamp()
  where nr_sequencia = nr_seq_proc_interno_p;

elsif (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and (ie_local_p = 'O') then

  select nextval('ageint_orient_preparo_seq')
  into STRICT nr_sequencia_w
;

  insert into ageint_orient_preparo(
    nr_sequencia,
    dt_atualizacao,
    dt_atualizacao_nrec,
    nm_usuario,
    nm_usuario_nrec,
    ie_situacao,
    ds_orientacao_preparo,
    nm_orientacao_preparo
  ) values (
    nr_sequencia_w,
    clock_timestamp(),
    clock_timestamp(),
    nm_usuario_p,
    nm_usuario_p,
    'A',
    ds_orientacao_preparo_p,
    nm_orientacao_preparo_p
  );

  insert into ageint_orient_prep_regra(
    dt_atualizacao,
    dt_atualizacao_nrec,
    nm_usuario,
    nm_usuario_nrec,
    nr_seq_orient_preparo,
    nr_sequencia,
    nr_seq_proc_interno,
    ie_consulta,
    cd_estabelecimento
  ) values (
    clock_timestamp(),
    clock_timestamp(),
    nm_usuario_p,
    nm_usuario_p,
    nr_sequencia_w,
    nextval('ageint_orient_prep_regra_seq'),
    nr_seq_proc_interno_p,
    'N',
    obter_estabelecimento_ativo()
  );

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE preparacao_orientacao_usu (nr_sequencia_p bigint, ds_orientacao_preparo_p text, nr_seq_proc_interno_p bigint, ie_local_p text, nm_usuario_p text, nm_orientacao_preparo_p text) FROM PUBLIC;
