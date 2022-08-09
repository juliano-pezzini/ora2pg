-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_marcacao ( cd_agenda_p bigint, hr_agenda_p timestamp, nr_seq_ageint_p bigint, ie_Acao_p text, nr_minuto_duracao_p bigint, nm_usuario_p text, nr_seq_item_p bigint, nr_seq_ageint_lib_p bigint, ie_encaixe_p text, cd_medico_p text, ie_Reservado_p INOUT text, nm_usuario_confirm_encaixe_p text default null, ie_principal_p INOUT text DEFAULT NULL, CD_JUSTIFICATIVA_P bigint DEFAULT NULL, DS_JUSTIFICATIVA_P text DEFAULT NULL) AS $body$
DECLARE


cd_tipo_agenda_w        bigint;
nr_Seq_agenda_w         agenda_paciente.nr_sequencia%type;
ie_status_Agenda_w      varchar(3);
ie_reservado_w          varchar(1)     := 'L';
nr_sequencia_w          bigint;
qt_minuto_w             bigint;
nr_seq_proc_interno_w   bigint;
nr_seq_proc_interno_ww   bigint;
hr_Agenda_w             timestamp;
cd_pessoa_fisica_w      varchar(10);
ie_inserido_w           varchar(1)     := 'N';
nr_duracao_aux_w        bigint;
nr_minuto_duracao_w     bigint;
ie_sobra_duracao_w      varchar(1)     := 'N';
nr_duracao_item_w		bigint;
nr_minuto_dif_w			bigint;
ie_inicio_cursor_w		varchar(1);
dt_confirm_encaixe_w	timestamp;
ie_principal_w			varchar(1)		:= 'N';
nr_seq_turno_w			bigint;
ie_lado_w				varchar(1);
cd_convenio_w			integer;
cd_Categoria_w			varchar(10);
cd_plano_w				varchar(10);
ie_cons_dur_exames_adic_w	varchar(1);
qt_minuto_aux_adic_w	bigint;
qt_minuto_aux_princ_w	bigint;
qt_minuto_tot_adic_w	bigint 		:= 0;
nr_seq_exame_adic_w		bigint;
ie_lado_adic_w			varchar(1);
qt_tempo_duracao_proced_w	bigint;
ie_se_hor_med_outra_ag_w	varchar(1);
ie_classif_agenda_w		varchar(5);
qt_duracao_classif_w		bigint;
cd_estabelecimento_w		bigint;
ie_utiliza_dur_classif_w	parametro_agenda_integrada.ie_utiliza_dur_classif%type;
IE_HOR_POR_PROFISSIONAL_w		PARAMETRO_AGENDA_INTEGRADA.IE_HOR_POR_PROFISSIONAL%TYPE;
nr_min_dur_final_w bigint;
ds_aux_w varchar(100);

C01 CURSOR FOR
        SELECT  hr_Agenda,
                nr_minuto_duracao
        from    ageint_horarios_usuario
        where   cd_Agenda               = cd_agenda_p
        and     nm_usuario              = nm_usuario_p
        and     nr_Seq_ageint_lib       = nr_seq_ageint_lib_p
        and     hr_Agenda       		> hr_Agenda_p
		and (cd_pessoa_Fisica		= cd_medico_p or coalesce(cd_medico_p::text, '') = '')
        and     ie_inserido_w   		= 'N'
        order by hr_Agenda;

/*INICIO - Tratamento para atualizacao correta das duracoes dos exames, com base nas regras de "Tempo Proced", para os exames normais e adicionais dos itens*/

C02 CURSOR FOR
		SELECT	nr_seq_proc_interno,
				ie_lado
		from	ageint_exame_adic_item
		where	nr_seq_item	= nr_seq_item_p;
/*FIM - Tratamento para atualizacao correta das duracoes dos exames, com base nas regras de "Tempo Proced", para os exames normais e adicionais dos itens*/

procedure liberar_horario is
	;
