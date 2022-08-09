-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_titulo_prot_reemb_js ( nr_seq_lista_p text, ie_status_lista_p text, dt_vencimento_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_lista_w		varchar(2000);
nr_sequencia_w		bigint;
ie_status_lista_w	varchar(2000);
ie_status_w		varchar(1);
ie_titulo_gerado_w	varchar(1);
dt_emissao_w		timestamp;


BEGIN 
dt_emissao_w		:= clock_timestamp();
nr_seq_lista_w		:= nr_seq_lista_p;
ie_status_lista_w	:= ie_status_lista_p;
 
while (nr_seq_lista_w IS NOT NULL AND nr_seq_lista_w::text <> '') loop 
	begin 
	nr_sequencia_w	:= substr(nr_seq_lista_w, 1, position(',' in nr_seq_lista_w) - 1);
	nr_seq_lista_w	:= substr(nr_seq_lista_w, position(',' in nr_seq_lista_w) + 1, length(nr_seq_lista_w));
 
	ie_status_w		:= substr(ie_status_lista_w, 1, 1);
	ie_status_lista_w	:= substr(ie_status_lista_w, 2, length(ie_status_lista_w));
 
	select	CASE WHEN count(*)=0 THEN  'S'  ELSE 'N' END  
	into STRICT	ie_titulo_gerado_w 
	from	titulo_pagar 
	where	nr_seq_reembolso	= nr_sequencia_w 
	and	ie_situacao	= 'A';
 
	if (ie_status_w = '3') and (ie_titulo_gerado_w = 'S') then 
		begin 
		CALL pls_gerar_titulo_prot_reemb( 
			nr_sequencia_w, 
			dt_vencimento_p, 
			dt_emissao_w, 
			nm_usuario_p, 
			'N', 
			'S');
		end;
	end if;
	end;
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_titulo_prot_reemb_js ( nr_seq_lista_p text, ie_status_lista_p text, dt_vencimento_p timestamp, nm_usuario_p text) FROM PUBLIC;
