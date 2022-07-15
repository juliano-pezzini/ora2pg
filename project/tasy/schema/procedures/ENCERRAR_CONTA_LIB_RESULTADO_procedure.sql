-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE encerrar_conta_lib_resultado ( cd_setor_encerramento_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
cd_setor_atendimento_w		integer;
ds_erro_w			varchar(255);
					

BEGIN 
 
select 	cd_setor_atendimento 
into STRICT 	cd_setor_atendimento_w 
from 	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
if 	((coalesce(cd_setor_encerramento_p::text, '') = '') or (cd_setor_encerramento_p = 0) or (cd_setor_encerramento_p = cd_setor_atendimento_w)) then 
	 
	 ds_erro_w := encerr_conta_lib_resu_exam(nr_seq_prescr_p, nr_seq_resultado_p, nm_usuario_p, ds_erro_w);
	 
	 if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
		ds_erro_p := ds_erro_w;
	 end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE encerrar_conta_lib_resultado ( cd_setor_encerramento_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

