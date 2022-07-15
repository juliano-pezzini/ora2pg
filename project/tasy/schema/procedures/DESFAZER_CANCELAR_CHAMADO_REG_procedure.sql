-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_cancelar_chamado_reg (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w	varchar(100);					
					 
			 

BEGIN 
 
if (nr_sequencia_p > 0) then 
	update	eme_regulacao 
	set	nm_usuario_cancelamento  = NULL, 
		dt_cancelamento  = NULL 
	where	nr_sequencia = nr_sequencia_p;
end if;
 
If (nr_atendimento_p > 0) then 
	ds_erro_w := gerar_estornar_alta(nr_atendimento_p, 'E', 0, 0, null, nm_usuario_p, ds_erro_w, 0, 0, null);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_cancelar_chamado_reg (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

