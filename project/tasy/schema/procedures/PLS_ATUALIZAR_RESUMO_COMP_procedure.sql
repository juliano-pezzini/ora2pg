-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_resumo_comp ( nr_seq_competencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
nr_seq_conta_w			bigint;
cd_estabelecimento_w		smallint;
				
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.cd_estabelecimento 
	from	pls_conta	a 
	where	a.nr_seq_competencia	= nr_seq_competencia_p 
	and	a.ie_status		= 'F' 
	
union
 
	SELECT	a.nr_sequencia, 
		a.cd_estabelecimento 
	from	pls_protocolo_conta	b, 
		pls_conta		a 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	coalesce(a.nr_seq_competencia::text, '') = '' 
	and	a.ie_status		= 'F' 
	and	exists (	select	1 
				from	pls_competencia	x 
				where	trunc(x.dt_mes_competencia,'month')	= trunc(b.dt_mes_competencia,'month') 
				and	x.cd_estabelecimento			= b.cd_estabelecimento 
				and	x.nr_sequencia				= nr_seq_competencia_p);


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_conta_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL pls_atualizar_conta_resumo(nr_seq_conta_w, cd_estabelecimento_w, nm_usuario_p);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_resumo_comp ( nr_seq_competencia_p bigint, nm_usuario_p text) FROM PUBLIC;

