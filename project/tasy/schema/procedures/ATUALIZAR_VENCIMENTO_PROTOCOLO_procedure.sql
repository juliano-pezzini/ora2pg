-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_vencimento_protocolo ( dt_vencimento_p timestamp, nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_titulo_w		bigint;
cd_estabelecimento_w	bigint;
ie_alt_venc_tit_w	varchar(255);
ds_texto_w		varchar(255);

c01 CURSOR FOR 
SELECT	nr_titulo 
from	titulo_receber 
where	nr_seq_protocolo	= nr_seq_protocolo_p 

union
 
SELECT	nr_titulo 
from	titulo_receber 
where	nr_interno_conta in (select	nr_interno_conta 
	from	conta_paciente 
	where	nr_seq_protocolo	= nr_seq_protocolo_p);


BEGIN 
	 
update	protocolo_convenio 
set	dt_vencimento 	= dt_vencimento_p, 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp()	 
where 	nr_seq_protocolo = nr_seq_protocolo_p;
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	protocolo_convenio 
where 	nr_seq_protocolo = nr_seq_protocolo_p;
 
ie_alt_venc_tit_w := obter_param_usuario(85, 142, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_alt_venc_tit_w);
 
if (coalesce(ie_alt_venc_tit_w, 'N') = 'S') then 
	begin 
	 
	ds_texto_w := substr(wheb_mensagem_pck.get_texto(302767),1,255);--Alteração através do protocolo 
	
	open c01;
	loop 
	fetch c01 into 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL alterar_vencimento_tit_rec(nr_titulo_w, dt_vencimento_p, 1, ds_texto_w || ' ' || nr_seq_protocolo_p, nm_usuario_p);
	end loop;
	close c01;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_vencimento_protocolo ( dt_vencimento_p timestamp, nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

