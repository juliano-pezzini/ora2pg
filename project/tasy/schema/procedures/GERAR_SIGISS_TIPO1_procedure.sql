-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_sigiss_tipo1 (dt_inicio_p timestamp, dt_fim_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_registro_w		varchar(1);
ie_tp_arquivo_w		varchar(12);
nr_insc_municipal_w	varchar(8);
cd_versao_arquivo_w	varchar(3);
dt_geracao_arquivo_w	varchar(10);
cd_estabelecimento_w	smallint;
ds_arquivo_ww		varchar(3000);
				

BEGIN 
			 
select	'1'								cd_registro, 
	rpad(substr('NFE_LOTE',1,12),12,' ')				ie_tp_arquivo, 
	lpad(coalesce(substr(obter_dados_pf_pj(null,cd_cgc,'IM'),1,8),' '),8,' ') 	nr_insc_municipal, 
	lpad('010','3',' ')					  	cd_versao_arquivo, 
	rpad(to_char(clock_timestamp(),'yyyymmdd'),8,' ')		  	dt_geracao_arquivo, 
	cd_estabelecimento						cd_estabelecimento 
into STRICT	cd_registro_w, 
	ie_tp_arquivo_w, 
	nr_insc_municipal_w, 
	cd_versao_arquivo_w, 
	dt_geracao_arquivo_w, 
	cd_estabelecimento_w 
from	estabelecimento 
where	cd_estabelecimento = cd_estabelecimento_p;				
 
ds_arquivo_ww := cd_registro_w		|| 
		ie_tp_arquivo_w		|| 
		nr_insc_municipal_w	|| 
		cd_versao_arquivo_w	|| 
		dt_geracao_arquivo_w;		
 
insert into w_inss_direp_arquivo(nr_sequencia, 
				 cd_estabelecimento, 
				 dt_atualizacao, 
				 nm_usuario, 
				 dt_atualizacao_nrec, 
				 nm_usuario_nrec, 
				 ds_arquivo_w) 
			values (nextval('w_inss_direp_arquivo_seq'), 
				 cd_estabelecimento_w, 
				 clock_timestamp(), 
				 nm_usuario_p, 
				 clock_timestamp(), 
				 nm_usuario_p, 
				 ds_arquivo_ww );
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_sigiss_tipo1 (dt_inicio_p timestamp, dt_fim_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
