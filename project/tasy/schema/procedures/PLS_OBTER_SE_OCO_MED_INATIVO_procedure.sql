-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_oco_med_inativo ( nr_seq_conta_p bigint, nr_seq_proc_p bigint, ie_gerar_ocorrencia_p INOUT text, ds_observacao_p INOUT text) AS $body$
DECLARE

 
cd_medico_w		bigint;
ie_medico_inativo_w	varchar(1) := 'N';
				
C01 CURSOR FOR 
	SELECT	a.cd_medico 
	from	pls_proc_participante a, 
		pls_conta_proc	b	 
	where	a.nr_seq_conta_proc	= b.nr_sequencia 
	and	b.nr_seq_conta 		= nr_seq_conta_p 
	and	((b.nr_sequencia = nr_seq_proc_p) or (coalesce(nr_seq_proc_p,0) = 0)) 
	
union
 
	SELECT	a.cd_medico_executor 
	from	pls_conta a, 
		pls_conta_proc b 
	where	a.nr_sequencia	= b.nr_seq_conta 
	and	b.nr_seq_conta	= nr_seq_conta_p 
	and	((b.nr_sequencia = nr_seq_proc_p) or (coalesce(nr_seq_proc_p,0) = 0)) 
	order by 1;
					

BEGIN 
 
ie_gerar_ocorrencia_p := 'N';
ds_observacao_p := 'Médico(s) inativo(s): '||chr(13)||chr(10);
 
open C01;
loop 
fetch C01 into	 
	cd_medico_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
	 
	if (coalesce(cd_medico_w,0) > 0) then 
		 
		/*Obter se o médico inativo*/
 
		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  
		into STRICT	ie_medico_inativo_w 
		from	medico 
		where	cd_pessoa_fisica = cd_medico_w 
		and	coalesce(ie_situacao,'I') = 'A';
		 
		if (ie_medico_inativo_w = 'S') then 
			ds_observacao_p := ds_observacao_p||cd_medico_w||' - '||obter_nome_pf(cd_medico_w)||' '||chr(13)||chr(10);
			ie_gerar_ocorrencia_p := 'S';
		end if;
	end if;
	 
	end;
end loop;
close C01;
 
if (ie_gerar_ocorrencia_p = 'N') then 
	ds_observacao_p := '';
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_oco_med_inativo ( nr_seq_conta_p bigint, nr_seq_proc_p bigint, ie_gerar_ocorrencia_p INOUT text, ds_observacao_p INOUT text) FROM PUBLIC;

