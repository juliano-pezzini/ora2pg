-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gerar_retirada_expurgo ( nr_seq_conjunto_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, qt_conjunto_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
ds_erro_w		varchar(2000) := '';
nr_sequencia_w		bigint;
qt_conjunto_w		bigint;
cd_codigo_w		varchar(10);


BEGIN 
 
qt_conjunto_w := qt_conjunto_p;
 
SELECT * FROM cm_converte_cod_barras(nr_seq_conjunto_p, cd_codigo_w, ds_erro_w) INTO STRICT cd_codigo_w, ds_erro_w;
 
if (coalesce(ds_erro_w::text, '') = '') then 
	 
	while(qt_conjunto_w > 0) loop 
		begin 
	 
		select	nextval('cm_expurgo_retirada_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		insert into cm_expurgo_retirada( 
			nr_sequencia, 
			cd_estabelecimento, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ie_status, 
			nr_seq_conjunto) 
		values (	nr_sequencia_w, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			2, 
			cd_codigo_w);
 
		CALL cm_gerar_conjunto_cont_expurgo(cd_codigo_w,null,null,nr_sequencia_w,null,cd_setor_atendimento_p,nm_usuario_p,cd_estabelecimento_p);
	 
		qt_conjunto_w := (qt_conjunto_w - 1);
		 
		end;
	end loop;
 
end if;
 
ds_erro_p := ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gerar_retirada_expurgo ( nr_seq_conjunto_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, qt_conjunto_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
