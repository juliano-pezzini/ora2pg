-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_painel_atend_lote_oper ( cd_estabelecimento_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_seq_turno_p bigint, nr_seq_classificacao_p text, cd_local_estoque_p text, qt_hora_passada_p bigint, qt_hora_futura_p bigint, ds_filtros_p text, ie_mostra_turnos_p text, ds_filtro_classif_html_p text default null, ds_filtro_local_html_p text default null, ds_filtro_setor_html_p text default null) AS $body$
DECLARE

								 
dt_hora_inicio_w			timestamp;
dt_hora_fim_w			timestamp;

qt_liberado_w			bigint	:= 0;
qt_pendente_w			bigint	:= 0;
qt_atendido_w			bigint	:= 0;
qt_dispesado_w			bigint	:= 0;
qt_entregue_setor_w		bigint	:= 0;
qt_recebido_setor_w		bigint	:= 0;
qt_atraso_inicio_atend_w		bigint	:= 0;
qt_atraso_atend_w			bigint	:= 0;
qt_atraso_disp_w			bigint	:= 0;
qt_atraso_entrega_setor_w		bigint	:= 0;
qt_atraso_receb_setor_w		bigint	:= 0;
qt_futuro_w			bigint	:= 0;
qt_min_atraso_inicio_atend_w		bigint;
qt_min_atraso_atend_w		bigint;
qt_min_atraso_disp_w		bigint;
qt_min_atraso_entrega_w		bigint;
qt_min_atraso_receb_w		bigint;

nr_seq_classif_w			bigint;
nr_seq_classif_w2			bigint := 0;
cd_setor_atendimento_w		bigint;
cd_setor_atendimento_w2		bigint := 0;
ds_setor_atendimento_w		varchar(100);
ds_turno_w			varchar(100);
ds_classif_w			varchar(100);

dt_atend_lote_w			timestamp;
dt_recebimento_setor_w		timestamp;
dt_entrega_setor_w			timestamp;
dt_disp_farmacia_w			timestamp;
dt_atend_farmacia_w		timestamp;
dt_inicio_dispensacao_w		timestamp;
dt_atualizacao_w			timestamp;
dt_limite_inicio_atend_w		timestamp;
dt_limite_atend_w			timestamp;
dt_limite_disp_farm_w		timestamp;
dt_limite_entrega_setor_w		timestamp;
dt_limite_receb_setor_w		timestamp;

nr_seq_apres_w			bigint;

posfim_w				bigint;
ds_filtros_w			varchar(4000);
ds_filtros_ww			varchar(4000);
ds_filtro_classif_w			varchar(4000);
ds_filtro_local_w			varchar(4000);
ds_filtro_setor_w			varchar(4000);
VarMostraColReceb_w		varchar(1);
ds_setores_w 			varchar(255);

C00 CURSOR FOR 
SELECT	dt_atend_lote, 
	dt_recebimento_setor, 
	dt_entrega_setor, 
	dt_disp_farmacia, 
	dt_atend_farmacia, 
	dt_inicio_dispensacao, 
	qt_min_atraso_inicio_atend, 
	qt_min_atraso_atend, 
	qt_min_atraso_disp, 
	qt_min_atraso_entrega, 
	qt_min_atraso_receb, 
	nr_seq_classif, 
	cd_setor_atendimento, 
	substr(obter_nome_setor(cd_setor_atendimento),1,100) ds_setor, 
	dt_limite_inicio_atend, 
	dt_limite_atend, 
	dt_limite_disp_farm, 
	dt_limite_entrega_setor, 
	dt_limite_receb_setor 
from	ap_lote 
where	dt_atend_lote between dt_hora_inicio_w and dt_hora_fim_w 
and	coalesce(cd_setor_atendimento_p,cd_setor_atendimento)	= cd_setor_atendimento 
and	((coalesce(ds_setores_w::text, '') = '') or (obter_se_contido_char(cd_setor_atendimento, ds_setores_w) = 'S')) 
and	coalesce(nr_seq_turno_p,nr_seq_turno)			= nr_seq_turno 
and	coalesce(cd_local_estoque_p, cd_local_estoque) 		= cd_local_estoque 
--and	nvl(nr_seq_classificacao_p,nr_seq_classif)		= nr_seq_classif 
and (obter_se_contido(nr_seq_classif, coalesce(nr_seq_classificacao_p, nr_seq_classif))	= 'S') 
and (obter_se_contido(nr_seq_classif, coalesce(ds_filtro_classif_w, nr_seq_classif))	= 'S') 
and (obter_se_contido(cd_local_estoque, coalesce(ds_filtro_local_w, cd_local_estoque))	= 'S') 
and (obter_se_contido(cd_setor_atendimento, coalesce(ds_filtro_setor_w, cd_setor_atendimento))	= 'S') 
and (obter_se_atendimento_alta(obter_atendimento_prescr(nr_prescricao)) = 'N') 
and 	ie_status_lote <> 'S' 
and	ie_status_lote <> 'C' 
order by 
	cd_setor_atendimento, 
	nr_seq_classif;

