-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_marcar_recorrencia (nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, dt_agenda_p timestamp, cd_agenda_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_min_prevista_w	timestamp;			
ds_aux_w		varchar(255);	
nr_seq_item_w		bigint;
dt_prevista_item_w	timestamp;
nr_minuto_duracao_w	bigint;
nr_min_dur_hor_w	bigint;
hr_marcacao_w		timestamp;	
nr_seq_ageint_lib_w	bigint;
cd_medico_w		varchar(10);
ie_Reservado_w		varchar(1);
ie_principal_w		varchar(1);
cd_agenda_w		bigint;
nr_seq_horario_w	bigint;
ie_Acao_w			varchar(1);
nr_seq_item_princ_w	bigint;
nr_seq_Agenda_w		ageint_marcacao_usuario.nr_seq_agenda%type;
ie_acao_ww 	varchar(1);
prof_hor_princ_w	pessoa_fisica.cd_pessoa_fisica%type;
				
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		coalesce(a.dt_prev_transf_item, a.dt_prevista_item),
		a.nr_minuto_duracao
	from	agenda_integrada_item a
	where	a.nr_seq_item_princ = nr_seq_item_princ_w
	and		((not exists (SELECT 1 from ageint_marcacao_usuario x where x.nr_seq_ageint_item = a.nr_sequencia) and (ie_acao_ww = 'I'))
	or (exists (select 1 from ageint_marcacao_usuario x where x.nr_seq_ageint_item = a.nr_sequencia) and (ie_acao_ww = 'D'))
	or (ie_acao_ww	= 'T' and (dt_prev_transf_item IS NOT NULL AND dt_prev_transf_item::text <> '') and nr_sequencia <> nr_seq_ageint_item_p))
	and 	((ie_acao_p = 'SI' AND a.nr_sequencia = nr_seq_ageint_item_p) or (ie_acao_p <> 'SI'))
	order by 1;				
				    

BEGIN
--SI- desmarcar somente o item
if (ie_acao_p = 'SI') then
	ie_acao_ww := 'D';
else
	ie_acao_ww := ie_acao_p;
end if;



select	trunc(min(coalesce(dt_prev_transf_item, dt_prevista_item)))	
into STRICT	dt_min_prevista_w
from	agenda_integrada_item
where	nr_sequencia = nr_seq_ageint_item_p;

select	coalesce(max(nr_seq_item_princ),nr_seq_ageint_item_p)
into STRICT	nr_seq_item_princ_w
from	agenda_integrada_item
where	nr_sequencia = nr_seq_ageint_item_p;

select 	coalesce(max(cd_pessoa_fisica), '0')
into STRICT	prof_hor_princ_w
from	ageint_marcacao_usuario
where	nr_seq_ageint_item = nr_seq_ageint_item_p;

if (dt_min_prevista_w = trunc(dt_agenda_p)) then
	open C01;
	loop
	fetch C01 into	
		 nr_seq_item_w,
		 dt_prevista_item_w,
		 nr_minuto_duracao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin				
		hr_marcacao_w := to_date(to_char(dt_prevista_item_w,'dd/mm/yyyy') ||' '||to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
		if (ie_acao_ww	= 'D') then
			select max(x.nr_Seq_agenda)
			into STRICT nr_seq_Agenda_w
			from ageint_marcacao_usuario x
			where x.nr_seq_ageint_item = nr_seq_item_w
			and	coalesce(ie_Gerado,'N') = 'N';
		end if;
	
		if (trunc(hr_marcacao_w) <> trunc(clock_timestamp())) then
			SELECT * FROM gerar_horarios_ageint_recor(hr_marcacao_w, nm_usuario_p, nr_seq_ageint_p, cd_estabelecimento_p, cd_Agenda_p, ds_aux_w, ds_aux_w, ds_aux_w, ds_aux_w, nr_seq_Agenda_w) INTO STRICT ds_aux_w, ds_aux_w, ds_aux_w, ds_aux_w;
		end if;
		
		select	min(a.nr_sequencia)
		into STRICT	nr_seq_horario_w
		from	ageint_horarios_usuario a
		where	((a.ie_Status_agenda	= 'L' and ie_acao_ww = 'I') or (ie_acao_ww = 'D' and a.ie_status_agenda <> 'L') or (ie_acao_ww	= 'T'))
		and		a.cd_agenda		= cd_agenda_p
		and		a.nm_usuario		= nm_usuario_p
		and		a.hr_agenda		= hr_marcacao_w
		and	exists (SELECT 	1
				from 	ageint_lib_usuario b
				where 	a.nr_seq_ageint_lib 	= b.nr_sequencia
				and 	b.nr_seq_ageint_item 	= nr_seq_item_w
				and	((coalesce(b.cd_pessoa_fisica,prof_hor_princ_w) = prof_hor_princ_w) or (prof_hor_princ_w = '0')));
				
		/* Buscando informacoes da sequencia em que sera marcado o item */

		if (nr_seq_horario_w > 0) then
			select	max(a.cd_agenda),
					max(a.nr_seq_ageint_lib),
					max(a.nr_minuto_duracao),
					max(b.cd_pessoa_fisica)
			into STRICT	cd_agenda_w,
					nr_seq_ageint_lib_w,
					nr_minuto_duracao_w,
					cd_medico_w
			from	ageint_horarios_usuario a,
					ageint_lib_usuario b
			where	a.nr_sequencia 		= nr_seq_horario_w
			and	a.nr_seq_ageint_lib	= b.nr_Sequencia;
		end if;
		
		if (nr_seq_ageint_lib_w IS NOT NULL AND nr_seq_ageint_lib_w::text <> '') then			
			if (ie_acao_ww	= 'T') then
				ie_acao_w	:= 'I';
			else
				ie_Acao_w	:= ie_acao_ww;
			end if;
			SELECT * FROM Atualiza_Dados_Marcacao(cd_agenda_w, hr_marcacao_w, nr_seq_ageint_p, ie_Acao_w, coalesce(nr_minuto_duracao_w,nr_min_dur_hor_w), nm_usuario_p, nr_seq_item_w, nr_seq_ageint_lib_w, 'N', cd_medico_w, ie_Reservado_w, null, ie_principal_w) INTO STRICT ie_Reservado_w, ie_principal_w;
		end if;
		nr_seq_ageint_lib_w	:= null;
		end;
	end loop;
	close C01;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_marcar_recorrencia (nr_seq_ageint_p bigint, nr_seq_ageint_item_p bigint, dt_agenda_p timestamp, cd_agenda_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

