-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE int_disp_mat_atend_pac ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(02);
cd_senha_w			varchar(20);
cd_setor_atendimento_w		integer;
dt_entrada_unidade_w		timestamp;
dt_entrada_unidade_atend_w	timestamp;
nr_seq_interno_w		bigint;
nr_seq_interno_atend_w		bigint;
dt_atendimento_w		timestamp;
cd_unidade_medida_w		varchar(30);
cd_material_w			integer;
qt_material_w			double precision;
cd_setor_w			integer;
ie_tipo_cobranca_w		varchar(1);
cd_local_estoque_w		smallint;
cd_estabelecimento_w		integer;
cd_perfil_w			bigint;
cd_funcao_w			bigint;
ds_observacao_w			varchar(2000);

c01 CURSOR FOR 
	SELECT	cd_unidade_medida, 
		cd_material, 
		qt_material, 
		cd_setor, 
		ie_tipo_cobranca 
	from	w_int_disp_auto 
	where	nr_atendimento = nr_atendimento_p;


BEGIN 
 
begin 
dt_atendimento_w	:= clock_timestamp();
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w		:= obter_perfil_ativo;
cd_funcao_w		:= wheb_usuario_pck.get_cd_funcao;
cd_local_estoque_w := obter_param_usuario(147, 4, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, cd_local_estoque_w);
exception 
	when others then 
	dt_atendimento_w	:= clock_timestamp();
	cd_estabelecimento_w	:= 1;
	cd_perfil_w		:= 0;
	cd_funcao_w		:= 0;
	cd_local_estoque_w	:= 0;
end;
 
select	obter_setor_atendimento(nr_atendimento_p) 
into STRICT	cd_setor_atendimento_w
;
 
ds_observacao_w :=	substr(wheb_mensagem_pck.get_texto(302174,'CD_PERFIL_ATIVO=' || cd_perfil_w || 
								';CD_FUNCAO_ATIVA=' || cd_funcao_w || 
								';CD_SETOR=' || cd_setor_atendimento_w || 
								';CD_SETOR_ATENDIMENTO=' || obter_setor_usuario(nm_usuario_p)),1,255);
 
if (coalesce(cd_local_estoque_w,0) = 0) then 
	cd_local_estoque_w := obter_local_estoque_setor(obter_setor_usuario(nm_usuario_p),cd_estabelecimento_w);
end if;
 