BEGIN
	select  max(nr_Seq_agenda),
			max(nr_sequencia),
			max(nr_minuto_duracao)
	into STRICT    nr_seq_agenda_w,
			nr_sequencia_w,
			nr_min_dur_final_w
	from    ageint_marcacao_usuario
	where   cd_agenda               = cd_agenda_p
	and     hr_agenda               = hr_Agenda_p
	and     nm_usuario              = nm_usuario_p
  and     nr_seq_ageint           = nr_Seq_ageint_p
  and     nr_seq_ageint_item      = nr_seq_item_p
  and (cd_pessoa_fisica  = cd_medico_p
  or    coalesce(cd_medico_p::text, '') = '');

  if (cd_tipo_agenda_w       = 2) then
    --liberar agenda_paciente

    /*update        agenda_paciente
    set     ie_status_agenda        = 'L',
        nm_usuario              = nm_usuario_p,
        dt_atualizacao          = sysdate
    where   nr_sequencia            = nr_seq_agenda_w;*/
    CALL liberar_horario_agenda_exame(nr_seq_Agenda_w, nm_usuario_p);
    CALL liberar_hor_dur_age_exame(nr_seq_Agenda_w, nr_min_dur_final_w, nm_usuario_p);
  else
    --liberar agenda_consulta

    /*update        agenda_consulta
                    set  ie_status_agenda        = 'L',
      nm_usuario              = nm_usuario_p,
      dt_atualizacao          = sysdate
    where   nr_sequencia            = nr_seq_agenda_w;*/
    select  max(nr_seq_turno)
    into STRICT  nr_seq_turno_w
    from  agenda_consulta
    where  nr_sequencia  = nr_seq_agenda_w;
    liberar_horario_agecons(nr_seq_agenda_w, nm_usuario_p, nr_seq_turno_w);
  end if;

  update  ageint_horarios_usuario
  set     ie_status_agenda        = 'L'
  where   cd_agenda               = cd_agenda_p
  and     hr_agenda               = hr_Agenda_p
  and     nm_usuario              = nm_usuario_p
  --and     nr_seq_ageint_lib       = nr_seq_ageint_lib_p
  and (cd_pessoa_fisica  = cd_medico_p
  or     coalesce(cd_medico_p::text, '') = '');

  delete  FROM ageint_marcacao_usuario
  where (nr_sequencia            = nr_Sequencia_w)
  or (nr_seq_ageint_item     = nr_seq_item_p
  and     ie_horario_auxiliar      = 'S');

  DELETE FROM ageint_just_marc_rodizio WHERE nr_seq_ageint_item = nr_seq_item_p;

  delete   FROM ageint_sugestao_horarios
  where  nr_seq_item  = nr_seQ_item_p;

  if (ie_encaixe_p   = 'S') then
    delete  FROM ageint_encaixe_usuario
    where   cd_agenda               = cd_agenda_p
    and     dt_encaixe              = hr_agenda_p
    and     nm_usuario              = nm_usuario_p
    and     nr_seq_ageint           = nr_Seq_ageint_p
    and     nr_seq_ageint_item      = nr_seq_item_p;

    delete  FROM ageint_horarios_usuario
    where   cd_agenda               = cd_agenda_p
    and     hr_agenda               = hr_Agenda_p
    and     nm_usuario              = nm_usuario_p
    and     nr_seq_ageint_lib       = nr_seq_ageint_lib_p
    and     coalesce(ie_encaixe,'N')     = 'S';
  end if;

  ie_reservado_w  := 'L';
  end;

begin
--"Consistir duracao dos exames adicionais com base nas regras 'Tempo proced', para atualizacao da duracao  do agendamento"
select  coalesce(max(obter_valor_param_usuario(869, 303, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)), 'N')
into STRICT  ie_cons_dur_exames_adic_w
;

select   coalesce(max(ie_utiliza_dur_classif),'N'),
  coalesce(MAX(IE_HOR_POR_PROFISSIONAL), 'N')
into STRICT  ie_utiliza_dur_classif_w,
  IE_HOR_POR_PROFISSIONAL_w
from  parametro_agenda_integrada
where  cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT  ie_principal_w
from  agenda_integrada_item a,
    ageint_grupo_proc b,
    ageint_grupo_proc_item c
where  b.nr_sequencia = a.nr_seq_grupo_proc
and    c.nr_seq_grupo_proc   = b.nr_sequencia
and    c.nr_seq_proc_interno   = a.nr_seq_proc_interno
and    a.nr_seq_Agenda_int  = nr_seq_ageint_p
and    a.nr_sequencia    = nr_seq_item_p
and    coalesce(c.ie_exame_principal,'N') = 'S';

select  max(ie_lado),
    max(ie_classif_agenda)
into STRICT  ie_lado_w,
    ie_classif_agenda_w
