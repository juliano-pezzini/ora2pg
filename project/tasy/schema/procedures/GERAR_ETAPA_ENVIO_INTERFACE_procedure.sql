-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_etapa_envio_interface ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
qt_existe_w		bigint;
nr_seq_etapa_w		bigint;
nr_interno_conta_w	bigint;
ie_tipo_atendimento_w	smallint;
cd_convenio_w		integer;
ie_evento_w		varchar(1);
cd_estabelecimento_w	bigint;
nr_seq_classificacao_w	bigint;
cd_setor_atendimento_w	integer;
nr_atendimento_w	bigint;
cd_categoria_w		varchar(10);
nr_seq_motivo_dev_w	bigint;
ie_tipo_convenio_w	smallint;
ie_regra_restrita_etapa_w	varchar(1);
ie_encontrou_regra_w	varchar(1);
cd_setor_atend_etapa_w	fatur_etapa_alta.cd_setor_atend_etapa%type;
nr_seq_etapa_filtro_w	fatur_etapa_alta.nr_seq_etapa_filtro%type;

C01 CURSOR FOR 
	SELECT	nr_seq_etapa, 
		nr_seq_motivo_dev, 
		cd_setor_atend_etapa 
	from	fatur_etapa_alta 
	where	((coalesce(cd_convenio::text, '') = '') or (coalesce(cd_convenio, coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0))) 
	and	((coalesce(cd_categoria::text, '') = '') or (coalesce(cd_categoria, coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0'))) 
	and	((coalesce(ie_tipo_atendimento::text, '') = '') or (coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0))) 
	and 	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,1)) = coalesce(cd_estabelecimento_w,1) 
	and 	coalesce(nr_seq_classificacao, coalesce(nr_seq_classificacao_w,0)) = coalesce(nr_seq_classificacao_w,0) 
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0) 
	and (coalesce(ie_evento,'I') = coalesce(ie_evento_w,'I')) 
	and	coalesce(cd_perfil, coalesce(obter_perfil_ativo,0)) = coalesce(obter_perfil_ativo,0) 
	and	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) = coalesce(ie_tipo_convenio_w,0) 
	and	ie_situacao = 'A' 
	and	coalesce(nr_seq_etapa_filtro, coalesce(nr_seq_etapa_filtro_w,0)) = coalesce(nr_seq_etapa_filtro_w,0) 
	order by	coalesce(cd_convenio,0), 
		coalesce(cd_categoria,'0'), 
		coalesce(cd_setor_atendimento,0), 
		coalesce(ie_tipo_atendimento,0), 
		coalesce(ie_tipo_convenio,0), 
		coalesce(nr_seq_classificacao,0), 
		coalesce(cd_perfil,0), 
		coalesce(cd_estabelecimento,0), 
		coalesce(nr_seq_etapa_filtro,0);
		
C02 CURSOR FOR 
	SELECT	coalesce(nr_interno_conta,0), 
		coalesce(nr_atendimento,0), 
		coalesce(cd_convenio_parametro,0), 
		coalesce(cd_categoria_parametro,'0'), 
		coalesce(obter_tipo_convenio(cd_convenio_parametro),0) 
	from	conta_paciente 
	where	nr_seq_protocolo = nr_seq_protocolo_p 
	order by coalesce(nr_atendimento,0), 
		coalesce(nr_interno_conta,0);
	

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from	fatur_etapa_alta 
where	ie_evento = 'I';
 
if (coalesce(qt_existe_w,0) > 0) then 
		 
	ie_evento_w := 'I';
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_interno_conta_w, 
		nr_atendimento_w, 
		cd_convenio_w, 
		cd_categoria_w, 
		ie_tipo_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		select	coalesce(max(ie_tipo_atendimento),0), 
			coalesce(max(cd_estabelecimento),1), 
			coalesce(max(nr_seq_classificacao),0), 
			coalesce(max(obter_setor_atendimento(nr_atendimento)),0) 
		into STRICT	ie_tipo_atendimento_w, 
			cd_estabelecimento_w, 
			nr_seq_classificacao_w, 
			cd_setor_atendimento_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_w;
		 
		select	coalesce(max(ie_regra_restrita_etapa),'N') 
		into STRICT	ie_regra_restrita_etapa_w 
		from	parametro_faturamento 
		where	cd_estabelecimento = cd_estabelecimento_w;
		 
		ie_encontrou_regra_w	:= 'N';
		 
		select	coalesce(obter_conta_paciente_etapa(nr_interno_conta_w, 'C'),0) 
		into STRICT	nr_seq_etapa_filtro_w 
		;
		 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_etapa_w, 
			nr_seq_motivo_dev_w, 
			cd_setor_atend_etapa_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			ie_encontrou_regra_w	:= 'S';
			 
			if (ie_regra_restrita_etapa_w = 'N') then 
				CALL gerar_conta_etapa(nr_interno_conta_w, nm_usuario_p, nr_seq_etapa_w, nr_seq_motivo_dev_w, cd_setor_atend_etapa_w, null);
			end if;
			end;
		end loop;
		close C01;
		 
		if (ie_regra_restrita_etapa_w = 'S') and (ie_encontrou_regra_w = 'S') then 
			CALL gerar_conta_etapa(nr_interno_conta_w, nm_usuario_p, nr_seq_etapa_w, nr_seq_motivo_dev_w, cd_setor_atend_etapa_w, null);
		end if;
		 
		end;
	end loop;
	close C02;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_etapa_envio_interface ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

