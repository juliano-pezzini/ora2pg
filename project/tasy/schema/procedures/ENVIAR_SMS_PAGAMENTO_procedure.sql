-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_pagamento (cd_estabelecimento_p bigint, nm_usuario_p text, cd_tipo_controle_p bigint) AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
vl_total_pago_w		double precision;
nr_telefone_celular_w	varchar(40);
ds_mensagem_w		varchar(255);
id_sms_w		bigint;
nm_estabelecimento_w	varchar(255);
ie_consist_destinatario_w	varchar(1);

c01 CURSOR FOR 
SELECT	cd_pessoa_fisica 
from	controle_pessoa 
where	cd_tipo_controle	= cd_tipo_controle_p 
and	ie_situacao	= 'A' 
and	clock_timestamp() 	between 	coalesce(dt_inicio_vigencia,clock_timestamp() - interval '1 days') and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days');


BEGIN 
ie_consist_destinatario_w	:= obter_valor_param_usuario(0,214,0,nm_usuario_p,cd_estabelecimento_p);
nm_estabelecimento_w	:= substr(obter_nome_estabelecimento(cd_estabelecimento_p),1,255);
 
open C01;
loop 
fetch C01 into 
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (ie_consist_destinatario_w = 'S') then 
		select	max(nr_telefone_celular) 
		into STRICT	nr_telefone_celular_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	else 
		select	max(nr_ddi_celular || nr_telefone_celular) 
		into STRICT	nr_telefone_celular_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	end if;
 
	nr_telefone_celular_w := replace(nr_telefone_celular_w,'(','');
	nr_telefone_celular_w := replace(nr_telefone_celular_w,')','');
	nr_telefone_celular_w := replace(nr_telefone_celular_w,' ','');
	nr_telefone_celular_w := replace(nr_telefone_celular_w,'-','');
 
	if (nr_telefone_celular_w IS NOT NULL AND nr_telefone_celular_w::text <> '') then 
 
		select	sum((coalesce(obter_dados_tit_pagar(nr_titulo,'P'),0))::numeric ) 
		into STRICT	vl_total_pago_w 
		from	titulo_pagar_v 
		where	dt_liquidacao		>= clock_timestamp() - interval '15 days' 
		and	cd_pessoa_fisica	= cd_pessoa_fisica_w;
	 
		ds_mensagem_w	:= WHEB_MENSAGEM_PCK.get_texto(278903) ||to_char(vl_total_pago_w);
 
		id_sms_w := wheb_sms.enviar_sms(nm_estabelecimento_w, nr_telefone_celular_w, ds_mensagem_w, nm_usuario_p, id_sms_w);
		 
	    	insert into log_envio_sms( 
	       		nr_sequencia, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_atualizacao, 
				nm_usuario, 
				dt_envio, 
	        	cd_agenda, 
	        	nr_seq_agenda, 
	        	nr_telefone, 
	        	ds_mensagem, 
	        	id_sms) 
			values (nextval('log_envio_sms_seq'), 
				clock_timestamp(), 
	        	nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				null, 
				null, 
				nr_telefone_celular_w, 
				ds_mensagem_w, 
				id_sms_w);
 
	end if;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_pagamento (cd_estabelecimento_p bigint, nm_usuario_p text, cd_tipo_controle_p bigint) FROM PUBLIC;

