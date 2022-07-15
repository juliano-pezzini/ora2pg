-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_lote_rvs ( nm_usuario_p text, nr_sequencia_p bigint, ie_somente_nota_p text) AS $body$
DECLARE

 
dt_referencia_w		timestamp;
dt_inicio_lote_w	timestamp;
dt_fim_lote_w		timestamp;
ie_registro_w		varchar(1);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_empresa_w		estabelecimento.cd_empresa%type;


BEGIN 
 
begin 
 
select	'S', 
	trunc(dt_referencia,'dd'), 
	trunc(dt_inicio_lote,'dd'), 
	fim_dia(dt_fim_lote), 
	cd_estabelecimento, 
	cd_empresa 
into STRICT	ie_registro_w, 
	dt_referencia_w, 
	dt_inicio_lote_w, 
	dt_fim_lote_w, 
	cd_estabelecimento_w, 
	cd_empresa_w	 
from	fis_siscoserv_lote a 
where	a.nr_sequencia = nr_sequencia_p;
 
exception 
when others then 
	ie_registro_w := 'N';
end;
 
if (coalesce(ie_registro_w,'N') = 'S') then 
	begin 
 
	CALL fis_gerar_pessoas_rvs(nm_usuario_p, nr_sequencia_p, dt_inicio_lote_w, dt_fim_lote_w, ie_somente_nota_p, cd_empresa_w, cd_estabelecimento_w);
	 
	CALL fis_gerar_notas_rvs(nm_usuario_p,'1',dt_inicio_lote_w, dt_fim_lote_w, nr_sequencia_p);
 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_lote_rvs ( nm_usuario_p text, nr_sequencia_p bigint, ie_somente_nota_p text) FROM PUBLIC;