from  agenda_integrada_item
where  nr_sequencia  = nr_seq_item_p;

ie_principal_p  := ie_principal_w;

if (nm_usuario_confirm_encaixe_p IS NOT NULL AND nm_usuario_confirm_encaixe_p::text <> '') then
  dt_confirm_encaixe_w := clock_timestamp();
end if;

select  cd_tipo_agenda
into STRICT    cd_tipo_agenda_w
from    agenda
where   cd_agenda       = cd_agenda_p;


if (ie_Acao_p      = 'I') and (ie_encaixe_p   = 'N') then
  if (cd_tipo_agenda_w       = 2) then--exame
    --reservar agenda_paciente
    select  coalesce(max(nr_sequencia),0),
        max(ie_status_agenda)
    into STRICT    nr_Seq_agenda_w,
        ie_status_Agenda_w
    from    agenda_paciente
    where   cd_agenda       = cd_agenda_p
    and     hr_inicio       = hr_agenda_p;

    ie_reservado_w := ageint_reserv_hor_agenda_exame(nr_Seq_agenda_w, nm_usuario_p, ie_reservado_w);

                /*if    (nr_Seq_agenda_w <> 0) and
                        (ie_status_Agenda_w = 'L') then
                        update  agenda_paciente
                        set     ie_status_agenda        = 'R',
                                nm_usuario              = nm_usuario_p,
                                dt_atualizacao          = sysdate
                        where   nr_sequencia            = nr_seq_agenda_w;
                elsif   (ie_status_Agenda_w <> 'L') then

                end if;*/
  elsif (cd_tipo_agenda_w       = 3) then--consulta
    --reservar agenda_consulta
    select  coalesce(max(nr_sequencia),0),
        max(ie_status_agenda)
    into STRICT    nr_Seq_agenda_w,
        ie_status_Agenda_w
    from    agenda_consulta
    where   cd_agenda       = cd_agenda_p
    and     dt_agenda       = hr_agenda_p;

    ie_reservado_w := ageint_reserv_hor_agecons(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);

                /*if    (nr_Seq_agenda_w <> 0) and
                        (ie_status_Agenda_w = 'L') then
                        update  agenda_consulta
                        set     ie_status_agenda        = 'R',
                                nm_usuario              = nm_usuario_p,
                                dt_atualizacao          = sysdate
                        where   nr_sequencia            = nr_seq_agenda_w;
                elsif   (ie_status_Agenda_w <> 'L') then

                end if;*/
  elsif (cd_tipo_agenda_w = 5) and (IE_HOR_POR_PROFISSIONAL_w = 'S')  then --servicos
    select  coalesce(max(nr_sequencia),0),
            max(ie_status_agenda)
        into STRICT    nr_seq_agenda_w,
            ie_status_Agenda_w
        from    agenda_consulta
        where   cd_agenda       = cd_agenda_p
    and    ie_status_agenda in ('L','B')
        and   dt_agenda       = hr_agenda_p
     and  coalesce(cd_medico, coalesce(cd_medico_p,'0')) = coalesce(cd_medico_p, '0');

    ie_reservado_w := ageint_reserv_hor_agecons(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);
  else
    --reservar agenda_consulta
    select  coalesce(max(nr_sequencia),0),
        max(ie_status_agenda)
    into STRICT    nr_seq_agenda_w,
        ie_status_Agenda_w
    from    agenda_consulta
    where   cd_agenda       = cd_agenda_p
    and    ie_status_agenda in ('L','B')
    and   dt_agenda       = hr_agenda_p;

    ie_reservado_w := ageint_reserv_hor_agecons(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);
        /*if  (ie_reservado_w  = 'S') then
          ageint_reserv_hor_ageserv(nr_seq_agenda_w, nm_usuario_p, ie_reservado_w);
        end if;*/


            /*if    (nr_Seq_agenda_w <> 0) and
                (ie_status_Agenda_w = 'L') then
                update  agenda_consulta
                set     ie_status_agenda        = 'R',
                    nm_usuario              = nm_usuario_p,
                    dt_atualizacao          = sysdate
                where   nr_sequencia            = nr_seq_agenda_w;
            elsif   (ie_status_Agenda_w <> 'L') then

            end if;*/
  end if;

  if (ie_reservado_w <> 'N') then

    select  max(nr_seq_proc_interno),
        max(nr_minuto_duracao)
    into STRICT    nr_seq_proc_interno_w,
        nr_duracao_item_w
    from    agenda_integrada_item
    where   nr_sequencia    = nr_seq_item_p;

    if (obter_valor_param_usuario(869, 410, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)= 'S')then 
      select ageint_tempo_ag_coletivo(nr_seq_ageint_p,nr_duracao_item_w) 
      into STRICT nr_duracao_item_w
