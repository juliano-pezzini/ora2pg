-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_setor_regra_oncologia ( cd_pessoa_fisica_p text, cd_protocolo_p bigint , nr_seq_medicacao_p bigint , cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_seq_loco_regional_p bigint, cd_setor_realizar_p INOUT bigint) AS $body$
DECLARE

 
cd_setor_ult_atendimento_w	bigint;
cd_retorno_w		     bigint;
nr_atendimento_w		   bigint;
cd_setor_realizar_w		   bigint;
cd_empresa_w		     smallint;
cd_estabelecimento_w	   smallint;
cd_protocolo_w		     bigint;
nr_seq_medicacao_w	     integer;
cd_categoria_w		     varchar(10);
nr_seq_agrupamento_w	   bigint;
cd_convenio_w		     bigint;
qt_reg_w			     bigint := 0;

C01 CURSOR FOR 
	SELECT cd_setor_realizar, 
		 nr_seq_agrupamento 
	from	 regra_setor_oncologia 
	where coalesce(cd_setor_ult_atendimento,cd_setor_ult_atendimento_w)	= cd_setor_ult_atendimento_w 
	and	 coalesce(cd_empresa,cd_empresa_w)			        = cd_empresa_w 
	and	 coalesce(cd_estabelecimento,cd_estabelecimento_w)	     = cd_estabelecimento_w 
	and	 coalesce(cd_protocolo,cd_protocolo_w)		          = cd_protocolo_w 
	and	 coalesce(nr_seq_medicacao,nr_seq_medicacao_w)	        = nr_seq_medicacao_w 
	and	 coalesce(cd_categoria,cd_categoria_w)			        = cd_categoria_w 
	and	 coalesce(cd_convenio,cd_convenio_w) 			        = cd_convenio_w 
	order by 
		coalesce(cd_empresa,0), 
		coalesce(cd_estabelecimento,0), 
		coalesce(cd_categoria,0), 
		coalesce(cd_protocolo,0), 
		coalesce(nr_seq_medicacao,0), 
		coalesce(cd_convenio,0),		 	 
		coalesce(cd_setor_ult_atendimento,0);
		

BEGIN 
 
select	max(nr_atendimento) 
into STRICT	   nr_atendimento_w 
from	   atendimento_paciente 
where	cd_pessoa_fisica = cd_pessoa_fisica_p 
and		ie_tipo_atendimento <> 7 
and		coalesce(dt_alta::text, '') = '';
 
--nr_atendimento_w	:= obter_ultimo_atendimento(cd_pessoa_fisica_p); 
 
if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
 
	cd_protocolo_w 			:= coalesce(cd_protocolo_p,0);
	nr_seq_medicacao_w 		   := coalesce(nr_seq_medicacao_p,0);
	cd_setor_ult_atendimento_w	:= coalesce(obter_setor_atendimento(nr_atendimento_w),0);
	cd_estabelecimento_w		:= coalesce(cd_estabelecimento_p,0);
	cd_convenio_w				:= coalesce(obter_convenio_atendimento(nr_atendimento_w),0);
	 
	if (coalesce(cd_empresa_p::text, '') = '') then 
		select	coalesce(obter_empresa_estab(cd_estabelecimento_p),0) 
		into STRICT	cd_empresa_w 
		;
	else 
		cd_empresa_w := cd_empresa_p;
	end if;
	 
	select coalesce(max(cd_categoria),'0') 
	into STRICT	  cd_categoria_w 
	from	  can_loco_regional 
	where  nr_sequencia = nr_seq_loco_regional_p;
	 
	open C01;
	loop 
	fetch C01 into	 
		cd_setor_realizar_w, 
		nr_seq_agrupamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 cd_retorno_w:= cd_setor_realizar_w;
		end;
	end loop;
	close C01;
	 
	if (nr_seq_agrupamento_w IS NOT NULL AND nr_seq_agrupamento_w::text <> '') then 
		select	max(cd_setor_atendimento) 
		into STRICT	   cd_setor_realizar_w	 
		from	   setor_atendimento 
		where	CD_ESTABELECIMENTO_BASE	= cd_estabelecimento_p 
		and		nr_seq_agrupamento	= nr_seq_agrupamento_w;
		 
		if (cd_setor_realizar_w IS NOT NULL AND cd_setor_realizar_w::text <> '') then 
			cd_retorno_w := cd_setor_realizar_w;
		end if;	
	end if;	
   
   if (cd_retorno_w IS NOT NULL AND cd_retorno_w::text <> '') then 
		select 	count(*) 
		into STRICT	   qt_reg_w 
		from 	setor_atendimento 
		where 	cd_classif_setor not in (6,7) 
		and 	   ie_situacao = 'A' 
		and 	   coalesce(ie_trat_oncologico,'S') = 'S' 
		and 	   cd_estabelecimento_base = wheb_usuario_pck.get_cd_estabelecimento 
		and 	   obter_se_setor_usuario(cd_setor_atendimento,wheb_usuario_pck.get_nm_usuario) = 'S' 
		and	   cd_setor_atendimento = cd_retorno_w;
	end if;
	 
end if;
 
if (qt_reg_w = 0)then 
	cd_setor_realizar_p := null;
else 
	cd_setor_realizar_p	:= cd_retorno_w;
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_setor_regra_oncologia ( cd_pessoa_fisica_p text, cd_protocolo_p bigint , nr_seq_medicacao_p bigint , cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_seq_loco_regional_p bigint, cd_setor_realizar_p INOUT bigint) FROM PUBLIC;

