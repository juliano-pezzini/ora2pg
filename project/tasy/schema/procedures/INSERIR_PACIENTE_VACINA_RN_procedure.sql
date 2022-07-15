-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_paciente_vacina_rn ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_nascimento_p bigint, nr_seq_teste_vacina_p bigint, nr_seq_vacina_p bigint, dt_registro_p timestamp, nm_usuario_p text, ie_rn_p text default 'N') AS $body$
DECLARE

/*
TIPOS ie_rn_p
S = SIM. Obtera os dados do RN para entao adicionar na tabela paciente_vacina
N = NAO. Adicionara na tabela paciente_vacina dados passados pelos parametros
ST = SIM TUDO. Obtera os dados do RN para entao adicionar na tabela paciente_vacina
*/
nr_seq_vacina_w	           vacina_calendario.nr_seq_vacina%type;
qt_prox_mes_w	             vacina_calendario.qt_prox_mes%type;
nr_atendimento_w           paciente_vacina.nr_atendimento%type;
cd_pessoa_fisica_w         paciente_vacina.cd_pessoa_fisica%type;
pac_vac_seq                paciente_vacina.nr_sequencia%type;
ie_rn_w                    varchar(10);

  vacina RECORD;

BEGIN
  ie_rn_w := coalesce(ie_rn_p, 'N');

  if (ie_rn_w = 'S' or ie_rn_w = 'ST') then
    begin
      select	max(nr_atend_rn), max(cd_pessoa_rn)
      into STRICT	nr_atendimento_w, cd_pessoa_fisica_w
      from	nascimento
      where	nr_atendimento = nr_atendimento_p
      and	nr_sequencia = nr_seq_nascimento_p  LIMIT 1;
    exception when others then
      nr_atendimento_w := null;
      cd_pessoa_fisica_w := null;
    end;

    if (coalesce(cd_pessoa_fisica_w::text, '') = '' and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')) then
        cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_w, 'C');
    end if;
  else
    cd_pessoa_fisica_w := cd_pessoa_fisica_p;
    nr_atendimento_w := nr_atendimento_p;

    if (coalesce(cd_pessoa_fisica_w::text, '') = '' and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')) then
        cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_w, 'C');
    end if;
  end if;

  if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '' AND (ie_rn_w = 'S' or ie_rn_w = 'N')) then
      begin
        if (nr_seq_teste_vacina_p IS NOT NULL AND nr_seq_teste_vacina_p::text <> '') then
			select  max(a.nr_seq_vacina), max(a.qt_prox_mes)
			into STRICT    nr_seq_vacina_w, qt_prox_mes_w
			from    vacina_calendario a,
					vacina_teste_rn b
			where   a.nr_seq_vacina = b.nr_seq_vacina
			and     b.nr_sequencia = nr_seq_teste_vacina_p
			and     coalesce(b.ie_vacina, 'N') = 'S'
			and     a.ie_dose = coalesce(b.ie_dose, '1D')  LIMIT 1;
        elsif (nr_seq_vacina_p IS NOT NULL AND nr_seq_vacina_p::text <> '') then
          begin
            select nr_seq_vacina, qt_prox_mes
            into STRICT nr_seq_vacina_w, qt_prox_mes_w
            from vacina_calendario
            where nr_seq_vacina = nr_seq_vacina_p
            and ie_dose = '1D'  LIMIT 1;
          exception when others then
            nr_seq_vacina_w := null;
            qt_prox_mes_w := null;
          end;
        end if;

        if (nr_seq_vacina_w IS NOT NULL AND nr_seq_vacina_w::text <> '') then

          select nextval('paciente_vacina_seq')
          into STRICT pac_vac_seq
;

          insert into PACIENTE_VACINA(
                NR_SEQUENCIA,
                NR_ATENDIMENTO, 
                IE_DOSE, 
                DT_VACINA, 
                NR_SEQ_VACINA, 
                DT_ATUALIZACAO, 
                NM_USUARIO, 
                IE_ORIGEM_PROCED, 
                DT_PROXIMA_DOSE, 
                CD_PESSOA_FISICA, 
                IE_EXECUTADO, 
                IE_LOCALIDADE_INF, 
                CD_PROFISSIONAL, 
                IE_SITUACAO, 
                IE_CONFIRMADO, 
                IE_GESTANTE,
                DT_REGISTRO,
				DT_LIBERACAO,
				DT_PREVISTA_EXECUCAO
          ) values (
                /*NR_SEQUENCIA*/
      pac_vac_seq, 
                /*NR_ATENDIMENTO*/
    nr_atendimento_w, 
                /*IE_DOSE*/
           '1D', 
                /*DT_VACINA*/
         dt_registro_p, 
                /*NR_SEQ_VACINA*/
     nr_seq_vacina_w, 
                /*DT_ATUALIZACAO*/
    clock_timestamp(), 
                /*NM_USUARIO*/
        nm_usuario_p, 
                /*IE_ORIGEM_PROCED*/
  1, 
                /*DT_PROXIMA_DOSE*/
   add_months(dt_registro_p, coalesce(qt_prox_mes_w, 0)), 
                /*CD_PESSOA_FISICA*/
  cd_pessoa_fisica_w, 
                /*IE_EXECUTADO*/
      'S', 
                /*IE_LOCALIDADE_INF*/
 'N', 
                /*CD_PROFISSIONAL*/
   obter_pf_usuario(nm_usuario_p, 'C'), 
                /*IE_SITUACAO*/
       'A', 
                /*IE_CONFIRMADO*/
     'N', 
                /*IE_GESTANTE*/
       'N',
                clock_timestamp(),
				clock_timestamp(),
				clock_timestamp()
          );

          commit;
        end if;

      exception when others then
        null;
      end;
  elsif (ie_rn_w = 'ST' and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_nascimento_p IS NOT NULL AND nr_seq_nascimento_p::text <> '')) then

    if ((cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') or (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') ) then
      for vacina in (
          SELECT nr_seq_teste_vacina,dt_registro from atend_vacina_teste
          where nr_atendimento = nr_atendimento_p
          and nr_seq_nascimento = nr_seq_nascimento_p
          and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
          and coalesce(dt_inativacao::text, '') = ''
          and (nr_seq_teste_vacina IS NOT NULL AND nr_seq_teste_vacina::text <> '')
      ) loop

          CALL INSERIR_PACIENTE_VACINA_RN(cd_pessoa_fisica_w, nr_atendimento_w, null, vacina.nr_seq_teste_vacina, null, vacina.dt_registro, nm_usuario_p, 'N');

      end loop;
    end if;
  end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_paciente_vacina_rn ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_nascimento_p bigint, nr_seq_teste_vacina_p bigint, nr_seq_vacina_p bigint, dt_registro_p timestamp, nm_usuario_p text, ie_rn_p text default 'N') FROM PUBLIC;

