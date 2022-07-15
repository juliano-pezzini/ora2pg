-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_venci_prop ( qt_dia_p bigint) AS $body$
DECLARE

 
nr_seq_prop_w 		bigint;
ds_razao_social_w		varchar(255);
nr_seq_cliente_w		bigint;
nr_seq_canal_w		bigint;
cd_gestor_resp_w		bigint;
ds_email_gestor_w		varchar(4000);
ds_menssagem_w		varchar(4000);
ds_canal_w		varchar(255);
dt_final_w		timestamp;

C01 CURSOR FOR 
SELECT 	a.nr_sequencia, 
	b.nr_sequencia, 
	c.nr_seq_canal, 
	substr(obter_razao_social(a.cd_cnpj),1,255) 
from  	com_cliente a, 
	com_cliente_proposta b, 
	com_canal_cliente c 
where 	a.nr_sequencia = b.nr_seq_cliente 
and	a.nr_sequencia = c.nr_seq_cliente 
and	a.ie_classificacao = 'P' -- Prospect 
and  	coalesce(b.dt_cancelamento::text, '') = '' 
and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') 
and	coalesce(c.dt_fim_atuacao::text, '') = '' 
and	c.ie_tipo_atuacao = 'V' 
and	trunc(b.dt_vencimento) = trunc(clock_timestamp() + qt_dia_p);

c02 CURSOR FOR 
SELECT 	a.cd_pessoa_fisica 
from	com_cliente_gestor a 
where	a.nr_seq_cliente = nr_seq_cliente_w 
and		((coalesce(a.dt_final::text, '') = '') or (trunc(a.dt_final) = trunc(clock_timestamp())));


BEGIN 
ds_menssagem_w := 'Sua proposta irá vencer daqui a ' || qt_dia_p || ' dias, favor atualizar a mesma. ' || chr(13) || chr(10) || 'Caso ela não esteja mais válida deverá ser cancelada.'||chr(13)||chr(10)||chr(13)||chr(10);
open C01;
loop 
fetch C01 into	 
	nr_seq_cliente_w, 
	nr_seq_prop_w, 
	nr_seq_canal_w, 
	ds_razao_social_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		if (coalesce(nr_seq_canal_w,0) = 3) then -- Philips 
		begin	 
			ds_email_gestor_w := 'comercial@wheb.com.br';
			 
			open C02;
			loop 
			fetch C02 into 
				cd_gestor_resp_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				ds_email_gestor_w := ds_email_gestor_w || ';' || obter_dados_pf_pj(cd_gestor_resp_w,null,'M');
				end;
			end loop;
			close C02;
			 
			CALL enviar_email('Vencimento da proposta ' || nr_seq_prop_w || ' Cliente: ' || ds_razao_social_w, ds_menssagem_w|| 'Canal: Philips', 'comercial@wheb.com.br', ds_email_gestor_w, 'Tasy', 'A');
		end;
		elsif (coalesce(nr_seq_canal_w,0) <> 3) then -- Não seja Philips 
		begin 
			select	coalesce(max(a.nm_guerra),'Canal não informado') 
			into STRICT	ds_canal_w 
			from	com_canal a 
			where	a.nr_sequencia = nr_seq_canal_w;
			CALL enviar_email('Vencimento da proposta ' || nr_seq_prop_w || ' Cliente: ' || ds_razao_social_w, ds_menssagem_w|| 'Canal: '||ds_canal_w, 'comercial@wheb.com.br', 'comercial@wheb.com.br', 'Tasy', 'A');
		end;	
		end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_venci_prop ( qt_dia_p bigint) FROM PUBLIC;

