-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_resp_errata ( nr_sequencia_p bigint, cd_pessoa_resp_p text, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_resp_velha_w		varchar(10);
ds_pessoa_resp_velha_w		varchar(100);
ds_pessoa_resp_novo_w		varchar(100);
ds_historico_w			varchar(4000);
nr_seq_contrato_atual_w 		bigint;

c01 CURSOR FOR 
	SELECT nr_sequencia 
	from 	contrato 
	where	((nr_seq_contrato_atual = nr_sequencia_p) or (nr_sequencia = nr_sequencia_p)) 
	and	ie_classificacao not in ('OR','AD');


BEGIN 
 
select	cd_pessoa_resp, 
	substr(coalesce(obter_nome_pf(cd_pessoa_resp),wheb_mensagem_pck.get_texto(244229)),1,100) ds_pessoa_resp, 
	substr(obter_nome_pf(cd_pessoa_resp_p),1,100) ds_pessoa_resp_novo 
into STRICT	cd_pessoa_resp_velha_w, 
	ds_pessoa_resp_velha_w, 
	ds_pessoa_resp_novo_w 
from	contrato 
where	nr_sequencia = nr_sequencia_p;
 
open c01;
loop 
fetch c01 into 
	nr_seq_contrato_atual_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	update	contrato 
	set	cd_pessoa_resp = cd_pessoa_resp_p 
	where	nr_sequencia = nr_seq_contrato_atual_w;
 
	ds_historico_w	:= substr(wheb_mensagem_pck.get_texto(315112,	'CD_PESSOA_RESP_VELHA_W='||CD_PESSOA_RESP_VELHA_W||';DS_PESSOA_RESP_VELHA_W='||DS_PESSOA_RESP_VELHA_W|| 
									';CD_PESSOA_RESP_P='||CD_PESSOA_RESP_P||';DS_PESSOA_RESP_NOVO_W='||DS_PESSOA_RESP_NOVO_W),1,2000);
 
	insert into contrato_historico( 
		nr_sequencia, 
		nr_seq_contrato, 
		dt_historico, 
		ds_historico, 
		dt_atualizacao, 
		nm_usuario, 
		ds_titulo, 
		dt_liberacao, 
		nm_usuario_lib, 
		ie_efetivado) 
	values (	nextval('contrato_historico_seq'), 
		nr_sequencia_p, 
		clock_timestamp(), 
		ds_historico_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		wheb_mensagem_pck.get_texto(315113), 
		clock_timestamp(), 
		nm_usuario_p, 
		'N');
	 
    end;	
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_resp_errata ( nr_sequencia_p bigint, cd_pessoa_resp_p text, nm_usuario_p text) FROM PUBLIC;

