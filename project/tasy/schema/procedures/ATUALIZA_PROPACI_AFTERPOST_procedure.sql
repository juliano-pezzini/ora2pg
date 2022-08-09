-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_propaci_afterpost (nr_sequencia_p bigint, ie_operacao_p integer, nm_usuario_p text) AS $body$
DECLARE

 
nr_atend_w		bigint;
dt_entrada_w	timestamp;
dt_proced_w		timestamp;
cd_proced_w		bigint;
cd_convenio_w	integer;
ie_classif_w	varchar(1);
cd_tipo_proced_w	smallint;
vl_parametro_w	varchar(255);


BEGIN 
 
select a.nr_atendimento, 
	 a.dt_entrada_unidade, 
	 a.dt_procedimento, 
	 a.cd_procedimento, 
	 a.cd_convenio, 
	 b.ie_classificacao, 
	 b.cd_tipo_procedimento 
into STRICT	 nr_atend_w, 
	 dt_entrada_w, 
	 dt_proced_w, 
	 cd_proced_w, 
	 cd_convenio_w, 
	 ie_classif_w, 
	 cd_tipo_proced_w 
from procedimento b, 
   procedimento_paciente a 
where a.cd_procedimento = b.cd_procedimento 
 and a.ie_origem_proced = b.ie_origem_proced 
 and a.nr_sequencia = nr_sequencia_p;
 
if (ie_classif_w in ('1','8')) then 
	CALL ATUALIZA_PRECO_PROCEDIMENTO(nr_sequencia_p, cd_convenio_w, nm_usuario_p);
	CALL GERAR_TAXA_SALA_PORTE(nr_atend_w, dt_entrada_w, dt_proced_w, cd_proced_w, nr_sequencia_p, nm_usuario_p);
else 
	CALL ATUALIZA_PRECO_SERVICO(nr_sequencia_p, nm_usuario_p);
end if;
 
vl_parametro_w := obter_parametro(24, 28, '', vl_parametro_w);
 
if (ie_operacao_p = 1) and (vl_parametro_w = 'N') then 
	CALL GERAR_LANCAMENTO_AUTOMATICO(nr_atend_w, '', 34, nm_usuario_p, nr_sequencia_p,null,null,null,null,null);
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_propaci_afterpost (nr_sequencia_p bigint, ie_operacao_p integer, nm_usuario_p text) FROM PUBLIC;
