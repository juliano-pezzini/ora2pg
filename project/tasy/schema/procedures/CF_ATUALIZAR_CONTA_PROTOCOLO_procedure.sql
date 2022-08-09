-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cf_atualizar_conta_protocolo ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ie_status_acerto_w	conta_paciente.ie_status_acerto%type;
nr_seq_protocolo_w	conta_paciente.nr_seq_protocolo%type;


BEGIN 
 
select 	coalesce(max(nr_seq_protocolo),0), 
		coalesce(max(ie_status_acerto),1) 
into STRICT	nr_seq_protocolo_w, 
		ie_status_acerto_w 
from 	conta_paciente 
where 	nr_interno_conta = nr_interno_conta_p;
 
if		(nr_seq_protocolo_w = 0 AND ie_status_acerto_w = 2) then 
 
		update	conta_paciente 
		set		nr_seq_protocolo	= nr_seq_protocolo_p, 
				nm_usuario			= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp() 
		where	nr_interno_conta = nr_interno_conta_p;
		 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cf_atualizar_conta_protocolo ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
