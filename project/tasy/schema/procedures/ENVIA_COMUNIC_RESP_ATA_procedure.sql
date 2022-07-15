-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_comunic_resp_ata (cd_estabelecimento_p bigint) AS $body$
DECLARE

 
 
nm_pessoa_fisica_w		varchar(200);
nm_usuario_destino_w 	varchar(100);
cd_pessoa_fisica_w  	numeric(20);
nr_sequencia_w			numeric(20);
dt_inicio_w				timestamp;
ds_titulo_w				varchar(80);
ds_comunicado_w			varchar(2000);

				    

BEGIN 
 
		select  substr(obter_nome_pf(d.cd_pessoa_fisica),1,150) nm_pessoa_fisica, 
				 d.dt_inicio, 
				 d.cd_pessoa_fisica 
		into STRICT	 nm_pessoa_fisica_w, 
				 dt_inicio_w, 
				 cd_pessoa_fisica_w 
		from   escala_diaria d 
		where  d.nr_seq_escala = '72' 
		and   d.dt_inicio >= clock_timestamp()  
		order  by d.dt_inicio LIMIT 1;
 
		select		nm_usuario 
		into STRICT		nm_usuario_destino_w 
		from		usuario 
		where		cd_pessoa_fisica = cd_pessoa_fisica_w;
		 
	 
	 
	ds_titulo_w := Wheb_mensagem_pck.get_texto(307943) || ' '; --'Ata da reunião de gerência '; 
	
	ds_comunicado_w := Wheb_mensagem_pck.get_texto(307945, 'NM_PESSOA_FISICA='||nm_pessoa_fisica_w) /*'O Tasy vem por meio deste comunicado lhe informar que você, ' ||nm_pessoa_fisica_w || ', é responsável pela ata da próxima reunião gerencial. '*/|| chr('13') 
						|| Wheb_mensagem_pck.get_texto(307948, 'DT_INICIO_W='||dt_inicio_w) /*'Que ocorrerá no dia ' || dt_inicio_w*/ || chr('13');
						 
	 
	 
		select	nextval('comunic_interna_seq') 
		into STRICT	nr_sequencia_w 
		;	
 
		 
	insert into comunic_interna( 
			dt_comunicado, 
			ds_titulo, 
			ds_comunicado, 
			nm_usuario, 
			dt_atualizacao, 
			ie_geral, 
			nm_usuario_destino, 
			nr_sequencia, 
			ie_gerencial, 
			nr_seq_classif, 
			dt_liberacao) 
		values (clock_timestamp(), 
			ds_titulo_w, 
			ds_comunicado_w, 
			'Tasy', 
			clock_timestamp(), 
			'N', 
			nm_usuario_destino_w||', alfernandes, ', 
			nr_sequencia_w, 
			'N', 
			'1', 
			clock_timestamp());
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_comunic_resp_ata (cd_estabelecimento_p bigint) FROM PUBLIC;

