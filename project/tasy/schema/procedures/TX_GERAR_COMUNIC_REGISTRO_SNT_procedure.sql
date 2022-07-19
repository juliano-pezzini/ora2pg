-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_gerar_comunic_registro_snt (nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_fisica_w	varchar(100);
ds_status_w		varchar(100);
CD_PERFIL_SNT_w		integer;

c01 CURSOR FOR 
	SELECT 	distinct 
		b.cd_pessoa_fisica, 
		substr(obter_nome_pf(b.cd_pessoa_fisica),1,100), 
		substr(OBTER_VALOR_DOMINIO(7654,IE_STATUS_RGCT),1,100) 
	from	tx_registro_snt a, 
		tx_receptor b, 
		paciente_tratamento c 
	where	a.ie_status_rgct <> 'A' 
	and	a.nr_Seq_receptor = b.nr_sequencia 
	and	b.cd_pessoa_fisica = c.cd_pessoa_fisica 
	and	coalesce(c.dt_final_tratamento::text, '') = '' 
	and	c.ie_tratamento = 'TX';


BEGIN 
 
open c01;
	loop 
	fetch c01 into 
		cd_pessoa_fisica_w, 
		nm_pessoa_fisica_w, 
		ds_status_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	select	coalesce(max(cd_perfil_snt),0) 
	into STRICT	cd_perfil_snt_w 
	from	tx_parametros;
	 
	if (cd_perfil_snt_w > 0) then 
		CALL gerar_comunic_padrao(clock_timestamp(), 
					wheb_mensagem_pck.get_texto(795578), 
					wheb_mensagem_pck.get_texto(795590, 
								'NM_PESSOA_FISICA='||nm_pessoa_fisica_w|| 
								';DS_STATUS='||ds_status_w) || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(795574), 
					nm_usuario_p, 
					'N', 
					null,						 
					'N', 
					null, 
					cd_perfil_snt_w || ',', 
					null, 
					null, 
					clock_timestamp(), 
					null, 
					null);	
	end if;
	 
	end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_gerar_comunic_registro_snt (nm_usuario_p text) FROM PUBLIC;