SELECT * FROM obter_convenio_execucao(nr_atendimento_p, dt_atendimento_w, cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
 
select	coalesce(max(a.dt_entrada_unidade),clock_timestamp()) 
into STRICT	dt_entrada_unidade_atend_w 
from 	tipo_acomodacao b, 
	setor_atendimento c, 
	atend_paciente_unidade a 
where 	a.cd_tipo_acomodacao = b.cd_tipo_acomodacao 
and  	a.cd_setor_atendimento = c.cd_setor_atendimento 
and  	nr_atendimento = nr_atendimento_p;
 
select	max(a.nr_seq_interno) 
into STRICT	nr_seq_interno_atend_w 
from 	tipo_acomodacao b, 
	setor_atendimento c, 
	atend_paciente_unidade a 
where 	a.cd_tipo_acomodacao = b.cd_tipo_acomodacao 
and  	a.cd_setor_atendimento = c.cd_setor_atendimento 
and  	nr_atendimento = nr_atendimento_p;
 
open c01;
loop 
fetch c01 into 
	cd_unidade_medida_w, 
	cd_material_w, 
	qt_material_w, 
	cd_setor_w, 
	ie_tipo_cobranca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	select	coalesce(max(a.dt_entrada_unidade),clock_timestamp()) 
	into STRICT	dt_entrada_unidade_w 
	from 	tipo_acomodacao b, 
		setor_atendimento c, 
		atend_paciente_unidade a 
	where 	a.cd_tipo_acomodacao = b.cd_tipo_acomodacao 
	and  	a.cd_setor_atendimento = c.cd_setor_atendimento 
	and  	nr_atendimento = nr_atendimento_p 
	and 	a.cd_setor_atendimento = coalesce(cd_setor_atendimento_w,cd_setor_w);
	 
	select	max(a.nr_seq_interno) 
	into STRICT	nr_seq_interno_w 
	from 	tipo_acomodacao b, 
		setor_atendimento c, 
		atend_paciente_unidade a 
	where 	a.cd_tipo_acomodacao = b.cd_tipo_acomodacao 
	and  	a.cd_setor_atendimento = c.cd_setor_atendimento 
	and  	nr_atendimento = nr_atendimento_p 
	and 	a.cd_setor_atendimento = coalesce(cd_setor_atendimento_w,cd_setor_w);
	 
	if (coalesce(ie_tipo_cobranca_w,'C') = 'C') then 
		begin 
		select	nextval('material_atend_paciente_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		insert into material_atend_paciente( 
			nr_sequencia, 
			nr_atendimento, 
			dt_entrada_unidade, 
			dt_atendimento, 
			cd_unidade_medida, 
			qt_material, 
			dt_atualizacao, 
			cd_material, 
			cd_setor_atendimento, 
			cd_local_estoque, 
			qt_executada, 
			ds_observacao, 
			nm_usuario, 
			nr_seq_atepacu, 
			cd_acao, 
			nr_doc_convenio, 
			cd_convenio, 
			cd_categoria, 
			ie_tipo_guia, 
			ie_auditoria, 
			ie_guia_informada, 
			qt_ajuste_conta, 
			cd_material_exec) 
		values (	nr_sequencia_w, 
			nr_atendimento_p, 
			coalesce(dt_entrada_unidade_w,dt_entrada_unidade_atend_w), 
			dt_atendimento_w, 
			cd_unidade_medida_w, 
			qt_material_w, 
			clock_timestamp(), 
			cd_material_w, 
			coalesce(cd_setor_atendimento_w,cd_setor_w), 
			cd_local_estoque_w, 
			qt_material_w, 
			ds_observacao_w, 
			nm_usuario_p, 
			coalesce(nr_seq_interno_w,nr_seq_interno_atend_w), 
			'1', 
			nr_doc_convenio_w, 
			cd_convenio_w, 
			cd_categoria_w, 
			ie_tipo_guia_w, 
			'N', 
			'N', 
			0, 
			CASE WHEN coalesce(cd_material_w,0)=0 THEN null  ELSE cd_material_w END );
 
		CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
		end;
	end if;
	if (coalesce(ie_tipo_cobranca_w,'C') = 'D') then 
		begin 
		select	nextval('material_atend_paciente_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		insert into material_atend_paciente( 
			nr_sequencia, 
			nr_atendimento, 
			dt_entrada_unidade, 
			dt_atendimento, 
			cd_unidade_medida, 
			qt_material, 
			dt_atualizacao, 
			cd_material, 
			cd_setor_atendimento, 
			cd_local_estoque, 
			qt_executada, 
			ds_observacao, 
			nm_usuario, 
			nr_seq_atepacu, 
			cd_acao, 
			nr_doc_convenio, 
			cd_convenio, 
			cd_categoria, 
			ie_tipo_guia, 
			ie_auditoria, 
			ie_guia_informada, 
			qt_ajuste_conta, 
			cd_material_exec) 
		values (	nr_sequencia_w, 
			nr_atendimento_p, 
			coalesce(dt_entrada_unidade_w,dt_entrada_unidade_atend_w), 
			dt_atendimento_w, 
			cd_unidade_medida_w, 
			(0 - qt_material_w), 
			clock_timestamp(), 
			cd_material_w, 
			coalesce(cd_setor_atendimento_w,cd_setor_w), 
			cd_local_estoque_w, 
			qt_material_w, 
			ds_observacao_w, 
			nm_usuario_p, 
			coalesce(nr_seq_interno_w,nr_seq_interno_atend_w), 
			'2', 
			nr_doc_convenio_w, 
			cd_convenio_w, 
			cd_categoria_w, 
			ie_tipo_guia_w, 
			'N', 
			'N', 
			0, 
			CASE WHEN coalesce(cd_material_w,0)=0 THEN null  ELSE cd_material_w END );
 
		CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
		end;
	end if;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE int_disp_mat_atend_pac ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
