-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_result_prescr_lab_at (nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_prescr_p bigint default 0) RETURNS timestamp AS $body$
DECLARE


dt_resultado_w			timestamp;			
nr_seq_grupo_exame_w	bigint;
qt_hora_adicional_w		bigint;
dt_prescricao_w			timestamp;
cd_estabelecimento_w	smallint;
cd_dia_semana_w			varchar(1);
ie_feriado_w			bigint;
ie_dia_semana_w			varchar(15);
nr_seq_exame_w			bigint;
nr_seq_grupo_w			bigint;
ie_tipo_atendimento_w	smallint;
nr_atendimento_w		bigint;
dt_prev_execucao_w		timestamp;

ie_data_regra_w			varchar(1);
nr_seq_instituicao_w	bigint;
nr_seq_forma_laudo_w	bigint;
ie_exame_lab_dia_w	    regra_dt_resultado_exame.ie_exame_lab_dia%type;
qt_dia_adicional_w	    bigint;
ie_domingo_w           	varchar(1);
ie_segunda_w           	varchar(1);
ie_terca_w             	varchar(1);
ie_quarta_w            	varchar(1);
ie_quinta_w            	varchar(1);
ie_sexta_w             	varchar(1);
ie_sabado_w            	varchar(1);
ie_feriado_regra_w     	varchar(1);
ie_tipo_feriado_w   	integer;
nr_seq_lab_exame_dia_w	bigint;
ie_dia_atual_w		    integer;
lista_dia_semana_w	    varchar(20);
ie_atual_urgente_w      varchar(1);
ie_exame_urgente_w      varchar(1);
dt_resultado_atual_w    prescr_procedimento.dt_resultado%TYPE;

C01 CURSOR FOR
	SELECT	qt_hora_adicional, nr_seq_exame, nr_seq_grupo_exame, ie_dia_semana, coalesce(ie_data_regra,'P'), coalesce(ie_exame_lab_dia, 'N'), coalesce(ie_atual_urgente,'S')
	from	regra_dt_resultado_exame
	where	coalesce(nr_seq_exame,nr_seq_exame_p) = nr_seq_exame_p
	and	coalesce(nr_seq_grupo_exame,nr_seq_grupo_exame_w) = nr_seq_grupo_exame_w
	and	(qt_hora_adicional IS NOT NULL AND qt_hora_adicional::text <> '')
	and	ie_feriado_w = 0
	and (coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w) = ie_tipo_atendimento_w)
	and (coalesce(nr_seq_instituicao,nr_seq_instituicao_w) = nr_seq_instituicao_w)
	and (coalesce(nr_seq_forma_laudo,nr_seq_forma_laudo_w) = nr_seq_forma_laudo_w)
	and	((coalesce(ie_dia_semana,cd_dia_semana_w) = cd_dia_semana_w) or (ie_dia_semana = 9 and cd_dia_semana_w not in ('7','1'))) --tratamento para quando opção for 9 - dias de trabalho
	
union

	SELECT	qt_hora_adicional_feriado, nr_seq_exame, nr_seq_grupo_exame, ie_dia_semana, coalesce(ie_data_regra,'P'), coalesce(ie_exame_lab_dia, 'N'), coalesce(ie_atual_urgente,'S')
	from	regra_dt_resultado_exame
	where	coalesce(nr_seq_exame,nr_seq_exame_p) = nr_seq_exame_p
	and	coalesce(nr_seq_grupo_exame,nr_seq_grupo_exame_w) = nr_seq_grupo_exame_w
	and	(qt_hora_adicional_feriado IS NOT NULL AND qt_hora_adicional_feriado::text <> '')
	and	ie_feriado_w > 0
	and (coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w) = ie_tipo_atendimento_w)
	and (coalesce(nr_seq_instituicao,nr_seq_instituicao_w) = nr_seq_instituicao_w)
	and (coalesce(nr_seq_forma_laudo,nr_seq_forma_laudo_w) = nr_seq_forma_laudo_w)
	and	coalesce(ie_dia_semana,cd_dia_semana_w) = cd_dia_semana_w
	order by nr_seq_exame, nr_seq_grupo_exame, ie_dia_semana;

c02 CURSOR FOR
	SELECT  ie_domingo,
		ie_segunda,
		ie_terca,
		ie_quarta,
		ie_quinta,
		ie_sexta,
		ie_sabado,
		ie_feriado,
		ie_tipo_feriado,
		nr_sequencia
	from 	lab_exame_dia
	where 	coalesce(nr_seq_grupo, nr_seq_grupo_exame_w) = nr_seq_grupo_exame_w
	and 	coalesce(nr_seq_exame, nr_seq_exame_p) = nr_seq_exame_p
	and 	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and 	coalesce(ie_tipo_regra,'X') <> 'C'
	order by	coalesce(nr_seq_exame, 0),
			coalesce(nr_seq_grupo, 0);	


BEGIN

select 	coalesce(max(nr_seq_grupo),0)
into STRICT	nr_seq_grupo_exame_w
from	exame_laboratorio
where	nr_seq_exame = nr_seq_exame_p;

