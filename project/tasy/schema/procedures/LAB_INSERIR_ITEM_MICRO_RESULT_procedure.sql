-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_inserir_item_micro_result (nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_result_p text, nm_usuario_p text, ds_erro_p INOUT text, ds_obs_antibiotico_p text default null, nr_seq_exame_atualiz_p bigint default null, cd_cod_system_microo_p text default null, cd_cod_system_medica_p text default null, update_p text default null) AS $body$
DECLARE

  nr_Seq_resultado_w   bigint;
  nr_seq_exame_atual_w bigint;
  nr_seq_superior_w    bigint;
  nr_seq_exame_w       bigint;
  nr_seq_prescr_nova_w integer;
  nr_Seq_result_item_w bigint;
  cd_microorganismo_w  bigint;
  cd_medicamento_w     bigint;
  Exist_w              smallint;

  C01 CURSOR FOR
    SELECT	nr_seq_exame,
      nr_seq_superior
    from	exame_laboratorio
    where coalesce(cd_exame_integracao, cd_exame) = cd_exame_p
    order by 1;


BEGIN
  if coalesce(nr_seq_exame_atualiz_p::text, '') = '' then
    open C01;
    loop
    fetch C01 into	
      nr_seq_exame_atual_w,
      nr_seq_superior_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
      begin

      nr_seq_exame_w	:= nr_seq_exame_atual_w;

      select max(coalesce(nr_sequencia, null))
      into STRICT	nr_seq_prescr_nova_w
      from	prescr_procedimento
      where	nr_prescricao		= nr_prescricao_p
        and	nr_seq_exame		= nr_seq_exame_atual_w;

      if (coalesce(nr_seq_prescr_nova_w::text, '') = '') then
    	
        select	max(coalesce(nr_sequencia, null))
        into STRICT	nr_seq_prescr_nova_w
        from	prescr_procedimento
        where	nr_prescricao = nr_prescricao_p
          and	ie_status_atend >= 30
          and	nr_seq_exame = nr_seq_superior_w;
    		
          if (coalesce(nr_seq_prescr_nova_w::text, '') = '') then
    		
          select	max(coalesce(nr_sequencia, null))
          into STRICT	nr_seq_prescr_nova_w
          from	prescr_procedimento
          where	nr_prescricao = nr_prescricao_p
          and	nr_seq_exame = nr_seq_superior_w;			
        end if;
      end if;
    	
      if (nr_seq_prescr_nova_w IS NOT NULL AND nr_seq_prescr_nova_w::text <> '') then
        exit;
      end if;	
    	
      end;
    end loop;
    close C01;

    nr_seq_exame_w	:= nr_seq_exame_atual_w;

    select 	max(nr_Seq_resultado)
    into STRICT	nr_Seq_resultado_w
    from	exame_lab_resultado
    where 	nr_prescricao = nr_prescricao_p;

    select 	max(nr_sequencia)
    into STRICT	nr_Seq_result_item_w
    from	exame_lab_result_item
    where 	nr_Seq_resultado = nr_Seq_resultado_w
    and	nr_seq_prescr 	= nr_seq_prescr_p
    and	nr_seq_exame	= nr_seq_exame_w;

    if (coalesce(nr_Seq_result_item_w::text, '') = '') then
      select 	max(nr_sequencia)
      into STRICT	nr_Seq_result_item_w
      from	exame_lab_result_item
      where 	nr_Seq_resultado = nr_Seq_resultado_w
      and	nr_seq_prescr 	= nr_seq_prescr_p;
    end if;
  else
    select max(ri.nr_seq_resultado),
           max(ri.nr_sequencia)
      into STRICT nr_seq_resultado_w,
           nr_seq_result_item_w
      from exame_lab_resultado r
      join exame_lab_result_item ri
        on ri.nr_seq_resultado = r.nr_seq_resultado
     where ri.nr_seq_exame = nr_seq_exame_atualiz_p
       and ri.nr_seq_prescr = nr_seq_prescr_p
       and r.nr_prescricao = nr_prescricao_p;
  end if;

  if (cd_cod_system_microo_p IS NOT NULL AND cd_cod_system_microo_p::text <> '') then
    cd_microorganismo_w := lab_obter_cih_micro_int(cd_microorganismo_integracao_p => cd_microorganismo_p,
                                                   ds_sigla_equip_p => cd_cod_system_microo_p);
  else
    SELECT coalesce(MAX(a.cd_microorganismo),0)
      INTO STRICT cd_microorganismo_w
      FROM cih_microorganismo_int A
      join CIH_MICROORGANISMO B on B.CD_MICROORGANISMO = A.CD_MICROORGANISMO
      WHERE a.cd_microorganismo_integracao = cd_microorganismo_p 
      and B.IE_SITUACAO = 'A';

    IF (cd_microorganismo_w = 0) THEN
      
        SELECT MAX(cd_microorganismo)
        INTO STRICT cd_microorganismo_w
        FROM CIH_MICROORGANISMO
        WHERE coalesce(DS_MICROORGANISMO_INTEGR,CD_MICROORGANISMO) = cd_microorganismo_p
        and IE_SITUACAO = 'A';
    	
    END IF;	
  end if;

  if (cd_cod_system_medica_p IS NOT NULL AND cd_cod_system_medica_p::text <> '') then
    cd_medicamento_w := lab_obter_cih_medic_int(cd_medicamento_integracao_p => cd_medicamento_p,
                                                ds_sigla_equip_p => cd_cod_system_medica_p);
  else
    select coalesce(MAX(cd_medicamento),0)
    into STRICT   cd_medicamento_w
    from   cih_medicamento_int
    where  cd_medicamento_integracao = cd_medicamento_p;

    if (cd_medicamento_w = 0) then
      select	max(cd_medicamento)
      into STRICT	cd_medicamento_w
      from	CIH_MEDICAMENTO
      where	coalesce(DS_CODIGO_INTEGR,cd_medicamento) = cd_medicamento_p;
    end if;
  end if;

