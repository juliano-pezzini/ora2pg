-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_arquivo_fcont ( nr_seq_controle_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
			 
dt_ref_final_w			timestamp;
dt_ref_inicial_w			timestamp;	
dt_ano_w				timestamp;

qt_contador_w			bigint;
nr_seq_regra_sped_w		bigint;
cd_estabelecimento_w		integer;
cd_empresa_w			smallint;
qt_linha_w			bigint := 0;
nr_sequencia_w			bigint;
qt_linhas_w			bigint;
qt_total_w			bigint;
ds_arquivo_w			varchar(4000);
ds_arquivo_ww			varchar(4000);
ie_forma_escrituracao_w		varchar(15);
cd_registro_w			varchar(15);
sep_w				varchar(1)	:= '|';

c01 CURSOR FOR 
SELECT	cd_registro 
from	ctb_regra_sped_registro 
where	nr_seq_regra_sped	=	nr_seq_regra_sped_w 
and	ie_gerar		=	'S' 
order by nr_sequencia;
		

BEGIN 
 
select	dt_ref_inicial, 
	dt_ref_final, 
	nr_seq_regra_sped, 
	cd_estabelecimento 
into STRICT	dt_ref_inicial_w, 
	dt_ref_final_w, 
	nr_seq_regra_sped_w, 
	cd_estabelecimento_w 
from	ctb_sped_controle 
where	nr_sequencia	=	nr_seq_controle_p;
 
select	ie_forma_escrituracao, 
	dt_ano 
into STRICT	ie_forma_escrituracao_w, 
	dt_ano_w	 
from	ctb_regra_sped 
where	nr_sequencia 	=	nr_seq_regra_sped_w;
 
select	count(*) 
into STRICT	qt_total_w 
from	ctb_regra_sped_registro 
where	nr_seq_regra_sped	= nr_seq_regra_sped_w;
 
select	cd_empresa 
into STRICT	cd_empresa_w 
from	ctb_sped_controle 
where	nr_sequencia	=	nr_seq_controle_p;
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_sequencia_w 
from	ctb_sped_registro;
 
delete	FROM ctb_sped_registro 
where	nr_seq_controle_sped	=	nr_seq_controle_p;
 
qt_contador_w	:= 0;
CALL gravar_processo_longo('Carregando informações' ,'CTB_GERAR_ARQUIVO_FCONT',qt_contador_w);
open c01;
loop 
fetch c01 into	 
	cd_registro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	nr_sequencia_w	:=	nr_sequencia_w;
	qt_linha_w	:=	qt_linha_w;
	qt_contador_w 	:= 	qt_contador_w + 1;
	CALL gravar_processo_longo('Carregando Registro: ' || cd_registro_w || ' ('|| qt_contador_w ||'/' ||qt_total_w ||')','CTB_GERAR_ARQUIVO_FCONT',qt_contador_w);
	if (cd_registro_w = '0000') then 
		SELECT * FROM CTB_GERAR_INTERF_0000_FCONT(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w in ('I001','J001','M001','9001')) then 
		SELECT * FROM ctb_gerar_reg_abertura_ecd(nr_seq_controle_p, nm_usuario_p, sep_w, cd_registro_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'I050') then 
		SELECT * FROM ctb_gerar_interf_I050_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'I075') then 
		SELECT * FROM ctb_gerar_interf_I075_ecd(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'I100') then 
		ctb_gerar_interf_I100_ecd(nr_seq_controle_p,nm_usuario_p,cd_estabelecimento_w,dt_ref_inicial_w,dt_ref_final_w,cd_empresa_w,qt_linha_w,nr_sequencia_w);
	elsif (cd_registro_w = 'I150') then 
		SELECT * FROM ctb_gerar_interf_I150_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	/*elsif	(cd_registro_w = 'I200') then MATHEUS - Retirado em 23/11/2011 - Não deve ser gerado pelo Tasy (ACTUSAUDIT) 
		ctb_gerar_interf_I200_fcont(nr_seq_controle_p,nm_usuario_p,cd_estabelecimento_w,dt_ref_inicial_w,dt_ref_final_w,cd_empresa_w,qt_linha_w,nr_sequencia_w);*/
 
	elsif (cd_registro_w = 'I350') then 
		SELECT * FROM ctb_gerar_interf_I350_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'M020') then 
		SELECT * FROM ctb_gerar_interf_M020_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'M030') then 
		SELECT * FROM ctb_gerar_interf_M030_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;
	elsif (cd_registro_w = 'J930') then 
		SELECT * FROM ctb_gerar_interf_J930_fcont(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;			
	elsif (cd_registro_w = '9900') then 
		SELECT * FROM ctb_gerar_interf_9900_ecd(nr_seq_controle_p, nm_usuario_p, cd_estabelecimento_w, dt_ref_inicial_w, dt_ref_final_w, cd_empresa_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;			
	elsif (cd_registro_w in ('9990','J990','I990','M990','0990','9999')) then 
		SELECT * FROM ctb_gerar_reg_fim_bloco_ecd(nr_seq_controle_p, nm_usuario_p, sep_w, cd_registro_w, qt_linha_w, nr_sequencia_w) INTO STRICT qt_linha_w, nr_sequencia_w;			
	end if;	
	end;
end loop;
close c01;
 
update	ctb_sped_controle 
set	dt_geracao	=	clock_timestamp() 
where	nr_sequencia	=	nr_seq_controle_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_arquivo_fcont ( nr_seq_controle_p bigint, nm_usuario_p text) FROM PUBLIC;

