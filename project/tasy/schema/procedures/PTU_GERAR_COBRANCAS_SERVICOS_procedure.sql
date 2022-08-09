-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_cobrancas_servicos ( nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_protocolo_conta_w	bigint;
nr_seq_conta_w			bigint;
nr_seq_servico_w		bigint;
cd_unimed_origem_w		smallint;
cd_cooperativa_w		varchar(10);
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
dt_mes_competencia_w		timestamp;

C01 CURSOR FOR 
	SELECT	b.cd_cooperativa, 
		b.nr_sequencia 
	from	pls_conta		b, 
		pls_protocolo_conta	a 
	where	b.nr_seq_protocolo	= a.nr_sequencia 
	and	trunc(a.dt_mes_competencia)	between	trunc(dt_inicio_w) and trunc(dt_fim_w) 
	and 	coalesce(b.nr_seq_serv_pre_pagto::text, '') = '' 
	and 	(b.cd_cooperativa IS NOT NULL AND b.cd_cooperativa::text <> '') 
	and	a.ie_status	= '3' 
	and	a.ie_tipo_protocolo	= 'C';
	
 
 

BEGIN 
 
/* Obter dados dos serviços*/
 
select	dt_inicio_pagto, 
	dt_fim_pagto 
into STRICT	dt_inicio_w, 
	dt_fim_w 
from	ptu_servico_pre_pagto 
where	nr_sequencia	= nr_seq_servico_p;
 
/* Obter a Unimed do estabelecimento */
 
cd_unimed_origem_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);
 
open C01;
loop 
fetch C01 into	 
	cd_cooperativa_w, 
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	update	pls_conta 
	set	nr_seq_serv_pre_pagto	= nr_seq_servico_p 
	where	nr_sequencia		= nr_seq_conta_w;
	 
	end;
end loop;
close C01;
 
CALL ptu_gerar_nota_cobranca_serv(nr_seq_servico_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_cobrancas_servicos ( nr_seq_servico_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
