-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_acesso_apap (nr_seq_documento_p bigint, ie_tipo_p text, nr_atendimento_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE


  cd_estabelecimento_w estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
  cd_perfil_w perfil.cd_perfil%type := wheb_usuario_pck.get_cd_perfil;
  nm_usuario_w usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
  cd_setor_atendimento_w setor_atendimento.cd_setor_atendimento%type := wheb_usuario_pck.get_cd_setor_atendimento;
  ie_acesso_w documento_acesso.ie_acesso%type := 'T';

  c_acesso_perfil CURSOR FOR
    SELECT  ie_acesso
    from    documento_acesso
    where   nr_seq_documento = nr_seq_documento_p
    and     coalesce(cd_estab_regra,cd_estabelecimento_w) = cd_estabelecimento_w
    and     coalesce(cd_perfil_regra,cd_perfil_w) = cd_perfil_w
    and     coalesce(nm_usuario_regra,nm_usuario_w) = nm_usuario_w
    ORDER BY
            coalesce(nm_usuario_regra,'AAA'),
            coalesce(cd_perfil_regra,0),
            coalesce(cd_estab_regra,0),
            nr_sequencia;

  c_acesso_setor CURSOR FOR
    SELECT  ie_acesso
    from    documento_setor
    where   nr_seq_documento = nr_seq_documento_p
    and     coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
    order by
            coalesce(cd_setor_atendimento, 0);

  c_acesso_diagnostico CURSOR FOR
  SELECT  doc.ie_acesso
  from    documento_diagnostico doc
  where   doc.nr_seq_documento = nr_seq_documento_p
  and     exists ( SELECT  1
                  from    diagnostico_doenca dd
                  where   dd.ie_classificacao_doenca = 'P'
                  and     dd.ie_tipo_diagnostico = 2
                  and     dd.ie_situacao = 'A'
                  and     (dd.dt_liberacao IS NOT NULL AND dd.dt_liberacao::text <> '')
                  and     dd.cd_doenca = doc.cd_doenca
                  and     dd.nr_atendimento = nr_atendimento_p)
    order by
          doc.ie_acesso;
BEGIN
  begin
    if (ie_tipo_p = 'P') then
      <<read_acesso_perfil>>
      for r_acesso_perfil in c_acesso_perfil
      loop
        ie_acesso_w := r_acesso_perfil.ie_acesso;
      end loop read_acesso_perfil;

    elsif (ie_tipo_p = 'S') then
      <<read_acesso_setor>>
      for r_acesso_setor in c_acesso_setor
      loop
        ie_acesso_w := r_acesso_setor.ie_acesso;
      end loop read_acesso_setor;

    elsif (ie_tipo_p = 'D') then
      <<read_acesso_diagnostico>>
      for r_acesso_diagnostico in c_acesso_diagnostico
      loop
        ie_acesso_w := r_acesso_diagnostico.ie_acesso;
      end loop read_acesso_diagnostico;
    end if;

  exception
    when no_data_found then
      ie_acesso_w := 'T';
  end;

  return ie_acesso_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_acesso_apap (nr_seq_documento_p bigint, ie_tipo_p text, nr_atendimento_p bigint DEFAULT NULL) FROM PUBLIC;
