-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_habilitar_aprovacao_ccb (nr_seq_impacto_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


  ie_ccb_reprovado varchar(1);
  qt_reg_w         bigint;
  cd_cargo_w	     bigint;

  c01 CURSOR FOR
    SELECT distinct coalesce(e.ie_tipo_equipe, 'X') as ie_tipo_equipe,
           mosac.nr_seq_equipe,
           mosac.nr_seq_grupo
      from man_ordem_serv_aprov_ccb mosac, ccb_equipe e
     where mosac.nr_seq_impacto = nr_seq_impacto_p
       and mosac.nr_seq_equipe = e.nr_sequencia
       and coalesce(mosac.dt_aprovacao::text, '') = ''
       and coalesce(mosac.dt_reprovacao::text, '') = '';

  r01 c01%rowtype;


BEGIN

  if (coalesce(nr_seq_impacto_p::text, '') = '' or coalesce(cd_pessoa_fisica_p::text, '') = '') then
    return 'N';
  end if;

  select coalesce(max('S'), 'N')
    into STRICT ie_ccb_reprovado
    from man_ordem_serv_impacto mosi
   where mosi.nr_sequencia = nr_seq_impacto_p
     and exists (SELECT 1
            from man_ordem_serv_aprov_ccb mosac
           where mosac.nr_seq_impacto = mosi.nr_sequencia
             and (mosac.dt_reprovacao IS NOT NULL AND mosac.dt_reprovacao::text <> ''));

  if (ie_ccb_reprovado = 'S') then
    return 'N';
  end if;

  for r01 in c01 loop

    if (r01.ie_tipo_equipe = 'SA') then
    
      select count(1)
        into STRICT qt_reg_w
        from ccb_grupo_desenv_v a
       where a.cd_pessoa_fisica = cd_pessoa_fisica_p
         and a.nr_seq_grupo = r01.nr_seq_grupo;

    elsif (r01.ie_tipo_equipe = 'ES') then
    
      select count(1)
        into STRICT qt_reg_w
        from ccb_especialista_v a
       where a.cd_pessoa_fisica = cd_pessoa_fisica_p
         and a.nr_seq_grupo = r01.nr_seq_grupo;

    else
    
      select count(1)
        into STRICT qt_reg_w
        from ccb_equipe_regra a
       where a.cd_pessoa_fisica = cd_pessoa_fisica_p
         and a.nr_seq_equipe = r01.nr_seq_equipe
         and trunc(clock_timestamp()) between trunc(a.dt_inicio) and
             fim_dia(trunc(coalesce(a.dt_fim, clock_timestamp())));

      if (qt_reg_w > 0) then
        return 'S';
      end if;

      select max(a.cd_cargo)
        into STRICT cd_cargo_w
        from pessoa_fisica a
       where a.cd_pessoa_fisica = cd_pessoa_fisica_p;

      select count(1)
        into STRICT qt_reg_w
        from ccb_equipe_regra a
       where a.cd_cargo = cd_cargo_w
         and a.nr_seq_equipe = r01.nr_seq_equipe
         and trunc(clock_timestamp()) between trunc(a.dt_inicio) and
             fim_dia(trunc(coalesce(a.dt_fim, clock_timestamp())));
    end if;

    if (qt_reg_w > 0) then
      return 'S';
    end if;

  end loop;

  return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_habilitar_aprovacao_ccb (nr_seq_impacto_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
