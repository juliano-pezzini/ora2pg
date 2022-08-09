-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_cancelar_numeracao ( nr_numeracao_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w		bigint;
nr_retorno_w		bigint;
ie_exclui_aih_laudo_w	varchar(10);

BEGIN
 
update	sus_lote_numeracao_item 
set	ie_utilizado	= 'N' 
where	nr_numeracao_sus	= nr_numeracao_p;
 
ie_exclui_aih_laudo_w := Obter_Valor_Param_Usuario(1123,87,Obter_Perfil_Ativo,nm_usuario_p,0);
 
if (ie_exclui_aih_laudo_w = 'S') then 
	begin 
	update	sus_laudo_paciente 
	set	nr_aih 	 = NULL, 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp() 
	where	nr_aih	= nr_numeracao_p;	
	end;
end if;
 
--commit; 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_cancelar_numeracao ( nr_numeracao_p bigint, nm_usuario_p text) FROM PUBLIC;
