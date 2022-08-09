-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajuste_desdobra_lote_prescr ( nr_prescricao_p bigint, nr_seq_item_prescr_p bigint, nr_seq_lote_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lote_novo_w	bigint;
ds_maq_user_w		varchar(80);
nr_seq_item_w		bigint;
nr_seq_mat_hor_w	bigint;
ie_arq_pyxis_w		varchar(1);
qt_existe_regra_local_w bigint;
qt_existe_regra_w	bigint;	
cd_setor_atendimento_w	integer;
cd_setor_atendimento_ww	integer;
nr_seq_turno_w		bigint;
nr_seq_novo_turno_w	bigint;
qt_itens_w			bigint;
ie_status_lote_w	ap_lote.ie_status_lote%type;
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
dt_prim_horario_w	timestamp;
hr_inicio_turno_w	varchar(5);
hr_hora_w			varchar(5);
dt_inicio_turno_w	timestamp;
ie_hora_antes_w		varchar(1);
qt_min_antes_atend_w		bigint;
qt_min_receb_setor_w		bigint;
qt_min_entr_setor_w			bigint;
qt_min_disp_farm_w			bigint;
qt_min_atend_farm_w			bigint;
qt_min_inicio_atend_w		bigint;

c01 CURSOR FOR
	SELECT	coalesce(max(nr_sequencia),0)
	from	prescr_mat_hor
	where	(((coalesce(nr_seq_superior::text, '') = '') and (nr_seq_material = nr_seq_item_prescr_p)) or (nr_seq_superior = nr_seq_item_prescr_p))
	and	nr_seq_lote = nr_seq_lote_p
	and	nr_prescricao = nr_prescricao_p
	group by nr_sequencia;

C02 CURSOR FOR
	SELECT	to_char(b.hr_inicial,'hh24:mi')
	from	regra_turno_disp_param b,
			regra_turno_disp a
	where	a.nr_sequencia			= b.nr_seq_turno
	and		a.cd_estabelecimento	= cd_estabelecimento_p
	and		a.nr_sequencia			= nr_seq_novo_turno_w
	and (coalesce(b.cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w)
	order by
			coalesce(b.cd_setor_atendimento,0),
			to_char(b.hr_inicial,'hh24:mi');

C03 CURSOR FOR
	SELECT	a.qt_min_antes_atend,
			a.qt_min_receb_setor,
			a.qt_min_entr_setor,
			a.qt_min_disp_farm,
			a.qt_min_atend_farm,
			a.qt_min_inicio_atend,
			coalesce(a.ie_hora_antes,'H')
	from	regra_tempo_disp a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and		coalesce(a.ie_situacao, 'A')	= 'A'
	and		exists(	SELECT	1
					from	ap_lote b
					where	b.nr_prescricao = nr_prescricao_p
					and		((coalesce(a.nr_seq_turno::text, '') = '') or (b.nr_seq_turno = a.nr_seq_turno))
					and		((coalesce(a.nr_seq_classif::text, '') = '') or (b.nr_seq_classif = a.nr_seq_classif))
					and		((coalesce(a.cd_setor_atendimento::text, '') = '') or (b.cd_setor_atendimento = a.cd_setor_atendimento)))
	order by	
			coalesce(a.nr_seq_classif,0), 
			coalesce(a.nr_seq_turno,0),
			coalesce(a.cd_setor_atendimento,0);


BEGIN
select	substr(obter_inf_sessao(0) ||' - ' || obter_inf_sessao(1),1,80)
into STRICT	ds_maq_user_w	
;

select 	coalesce(max(ie_arq_pyxis),'N')
into STRICT	ie_arq_pyxis_w
from	parametro_atendimento
where	cd_estabelecimento = cd_estabelecimento_p;

select	min(dt_horario),
		to_char(min(dt_horario),'hh24:mi')
into STRICT	dt_prim_horario_w,
		hr_hora_w
from	prescr_mat_hor
where	(((coalesce(nr_seq_superior::text, '') = '') and (nr_seq_material = nr_seq_item_prescr_p)) or (nr_seq_superior = nr_seq_item_prescr_p))
and		nr_seq_lote = nr_seq_lote_p
and		nr_prescricao = nr_prescricao_p;

select	max(cd_setor_atendimento)
into STRICT	cd_setor_atendimento_w
from 	ap_lote
where 	nr_sequencia = nr_seq_lote_p;

nr_seq_novo_turno_w :=	Obter_turno_horario_prescr(cd_estabelecimento_p,cd_setor_atendimento_w,
						to_char(dt_prim_horario_w,'hh24:mi'),cd_local_estoque_p);

open c02;
loop
	fetch c02 into
		hr_inicio_turno_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	hr_inicio_turno_w := hr_inicio_turno_w;
	end;
end loop;
close c02;

if (hr_hora_w < hr_inicio_turno_w) then
	dt_inicio_turno_w	:= PKG_DATE_UTILS.get_Time(dt_prim_horario_w - 1, replace(hr_inicio_turno_w,'24:','00:'));
else
	dt_inicio_turno_w	:= PKG_DATE_UTILS.get_Time(dt_prim_horario_w, replace(hr_inicio_turno_w,'24:','00:'));
end if;

select 	nextval('ap_lote_seq')
into STRICT	nr_seq_lote_novo_w
;

if (nr_seq_lote_novo_w > 0) then
	begin
	insert into ap_lote(
		nr_sequencia,
		ie_status_lote,
		cd_setor_atendimento,
		dt_geracao_lote,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prescricao,
		nr_seq_turno,
		dt_inicio_dispensacao,
		nm_usuario_ini_disp,
		ds_maquina_ini_disp,
		dt_atend_farmacia,
		nm_usuario_atend,
		ds_maquina_atend,
		dt_disp_farmacia,
		nm_usuario_disp,
		dt_entrega_setor,
		nm_usuario_entrega,
		ds_maquina_disp,
		dt_recebimento_setor,
		nm_usuario_receb,
		ds_maquina_receb,
		ds_maquina_entrega,
		dt_cancelamento,
		nm_usuario_cancelamento,
		ds_maquina_cancelamento,
		dt_atend_lote,
		dt_inicio_turno,
		nr_seq_classif,
		nm_usuario_geracao,
		ds_maquina_geracao,
		dt_limite_inicio_atend,
		dt_limite_atend,
		dt_limite_disp_farm,
		dt_limite_entrega_setor,
		dt_limite_receb_setor,
		qt_min_atraso_inicio_atend,
		qt_min_atraso_atend,
		qt_min_atraso_disp,
		qt_min_atraso_entrega,
		qt_min_atraso_receb,
		ie_conta_paciente,
		ie_atualiza_estoque,
		cd_tipo_baixa,
		dt_prim_horario,
		dt_impressao,
		cd_local_estoque,
		nr_seq_lote_sup,
		nr_atendimento)
	SELECT 	nr_seq_lote_novo_w,
		ie_status_lote,
		cd_setor_atendimento,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_prescricao,
		coalesce(nr_seq_novo_turno_w,nr_seq_turno),
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		dt_atend_lote,
		coalesce(dt_inicio_turno_w,dt_inicio_turno),
		nr_seq_classif,
		nm_usuario_p,
		ds_maq_user_w,
		dt_limite_inicio_atend,
		dt_limite_atend,
		dt_limite_disp_farm,
		dt_limite_entrega_setor,
		dt_limite_receb_setor,
		qt_min_atraso_inicio_atend,
		qt_min_atraso_atend,
		qt_min_atraso_disp,
		qt_min_atraso_entrega,
		qt_min_atraso_receb,
		ie_conta_paciente,
		ie_atualiza_estoque,
		cd_tipo_baixa,
		coalesce(dt_prim_horario_w,dt_prim_horario),
		null,
		cd_local_estoque_p,
		nr_seq_lote_p,
		nr_atendimento
	from 	ap_lote
	where 	nr_sequencia = nr_seq_lote_p;
		
	open c01;
	loop
	fetch c01 into
		nr_seq_mat_hor_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into ap_lote_item(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_lote,
			nr_seq_mat_hor,
			ie_prescrito,
			cd_material,
			cd_unidade_medida,
			qt_dispensar,
			qt_total_dispensar,
			ie_urgente,
			dt_supensao,		
			nm_usuario_susp,
			ds_maquina_susp)
		SELECT 	nextval('ap_lote_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_novo_w,
			nr_seq_mat_hor_w,
			ie_prescrito,
			cd_material,
			cd_unidade_medida,
			qt_dispensar,
			qt_total_dispensar,
			ie_urgente,
			null,		
			null,
			null
		from 	ap_lote_item
		where 	nr_seq_mat_hor = nr_seq_mat_hor_w;
		
		update	prescr_mat_hor
		set	nr_seq_lote = nr_seq_lote_novo_w
		where	nr_sequencia = nr_seq_mat_hor_w;
		
		delete	FROM ap_lote_item
		where	nr_seq_lote = nr_seq_lote_p
		and	nr_seq_mat_hor = nr_seq_mat_hor_w;
		
		end;
	end loop;
	close c01;
	
	select 	count(*)
	into STRICT	qt_itens_w
	from	ap_lote_item
	where 	nr_seq_lote = nr_seq_lote_novo_w;
	
	if (qt_itens_w = 0) then
		update	ap_lote
		set 	ie_status_lote = 'C',
				nm_usuario = nm_usuario_p
		where 	nr_sequencia = nr_seq_lote_novo_w;
		goto final;
	end if;
	
	select	count(1)
	into STRICT	qt_existe_regra_w
	from	dis_regra_setor;

	if (qt_existe_regra_w > 0) then
		
		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;
		
		select	count(1)
		into STRICT	qt_existe_regra_w
		from	local_estoque c,
			dis_regra_setor b,
			dis_regra_local_setor a
		where	a.nr_seq_dis_regra_setor = b.nr_sequencia
		and	c.cd_local_estoque = a.cd_local_estoque
		and	b.cd_setor_atendimento = obter_setor_atendimento(nr_atendimento_w)
		and	c.ie_tipo_local = '11';

		if (qt_existe_regra_w > 0) then
		
			select	max(ie_status_lote)
			into STRICT	ie_status_lote_w
			from	ap_lote
			where	nr_sequencia = nr_seq_lote_novo_w;
			
			CALL intdisp_movto_mat_hor(nr_seq_lote_novo_w, ie_status_lote_w, cd_local_estoque_p, '1');
		else	
			select	count(1)
			into STRICT	qt_existe_regra_w
			from	ap_lote
			where	nr_seq_lote_sup = nr_seq_lote_p
			and	cd_local_estoque <> cd_local_estoque_p
			and	ie_status_lote = 'G';
			
			if (qt_existe_regra_w > 0) then
			
				select	max(ie_status_lote)
				into STRICT	ie_status_lote_w
				from	ap_lote
				where	nr_sequencia = nr_seq_lote_novo_w;
				
				CALL intdisp_movto_mat_hor(nr_seq_lote_novo_w, ie_status_lote_w, cd_local_estoque_p, '2');
			end if;
		end if;
	end if;
	
	if (ie_arq_pyxis_w = 'S') then
		
		select 	count(*)
		into STRICT	qt_existe_regra_w
		from	dis_regra_local
		where	cd_estabelecimento = cd_estabelecimento_p;		
		
		if (coalesce(qt_existe_regra_w,0) > 0) then
		
			
			
			select	count(*)
			into STRICT	qt_existe_regra_local_w
			from	regra_local_dispensacao
			where 	cd_local_estoque = cd_local_estoque_p
			and 	(nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '')
			and 	(nr_seq_regra_disp IS NOT NULL AND nr_seq_regra_disp::text <> '')
			and 	cd_setor_atendimento = cd_setor_atendimento_w;

			if (coalesce(qt_existe_regra_local_w,0) > 0) then
				CALL dis_gerar_arq_lote(nr_seq_lote_novo_w, '1', nm_usuario_p, cd_estabelecimento_p);
				
				begin
				select	coalesce(max(obter_turno_horario_prescr(cd_estabelecimento_p,cd_setor_atendimento_w,ds_horario,cd_local_estoque_p)),0)
				into STRICT	nr_seq_turno_w
				from	prescr_mat_hor
				where	nr_seq_lote = nr_seq_lote_novo_w
				and	nr_prescricao = nr_prescricao_p;
				exception
					when others then
					nr_seq_turno_w := 0;
				end;
				
				if (nr_seq_turno_w > 0) then
					update	ap_lote
					set	nr_seq_turno = nr_seq_turno_w
					where	nr_sequencia = nr_seq_lote_novo_w;
					
					update	prescr_mat_hor
					set	nr_seq_turno = nr_seq_turno_w
					where	nr_seq_lote = nr_seq_lote_novo_w
					and	nr_prescricao = nr_prescricao_p;
		
				end if;
			end if;
		end if;	
	end if;
	
	open C03;
	loop
	fetch C03 into	
		qt_min_antes_atend_w,
		qt_min_receb_setor_w,
		qt_min_entr_setor_w,
		qt_min_disp_farm_w,
		qt_min_atend_farm_w,
		qt_min_inicio_atend_w,
		ie_hora_antes_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (ie_hora_antes_w = 'H') then
			begin
			update	ap_lote
			set		dt_atend_lote		= round(dt_prim_horario - dividir(qt_min_antes_atend_w,1440),'mi'),
					dt_limite_inicio_atend	= round(dt_prim_horario - dividir(qt_min_inicio_atend_w,1440),'mi'),
					dt_limite_atend		= round(dt_prim_horario - dividir(qt_min_atend_farm_w,1440),'mi'),
					dt_limite_disp_farm	= round(dt_prim_horario - dividir(qt_min_disp_farm_w,1440),'mi'),
					dt_limite_entrega_setor	= round(dt_prim_horario - dividir(qt_min_entr_setor_w,1440),'mi'),
					dt_limite_receb_setor	= round(dt_prim_horario - dividir(qt_min_receb_setor_w,1440),'mi')
			where	nr_sequencia 		= nr_seq_lote_novo_w;
			end;
		elsif (ie_hora_antes_w = 'I') then
			begin
			update	ap_lote
			set		dt_atend_lote		= round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi'),
					dt_limite_inicio_atend	= round(dt_prim_horario - dividir(qt_min_inicio_atend_w,1440),'mi'),
					dt_limite_atend		= round(dt_prim_horario - dividir(qt_min_atend_farm_w,1440),'mi'),
					dt_limite_disp_farm	= round(dt_prim_horario - dividir(qt_min_disp_farm_w,1440),'mi'),
					dt_limite_entrega_setor	= round(dt_prim_horario - dividir(qt_min_entr_setor_w,1440),'mi'),
					dt_limite_receb_setor	= round(dt_prim_horario - dividir(qt_min_receb_setor_w,1440),'mi')
			where	nr_sequencia 		= nr_seq_lote_novo_w;
			end;
		elsif (ie_hora_antes_w = 'T') then
			begin
			update	ap_lote
			set		dt_atend_lote		= CASE WHEN to_char(round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi'), 'hh24:mi:ss')='00:00:00' THEN  --OS186690
					round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi') + 1/86400  ELSE round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi') END ,
					dt_limite_inicio_atend	= CASE WHEN to_char(round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi'), 'hh24:mi:ss')='00:00:00' THEN					round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi') + 1/86400  ELSE round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi') END , 
					dt_limite_atend		= round(dt_inicio_turno - dividir(qt_min_atend_farm_w,1440),'mi'),
					dt_limite_disp_farm	= round(dt_inicio_turno - dividir(qt_min_disp_farm_w,1440),'mi'),
					dt_limite_entrega_setor	= round(dt_inicio_turno - dividir(qt_min_entr_setor_w,1440),'mi'),
					dt_limite_receb_setor	= round(dt_inicio_turno - dividir(qt_min_receb_setor_w,1440),'mi')
			where	nr_sequencia 		= nr_seq_lote_novo_w;
			end;
		end if;
		end;
	end loop;
	close C03;
		
	<<final>>
	
	insert into ap_lote_historico(
		nr_sequencia,			dt_atualizacao,
		nm_usuario,			nr_seq_lote,
		ds_evento,			ds_log)
	values (	nextval('ap_lote_historico_seq'),	clock_timestamp(),
		nm_usuario_p,			nr_seq_lote_p,
		wheb_mensagem_pck.get_texto(315072),wheb_mensagem_pck.get_texto(315073));
	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajuste_desdobra_lote_prescr ( nr_prescricao_p bigint, nr_seq_item_prescr_p bigint, nr_seq_lote_p bigint, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
