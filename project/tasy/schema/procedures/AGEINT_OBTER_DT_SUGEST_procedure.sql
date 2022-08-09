-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_obter_dt_sugest (dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_agenda_int_p bigint, ie_transferencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dt_retorno_p INOUT timestamp) AS $body$
DECLARE

 
dt_retorno_w			timestamp;
nr_seq_item_w			bigint;
dt_controle_w			timestamp;
ie_continua_w			varchar(1) := 'S';
ds_aux_w				varchar(255);
ie_data_w				varchar(1);
ie_bloq_glosa_part_w	varchar(1);
nr_glosa_part_w			bigint;
qt_contador_pb_w		bigint;
ds_agendas_montadas_w	varchar(1);

C01 CURSOR FOR  /* Validando datas dos itens */
 
	SELECT	ageint_obter_se_dt_disp(dt_controle_w,nr_seq_agenda_int_p,a.nr_sequencia) 
	from	agenda_integrada_item a 
	where	a.nr_seq_agenda_int = nr_seq_agenda_int_p 
	and	ageint_obter_status_item(a.nr_seq_agenda_int,a.nr_sequencia,'C') <> 'C' 
	and	coalesce(ie_regra,0) not in (1,2,5,nr_glosa_part_w) 
	and	coalesce(ie_glosa,'X') <> 'T' 
	and (not exists (	SELECT	1 
				from	ageint_marcacao_usuario b 
				where	b.nr_seq_ageint_item	= a.nr_sequencia) 
	or		ie_Transferencia_p	= 'S') 
	order by 1 desc;


BEGIN 
 
qt_contador_pb_w := 0;
CALL gravar_processo_longo(WHEB_MENSAGEM_PCK.get_texto(279711,null)||to_char(dt_controle_w,'dd/mm/yyyy'),'AGEINT_OBTER_DT_SUGEST',qt_contador_pb_w);
 
nr_glosa_part_w	:= 99;
 
if (ie_bloq_glosa_part_w = 'N') then 
	nr_glosa_part_w := 8;
end if;
 
dt_controle_w	:= trunc(dt_inicial_p);
 
while(dt_controle_w	>= trunc(dt_inicial_p)) and (dt_controle_w	<= trunc(dt_final_p)) and (ie_continua_w = 'S') loop 
	begin 
	 
	qt_contador_pb_w := qt_contador_pb_w + 1;
	CALL gravar_processo_longo(WHEB_MENSAGEM_PCK.get_texto(279711,null)||to_char(dt_controle_w,'dd/mm/yyyy'),'AGEINT_OBTER_DT_SUGEST',qt_contador_pb_w);
	 
 
	SELECT * FROM Gerar_Horarios_AgeInt(dt_controle_w, nm_usuario_p, nr_seq_agenda_int_p, cd_estabelecimento_p, ds_agendas_montadas_w, ds_aux_w, ds_aux_w, ds_aux_w, ds_aux_w) INTO STRICT ds_aux_w, ds_aux_w, ds_aux_w, ds_aux_w;
 
	open C01;
	loop 
	fetch C01 into 
		ie_data_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		if (ie_data_w = 'N') then 
			ie_continua_w := 'S';
		else 
			ie_continua_w := 'N';
		end if;
 
		end;
	end loop;
	close C01;
 
	end;
	if (ie_continua_w = 'S') then 
		dt_controle_w		:= dt_controle_w + 1;
	end if;
end loop;
 
dt_retorno_p	:= dt_controle_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_obter_dt_sugest (dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_agenda_int_p bigint, ie_transferencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dt_retorno_p INOUT timestamp) FROM PUBLIC;
