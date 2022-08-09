-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_gps_titulo ( cd_pagamento_p text, dt_referencia_p timestamp, dt_vencimento_p timestamp, cd_estabelecimento_p bigint, nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_gps_w		smallint;
nr_sequencia_titulo_w		bigint;


BEGIN 
 
select 	nextval('gps_seq') 
into STRICT 	nr_sequencia_gps_w
;
 
insert into 	gps(	nr_sequencia, 
			cd_estabelecimento,	 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_pagamento, 
			dt_referencia, 
			dt_vencimento, 
			cd_identificador, 
			vl_inss, 
			vl_gps, 
			nr_seq_dirf, 
			nr_bordero, 
			vl_multa, 
			vl_juros, 
			vl_outras_entidades) 
	values (	nr_sequencia_gps_w, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_pagamento_p, 
			dt_referencia_p, 
			dt_vencimento_p, 
			'', 
			null, 
			null, 
			null, 
			null, 
			null, 
			null, 
			null);
 
commit;
 
select 	nextval('gps_titulo_seq') 
into STRICT 	nr_sequencia_titulo_w
;
 
insert into 	gps_titulo(	nr_sequencia, 
				nr_titulo, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_gps) 
	values (			nr_sequencia_titulo_w, 
				nr_titulo_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_sequencia_gps_w);
 
CALL gerar_identificador_gps(nr_sequencia_gps_w);
CALL atualiza_valor_gps(nr_sequencia_gps_w,nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_gps_titulo ( cd_pagamento_p text, dt_referencia_p timestamp, dt_vencimento_p timestamp, cd_estabelecimento_p bigint, nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;
