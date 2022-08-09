-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_reprovar_duplic ( nr_seq_cliente_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
nr_seq_gestor_w		bigint;
nr_seq_cliente_w	bigint;
nr_seq_canal_w		bigint;
nr_seq_canal_ww		bigint;
cd_pessoa_fisica_w	bigint;
ds_email_w		varchar(255);
				
C01 CURSOR FOR 
	SELECT	nr_sequencia, cd_pessoa_fisica 
	from	com_cliente_gestor 
	where	nr_seq_cliente = nr_seq_cliente_p 
	and	coalesce(dt_final::text, '') = '' 
	order by 1;
	
C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	com_canal_cliente 
	where	nr_seq_cliente = nr_seq_cliente_p 
	and	coalesce(dt_fim_atuacao::text, '') = '' 
	and	ie_situacao = 'A' 
	order by 1;	

BEGIN 
if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_gestor_w, 
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		delete FROM com_cliente_gestor 
		where	nr_sequencia = nr_seq_gestor_w;
		end;
	end loop;
	close C01;
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_canal_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		delete FROM com_canal_cliente 
		where	nr_sequencia = nr_seq_canal_w;
		end;
	end loop;
	close C02;
	 
	select	max(nr_seq_canal) 
	into STRICT	nr_seq_canal_ww 
	from	com_canal_cliente 
	where	nr_seq_cliente = nr_seq_cliente_w 
	and	nr_sequencia = (SELECT	max(nr_sequencia) 
				from	com_canal_cliente 
				where	nr_seq_cliente = nr_seq_cliente_w);
				 
	delete 	FROM com_cliente_hist 
	where	nr_seq_cliente = nr_seq_cliente_p;
	 
	select 	substr(obter_dados_pf_pj(cd_pessoa_fisica_w, null, 'M'),1,255) 
	into STRICT	ds_email_w 
	;
	 
	delete FROM com_cliente 
	where	nr_sequencia = nr_seq_cliente_p;
 
CALL enviar_email(wheb_mensagem_pck.get_texto(802674), wheb_mensagem_pck.get_texto(802675,'nr_seq_cliente_p=' || nr_seq_cliente_p) , 'comercial@wheb.com.br', 'comercial@wheb.com.br;' || ds_email_w, nm_usuario_p, 'A');							
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_reprovar_duplic ( nr_seq_cliente_p bigint, nm_usuario_p text) FROM PUBLIC;
