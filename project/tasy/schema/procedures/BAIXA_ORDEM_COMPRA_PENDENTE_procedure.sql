-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_ordem_compra_pendente () AS $body$
DECLARE

 
nr_ordem_compra_w		bigint :=0;
nr_seq_motivo_baixa_aut_w	bigint;
cd_estabelecimento_w		smallint;

c01 CURSOR FOR 
SELECT	distinct b.nr_ordem_compra, 
	b.cd_estabelecimento 
from	ordem_compra b, 
	ordem_compra_item_entrega a 
where	a.nr_ordem_compra = b.nr_ordem_compra 
and	((coalesce(qt_prevista_entrega,0) > coalesce(qt_real_entrega,0)) and coalesce(a.dt_baixa::text, '') = '') 
and	a.dt_prevista_entrega < (clock_timestamp() - coalesce(obter_dados_parametro_compras(b.cd_estabelecimento,'17'),180)) 
and	coalesce(a.dt_real_entrega::text, '') = '' 
and	coalesce(b.dt_baixa::text, '') = '';


BEGIN 
 
open c01;
loop 
fetch c01 into	 
	nr_ordem_compra_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	select	nr_seq_motivo_baixa_aut 
	into STRICT	nr_seq_motivo_baixa_aut_w 
	from	parametro_compras 
	where	cd_estabelecimento = cd_estabelecimento_w;
 
	update	ordem_compra 
	set	dt_baixa = clock_timestamp(), 
		nr_seq_motivo_baixa = nr_seq_motivo_baixa_aut_w 
	where	nr_ordem_compra = nr_ordem_compra_w;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_ordem_compra_pendente () FROM PUBLIC;
