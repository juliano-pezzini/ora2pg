-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consiste_classif_pacote (nr_seq_pacote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_classif_p INOUT text) AS $body$
DECLARE

 
ie_procedimento_regra_w     varchar(1):= 'S';					
nr_seq_pacote_proc_w		bigint;
nr_seq_proc_interno_w		bigint;
cd_procedimento_w        bigint;
ie_origem_proced_w       bigint;
NR_SEQ_PAC_ACOMOD_w       bigint;
ie_exige_classif_w		varchar(1) := 'N';
	
c01 CURSOR FOR 
    SELECT cd_procedimento, 
        ie_origem_proced, 
		NR_SEQ_PAC_ACOMOD, 
		nr_seq_proc_interno 
    from  pacote_procedimento 
    where  nr_seq_pacote  = nr_seq_pacote_p 
    and   ie_inclui_exclui = 'I' 
    and ((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> '')) 
	and 	coalesce(ie_agendavel,'N') = 'S' 
    and   coalesce(ie_procedimento_regra_w,'S') = 'A';
	

BEGIN 
 
ie_procedimento_regra_w := obter_param_usuario(106, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_procedimento_regra_w);
 
open C01;
loop 
fetch C01 into	 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	NR_SEQ_PAC_ACOMOD_w, 
	nr_seq_proc_interno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_exige_classif_w = 'N') then 
		if (coalesce(nr_seq_proc_interno_w::text, '') = '') then 
			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
				select	coalesce(max(nr_sequencia),0) 
				into STRICT	nr_seq_proc_interno_w 
				from	proc_interno 
				where	cd_procedimento		= cd_procedimento_w 
				and	ie_origem_proced	= ie_origem_proced_w;
				 
				if (nr_seq_proc_interno_w	= 0) then	 
					select	max(nr_Seq_proc_interno) 
					into STRICT	nr_Seq_proc_interno_w 
					from	proc_interno_conv 
					where	cd_procedimento		= cd_procedimento_w 
					and	ie_origem_proced	= ie_origem_proced_w;
				end if;
			end if;
		elsif (coalesce(cd_procedimento_w::text, '') = '') or (coalesce(ie_origem_proced_w::text, '') = '') then 
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;			
		end if;
	 
		select	coalesce(max(ie_exige_classif_item_ageint),'N') 
		into STRICT	ie_exige_classif_w 
		from	proc_interno 
		where	nr_sequencia	= nr_seq_proc_interno_w;
	end if;
	end;
end loop;
close C01;
 
ie_classif_p := ie_exige_classif_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consiste_classif_pacote (nr_seq_pacote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_classif_p INOUT text) FROM PUBLIC;