;
    end if;

    select  max(cd_pessoa_fisica),
        max(cd_convenio),
        max(cd_Categoria),
        max(cd_plano)
    into STRICT    cd_pessoa_fisica_w,
        cd_convenio_w,
        cd_Categoria_w,
        cd_plano_w
    from    agenda_integrada
    where   nr_sequencia    = nr_seq_ageint_p;

    if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') and (coalesce(nr_duracao_item_w::text, '') = '')then
      qt_minuto_w := Obter_Tempo_Padrao_Ageint(nr_seq_proc_interno_w, null, null, cd_medico_p, cd_agenda_p, cd_pessoa_fisica_w, qt_minuto_w, ie_lado_w, cd_convenio_w, cd_Categoria_w, cd_plano_w, nr_Seq_agenda_w, null);
    end if;

    if (coalesce(ie_classif_agenda_w,'XPTO') <> 'XPTO') then

      select   max(cd_estabelecimento)
      into STRICT  cd_estabelecimento_w
      from   agenda
      where  cd_agenda = cd_agenda_p;

      select   Ageint_Obter_Dur_Classif(ie_classif_agenda_w, coalesce(cd_estabelecimento_w,wheb_usuario_pck.get_cd_estabelecimento), cd_medico_p, hr_agenda_p)
      into STRICT  qt_duracao_classif_w
;

      if (qt_duracao_classif_w > 0) then
        nr_minuto_duracao_w := qt_duracao_classif_w;
      end if;

    end if;
    /*INICIO - Tratamento para atualizacao correta das duracoes dos exames, com base nas regras de "Tempo Proced", para os exames normais e adicionais dos itens*/

    if (ie_cons_dur_exames_adic_w = 'S') then
      --Exame adicional
      open C02;
      loop
      fetch C02 into
        nr_seq_exame_adic_w,
        ie_lado_adic_w;
      EXIT WHEN NOT FOUND; /* apply on C02 */
        begin

        if (nr_seq_exame_adic_w IS NOT NULL AND nr_seq_exame_adic_w::text <> '')then

          qt_minuto_aux_adic_w := Obter_Tempo_Padrao_Ageint(  nr_seq_exame_adic_w, null, null, cd_medico_p, cd_agenda_p, cd_pessoa_fisica_w, qt_minuto_aux_adic_w, ie_lado_adic_w, cd_convenio_w, cd_Categoria_w, cd_plano_w, nr_Seq_agenda_w, null);

          if (qt_minuto_aux_adic_w IS NOT NULL AND qt_minuto_aux_adic_w::text <> '')then
            qt_minuto_tot_adic_w := qt_minuto_aux_adic_w + qt_minuto_tot_adic_w;
          end if;

        end if;

        end;
      end loop;
      close C02;

      --Exame normal
      select  b.nr_seq_proc_interno
      into STRICT  nr_seq_proc_interno_ww
      from  agenda_integrada_item b
      where  b.nr_sequencia  = nr_seq_item_p;

      qt_minuto_aux_princ_w := Obter_Tempo_Padrao_Ageint(  nr_seq_proc_interno_ww, null, null, cd_medico_p, cd_agenda_p, cd_pessoa_fisica_w, qt_minuto_aux_princ_w, ie_lado_w, cd_convenio_w, cd_Categoria_w, cd_plano_w, nr_Seq_agenda_w, null);

      if (qt_minuto_aux_princ_w IS NOT NULL AND qt_minuto_aux_princ_w::text <> '') then
        qt_minuto_tot_adic_w := qt_minuto_tot_adic_w + qt_minuto_aux_princ_w;
      end if;

      --if   ((qt_duracao_classif_w > 0) and (cd_tipo_agenda_w = 3)) then
      if   (qt_duracao_classif_w > 0 AND cd_tipo_agenda_w = 3 AND ie_utiliza_dur_classif_w = 'S') then
        qt_minuto_tot_adic_w := qt_minuto_tot_adic_w + qt_duracao_classif_w;
      end if;

      if (coalesce(qt_minuto_tot_adic_w, 0) = 0) or (coalesce(qt_minuto_tot_adic_w::text, '') = '')then

        if (coalesce(qt_minuto_w, 0) > 0)then
          qt_minuto_tot_adic_w  := qt_minuto_w;
        elsif (coalesce(nr_minuto_duracao_p, 0) > 0) then
          qt_minuto_tot_adic_w  := nr_minuto_duracao_p;
        elsif (coalesce(nr_duracao_item_w, 0) > 0)then
          qt_minuto_tot_adic_w  := nr_duracao_item_w;
        end if;

      end if;

    end if;
    /*FIM - Tratamento para atualizacao correta das duracoes dos exames, com base nas regras de "Tempo Proced", para os exames normais e adicionais dos itens*/

    if (ie_cons_dur_exames_adic_w = 'N') and (coalesce(nr_minuto_duracao_w::text, '') = '') and (coalesce(nr_duracao_item_w::text, '') = '')then
      nr_minuto_duracao_w := nr_minuto_duracao_p;
    end if;

    select   CASE WHEN coalesce(qt_minuto_tot_adic_w, 0)=0 THEN  CASE WHEN coalesce(qt_minuto_w, 0)=0 THEN  CASE WHEN coalesce(nr_minuto_duracao_w, 0)=0 THEN  nr_duracao_item_w  ELSE nr_minuto_duracao_w END   ELSE qt_minuto_w END   ELSE qt_minuto_tot_adic_w END 
    into STRICT   nr_min_dur_final_w
