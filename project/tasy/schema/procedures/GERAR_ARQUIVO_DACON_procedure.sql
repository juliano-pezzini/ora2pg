-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_arquivo_dacon ( nm_usuario_p text, nr_seq_dacon_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_regime_apuracao_w	smallint;
vl_receita_w			double precision;
vl_receita_ww			double precision;
				

BEGIN 
 
delete from w_dacon 
where nm_usuario = nm_usuario_p;
 
select 	ie_regime_apuracao 
into STRICT	ie_regime_apuracao_w 
from 	dacon 
where 	nr_sequencia = nr_seq_dacon_p;
 
CALL dacon_registro_header(nm_usuario_p,nr_seq_dacon_p);
CALL dacon_registro_r1(nm_usuario_p, nr_seq_dacon_p);
CALL dacon_registro_r2(nm_usuario_p, nr_seq_dacon_p);
CALL dacon_registro_r03(nm_usuario_p, nr_seq_Dacon_p, cd_estabelecimento_p);
 
if (ie_regime_apuracao_w = 1) then 
	CALL dacon_registro_r08a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r15a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r18a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r25a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r30(nm_usuario_p, nr_seq_dacon_p, cd_estabelecimento_p);
	CALL dacon_rt9(nm_usuario_p);	
	 
elsif (ie_regime_apuracao_w = 2)then 
	CALL dacon_registro_r06a(nr_seq_dacon_p,nm_usuario_p);
	vl_receita_w := dacon_registro_r07b(nr_seq_dacon_p, nm_usuario_p, vl_receita_w);
	CALL dacon_registro_r08a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r15a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r15b(nr_seq_dacon_p,nm_usuario_p,vl_receita_w);
	CALL dacon_registro_r16a(nr_seq_dacon_p,nm_usuario_p);
	vl_receita_ww := dacon_registro_r17b(nr_seq_dacon_p, nm_usuario_p, vl_receita_ww);
	CALL dacon_registro_r18a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r25a(nm_usuario_p, nr_seq_dacon_p);
	CALL dacon_registro_r25b(nr_seq_dacon_p,nm_usuario_p,vl_receita_ww);
	CALL dacon_registro_r30(nm_usuario_p, nr_seq_dacon_p, cd_estabelecimento_p);
	CALL dacon_rt9(nm_usuario_p);
else 
	CALL dacon_rt9(nm_usuario_p);
end if;	
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_arquivo_dacon ( nm_usuario_p text, nr_seq_dacon_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