select	max(dt_prescricao),
		max(cd_estabelecimento),
		max(nr_atendimento),
		coalesce(max(nr_seq_forma_laudo),0)
into STRICT	dt_prescricao_w,
		cd_estabelecimento_w,
		nr_atendimento_w,
		nr_seq_forma_laudo_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	max(ie_tipo_atendimento)
into STRICT	ie_tipo_atendimento_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_w;

select	max(dt_prev_execucao),
		max(dt_resultado)
into STRICT	dt_prev_execucao_w,
		dt_resultado_atual_w
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and		nr_seq_exame = nr_seq_exame_p
and		nr_sequencia = nr_seq_prescr_p;

begin
    select	ie_urgencia
    into STRICT	ie_exame_urgente_w
    from	prescr_procedimento
    where	nr_prescricao = nr_prescricao_p
    and		nr_seq_exame = nr_seq_exame_p
    and     nr_sequencia = nr_seq_prescr_p;
exception
    when    no_data_found or too_many_rows then
            ie_exame_urgente_w  := 'N';
end;

select	coalesce(max(a.nr_seq_instituicao),0)
into STRICT	nr_seq_instituicao_w
from	lote_ent_secretaria a,
		lote_ent_sec_ficha b
where	a.nr_sequencia = b.nr_seq_lote_sec
and		b.nr_prescricao = nr_prescricao_p;

cd_dia_semana_w := substr(Obter_Cod_Dia_Semana(clock_timestamp()),1,1);

ie_feriado_w := coalesce(Obter_Se_Feriado(cd_estabelecimento_w, clock_timestamp()),0);

open C01;
loop
fetch C01 into	
	qt_hora_adicional_w,
	nr_seq_exame_w,
	nr_seq_grupo_w,
	ie_dia_semana_w,
	ie_data_regra_w,
	ie_exame_lab_dia_w,
    ie_atual_urgente_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

    if (ie_atual_urgente_w = 'N' AND ie_exame_urgente_w = 'S') then
      dt_resultado_w := dt_resultado_atual_w;
	elsif (coalesce(ie_exame_lab_dia_w, 'N') = 'N') then	
		if (ie_data_regra_w = 'P') then
			dt_resultado_w := dt_prescricao_w + (qt_hora_adicional_w/24);
		elsif (ie_data_regra_w = 'A') then
			dt_resultado_w := clock_timestamp() + (qt_hora_adicional_w/24);
		elsif (ie_data_regra_w = 'D') then
			dt_resultado_w := dt_prev_execucao_w + (qt_hora_adicional_w/24);
		end if;
	else
		open c02;
		loop
		fetch c02 into
			ie_domingo_w,
			ie_segunda_w,
			ie_terca_w,
			ie_quarta_w,
			ie_quinta_w,
			ie_sexta_w,
			ie_sabado_w,
			ie_feriado_regra_w,
			ie_tipo_feriado_w,
			nr_seq_lab_exame_dia_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		end loop;		
		close c02;

		qt_dia_adicional_w := (qt_hora_adicional_w/24);
		if (ie_data_regra_w = 'P') then
			dt_resultado_w := dt_prescricao_w;
		elsif (ie_data_regra_w = 'A') then
			dt_resultado_w := clock_timestamp();
		elsif (ie_data_regra_w = 'D') then
			dt_resultado_w := dt_prev_execucao_w;
		end if;
		-- quanto estiver utilizando a regra da tabela LAB_EXAME_DIA, as horas adicionais devem ser dias completos.
		if ((nr_seq_lab_exame_dia_w IS NOT NULL AND nr_seq_lab_exame_dia_w::text <> '') and qt_dia_adicional_w >= 1) then

			if (ie_domingo_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '1,';
			end if;
			if (ie_segunda_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '2,';
			end if;
			if (ie_terca_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '3,';
			end if;
			if (ie_quarta_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '4,';
			end if;
			if (ie_quinta_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '5,';
			end if;
			if (ie_sexta_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '6,';
			end if;
			if (ie_sabado_w = 'S') then
				lista_dia_semana_w := lista_dia_semana_w || '7,';
			end if;

			lista_dia_semana_w := substr(lista_dia_semana_w, 1, length(lista_dia_semana_w)-1);
			while(qt_dia_adicional_w > 0) loop
				dt_resultado_w := dt_resultado_w + 1;
				select	pkg_date_utils.get_weekday(dt_resultado_w)
				into STRICT	ie_dia_atual_w
				;

				if (obter_se_contido(ie_dia_atual_w, lista_dia_semana_w) = 'S') or (lab_obter_se_feriado(cd_estabelecimento_w, dt_resultado_w, ie_tipo_feriado_w) > 0 and ie_feriado_regra_w = 'S') then					
					qt_dia_adicional_w := qt_dia_adicional_w - 1;
				end if;						
			end loop;
		else
			dt_resultado_w := dt_resultado_w + qt_dia_adicional_w;
		end if;
	end if;	
	exit;
	end;
end loop;
close C01;

return dt_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_result_prescr_lab_at (nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_prescr_p bigint default 0) FROM PUBLIC;