;

    insert into ageint_marcacao_usuario(nr_Sequencia,
        cd_Agenda,
        hr_agenda,
        nm_usuario,
        nr_Seq_ageint,
        nr_minuto_duracao,
        nr_Seq_agenda,
        nr_seq_ageint_item,
        ie_horario_auxiliar,
        cd_pessoa_fisica)
    values (nextval('ageint_marcacao_usuario_seq'),
        cd_Agenda_p,
        hr_agenda_p,
        nm_usuario_p,
        nr_Seq_ageint_p,
        nr_min_dur_final_w,
        --decode(nvl(qt_minuto_w, 0), 0, decode(nvl(nr_duracao_item_w, 0), 0, nr_minuto_duracao_p, nr_duracao_item_w), qt_minuto_w),
        nr_Seq_agenda_w,
        nr_seq_item_p,
        'N',
        cd_medico_p);

    IF ((cd_justificativa_p IS NOT NULL AND cd_justificativa_p::text <> '') OR
      (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '')) THEN
      INSERT INTO ageint_just_marc_rodizio(nr_sequencia,
         nr_seq_ageint_item,
         nr_seq_justificativa,
         ds_justificativa,
         dt_atualizacao,
         dt_atualizacao_nrec,
         nm_usuario,
         nm_usuario_nrec)
      VALUES (nextval('ageint_just_marc_rodizio_seq'),
         nr_seq_item_p,
         cd_justificativa_p,
         ds_justificativa_p,
         clock_timestamp(),
         clock_timestamp(),
         nm_usuario_p,
         nm_usuario_p);
    END IF;

    if (cd_tipo_agenda_w = 2) then
      ie_reservado_w := reserv_hor_dur_age_exame( nr_Seq_agenda_w, nm_usuario_p, nr_min_dur_final_w, ie_reservado_w);
    end if;


    if (qt_minuto_w  > 0) then
      nr_minuto_dif_w  := qt_minuto_w;
    /*elsif  (nr_duracao_item_w  > 0) then
      nr_minuto_dif_w  := nr_duracao_item_w;*/
    else
      nr_minuto_dif_w  := 0;
    end if;

    if (nr_minuto_dif_w      <> 0) then
        --nr_duracao_aux_w        := nr_minuto_duracao_p;
      ie_inicio_cursor_w  := 'S';
      open C01;
      loop
      fetch C01 into
          hr_agenda_w,
          nr_minuto_duracao_w;
      EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
        if (ie_inicio_cursor_w  = 'S') then
          nr_duracao_aux_w  := nr_minuto_duracao_w;
        end if;

        if (nr_duracao_aux_w       < nr_minuto_dif_w) and
          ((ie_inserido_w   = 'S') or (ie_inicio_cursor_w  = 'S')) then
          ie_inserido_w           := 'N';
          ie_sobra_duracao_w      := 'S';
        end if;
        --nr_duracao_aux_w        := nr_duracao_aux_w + nr_minuto_duracao_w;
        if (nr_duracao_aux_w       < nr_minuto_dif_w) or (ie_sobra_duracao_w     = 'S') then


          insert into ageint_marcacao_usuario(nr_Sequencia,
              cd_Agenda,
              hr_agenda,
              nm_usuario,
              nr_Seq_ageint,
              nr_minuto_duracao,
              nr_Seq_agenda,
              nr_seq_ageint_item,
              ie_horario_auxiliar,
              cd_pessoa_fisica)
            values (nextval('ageint_marcacao_usuario_seq'),
              cd_Agenda_p,
              hr_agenda_w,
              nm_usuario_p,
              nr_Seq_ageint_p,
              nr_minuto_duracao_w,
              nr_Seq_agenda_w,
              nr_seq_item_p,
              'S',
              cd_medico_p);
          IF ((cd_justificativa_p IS NOT NULL AND cd_justificativa_p::text <> '') OR
            (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '')) THEN
            INSERT INTO ageint_just_marc_rodizio(nr_sequencia,
               nr_seq_ageint_item,
               nr_seq_justificativa,
               ds_justificativa,
               dt_atualizacao_nrec,
               dt_atualizacao,
               nm_usuario_nrec,
               nm_usuario)
            VALUES (nextval('ageint_just_marc_rodizio_seq'),
               nr_seq_item_p,
               cd_justificativa_p,
               ds_justificativa_p,
               clock_timestamp(),
               clock_timestamp(),
               nm_usuario_p,
               nm_usuario_p);
          END IF;

        ie_inserido_w           := 'S';
        ie_sobra_duracao_w      := 'N';
        end if;

        nr_duracao_aux_w        := nr_duracao_aux_w + nr_minuto_duracao_w;
        ie_inicio_cursor_w    := 'N';
        end;

      end loop;
      close C01;
    end if;
  end if;

        ie_reservado_p  := ie_reservado_w;
