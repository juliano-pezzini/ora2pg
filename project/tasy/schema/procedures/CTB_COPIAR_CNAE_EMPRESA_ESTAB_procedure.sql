-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_copiar_cnae_empresa_estab ( cd_estabelecimento_origem_p bigint, cd_estabelecimento_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE

	/*Variaveis de controle*/

	nr_sequencia_w			bigint;

	/*Cursor com dados filtrados */

	c1 CURSOR FOR
	SELECT	nr_sequencia,
		cd_estabelecimento_destino_p cd_estabelecimento,
		clock_timestamp() dt_atualizacao,
		nm_usuario_p nm_usuario,
		clock_timestamp() dt_atualizacao_nrec,
		nm_usuario_p nm_usuario_nrec,
		cd_empresa,
		nr_seq_cnae,
		nr_seq_serv_item,
		cd_procedimento,
		ie_origem_proced
	from	cnae_empresa_estab
	where	cd_estabelecimento  = cd_estabelecimento_origem_p;

	r1 c1%rowtype;


--CNAE_EMPRESA_ESTAB
BEGIN

open c1;
loop
fetch c1 into r1;
EXIT WHEN NOT FOUND; /* apply on c1 */

	select	nextval('cnae_empresa_estab_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into cnae_empresa_estab(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_empresa,
		nr_seq_cnae,
		nr_seq_serv_item,
		cd_procedimento,
		ie_origem_proced)
	values (nr_sequencia_w,
		cd_estabelecimento_destino_p,
		r1.dt_atualizacao,
		r1.nm_usuario,
		r1.dt_atualizacao_nrec,
		r1.nm_usuario_nrec,
		r1.cd_empresa,
		r1.nr_seq_cnae,
		r1.nr_seq_serv_item,
		r1.cd_procedimento,
		r1.ie_origem_proced);

end loop;
close c1;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_copiar_cnae_empresa_estab ( cd_estabelecimento_origem_p bigint, cd_estabelecimento_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

