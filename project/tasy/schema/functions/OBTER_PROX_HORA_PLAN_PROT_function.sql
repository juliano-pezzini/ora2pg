-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prox_hora_plan_prot ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_item_p text) RETURNS timestamp AS $body$
DECLARE


  nr_seq_ficha_tecnica_w  material.nr_seq_ficha_tecnica%type;
  nr_seq_proc_interno_w	  cpoe_procedimento.nr_seq_proc_interno%type;
  ie_respiracao_w 		  cpoe_gasoterapia.ie_respiracao%type;
  cd_recomendacao_w		  cpoe_recomendacao.cd_recomendacao%type;
  ie_tipo_dieta_w		  cpoe_dieta.ie_tipo_dieta%type;
  nr_seq_tipo_w		  	  cpoe_dieta.nr_seq_tipo%type;
  cd_dieta_w			  cpoe_dieta.cd_dieta%type;
  cd_mat_prod1_w		  cpoe_dieta.cd_mat_prod1%type;
  cd_material_w     cpoe_material.cd_material%type;
  cd_intervalo_w    cpoe_material.cd_intervalo%type;
  ds_horarios_w     cpoe_material.ds_horarios%type;
  dt_inicio_w       cpoe_material.dt_inicio%type;
  dt_fim_w          cpoe_material.dt_fim%type;
  ds_ultimo_hor_w   cpoe_material.ds_horarios%type;
  dt_inicio_previsto_w   timestamp := null;
  i_pos_w           smallint;
  i_length_w        smallint;
  ie_minutos_w		varchar(1);
  qt_horas_int_w    double precision;

