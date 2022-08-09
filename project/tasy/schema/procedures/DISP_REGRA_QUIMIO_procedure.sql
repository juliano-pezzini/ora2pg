-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE disp_regra_quimio ( nr_atendimento_p bigint, nr_seq_atendimento_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_local_estoque_w 	smallint;
nr_sequencia_w		bigint;
nr_seq_ordem_w		bigint;
	
C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_local_estoque 
	from	material_atend_paciente 
	where	nr_seq_ordem_prod = nr_seq_ordem_p;

BEGIN
 
open C02;
loop 
fetch C02 into	 
	nr_sequencia_w, 
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	if (nr_atendimento_p > 0) then 
		CALL gerar_lanc_automatico_mat(nr_atendimento_p, cd_local_estoque_w, 441, nm_usuario_p, nr_sequencia_w, nr_seq_atendimento_p, null);
	end if;
	end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE disp_regra_quimio ( nr_atendimento_p bigint, nr_seq_atendimento_p bigint, nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;
