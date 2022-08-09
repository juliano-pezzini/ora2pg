-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_relatorio_perfil (cd_perfil_origem_p bigint, cd_perfil_destino_p bigint, nr_seq_relatorio_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_antiga_w		bigint;
nr_sequencia_w		bigint;
			

BEGIN

select	nextval('relatorio_perfil_seq')
into STRICT	nr_sequencia_w
;

select 	max(nr_sequencia)
into STRICT	nr_seq_antiga_w
from	RELATORIO_PERFIL
where	cd_perfil		 = cd_perfil_origem_p
and		nr_seq_relatorio = nr_seq_relatorio_p;



insert	into RELATORIO_PERFIL(NR_SEQUENCIA,
		CD_PERFIL,              
		NR_SEQ_RELATORIO,       
		DT_ATUALIZACAO,         
		NM_USUARIO,             
		QT_COPIA,               
		IE_LOGO,                
		IE_CONFIGURAR,          
		IE_IMPRIMIR,            
		IE_OUTPUTBIN,           
		DS_IMPRESSORA,          
		NR_SEQ_APRESENT,        
		IE_GRAVAR_LOG,          
		IE_VISUALIZAR,          
		IE_APRESENTA,           
		IE_FORMA_IMPRESSAO,
        CD_ESTAB)
(SELECT	nr_sequencia_w,
		cd_perfil_destino_p,
		nr_seq_relatorio_p,
		clock_timestamp(),
		nm_usuario_p,             
		QT_COPIA,               
		IE_LOGO,                
		IE_CONFIGURAR,          
		IE_IMPRIMIR,            
		IE_OUTPUTBIN,           
		DS_IMPRESSORA,          
		NR_SEQ_APRESENT,        
		IE_GRAVAR_LOG,          
		IE_VISUALIZAR,          
		IE_APRESENTA,           
		IE_FORMA_IMPRESSAO,
        CD_ESTAB
from	RELATORIO_PERFIL 
where	cd_perfil		 = cd_perfil_origem_p
and		nr_seq_relatorio = nr_seq_relatorio_p);

insert into relatorio_perfil_param(
			nr_seq_perfil_relat,
			nr_seq_parametro,
			dt_atualizacao,
			nm_usuario,
			ds_valor,
			ds_valor_exec)
(SELECT	nr_sequencia_w,
		nr_seq_parametro,
		clock_timestamp(),
		nm_usuario_p,
		ds_valor,
		ds_valor_exec
from	relatorio_perfil_param a
where	a.nr_seq_perfil_relat = nr_seq_antiga_w);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_relatorio_perfil (cd_perfil_origem_p bigint, cd_perfil_destino_p bigint, nr_seq_relatorio_p text, nm_usuario_p text) FROM PUBLIC;
