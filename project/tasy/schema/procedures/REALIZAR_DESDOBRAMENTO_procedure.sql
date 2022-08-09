-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE realizar_desdobramento (nr_seq_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_ordem_w	 	bigint;
qt_ordem_w		bigint;
				
C01 CURSOR FOR 
	SELECT 	distinct 
		b.nr_sequencia 
	from	paciente_atend_medic d, 
		prescr_material c, 
		can_ordem_prod b, 
		can_ordem_item_prescr a 
	where	d.nr_seq_atendimento	= b.nr_seq_atendimento 
	and	d.nr_seq_material 	= c.nr_seq_material 
	and	a.nr_prescricao 	= c.nr_prescricao 
	and	a.nr_seq_prescricao 	= c.nr_sequencia 
	and	b.nr_sequencia 		= a.nr_seq_ordem 
	and	c.nr_seq_atendimento 	= nr_seq_atendimento_p 
	and 	ie_administracao 	= 'P' 
	and	coalesce(b.nr_seq_ordem_origem::text, '') = '';

BEGIN
 
open C01;
loop 
fetch C01 into	 
	nr_seq_ordem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select 	count(*) 
	into STRICT	qt_ordem_w 
	from 	can_ordem_prod 
	where 	nr_seq_ordem_origem = nr_seq_ordem_w;
	 
	if (coalesce(qt_ordem_w,0) = 0) then 
		CALL gerar_desdobramento_ordem(nr_seq_ordem_w,nm_usuario_p);
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE realizar_desdobramento (nr_seq_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