BEGIN

	if ie_tipo_item_p = 'M' then
	    select max(a.cd_material),
	           max(a.cd_intervalo),
	           max(a.dt_inicio),
	           max(b.nr_seq_ficha_tecnica)
	      into STRICT cd_material_w,
	           cd_intervalo_w,
	           dt_inicio_w,
	           nr_seq_ficha_tecnica_w
	      from cpoe_material a,
	           material b
	     where b.cd_material = a.cd_material
	       and a.nr_sequencia = nr_seq_cpoe_p;

	    if ((cd_material_w IS NOT NULL AND cd_material_w::text <> '') or (nr_seq_ficha_tecnica_w IS NOT NULL AND nr_seq_ficha_tecnica_w::text <> '')) then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_material a,
	               material b
	         where b.cd_material = a.cd_material
	           and a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and ((a.cd_material = cd_material_w)
	            or (b.nr_seq_ficha_tecnica = coalesce(nr_seq_ficha_tecnica_w, -1)))
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
	elsif ie_tipo_item_p = 'P' then
	    select max(a.nr_seq_proc_interno),
	           max(a.cd_intervalo),
	           max(a.dt_inicio)
	      into STRICT nr_seq_proc_interno_w,
	           cd_intervalo_w,
	           dt_inicio_w
	      from cpoe_procedimento a
	     where a.nr_sequencia = nr_seq_cpoe_p;

	    if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_procedimento a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.nr_seq_proc_interno = nr_seq_proc_interno_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
	elsif ie_tipo_item_p = 'G' then
	    select max(a.ie_respiracao),
	           max(a.cd_intervalo),
	           max(a.dt_inicio)
	      into STRICT ie_respiracao_w,
	           cd_intervalo_w,
	           dt_inicio_w
	      from cpoe_gasoterapia a
	     where a.nr_sequencia = nr_seq_cpoe_p;

	    if (ie_respiracao_w IS NOT NULL AND ie_respiracao_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_gasoterapia a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.ie_respiracao = ie_respiracao_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
	elsif ie_tipo_item_p = 'R' then
	    select max(a.cd_recomendacao),
	           max(a.cd_intervalo),
	           max(a.dt_inicio)
	      into STRICT cd_recomendacao_w,
	           cd_intervalo_w,
	           dt_inicio_w
	      from cpoe_recomendacao a
	     where a.nr_sequencia = nr_seq_cpoe_p;

	    if (cd_recomendacao_w IS NOT NULL AND cd_recomendacao_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_recomendacao a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.cd_recomendacao = cd_recomendacao_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
	elsif ie_tipo_item_p = 'MA' then
	    select max(a.cd_material),
	           max(a.cd_intervalo),
	           max(a.dt_inicio)
	      into STRICT cd_material_w,
	           cd_intervalo_w,
	           dt_inicio_w
	      from cpoe_material a,
	           material b
	     where b.cd_material = a.cd_material
	       and a.nr_sequencia = nr_seq_cpoe_p;

	    if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_material a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.cd_material = cd_material_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
	elsif ie_tipo_item_p = 'N' then
	    select max(a.ie_tipo_dieta),
			   max(a.cd_dieta),
			   max(a.cd_mat_prod1),
			   max(a.cd_material),
	           max(a.cd_intervalo),
	           max(a.dt_inicio)
	      into STRICT ie_tipo_dieta_w,
		  	   cd_dieta_w,
			   cd_mat_prod1_w,
		  	   cd_material_w,
	           cd_intervalo_w,
	           dt_inicio_w
	      from cpoe_dieta a,
	           material b
	     where b.cd_material = a.cd_material
	       and a.nr_sequencia = nr_seq_cpoe_p;

	    if ((ie_tipo_dieta_w in ('E', 'S')) and (cd_material_w IS NOT NULL AND cd_material_w::text <> '')) then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_dieta a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.cd_material = cd_material_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		elsif (ie_tipo_dieta_w = 'O' AND cd_dieta_w IS NOT NULL AND cd_dieta_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_dieta a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.cd_dieta = cd_dieta_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
	    elsif (ie_tipo_dieta_w = 'L' AND cd_mat_prod1_w IS NOT NULL AND cd_mat_prod1_w::text <> '') then
	        select max(a.ds_horarios),
				   max(a.dt_fim)
	          into STRICT ds_horarios_w,
	               dt_fim_w
	          from cpoe_dieta a
	         where a.nr_atendimento = nr_atendimento_p
	           and a.nr_sequencia <> nr_seq_cpoe_p
	           and a.cd_mat_prod1 = cd_mat_prod1_w
	           and coalesce(a.dt_suspensao::text, '') = ''
	           and a.ie_duracao = 'P';
		end if;
    end if;

	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '' AND dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') then
		while	(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
			i_length_w := length(ds_horarios_w);
			i_pos_w	:= position(' ' in ds_horarios_w);

			if (i_pos_w > 0) then
				ds_ultimo_hor_w := trim(both substr(ds_horarios_w, i_pos_w, i_length_w));
				ds_horarios_w := trim(both substr(ds_horarios_w, i_pos_w, i_length_w));
				i_length_w := length(ds_horarios_w);
			else
				ds_horarios_w := null;
			end if;
		end loop;

		if (substr(ds_ultimo_hor_w,1,2) = '00') or (substr(ds_ultimo_hor_w,1,2) = '24') then
		  dt_inicio_previsto_w := PKG_DATE_UTILS.start_of(dt_fim_w,'dd',0) + 1;
		else
			ie_minutos_w	:= 'N';
			if (length(ds_ultimo_hor_w) = 0) then
				ds_ultimo_hor_w	:= '00';
			elsif	((length(ds_ultimo_hor_w) > 2) and (length(ds_ultimo_hor_w) <> 5)) or
				((length(ds_ultimo_hor_w) = 5) and
				((substr(ds_ultimo_hor_w,3,1) <> ':') or (substr(ds_ultimo_hor_w,4,1) > '5'))) then
				ds_ultimo_hor_w	:= substr(ds_ultimo_hor_w,1,2);
			end if;

			if (length(ds_ultimo_hor_w) = 1) then
				ds_ultimo_hor_w	:= '0' || ds_ultimo_hor_w;
			elsif (length(ds_ultimo_hor_w) = 5) then
				ie_minutos_w	:= 'S';
			end if;

			if (ds_ultimo_hor_w <> 'SN') and (ds_ultimo_hor_w <> 'ACM') and (ds_ultimo_hor_w IS NOT NULL AND ds_ultimo_hor_w::text <> '') then
					if (ie_minutos_w	= 'S') then
						dt_inicio_previsto_w := to_date(to_char(dt_fim_w,'dd/mm/yyyy') || ds_ultimo_hor_w,'dd/mm/yyyy hh24:mi');
					else
						dt_inicio_previsto_w := to_date(to_char(dt_fim_w,'dd/mm/yyyy') || ds_ultimo_hor_w,'dd/mm/yyyy hh24');
					end if;
			end if;
		end if;
	end if;

  if (dt_inicio_previsto_w IS NOT NULL AND dt_inicio_previsto_w::text <> '') then
	qt_horas_int_w := Obter_ocorrencia_intervalo(cd_intervalo_w, 24, 'H');
    dt_inicio_previsto_w := dt_inicio_previsto_w + qt_horas_int_w/24;
  end if;

  if ((dt_inicio_previsto_w IS NOT NULL AND dt_inicio_previsto_w::text <> '' AND dt_inicio_w > dt_inicio_previsto_w) or (coalesce(dt_inicio_previsto_w::text, '') = '')) then
    dt_inicio_previsto_w := dt_inicio_w;
  end if;

  return dt_inicio_previsto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prox_hora_plan_prot ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_item_p text) FROM PUBLIC;

