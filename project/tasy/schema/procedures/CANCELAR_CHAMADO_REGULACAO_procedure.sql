-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_chamado_regulacao ( nm_usuario_p text, nr_sequencia_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_motivo_alta_w	smallint;
ds_erro_w	varchar(255);

BEGIN
 
cd_motivo_alta_w := 0;
 
if (nr_sequencia_p > 0) then 
	update	eme_regulacao 
	set	nm_usuario_cancelamento = nm_usuario_p, 
		dt_cancelamento = clock_timestamp() 
	where	nr_sequencia = nr_sequencia_p;
	 
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_atendimento_p <> 0) then 
		 
		cd_motivo_alta_w := Obter_Param_Usuario(989, 33, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_motivo_alta_w);
		 
		if (cd_motivo_alta_w > 0) then 
		 
			ds_erro_w := gerar_estornar_alta(nr_atendimento_p, 'A', 0, cd_motivo_alta_w, clock_timestamp(), nm_usuario_p, ds_erro_w, null, 0, null, null);
			 
		end if;
	 
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_chamado_regulacao ( nm_usuario_p text, nr_sequencia_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
