-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_devolucao_material ( nr_devolucao_p bigint, cd_local_estoque_p bigint, cd_tipo_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
nr_seq_lote_fornec_w		bigint;
qt_material_w			double precision;
qt_itens_nao_baixados_w		bigint;

c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.qt_material, 
	a.nr_seq_lote_fornec 
from	item_devolucao_material_pac a 
where	coalesce(a.dt_recebimento::text, '') = '' 
and	a.nr_devolucao = nr_devolucao_p;


BEGIN 
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	qt_material_w, 
	nr_seq_lote_fornec_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	CALL baixar_item_devolucao(nr_devolucao_p, nr_sequencia_w, qt_material_w, cd_tipo_baixa_p, cd_local_estoque_p, nr_seq_lote_fornec_w, nm_usuario_p);
	end;
end loop;
close c01;
 
select	count(*) 
into STRICT	qt_itens_nao_baixados_w 
from	item_devolucao_material_pac 
where	nr_devolucao	= nr_devolucao_p 
and	coalesce(dt_recebimento::text, '') = '';
 
if (qt_itens_nao_baixados_w = 0) then 
 
	update	devolucao_material_pac 
	set	dt_baixa_total	= clock_timestamp(), 
		nm_usuario_baixa	= nm_usuario_p 
	where	nr_devolucao	= nr_devolucao_p;
end if;
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_devolucao_material ( nr_devolucao_p bigint, cd_local_estoque_p bigint, cd_tipo_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;