if (coalesce(nr_Seq_result_item_w::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(280066,'CD_EXAME='||cd_exame_p||';NR_PRESCRICAO='||nr_prescricao_p||',NR_SEQ_PRESCR='||nr_seq_prescr_p);
elsif (coalesce(cd_microorganismo_w::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277533,'CD_MICROORGANISMO='|| cd_microorganismo_p||';NR_PRESCRICAO='|| nr_prescricao_p||';NR_SEQ_PRESCR='|| nr_seq_prescr_p);
elsif (coalesce(cd_medicamento_w::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(280070,'CD_MEDICAMENTO='|| cd_medicamento_p||';NR_PRESCRICAO='|| nr_prescricao_p||';NR_SEQ_PRESCR='|| nr_seq_prescr_p);
end if;
	
if (nr_Seq_resultado_w IS NOT NULL AND nr_Seq_resultado_w::text <> '') and (cd_microorganismo_w IS NOT NULL AND cd_microorganismo_w::text <> '') and (cd_medicamento_w IS NOT NULL AND cd_medicamento_w::text <> '') and (nr_Seq_result_item_w IS NOT NULL AND nr_Seq_result_item_w::text <> '') then

  select count(1)
     into STRICT Exist_w
     from exame_lab_result_antib
    where nr_seq_resultado = nr_seq_resultado_w
      and nr_seq_result_item = nr_seq_result_item_w
      and cd_microorganismo = cd_microorganismo_w
      and cd_medicamento = cd_medicamento_w;

  if (update_p <> 'S' or coalesce(update_p::text, '') = '') or Exist_w = 0 then
    insert	into exame_lab_result_antib(NR_SEQUENCIA,
              NR_SEQ_RESULTADO,
              NR_SEQ_RESULT_ITEM,
              CD_MICROORGANISMO,
              CD_MEDICAMENTO,
              IE_RESULTADO,
              DT_ATUALIZACAO,
              DS_RESULTADO_ANTIB,
              NM_USUARIO,
              QT_MICROORGANISMO,
              ds_obs_antibiotico)
    values (nextval('exame_lab_result_antib_seq'),
              nr_Seq_resultado_w,
              nr_Seq_result_item_w,
              cd_microorganismo_w,
              cd_medicamento_w,
              ie_result_p,
              clock_timestamp(),
              qt_mic_p,
              nm_usuario_p,
              qt_microorganismo_p,
              ds_obs_antibiotico_p);	
  else
    update exame_lab_result_antib
       set ie_resultado = ie_result_p,
           dt_atualizacao = clock_timestamp(),
           ds_resultado_antib = qt_mic_p,
           nm_usuario = nm_usuario_p,
           qt_microorganismo = qt_microorganismo_p,
           ds_obs_antibiotico = ds_obs_antibiotico_p
    where nr_seq_resultado = nr_seq_resultado_w
      and nr_seq_result_item = nr_seq_result_item_w
      and cd_microorganismo = cd_microorganismo_w
      and cd_medicamento = cd_medicamento_w;
  end if;	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_inserir_item_micro_result (nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_exame_p text, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_result_p text, nm_usuario_p text, ds_erro_p INOUT text, ds_obs_antibiotico_p text default null, nr_seq_exame_atualiz_p bigint default null, cd_cod_system_microo_p text default null, cd_cod_system_medica_p text default null, update_p text default null) FROM PUBLIC;

