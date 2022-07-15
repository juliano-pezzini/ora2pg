-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_os_contador ( nr_seq_ordem_p bigint) AS $body$
DECLARE

 
nr_seq_equip_w			bigint;
nr_seq_planej_w			bigint;
nr_seq_ordem_w			bigint;
qt_contador_w			bigint;
qt_contador_ww			bigint;	
qt_contador_os_w		bigint;	
dt_fim_real_w			timestamp;
ie_status_w			smallint;
nm_usuario_w			varchar(15);
nr_sequencia_w			bigint;
ie_equip_regra_excl_w		varchar(1) := 'N';
qt_reg_w			bigint;
nr_seq_planej_ww		bigint;

c01 CURSOR FOR 
	SELECT b.nr_sequencia, 
		a.qt_contador 
	from	man_planej_prev b, 
		man_planej_prev_regra a 
	where	a.nr_seq_planej_prev		= nr_seq_planej_w 
	and	a.nr_seq_planej_contador	= b.nr_sequencia 
	and	coalesce(b.dt_inicial,clock_timestamp())	<= clock_timestamp() 
	and	coalesce(b.ie_situacao,'A')		= 'A' 
	and	coalesce(b.ie_contador,'N')		= 'S';


BEGIN 
select	coalesce(qt_contador,0), 
	coalesce(nr_seq_planej,0), 
	coalesce(nr_seq_equipamento,0), 
	dt_fim_real, 
	coalesce(ie_status_ordem,0), 
	nm_usuario 
into STRICT	qt_contador_os_w, 
	nr_seq_planej_w, 
	nr_seq_equip_w, 
	dt_fim_real_w, 
	ie_status_w, 
	nm_usuario_w 
from	man_ordem_servico 
where	nr_sequencia	= nr_seq_ordem_p;
 
if (qt_contador_os_w > 0) and (nr_seq_planej_w > 0) and (nr_seq_equip_w > 0) and (dt_fim_real_w IS NOT NULL AND dt_fim_real_w::text <> '') and (ie_status_w = 3) then 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_planej_ww, 
		qt_contador_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		/* Buscar última OS do Equipamento antes da atual*/
 
		select	coalesce(max(nr_sequencia), 0) 
		into STRICT	nr_seq_ordem_w 
		from 	man_ordem_servico 
		where 	nr_seq_equipamento 	= nr_seq_equip_w 
		and 	coalesce(nr_seq_planej,0) 	= nr_seq_planej_w 
		and 	ie_tipo_ordem 		= 2 
		and	nr_sequencia		<> nr_seq_ordem_p;
 
		select	coalesce(max(qt_contador), 0) 
		into STRICT 	qt_contador_ww 
		from 	man_ordem_servico 
		where 	nr_sequencia 	= nr_seq_ordem_w;
		 
		select	count(nr_sequencia) 
		into STRICT	qt_reg_w 
		from	man_planej_prev_equip_excl 
		where	nr_seq_equipamento = nr_seq_equip_w 
		and	nr_seq_planej_prev = nr_seq_planej_w;
		 
		ie_equip_regra_excl_w	:= 'N';
		 
		if (qt_reg_w > 0) then 
			ie_equip_regra_excl_w	:= 'S';
		end if;
		 
		if	((qt_contador_os_w >= (qt_contador_w + qt_contador_ww)) and (ie_equip_regra_excl_w = 'N')) then 
			nr_sequencia_w := man_gerar_os_planejada(nr_seq_equip_w, nr_seq_planej_ww, dt_fim_real_w, nm_usuario_w, nr_sequencia_w, 'S');
		end if;
	end loop;
	close c01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_os_contador ( nr_seq_ordem_p bigint) FROM PUBLIC;

