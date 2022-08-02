-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_turno_completo ( nr_seq_turno_p bigint, nr_prescricao_p bigint, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w	bigint;
ds_erro_w	varchar(255);
ds_funcaoSuspensa varchar(100);

c01 CURSOR FOR 
SELECT  nr_sequencia 
from   prescr_mat_hor 
where  nr_seq_turno	= nr_seq_turno_p 
and   nr_prescricao	= nr_prescricao_p 
and   coalesce(dt_suspensao::text, '') = '' 
and   coalesce(dt_fim_horario::text, '') = '' 
and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S' 
order by dt_horario;


BEGIN 
     
if (cd_funcao_p = 1113) then--ADEP   
	ds_funcaoSuspensa := wheb_mensagem_pck.get_texto(299621);
end if;
if (cd_funcao_p = 924) then--REP 
	ds_funcaoSuspensa := wheb_mensagem_pck.get_texto(299619);
end if;
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 
	ds_erro_w := Consiste_susp_prescr_mat_hor(nr_prescricao_p, nr_sequencia_w, cd_estabelecimento_p, nm_usuario_p, ds_erro_w);
	 
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(214150,'ERRO='||ds_erro_w);	
	else                                       -- S = Gerar evento do item 
		CALL suspender_prescr_mat_hor(nr_sequencia_w, nm_usuario_p, null, ds_funcaoSuspensa,'S',null);
		 
		if (cd_funcao_p = 1113) then--ADEP   
			update	prescr_mat_alteracao 
			set		ds_justificativa = ds_funcaoSuspensa 
			where	NR_SEQ_HORARIO = nr_sequencia_w;
		end if;
	end if;
	 
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_turno_completo ( nr_seq_turno_p bigint, nr_prescricao_p bigint, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