elsif (ie_Acao_p      = 'I') and (ie_encaixe_p   = 'S') then
  insert into ageint_marcacao_usuario(nr_Sequencia,
          cd_Agenda,
          hr_agenda,
          nm_usuario,
          nr_Seq_ageint,
          nr_minuto_duracao,
          nr_seq_ageint_item,
          ie_horario_auxiliar,
          ie_encaixe,
          cd_pessoa_Fisica,
          nm_usuario_confirm_encaixe,
          dt_confirm_encaixe)
      values (nextval('ageint_marcacao_usuario_seq'),
          cd_Agenda_p,
          hr_agenda_p,
          nm_usuario_p,
          nr_Seq_ageint_p,
          nr_minuto_duracao_p,
          nr_seq_item_p,
          'N',
          'S',
          cd_medico_p,
          nm_usuario_confirm_encaixe_p,
          dt_confirm_encaixe_w);

  IF ((cd_justificativa_p IS NOT NULL AND cd_justificativa_p::text <> '') OR
    (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '')) THEN
    INSERT INTO ageint_just_marc_rodizio(nr_sequencia,
     nr_seq_ageint_item,
     nr_seq_justificativa,
     ds_justificativa,
     dt_atualizacao_nrec,
     dt_atualizacao,
     nm_usuario_nrec,
     nm_usuario)
    VALUES (nextval('ageint_just_marc_rodizio_seq'),
     nr_seq_item_p,
     cd_justificativa_p,
     ds_justificativa_p,
     clock_timestamp(),
     clock_timestamp(),
     nm_usuario_p,
     nm_usuario_p);
    END IF;
else
  CALL liberar_horario();
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_marcacao ( cd_agenda_p bigint, hr_agenda_p timestamp, nr_seq_ageint_p bigint, ie_Acao_p text, nr_minuto_duracao_p bigint, nm_usuario_p text, nr_seq_item_p bigint, nr_seq_ageint_lib_p bigint, ie_encaixe_p text, cd_medico_p text, ie_Reservado_p INOUT text, nm_usuario_confirm_encaixe_p text default null, ie_principal_p INOUT text DEFAULT NULL, CD_JUSTIFICATIVA_P bigint DEFAULT NULL, DS_JUSTIFICATIVA_P text DEFAULT NULL) FROM PUBLIC;
