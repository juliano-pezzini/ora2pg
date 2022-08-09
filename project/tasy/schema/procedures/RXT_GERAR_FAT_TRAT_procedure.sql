-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_gerar_fat_trat (ie_tipo_lancamento_p text, nr_seq_agenda_p bigint, nr_seq_fase_p bigint, nr_seq_tratamento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
nr_atendimento_w	bigint;			
nr_seq_tratamento_w	bigint;
nr_seq_tumor_w		bigint;	
cd_convenio_w		integer;		
ie_regra_lancamento_w	varchar(2);
nr_seq_tipo_w		bigint;

nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

nr_seq_campo_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	RXT_PLANEJAMENTO_FISICO 
	where	nr_seq_fase = nr_seq_fase_p;


BEGIN 
 
select	max(nr_atendimento), 
	max(nr_seq_tratamento) 
into STRICT	nr_atendimento_w, 
	nr_seq_tratamento_w 
from	rxt_Agenda 
where	nr_sequencia	= nr_seq_agenda_p;
 
if (coalesce(nr_seq_tratamento_w::text, '') = '') then 
	nr_seq_tratamento_w := nr_seq_tratamento_p;
end if;	
 
 
 
select	max(nr_seq_tumor) 
into STRICT	nr_seq_tumor_w 
from	rxt_tratamento b 
where 	b.nr_sequencia	= nr_seq_tratamento_w;
 
select	max(nr_seq_tipo) 
into STRICT	nr_seq_tipo_w 
from	rxt_tratamento a, 
	rxt_protocolo b 
where	a.nr_seq_protocolo = b.nr_sequencia 
and	a.nr_sequencia = nr_seq_tratamento_w;
 
 
if (coalesce(nr_seq_tipo_w,0) = 0) then 
	select nr_seq_tipo 
	into STRICT nr_seq_tipo_w 
	from rxt_tumor 
	where nr_sequencia = nr_seq_tumor_w;
end if;
 
 
if (coalesce(nr_atendimento_w,0) = 0) then 
	select 	max(nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from	rxt_tumor 
	where	nr_Sequencia = nr_seq_tumor_w;
end if;
 
 
 
if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
	cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_w);
	 
	 
	select	CASE WHEN count(*)=0 THEN 'PD'  ELSE 'N' END  
	into STRICT	ie_regra_lancamento_w 
	from	procedimento_paciente a, 
		rxt_tipo_trat_proced b 
	where	nr_atendimento = nr_atendimento_w 
	and	((a.cd_procedimento = b.cd_procedimento 
	and	a.ie_origem_proced = b.ie_origem_proced) or (coalesce(b.cd_procedimento::text, '') = '')) 
	and	((a.nr_seq_proc_interno = b.nr_seq_proc_interno) or (coalesce(b.nr_seq_proc_interno::text, '') = ''))	 
	and	b.nr_seq_tipo = nr_seq_tipo_w 
	and	b.ie_regra_lancamento = 'PD' 
	and	b.ie_situacao = 'A';
 
	 
	if (ie_regra_lancamento_w = 'PD') then 
		SELECT * FROM rxt_obter_proced_tip_trat(ie_regra_lancamento_w, ie_tipo_lancamento_p, nr_seq_tipo_w, nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w) INTO STRICT nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w;	
 
		 
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or 
			(cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '' AND ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
			CALL rxt_inserir_proced_fat(nr_seq_tratamento_w, nm_usuario_p, nr_atendimento_w, obter_setor_usuario(nm_usuario_p), 
						obter_estab_atend(nr_atendimento_w), nr_seq_agenda_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, 
						ie_tipo_lancamento_p);
			 
		 
		end if;	
	else 
	     
		SELECT * FROM rxt_obter_proced_tip_trat('DS', ie_tipo_lancamento_p, nr_seq_tipo_w, nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w) INTO STRICT nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w;	
 
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or 
			(cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '' AND ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
			CALL rxt_inserir_proced_fat(nr_seq_tratamento_w, nm_usuario_p, nr_atendimento_w, obter_setor_usuario(nm_usuario_p), 
						obter_estab_atend(nr_atendimento_w), nr_seq_agenda_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, 
						ie_tipo_lancamento_p);			
		end if;	
		 
	end if;						
		 
	if (ie_tipo_lancamento_p = 'GC') then 
		 
		SELECT * FROM rxt_obter_proced_tip_trat('MC', ie_tipo_lancamento_p, nr_seq_tipo_w, nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w) INTO STRICT nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w;	
		 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_campo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or 
				(cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '' AND ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
				CALL rxt_inserir_proced_fat(nr_seq_tratamento_w, nm_usuario_p, nr_atendimento_w, obter_setor_usuario(nm_usuario_p), 
							obter_estab_atend(nr_atendimento_w), nr_seq_agenda_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, 
							ie_tipo_lancamento_p);
			 
			end if;	
			end;
		end loop;
		close C01;
		 
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_gerar_fat_trat (ie_tipo_lancamento_p text, nr_seq_agenda_p bigint, nr_seq_fase_p bigint, nr_seq_tratamento_p bigint, nm_usuario_p text) FROM PUBLIC;
