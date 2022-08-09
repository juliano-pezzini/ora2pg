-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_automatica_solic_compra ( cd_estabelecimento_p bigint, dt_parametro_p timestamp, qt_hora_p bigint) AS $body$
DECLARE

 
 
nr_solic_compra_w	bigint :=0;

C01 CURSOR FOR 
SELECT	nr_solic_compra 
from 	solic_compra 
where 	dt_solicitacao_compra < (dt_parametro_p - qt_hora_p / 24) 
 and	cd_estabelecimento = cd_estabelecimento_p 
 and 	coalesce(dt_baixa::text, '') = '' 
 and	coalesce(dt_liberacao::text, '') = '';

 

BEGIN 
 
open	c01;
loop 
fetch	c01 into 
	nr_solic_compra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	update	solic_compra 
	set	dt_baixa = clock_timestamp() 
	where 	nr_solic_compra = nr_solic_compra_w;
	 
	insert into solic_compra_hist( 
		nr_sequencia, 
		nr_solic_compra, 
		dt_atualizacao, 
		nm_usuario, 
		dt_historico, 
		ds_titulo, 
		ds_historico, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_tipo, 
		cd_evento, 
		dt_liberacao) 
	values (	nextval('solic_compra_hist_seq'), 
		nr_solic_compra_w, 
		clock_timestamp(), 
		'Tasy', 
		clock_timestamp(), 
		Wheb_mensagem_pck.get_Texto(297835), 
		Wheb_mensagem_pck.get_Texto(297838), 
		clock_timestamp(), 
		'Tasy', 
		'S', 
		'B', 
		clock_timestamp());	
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_automatica_solic_compra ( cd_estabelecimento_p bigint, dt_parametro_p timestamp, qt_hora_p bigint) FROM PUBLIC;