C01 CURSOR FOR 
SELECT	dt_atend_lote, 
	dt_recebimento_setor, 
	dt_entrega_setor, 
	dt_disp_farmacia, 
	dt_atend_farmacia, 
	dt_inicio_dispensacao, 
	qt_min_atraso_inicio_atend, 
	qt_min_atraso_atend, 
	qt_min_atraso_disp, 
	qt_min_atraso_entrega, 
	qt_min_atraso_receb, 
	substr(Obter_Desc_Classif_Lote(nr_seq_classif),1,100) ds_classif, 
	dt_limite_inicio_atend, 
	dt_limite_atend, 
	dt_limite_disp_farm, 
	dt_limite_entrega_setor, 
	dt_limite_receb_setor 
from	ap_lote 
where	dt_atend_lote between dt_hora_inicio_w and dt_hora_fim_w 
and	coalesce(nr_seq_turno_p,nr_seq_turno)		= nr_seq_turno 
and	coalesce(cd_local_estoque_p, cd_local_estoque) 	= cd_local_estoque 
and	cd_setor_atendimento				= cd_setor_atendimento_w 
and	((coalesce(ds_setores_w::text, '') = '') or (obter_se_contido_char(cd_setor_atendimento, ds_setores_w) = 'S')) 
and	nr_seq_classif					= nr_seq_classif_w 
and (obter_se_contido(nr_seq_classif, coalesce(nr_seq_classificacao_p, nr_seq_classif))	= 'S') 
and (obter_se_contido(nr_seq_classif, coalesce(ds_filtro_classif_w, nr_seq_classif))	= 'S') 
and (obter_se_contido(cd_local_estoque, coalesce(ds_filtro_local_w, cd_local_estoque))	= 'S') 
and (obter_se_contido(cd_setor_atendimento, coalesce(ds_filtro_setor_w, cd_setor_atendimento))	= 'S') 
and (obter_se_atendimento_alta(obter_atendimento_prescr(nr_prescricao)) = 'N') 
and 	ie_status_lote <> 'S' 
and	ie_status_lote <> 'C' 
order by ds_classif;

 

BEGIN 
VarMostraColReceb_w := obter_param_usuario(7030, 23, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, VarMostraColReceb_w);
ds_setores_w := obter_param_usuario(7030, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ds_setores_w);
 
ds_filtros_w	:= ds_filtros_p;
	 
if (coalesce(ds_filtros_w,'X') <> 'X') then 
	begin 
	ds_filtro_classif_w	:= '';
	ds_filtro_local_w	:= '';
	ds_filtro_setor_w	:= '';
 
	while(position('and' in ds_filtros_w) > 0) loop 
		begin 
		ds_filtros_w	:= substr(ds_filtros_w, position('and' in ds_filtros_w) + 3, length(ds_filtros_w));
		posfim_w		:= length(ds_filtros_w);
		if (position('and' in ds_filtros_w) > 0) then 
			posfim_w	:= position('and' in ds_filtros_w) - 1;
		end if;
		 
		ds_filtros_ww	:= substr(ds_filtros_w, 1, posfim_w);
		ds_filtros_w	:= substr(ds_filtros_w, posfim_w, length(ds_filtros_w));
 
 
		if (position('nr_seq_classif in' in ds_filtros_ww) > 0) then 
			ds_filtro_classif_w	:= replace(ds_filtros_ww, 'nr_seq_classif in', '');
			ds_filtro_classif_w	:= replace(ds_filtro_classif_w, ' ', '');
		end if;
 
		if (position('cd_local_estoque in' in ds_filtros_ww) > 0) then 
			ds_filtro_local_w	:= replace(ds_filtros_ww, 'cd_local_estoque in', '');
			ds_filtro_local_w	:= replace(ds_filtro_local_w, ' ', '');
		end if;
 
		if (position('cd_setor_atendimento in' in ds_filtros_ww) > 0) then 
			ds_filtro_setor_w	:= replace(ds_filtros_ww, 'cd_setor_atendimento in', '');
			ds_filtro_setor_w	:= replace(ds_filtro_setor_w, ' ', '');
		end if;
		 
		end;
	end loop;
	end;
