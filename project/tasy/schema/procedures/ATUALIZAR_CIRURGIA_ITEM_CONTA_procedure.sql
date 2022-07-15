-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cirurgia_item_conta (nr_seq_item_p bigint, ie_proc_mat_p text, nr_cirurgia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w	bigint;
ie_status_acerto_w	smallint;
ie_atualizar_resumo_w	varchar(10);


BEGIN 
 
 
if (ie_proc_mat_p	= 'P') then 
	update	procedimento_paciente 
	set	nr_cirurgia 	= nr_cirurgia_p, 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_item_p;
	 
	select	coalesce(max(nr_interno_conta),0) 
	into STRICT	nr_interno_conta_w 
	from	procedimento_paciente a 
	where	a.nr_sequencia	= nr_seq_item_p;
	 
elsif (ie_proc_mat_p	= 'M') then 
	update	material_atend_paciente 
	set	nr_cirurgia 	= nr_cirurgia_p, 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_item_p;
	 
	select	coalesce(max(nr_interno_conta),0) 
	into STRICT	nr_interno_conta_w 
	from	material_atend_paciente a 
	where	a.nr_sequencia	= nr_seq_item_p;
end if;
ie_atualizar_resumo_w	:= coalesce(Obter_Valor_Param_Usuario(obter_funcao_ativa,242,obter_perfil_ativo,nm_usuario_p,0),'N');
 
if (coalesce(nr_interno_conta_w,0)	<> 0)	and (ie_atualizar_resumo_w		= 'S')	then 
	select	ie_status_acerto 
	into STRICT	ie_status_acerto_w 
	from	conta_paciente 
	where	 nr_interno_conta	= nr_interno_conta_w;
	 
	if (ie_status_acerto_w	= 2) then 
		CALL atualizar_resumo_conta(nr_interno_conta_w,ie_status_acerto_w);
	end if;
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cirurgia_item_conta (nr_seq_item_p bigint, ie_proc_mat_p text, nr_cirurgia_p bigint, nm_usuario_p text) FROM PUBLIC;

