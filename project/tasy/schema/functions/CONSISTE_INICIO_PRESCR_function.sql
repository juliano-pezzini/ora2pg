-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_inicio_prescr ( nr_seq_cpoe_tipo_pedido_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, dt_inicio_desejada_p timestamp, nr_atendimento_p bigint default null, si_type_of_prescription_p text default null, nr_seq_cpoe_order_unit_p bigint default null, is_inconsistency_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_permite_w			    varchar(70);
dt_maxima_w           timestamp;
qt_dias_w             bigint;
ie_level_warning_w    bigint;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;

ie_considera_feriado_w			    varchar(2);
ie_considera_fim_semana_w			    varchar(2);

is_feriado_w    bigint;
is_fds_w    bigint;
qt_dias_regra_w    bigint;
qt_dias_add_fds_w    bigint;
qt_dias_add_holiday_w    bigint;
dt_horas_inicio_w	TIMESTAMP;

dt_loop_w	timestamp;
dt_diff_w	bigint;
qtd_feriado_w	bigint;
qtd_fds_w	bigint;

dt_inicio_desejada_w	timestamp;

nr_seq_cpoe_tipo_pedido_w cpoe_order_unit.nr_seq_cpoe_tipo_pedido%type;
si_type_of_prescription_w cpoe_order_unit.si_type_of_prescription%type;

c01 CURSOR FOR
  SELECT  pkg_date_utils.get_DateTime(dt_inicio_desejada_p - coalesce(qt_dias_inicio, 0), pkg_date_utils.get_Time(
                            coalesce(pkg_date_utils.extract_field('HOUR', dt_horas_inicio, 0), 0),
                            coalesce(pkg_date_utils.extract_field('MINUTE', dt_horas_inicio, 0), 0)
                            )),
          ie_level_warning,
          qt_dias_inicio, 
          dt_horas_inicio,
          IE_CONSIDERA_FERIADO, 
          IE_CONSIDERA_FIM_SEMANA 
  from    cpoe_prazo_inicio_prescr
  where   cd_estabelecimento = cd_estabelecimento_p
  and  	  coalesce(cd_perfil,cd_perfil_p) = cd_perfil_p
  and (nr_seq_cpoe_tipo_pedido = nr_seq_cpoe_tipo_pedido_w or coalesce(nr_seq_cpoe_tipo_pedido::text, '') = '')
  and (cd_setor_atendimento = cd_setor_atendimento_p or coalesce(cd_setor_atendimento::text, '') = '')
  and (ie_tipo_atendimento = ie_tipo_atendimento_w or  coalesce(ie_tipo_atendimento::text, '') = '')
  and (si_type_of_prescription = si_type_of_prescription_w or coalesce(si_type_of_prescription::text, '') = '');

BEGIN


  ds_permite_w := 'ALLOW';
  qt_dias_add_fds_w := 0;
  qtd_feriado_w := 0;
  qtd_fds_w := 0;

  select  max(a.ie_tipo_atendimento)
  into STRICT    ie_tipo_atendimento_w
  from    atendimento_paciente a   
  where   a.nr_atendimento = nr_atendimento_p;

  if (nr_seq_cpoe_order_unit_p IS NOT NULL AND nr_seq_cpoe_order_unit_p::text <> '') then
    select nr_seq_cpoe_tipo_pedido,
           si_type_of_prescription
    into STRICT  nr_seq_cpoe_tipo_pedido_w,
          si_type_of_prescription_w
    from cpoe_order_unit
    where nr_sequencia = nr_seq_cpoe_order_unit_p;
  else
    nr_seq_cpoe_tipo_pedido_w := nr_seq_cpoe_tipo_pedido_p;
    si_type_of_prescription_w := si_type_of_prescription_p;
  end if;
  open c01;

  loop

      fetch c01 into
          dt_maxima_w,
          ie_level_warning_w,
          qt_dias_regra_w,
          dt_horas_inicio_w,
          ie_considera_feriado_w,
          ie_considera_fim_semana_w;
      EXIT WHEN NOT FOUND; /* apply on c01 */

      begin
      
			dt_inicio_desejada_w := dt_inicio_desejada_p;
 		 	
 		 	dt_diff_w := TRUNC(dt_inicio_desejada_w) - TRUNC(dt_maxima_w);
				 		 	
 		 	dt_loop_w := dt_maxima_w;

 		 	FOR i IN 1..dt_diff_w LOOP

                		dt_loop_w := dt_loop_w + 1;
 		 	
 		 		is_fds_w := obter_cod_dia_semana(dt_loop_w);
 		 		is_feriado_w := obter_se_feriado(1, dt_loop_w);

                		if ((is_fds_w = '1') OR (is_fds_w = '7') OR (is_feriado_w = '1')) then 
                
                    			if (ie_considera_fim_semana_w = 'N') THEN
                        			qt_dias_regra_w := qt_dias_regra_w + 1;
                    			end if;

                    			if (ie_considera_feriado_w = 'N' AND is_feriado_w = '1') THEN
                        			qt_dias_regra_w := qt_dias_regra_w + 1;
                    			end if;

                		end if;
 		 		
 		 	END LOOP;
 		 	
 		 	dt_maxima_w := pkg_date_utils.get_DateTime(dt_inicio_desejada_p - coalesce(qt_dias_regra_w, 0),
			 		 	pkg_date_utils.get_Time(coalesce(pkg_date_utils.extract_field('HOUR', dt_horas_inicio_w, 0), 0), 
			 		 	coalesce(pkg_date_utils.extract_field('MINUTE', dt_horas_inicio_w, 0), 0)));
			 		 	
	
			if (ie_level_warning_w IS NOT NULL AND ie_level_warning_w::text <> '') then
			  if ( clock_timestamp() > dt_maxima_w) then
			      if ( ie_level_warning_w = 0 ) then
              if (is_inconsistency_p = 'N') then
                CALL Wheb_mensagem_pck.exibir_mensagem_abort(1175410);
              else
                ds_permite_w := 'ERROR';
              end if;
			      elsif ( ie_level_warning_w = 1 ) then
			          ds_permite_w := 'WARNING';
			      end if;
			  end if;
			end if;
		end;

  end loop;

  CLOSE c01;

return coalesce(ds_permite_w, 'ALLOW');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_inicio_prescr ( nr_seq_cpoe_tipo_pedido_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, dt_inicio_desejada_p timestamp, nr_atendimento_p bigint default null, si_type_of_prescription_p text default null, nr_seq_cpoe_order_unit_p bigint default null, is_inconsistency_p text default 'N') FROM PUBLIC;