else 
	begin 
	ds_filtro_classif_w	:= ds_filtro_classif_html_p;
	ds_filtro_local_w	:= ds_filtro_local_html_p;
	ds_filtro_setor_w	:= ds_filtro_setor_html_p;
	end;
end if;
 
 
delete	FROM w_atend_lote_oper 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	nm_usuario		= nm_usuario_p;
 
commit;
 
dt_hora_inicio_w	:= clock_timestamp() - (qt_hora_passada_p /24);
dt_hora_fim_w		:= clock_timestamp() + (qt_hora_futura_p / 24);
nr_seq_apres_w		:= 0;
 
open C00;
loop 
fetch C00 into	 
	dt_atend_lote_w, 
	dt_recebimento_setor_w, 
	dt_entrega_setor_w, 
	dt_disp_farmacia_w, 
	dt_atend_farmacia_w, 
	dt_inicio_dispensacao_w, 
	qt_min_atraso_inicio_atend_w, 
	qt_min_atraso_atend_w, 
	qt_min_atraso_disp_w, 
	qt_min_atraso_entrega_w, 
	qt_min_atraso_receb_w, 
	nr_seq_classif_W, 
	cd_setor_atendimento_w, 
	ds_setor_atendimento_w, 
	dt_limite_inicio_atend_w, 
	dt_limite_atend_w, 
	dt_limite_disp_farm_w, 
	dt_limite_entrega_setor_w, 
	dt_limite_receb_setor_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin 
	qt_liberado_w			:= 1;
	qt_pendente_w			:= 0;
	qt_atendido_w			:= 0;
	qt_dispesado_w			:= 0;
	qt_entregue_setor_w		:= 0;
	qt_recebido_setor_w		:= 0;
	qt_atraso_inicio_atend_w	:= 0;
	qt_atraso_atend_w		:= 0;
	qt_atraso_disp_w		:= 0;
	qt_atraso_entrega_setor_w	:= 0;
	qt_atraso_receb_setor_w		:= 0;
	qt_futuro_w			:= 0;
	 
	if (dt_atend_lote_w > clock_timestamp()) then 
		qt_futuro_w		:= 1;
	elsif (coalesce(dt_atend_farmacia_w::text, '') = '') then 
		qt_atendido_w		:= 1;
	elsif (coalesce(dt_disp_farmacia_w::text, '') = '') then 
		qt_dispesado_w		:= 1;
	elsif (coalesce(dt_entrega_setor_w::text, '') = '') then 
		qt_entregue_setor_w	:= 1;
	elsif (coalesce(dt_recebimento_setor_w::text, '') = '') then 
		qt_recebido_setor_w	:= 1;
	end if;
	if	((coalesce(dt_recebimento_setor_w::text, '') = '') and (VarMostraColReceb_w = 'S') and (dt_atend_lote_w < clock_timestamp())) then 
		qt_pendente_w		:= 1;
	end if;
	if	((coalesce(dt_recebimento_setor_w::text, '') = '') and (coalesce(dt_entrega_setor_w::text, '') = '') and (VarMostraColReceb_w = 'N') and (dt_atend_lote_w < clock_timestamp())) then 
		qt_pendente_w		:= 1;
	end if;
	if (dt_limite_atend_w < clock_timestamp()) and (coalesce(dt_atend_farmacia_w::text, '') = '') then 
		qt_atraso_atend_w		:= 1;
	elsif (dt_limite_disp_farm_w < clock_timestamp()) and (coalesce(dt_disp_farmacia_w::text, '') = '') then 
		qt_atraso_disp_w		:= 1;
	elsif (dt_limite_entrega_setor_w < clock_timestamp()) and (coalesce(dt_entrega_setor_w::text, '') = '') then 
		qt_atraso_entrega_setor_w	:= 1;
	elsif (dt_limite_receb_setor_w < clock_timestamp()) and (coalesce(dt_recebimento_setor_w::text, '') = '') then 
		qt_atraso_receb_setor_w		:= 1;
	end if;
 
	if (cd_setor_atendimento_w <> cd_setor_atendimento_w2) then 
	 
		select	coalesce(max(nr_seq_apres),0) + 1 
		into STRICT	nr_seq_apres_w 
		from	w_atend_lote_oper;
	end if;	
	 
	insert into w_atend_lote_oper( 
		cd_estabelecimento,   
		dt_atualizacao, 
		nm_usuario, 
		ds_informacao, 
		qt_liberado, 
		qt_pendente, 
		qt_atendido, 
		qt_dispesado, 
		qt_entregue_setor, 
		qt_recebido_setor, 
		qt_atraso_inicio_atend, 
		qt_atraso_atend, 
		qt_atraso_disp, 
		qt_atraso_entrega_setor, 
		qt_atraso_receb_setor, 
		qt_futuro, 
		ie_temp, 
		ie_tipo, 
		nr_seq_apres) 
	values (	cd_estabelecimento_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_setor_atendimento_w, 
		qt_liberado_w, 
		qt_pendente_w, 
		qt_atendido_w, 
		qt_dispesado_w, 
		qt_entregue_setor_w, 
		qt_recebido_setor_w, 
		qt_atraso_inicio_atend_w, 
		qt_atraso_atend_w, 
		qt_atraso_disp_w, 
		qt_atraso_entrega_setor_w, 
		qt_atraso_receb_setor_w, 
		qt_futuro_w, 
		'S', 
		0, 
		nr_seq_apres_w);
 
	if (cd_setor_atendimento_w <> cd_setor_atendimento_w2) or (nr_seq_classif_w <> nr_seq_classif_w2) then 
		 
		open C01;
		loop 
		fetch C01 into	 
			dt_atend_lote_w, 
			dt_recebimento_setor_w, 
			dt_entrega_setor_w, 
			dt_disp_farmacia_w, 
			dt_atend_farmacia_w, 
			dt_inicio_dispensacao_w, 
			qt_min_atraso_inicio_atend_w, 
			qt_min_atraso_atend_w, 
			qt_min_atraso_disp_w, 
			qt_min_atraso_entrega_w, 
			qt_min_atraso_receb_w, 
			ds_classif_w, 
			dt_limite_inicio_atend_w, 
			dt_limite_atend_w, 
			dt_limite_disp_farm_w, 
			dt_limite_entrega_setor_w, 
			dt_limite_receb_setor_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
		 
			qt_liberado_w			:= 1;
			qt_pendente_w			:= 0;
			qt_atendido_w			:= 0;
			qt_dispesado_w			:= 0;
			qt_entregue_setor_w		:= 0;
			qt_recebido_setor_w		:= 0;
			qt_atraso_inicio_atend_w	:= 0;
			qt_atraso_atend_w		:= 0;
			qt_atraso_disp_w		:= 0;
			qt_atraso_entrega_setor_w	:= 0;
			qt_atraso_receb_setor_w		:= 0;
			qt_futuro_w			:= 0;
	 
			if (dt_atend_lote_w > clock_timestamp()) then 
				qt_futuro_w		:= 1;
			elsif (coalesce(dt_atend_farmacia_w::text, '') = '') then 
				qt_atendido_w	:= 1;
			elsif (coalesce(dt_disp_farmacia_w::text, '') = '') then 
				qt_dispesado_w	:= 1;
			elsif (coalesce(dt_entrega_setor_w::text, '') = '') then 
				qt_entregue_setor_w	:= 1;
			elsif (coalesce(dt_recebimento_setor_w::text, '') = '') then 
				qt_recebido_setor_w	:= 1;
			end if;
			if	((coalesce(dt_recebimento_setor_w::text, '') = '') and (VarMostraColReceb_w = 'S') and (dt_atend_lote_w < clock_timestamp())) then 
				qt_pendente_w		:= 1;
			end if;
			if	((coalesce(dt_recebimento_setor_w::text, '') = '') and (coalesce(dt_entrega_setor_w::text, '') = '') and (VarMostraColReceb_w = 'N') and (dt_atend_lote_w < clock_timestamp())) then 
				qt_pendente_w		:= 1;
			end if;
			if (dt_limite_atend_w < clock_timestamp()) and (coalesce(dt_atend_farmacia_w::text, '') = '') then 
				qt_atraso_atend_w		:= 1;
			elsif (dt_limite_disp_farm_w < clock_timestamp()) and (coalesce(dt_disp_farmacia_w::text, '') = '') then 
				qt_atraso_disp_w		:= 1;
			elsif (dt_limite_entrega_setor_w < clock_timestamp()) and (coalesce(dt_entrega_setor_w::text, '') = '') then 
				qt_atraso_entrega_setor_w	:= 1;
			elsif (dt_limite_receb_setor_w < clock_timestamp()) and (coalesce(dt_recebimento_setor_w::text, '') = '') then 
				qt_atraso_receb_setor_w	:= 1;
			end if;
 
			insert into w_atend_lote_oper( 
				cd_estabelecimento,   
				dt_atualizacao, 
				nm_usuario, 
				ds_informacao, 
				qt_liberado, 
				qt_pendente, 
				qt_atendido, 
				qt_dispesado, 
				qt_entregue_setor, 
				qt_recebido_setor, 
				qt_atraso_inicio_atend, 
				qt_atraso_atend, 
				qt_atraso_disp, 
				qt_atraso_entrega_setor, 
				qt_atraso_receb_setor, 
				qt_futuro, 
				ie_temp, 
				ie_tipo, 
				nr_seq_apres) 
			values (	cd_estabelecimento_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				'  '|| ds_classif_w, 
				qt_liberado_w, 
				qt_pendente_w, 
				qt_atendido_w, 
				qt_dispesado_w, 
				qt_entregue_setor_w, 
				qt_recebido_setor_w, 
				qt_atraso_inicio_atend_w, 
				qt_atraso_atend_w, 
				qt_atraso_disp_w, 
				qt_atraso_entrega_setor_w, 
				qt_atraso_receb_setor_w, 
				qt_futuro_w, 
				'S', 
				1, 
				nr_seq_apres_w);
			end;		
			end loop;
		close C01;
	end if;
	 
	cd_setor_atendimento_w2 := cd_setor_atendimento_w;
	nr_seq_classif_w2	:= nr_seq_classif_w;
	 
	end;
