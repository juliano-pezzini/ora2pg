-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gerar_calendario_planej ( cd_estabelecimento_p bigint, nr_seq_planej_compras_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_planej_compras_w		bigint;
dt_atual_w			timestamp;

qt_dia_frequencia_w		bigint;
qt_dia_antecedencia_w		bigint;
dt_primeira_entrega_w		timestamp;
dt_periodo_final_w			timestamp;
dt_planejamento_w		timestamp;
dt_planejamento_ww		timestamp;

ie_continua_w			varchar(1);

ie_postergar_fim_semana_w		varchar(1);
ie_dia_semana_w			varchar(1);
			
c01 CURSOR FOR 
SELECT	nr_sequencia, 
	trunc(dt_primeira_entrega,'dd'), 
	trunc(dt_periodo_final,'dd'), 
	trunc(qt_dia_frequencia), 
	trunc(qt_dia_antecedencia) 
from	sup_planejamento_compras 
where	nr_sequencia = coalesce(nr_seq_planej_compras_p,nr_sequencia) 
and	ie_gerar_calendario = 'S' 
and	cd_estabelecimento = cd_estabelecimento_p 
and	dt_atual_w between dt_periodo_inicial and dt_periodo_final;

 

BEGIN 
dt_atual_w := trunc(clock_timestamp(),'dd');
 
select	coalesce(ie_postergar_planej_fs,'N') 
into STRICT	ie_postergar_fim_semana_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_p;
 
open c01;
loop 
fetch c01 into	 
	nr_seq_planej_compras_w, 
	dt_primeira_entrega_w, 
	dt_periodo_final_w, 
	qt_dia_frequencia_w, 
	qt_dia_antecedencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	delete	FROM planej_compras_calendario 
	where	nr_seq_planej_compras = nr_seq_planej_compras_w 
	and	dt_planejamento >= dt_atual_w;
	 
	dt_planejamento_w	:= dt_primeira_entrega_w;
	ie_continua_w	:= 'S';
	 
	while(ie_continua_w = 'S') loop 
		begin 
		if (dt_planejamento_w <= dt_periodo_final_w) then 
			begin	 
			dt_planejamento_ww := dt_planejamento_w;
			 
			if (qt_dia_antecedencia_w > 0) then 
				dt_planejamento_ww := (dt_planejamento_w - qt_dia_antecedencia_w);
			end if;
 
			/* Inicio - Postergar finais de semana */
 
			select	pkg_date_utils.get_WeekDay(dt_planejamento_ww) 
			into STRICT	ie_dia_semana_w 
			;
 
			if (ie_postergar_fim_semana_w = 'S') and (pkg_date_utils.is_business_day(dt_planejamento_ww) = 0) then 
				begin 
				if (ie_dia_semana_w	= '1') then /* Domingo */
 
					dt_planejamento_ww := (dt_planejamento_w + 1);
				elsif (ie_dia_semana_w = '7') then /* Sábado */
 
					dt_planejamento_ww := (dt_planejamento_w + 2);
				end if;
 
				end;
			end if;
			/* Fim - Postergar finais de semana */
 
			 
			if (dt_planejamento_w >= dt_atual_w) then 
				begin 
				insert into planej_compras_calendario( 
					nr_sequencia, 
					cd_estabelecimento, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					dt_planejamento, 
					dt_planejamento_inicial, 
					dt_cancelamento, 
					nm_usuario_cancel, 
					nr_seq_planej_compras) 
				values (	nextval('planej_compras_calendario_seq'), 
					cd_estabelecimento_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					dt_planejamento_ww, 
					dt_planejamento_ww, 
					null, 
					null, 
					nr_seq_planej_compras_w);
				end;
			end if;
			 
			if (qt_dia_frequencia_w > 0) then 
				dt_planejamento_w := (dt_planejamento_w + qt_dia_frequencia_w);
			else 
				ie_continua_w := 'N';
			end if;
			end;
		else 
			ie_continua_w := 'N';
		end if;
		end;
	end loop;
	 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_calendario_planej ( cd_estabelecimento_p bigint, nr_seq_planej_compras_p bigint, nm_usuario_p text) FROM PUBLIC;

