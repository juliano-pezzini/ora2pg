-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_itens_kit ( nr_interno_conta_p bigint, cd_kit_material_p bigint, dt_atendimento_p timestamp, cd_setor_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_motivo_exc_conta_w	smallint;				
nr_sequencia_w		bigint;
ds_compl_motivo_excon_w	varchar(255);

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	material_atend_paciente 
	where	cd_kit_material = cd_kit_material_p 
	and	dt_atendimento = dt_atendimento_p 
	and	cd_setor_atendimento =cd_setor_atendimento_p 
	and	nr_interno_conta = nr_interno_conta_p 
	and	coalesce(cd_motivo_exc_conta::text, '') = '' 
	order by nr_sequencia;
				

BEGIN 
 
select	max(cd_motivo_exc_conta) 
into STRICT	cd_motivo_exc_conta_w 
from	parametro_faturamento 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
ds_compl_motivo_excon_w := substr(wheb_mensagem_pck.get_texto(305292),1,255);
--Excluido através da opção "Excluir itens kit" da Conta Paciente 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL excluir_matproc_conta(	nr_sequencia_w, 
				nr_interno_conta_p, 
				cd_motivo_exc_conta_w, 
				ds_compl_motivo_excon_w, 
				'M', 
				nm_usuario_p);
 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_itens_kit ( nr_interno_conta_p bigint, cd_kit_material_p bigint, dt_atendimento_p timestamp, cd_setor_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