end loop;
close C00;
 
dt_atualizacao_w	:= clock_timestamp();
 
insert into w_atend_lote_oper( 
	cd_estabelecimento,   
	dt_atualizacao, 
	nm_usuario, 
	ds_informacao, 
	qt_liberado, 
	qt_pendente, 
	qt_atendido, 
	qt_dispesado, 
	qt_entregue_setor, 
	qt_recebido_setor, 
	qt_atraso_inicio_atend, 
	qt_atraso_atend, 
	qt_atraso_disp, 
	qt_atraso_entrega_setor, 
	qt_atraso_receb_setor, 
	qt_futuro, 
	ie_temp, 
	nr_seq_apres, 
	ie_tipo) 
SELECT	cd_estabelecimento,   
	dt_atualizacao_w, 
	nm_usuario, 
	ds_informacao, 
	sum(qt_liberado), 
	sum(qt_pendente), 
	sum(qt_atendido), 
	sum(qt_dispesado), 
	sum(qt_entregue_setor), 
	sum(qt_recebido_setor), 
	sum(qt_atraso_inicio_atend), 
	sum(qt_atraso_atend), 
	sum(qt_atraso_disp), 
	sum(qt_atraso_entrega_setor), 
	sum(qt_atraso_receb_setor), 
	sum(qt_futuro), 
	'N', 
	nr_seq_apres, 
	ie_tipo 
from	w_atend_lote_oper 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	nm_usuario		= nm_usuario_p 
group by cd_estabelecimento,   
	dt_atualizacao_w, 
	nm_usuario, 
	ds_informacao, 
	nr_seq_apres, 
	ie_tipo 
order by nr_seq_apres,ie_tipo,ds_informacao;
 
delete	FROM w_atend_lote_oper 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	nm_usuario		= nm_usuario_p 
and	ie_temp			= 'S';
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_painel_atend_lote_oper ( cd_estabelecimento_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_seq_turno_p bigint, nr_seq_classificacao_p text, cd_local_estoque_p text, qt_hora_passada_p bigint, qt_hora_futura_p bigint, ds_filtros_p text, ie_mostra_turnos_p text, ds_filtro_classif_html_p text default null, ds_filtro_local_html_p text default null, ds_filtro_setor_html_p text default null) FROM PUBLIC;
