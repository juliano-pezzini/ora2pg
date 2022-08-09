-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_transf_recor_cons ( dt_prev_transf_p timestamp, dt_prev_selecionada_p timestamp, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, ie_opcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_gerar_final_semana_p text, ie_gerar_feriado_p text, ie_diario_p text default null, ds_dias_p text default null, ie_semanal_p text default null, dt_prev_final_p timestamp default null) AS $body$
DECLARE



dt_agenda_w	timestamp;				
qt_dias_w	bigint;
nr_seq_ageint_item_w	bigint;
dt_agendamento_w	timestamp;
ie_dia_semana_w		varchar(3);
ie_Feriado_w		smallint;
ie_gerar_w			varchar(1)	:= 'N';

/* Alteracoes nesse cursor devem ser feitas tambem na rotina obter_dt_fim_transf_recorr e rotina ageint_transf_recorrencia_serv*/

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
			trunc(a.dt_agenda)
	from	agenda_consulta a,
		agenda_integrada_item b
	where	a.nr_sequencia = b.nr_seq_agenda_cons
	and	b.nr_seq_agenda_int = nr_seq_ageint_p
	and	a.ie_status_agenda <> 'C'
	--and	a.dt_agenda >= dt_agenda_w
	and	b.nr_sequencia <> nr_seq_ageint_item_p
	and (b.nr_sequencia > nr_seq_ageint_item_p or ie_opcao_p = 0)
	
union all

	SELECT	b.nr_sequencia,
			trunc(a.dt_agenda)
	from	agenda_consulta a,
		agenda_integrada_item b
	where	a.nr_sequencia = b.nr_seq_Agenda_cons
	and	b.nr_seq_agenda_int = nr_seq_ageint_p
	and	a.ie_status_agenda <> 'C'
	and	b.nr_sequencia = nr_seq_ageint_item_p
	order by 1;
				

BEGIN

/* opcao
    0 - Somente data selecionada
    1 - Todas as datas de recorrencia
*/
update	agenda_integrada_item
set	dt_prev_transf_item	 = NULL
where	nr_Seq_agenda_int	= nr_seq_ageint_p;

commit;

select	max(a.dt_agenda)
into STRICT	dt_agenda_w
from	agenda_consulta a,
		agenda_integrada_item b
where	a.nr_sequencia		= b.nr_seq_agenda_cons
and		b.nr_seq_agenda_int	= nr_seq_ageint_p;

if (ie_opcao_p = 0) then

	ie_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_w);
	ie_Feriado_w	:= obter_se_feriado(cd_estabelecimento_p, dt_agenda_w);
	if (ie_gerar_final_semana_p	= 'S') and (ie_Gerar_feriado_p		= 'S') then
		update	agenda_integrada_item
		set		dt_prev_transf_item = dt_prev_transf_p
		where	nr_sequencia = nr_seq_ageint_item_p;
	else
		qt_dias_w := 0;--dt_prev_transf_p - dt_prev_selecionada_p;
		ie_gerar_w	:= 'N';
		while(ie_gerar_w	= 'N') loop
			begin
			ie_dia_semana_w	:= obter_cod_dia_semana(dt_prev_transf_p + qt_dias_w);
			ie_Feriado_w	:= obter_se_feriado(cd_estabelecimento_p, dt_prev_transf_p + qt_dias_w);

			if (ie_gerar_final_semana_p	= 'N') then
				if (ie_dia_semana_w not in (1,7)) then
					ie_gerar_w	:= 'S';
				else
					ie_gerar_w	:= 'N';
				end if;
      else
        ie_gerar_w	:= 'S';
			end if;
			
			if (ie_Gerar_feriado_p	= 'N') and (ie_gerar_w			= 'S') then
				if (ie_feriado_w	= 0) then
					ie_gerar_w	:= 'S';
				else
					ie_gerar_w	:= 'N';
				end if;
			end if;
			
			if (ie_gerar_w	= 'N') then
				qt_dias_w	:= qt_dias_w + 1;
			end if;
			end;
		end loop;
		
		update	agenda_integrada_item
		set		dt_prev_transf_item = dt_prev_transf_p + qt_dias_w
		where	nr_sequencia = nr_seq_ageint_item_p;
	end if;
else
	if ((ie_diario_p = 'S') or (ie_semanal_p = 'S')) and (dt_prev_final_p IS NOT NULL AND dt_prev_final_p::text <> '') and (ie_opcao_p = 1) then
	
		CALL ageint_transf_recorrencia_serv(nr_seq_ageint_p, nm_usuario_p, ie_diario_p, ie_semanal_p, ds_dias_p, dt_prev_transf_p, dt_prev_final_p, ie_gerar_final_semana_p, nr_seq_ageint_item_p);
	
	else
		qt_dias_w := dt_prev_transf_p - dt_prev_selecionada_p;
		
		open C01;
		loop
		fetch C01 into	
			nr_seq_ageint_item_w,
			dt_agendamento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin		
			ie_gerar_w	:= 'N';
			--qt_dias_w := dt_prev_transf_p - dt_prev_selecionada_p;
			
			ie_dia_semana_w	:= obter_cod_dia_semana(dt_agendamento_w);
			ie_Feriado_w	:= obter_se_feriado(cd_estabelecimento_p, dt_agendamento_w);
			
			if (ie_gerar_final_semana_p	= 'S') and (ie_Gerar_feriado_p		= 'S') then
				update	agenda_integrada_item
				set		dt_prev_transf_item = dt_agendamento_w + qt_dias_w
				where	nr_sequencia = nr_seq_ageint_item_w;
			else
							
				while(ie_gerar_w	= 'N') loop 
					begin
					ie_dia_semana_w	:= obter_cod_dia_semana(dt_agendamento_w + qt_dias_w);
					ie_Feriado_w	:= obter_se_feriado(cd_estabelecimento_p, dt_agendamento_w + qt_dias_w);

					if (ie_gerar_final_semana_p	= 'N') then
						if (ie_dia_semana_w not in (1,7)) then
							ie_Gerar_w	:= 'S';
						else
							ie_gerar_w	:= 'N';
						end if;
          else
            ie_gerar_w	:= 'S';
					end if;
					
					if (ie_Gerar_feriado_p	= 'N') and (ie_Gerar_w			= 'S') then
						if (ie_feriado_w	= 0) then
							ie_Gerar_w	:= 'S';
						else
							ie_gerar_w	:= 'N';
						end if;
					end if;
					
					if (ie_Gerar_w	= 'N') then
						qt_dias_w	:= qt_dias_w + 1;
					end if;
					
					end;
				end loop;
				
				update	agenda_integrada_item
				set		dt_prev_transf_item = dt_agendamento_w + qt_dias_w
				where	nr_sequencia = nr_seq_ageint_item_w;
			end if;
			
			end;
		end loop;
		close C01;
	end if;	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_transf_recor_cons ( dt_prev_transf_p timestamp, dt_prev_selecionada_p timestamp, nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, ie_opcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_gerar_final_semana_p text, ie_gerar_feriado_p text, ie_diario_p text default null, ds_dias_p text default null, ie_semanal_p text default null, dt_prev_final_p timestamp default null) FROM PUBLIC;
