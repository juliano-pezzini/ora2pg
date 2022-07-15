-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_solicitante_os ( nr_sequencia_p bigint, cd_pessoa_solicitante_p text, ie_historico_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_pessoa_solicitante_w		varchar(10);
ds_historico_w			varchar(4000);


BEGIN 
 
select	cd_pessoa_solicitante 
into STRICT	cd_pessoa_solicitante_w 
from	man_ordem_servico 
where	nr_sequencia	= nr_sequencia_p;
 
if (cd_pessoa_solicitante_w <> cd_pessoa_solicitante_p) then 
	begin 
	update	man_ordem_servico 
	set	cd_pessoa_solicitante	= cd_pessoa_solicitante_p, 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_sequencia		= nr_sequencia_p;
	 
	if (ie_historico_p	= 'S') then 
 
		ds_historico_w	:= substr('O usuário: ' || nm_usuario_p || ' alterou o solicitante desta OS' || chr(13) || chr(10) || 
					'de ' || substr(obter_nome_pf(cd_pessoa_solicitante_w),1,60)  || ' para ' || 
					substr(obter_nome_pf(cd_pessoa_solicitante_p),1,60),1,4000);
	 
		CALL man_gravar_historico_ordem(	nr_sequencia_p, 
					clock_timestamp(), 
					ds_historico_w, 
					'I', 
					null, 
					nm_usuario_p);
	end if;
 
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_solicitante_os ( nr_sequencia_p bigint, cd_pessoa_solicitante_p text, ie_historico_p text, nm_usuario_p text) FROM PUBLIC;

