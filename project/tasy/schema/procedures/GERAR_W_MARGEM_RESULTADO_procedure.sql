-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_margem_resultado ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_convenio_p text, cd_categoria_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_parametro_inicio_w		timestamp;
dt_parametro_fim_w			timestamp;
dt_referencia_w			timestamp;
dt_receita_w			timestamp;
nr_atendimento_w			bigint;
nr_interno_conta_w			bigint;
cd_convenio_parametro_w		integer;
cd_categoria_parametro_w		varchar(10);
cd_estabelecimento_w		integer;
cd_estrutura_conta_w		varchar(5);
ie_gerar_w			varchar(1);
ie_protocolo_w			varchar(2);
vl_procedimento_w			double precision;
vl_material_w			double precision;
vl_custo_w			double precision;
vl_custo_excluido_w		double precision;
vl_receita_w			double precision;
vl_resultado_w			double precision;
cd_convenio_w			varchar(255);
cd_categoria_w			varchar(255);

C01 CURSOR FOR 
SELECT	/*+ index (p PROCONV_PK) */ 
	a.cd_estabelecimento, 
	a.cd_convenio_parametro, 
	b.cd_estrutura_conta, 
	a.cd_categoria_parametro, 
	a.nr_interno_conta, 
	a.nr_atendimento, 
	trunc(a.dt_mesano_referencia,'month') dt_referencia, 
	coalesce(trunc(b.dt_referencia,'month'),trunc(a.dt_mesano_referencia,'month')) dt_receita, 
	CASE WHEN coalesce(p.ie_status_protocolo,9)=2 THEN '10' WHEN coalesce(p.ie_status_protocolo,9)=1 THEN '8' WHEN coalesce(p.ie_status_protocolo,9)=3 THEN '9'  ELSE /* Marcus 05/03/2007 protocolo definitivo em auditoria = 3 */
 		CASE WHEN ie_status_acerto=2 THEN '6'  ELSE CASE WHEN coalesce(t.dt_alta::text, '') = '' THEN '2'  ELSE '4' END  END  END  ie_protocolo, 
	sum(coalesce(vl_procedimento,0) - (coalesce(b.vl_repasse_terceiro,0))) vl_procedimento, 
	sum(coalesce(b.vl_material,0)) vl_material, 
	sum(coalesce(b.vl_custo,0)) vl_custo, 
	sum(coalesce(b.vl_custo_excluido,0)) vl_custo_excluido 
FROM atendimento_paciente t, conta_paciente_resumo b, conta_paciente a
LEFT OUTER JOIN protocolo_convenio p ON (a.nr_seq_protocolo = p.nr_seq_protocolo)
WHERE a.dt_mesano_referencia between dt_parametro_inicio_w and dt_parametro_fim_w and a.nr_interno_conta   	= b.nr_interno_conta and a.nr_atendimento	= (t.nr_atendimento)::numeric  /*and	a.cd_convenio_parametro	= nvl(cd_convenio_p,a.cd_convenio_parametro)*/
 group by 
	a.cd_estabelecimento, 
	a.cd_convenio_parametro, 
	b.cd_estrutura_conta, 
	a.cd_categoria_parametro, 
	a.nr_interno_conta, 
	a.nr_atendimento, 
	trunc(a.dt_mesano_referencia,'month'), 
	coalesce(trunc(b.dt_referencia,'month'),trunc(a.dt_mesano_referencia,'month')), 
	CASE WHEN coalesce(p.ie_status_protocolo,9)=2 THEN '10' WHEN coalesce(p.ie_status_protocolo,9)=1 THEN '8' WHEN coalesce(p.ie_status_protocolo,9)=3 THEN '9'  ELSE CASE WHEN ie_status_acerto=2 THEN '6'  ELSE CASE WHEN coalesce(t.dt_alta::text, '') = '' THEN '2'  ELSE '4' END  END  END;


BEGIN 
 
delete	from	w_margem_resultado 
where	nm_usuario = nm_usuario_p;
 
commit;
 
dt_parametro_inicio_w	:= trunc(dt_referencia_p,'mm');
dt_parametro_fim_w	:= fim_mes(dt_referencia_p);
cd_convenio_w		:= substr(cd_convenio_p,1,255);
cd_categoria_w		:= substr(cd_categoria_p,1,255);
 
cd_convenio_w		:= substr(cd_convenio_w,position('(' in cd_convenio_w),255);
cd_categoria_w		:= substr(cd_categoria_w,position('(' in cd_categoria_w),255);
 
open C01;
loop 
fetch C01 into	 
	cd_estabelecimento_w, 
	cd_convenio_parametro_w, 
	cd_estrutura_conta_w, 
	cd_categoria_parametro_w, 
	nr_interno_conta_w, 
	nr_atendimento_w, 
	dt_referencia_w, 
	dt_receita_w, 
	ie_protocolo_w, 
	vl_procedimento_w, 
	vl_material_w, 
	vl_custo_w, 
	vl_custo_excluido_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_gerar_w	:= 'S';
	 
	vl_receita_w	:= vl_procedimento_w + vl_material_w;
	vl_custo_w	:= vl_custo_w - vl_custo_excluido_w;
	vl_resultado_w	:= vl_receita_w - vl_custo_w;
		 
	if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then 
		ie_gerar_w	:= obter_se_contido(cd_convenio_parametro_w,cd_convenio_w);
	end if;
		 
	if (cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') and (ie_gerar_w = 'S') then 
		ie_gerar_w	:= obter_se_contido(cd_categoria_parametro_w,cd_categoria_w);
	end if;
	 
	if (ie_gerar_w = 'S') then 
		insert into w_margem_resultado( 
			cd_estabelecimento, 
			dt_atualizacao, 
			nm_usuario, 
			dt_referencia, 
			dt_receita, 
			nr_atendimento, 
			nr_interno_conta, 
			cd_convenio, 
			cd_categoria, 
			cd_estrutura_conta, 
			ie_protocolo, 
			vl_receita, 
			vl_custo, 
			vl_resultado) 
		values (	cd_estabelecimento_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			dt_referencia_w, 
			dt_receita_w, 
			nr_atendimento_w, 
			nr_interno_conta_w, 
			cd_convenio_parametro_w, 
			cd_categoria_parametro_w, 
			somente_numero(cd_estrutura_conta_w), 
			ie_protocolo_w, 
			vl_receita_w, 
			vl_custo_w, 
			vl_resultado_w);
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_margem_resultado ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_convenio_p text, cd_categoria_p text, nm_usuario_p text) FROM PUBLIC;

