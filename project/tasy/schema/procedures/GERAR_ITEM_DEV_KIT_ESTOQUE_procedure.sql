-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_dev_kit_estoque ( nr_devolucao_p bigint, cd_motivo_devolucao_p bigint, nr_seq_kit_estoque_p bigint, nr_atendimento_p bigint, nr_seq_atepacu_p bigint, nm_usuario_p text, cd_local_estoque_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


nr_sequencia_w			bigint;
cd_local_estoque_w		smallint;
cd_material_w			integer;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
qt_material_w			double precision;
cd_unidade_medida_w		varchar(30);
ie_tipo_material_w		varchar(3);
dt_entrada_unidade_w		timestamp;
ie_via_aplicacao_w		varchar(5);
cd_setor_atendimento_w		integer;
cd_perfil_w			bigint;
ds_observacao_w			varchar(2000);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
cd_senha_w			varchar(20);
nr_seq_lote_fornec_w		bigint;
cd_kit_material_w		integer;
cd_local_estoque_ww		smallint;
ds_erro_w			varchar(255);
cd_setor_usuario_w		integer;
qt_existe_w			bigint;
dt_atendimento_w		timestamp;
dt_conta_w			timestamp;
nr_prescricao_w			bigint;
ie_local_estoque_geracao_w	varchar(1);
ie_consiste_devol_w		varchar(1);
qt_mat_saldo_w			double precision;
nr_sequencia_prescricao_w	integer;
nr_seq_atendimento_w		bigint;

c01 CURSOR FOR
	SELECT	a.cd_material,
		a.qt_material,
		d.cd_unidade_medida_consumo,
		d.ie_via_aplicacao,
		d.ie_tipo_material,
		a.nr_seq_lote_fornec,
		b.cd_kit_material
	from	material d,
		kit_estoque b,
		kit_estoque_comp a
	where 	b.nr_sequencia = a.nr_seq_kit_estoque
	and 	a.cd_material = d.cd_material
	and 	a.nr_seq_kit_estoque = nr_seq_kit_estoque_p
	and 	(b.dt_utilizacao IS NOT NULL AND b.dt_utilizacao::text <> '')
	and 	coalesce(nr_seq_kit_estoque_p,0) > 0
	and 	d.ie_situacao = 'A';


BEGIN

begin
select	count(*)
into STRICT	qt_existe_w
from	material_em_devolucao_v
where	nr_kit_estoque = nr_seq_kit_estoque_p
and	nr_atendimento = nr_atendimento_p
having sum(qt_material) > 0;
exception
	when others then
		qt_existe_w := 0;
end;

if (coalesce(qt_existe_w, 0) = 0) then
	goto final;
end if;

cd_perfil_w			:= obter_perfil_ativo;

-- Criar parametros na Devolucao para substituir esses da Execucao.
ie_local_estoque_geracao_w 	:= coalesce(obter_valor_param_usuario(24, 314, cd_perfil_w, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento),'N');
ie_consiste_devol_w		:= coalesce(obter_valor_param_usuario(24, 317, cd_perfil_w, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento),'N');

ds_observacao_w:= WHEB_MENSAGEM_PCK.get_texto(306004,'CD_PERFIL_W='|| CD_PERFIL_W ||';NR_SEQ_KIT_ESTOQUE_P='|| NR_SEQ_KIT_ESTOQUE_P);
			/*Perfil: #@CD_PERFIL_W#@ Kit de estoque: #@NR_SEQ_KIT_ESTOQUE_P#@*/

			
cd_setor_usuario_w := wheb_usuario_pck.get_cd_setor_atendimento;
if (coalesce(cd_setor_usuario_w,0) <= 0) then
	cd_setor_usuario_w := null;
end if;

select 	dt_entrada_unidade,
	cd_setor_atendimento,
	obter_convenio_atendimento(nr_atendimento),
	substr(obter_categoria_atendimento(nr_atendimento),1,10)
into STRICT	dt_entrada_unidade_w,
	cd_setor_atendimento_w,
	cd_convenio_w,
	cd_categoria_w
from 	atend_paciente_unidade
where 	nr_atendimento = nr_atendimento_p
and 	nr_seq_interno = nr_seq_atepacu_p;

begin
select 	nr_doc_convenio,
	ie_tipo_guia,
	cd_senha
into STRICT	nr_doc_convenio_w,
	ie_tipo_guia_w,
	cd_senha_w
from 	atend_categoria_convenio
where 	nr_atendimento = nr_atendimento_p
and 	dt_inicio_vigencia = 	(SELECT max(dt_inicio_vigencia)
				 from 	atend_categoria_convenio b
			         where 	nr_atendimento = nr_atendimento_p);
exception
	when others then
		nr_doc_convenio_w	:= '';
		cd_senha_w		:= '';
		ie_tipo_guia_w		:= '';
end;

cd_local_estoque_w	:= cd_local_estoque_p;

ds_erro_w  := 	'';

select	max(dt_atendimento),
	max(dt_conta)
into STRICT	dt_atendimento_w,
	dt_conta_w
from	material_atend_paciente
where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
and	nr_atendimento = nr_atendimento_p;

open c01;
loop
fetch c01 into
	cd_material_w,
	qt_material_w,
	cd_unidade_medida_w,
	ie_via_aplicacao_w,
	ie_tipo_material_w,
	nr_seq_lote_fornec_w,
	cd_kit_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	if (coalesce(ds_erro_w, 'X') = 'X') then
		begin
		
		if (ie_consiste_devol_w = 'S') then
			begin
			select	sum(qt_material)
			into STRICT	qt_mat_saldo_w
			from	material_atend_paciente
			where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
			and	nr_atendimento = nr_atendimento_p
			and 	cd_material = cd_material_w;
			exception
				when others then
					qt_mat_saldo_w := 1;
			end;
			
			if (qt_mat_saldo_w <= qt_material_w) then
				goto final;
			else
				qt_material_w:= qt_mat_saldo_w;
			end if;
		end if;
		
		begin
		select	coalesce(max(nr_prescricao),0)
		into STRICT	nr_prescricao_w
		from	material_atend_paciente
		where	nr_seq_kit_estoque = nr_seq_kit_estoque_p
		and	nr_atendimento = nr_atendimento_p
		having	sum(qt_material) > 0;
		exception
			when others then
				nr_prescricao_w := 0;
		end;
		
		cd_local_estoque_ww		:= cd_local_estoque_w;
		
		if (ie_local_estoque_geracao_w = 'S') then
			select 	coalesce(max(cd_local_estoque),cd_local_estoque_ww)
			into STRICT	cd_local_estoque_ww
			from	material_atend_paciente
			where	nr_seq_kit_estoque  = nr_seq_kit_estoque_p
			and	nr_atendimento      = nr_atendimento_p
			and 	cd_material	    = cd_material_w
			and 	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '');
		end if;
		
		if (nr_prescricao_w > 0) then
			select	coalesce(max(a.nr_sequencia),0),
				coalesce(max(b.nr_sequencia),0)
			into STRICT	nr_sequencia_prescricao_w,
				nr_seq_atendimento_w
			from	prescr_material a,
				material_atend_paciente b
			where	b.nr_seq_kit_estoque = nr_seq_kit_estoque_p
			and	a.cd_material = cd_material_w
			and	a.nr_prescricao = nr_prescricao_w
			and	a.nr_sequencia = b.nr_sequencia_prescricao
			and	a.nr_prescricao = b.nr_prescricao;
			
			if (coalesce(nr_seq_atendimento_w, 0) = 0) then
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_atendimento_w
				from	material_atend_paciente a
				where	a.nr_atendimento = nr_atendimento_p
				and	a.nr_seq_kit_estoque = nr_seq_kit_estoque_p
				and	coalesce(a.cd_material_exec, a.cd_material) = cd_material_w
				and	a.nr_prescricao = nr_prescricao_w;
			end if;
		else
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_atendimento_w
			from	material_atend_paciente
			where	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
			and	nr_seq_kit_estoque = nr_seq_kit_estoque_p
			and	nr_atendimento = nr_atendimento_p;
		end if;
		
		begin
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	item_devolucao_material_pac
		where	nr_devolucao = nr_devolucao_p;
		
		insert into item_devolucao_material_pac(
			nr_devolucao,
			nr_sequencia,
			cd_material,
			dt_atendimento,
			cd_local_estoque,
			cd_unidade_medida,
			cd_motivo_devolucao,
			dt_atualizacao,
			nm_usuario_devol,
			qt_material,
			nr_prescricao,
			nr_sequencia_prescricao,
			ie_tipo_baixa_estoque,
			dt_entrada_unidade,
			nr_seq_atendimento,
			nm_usuario,
			nr_kit_estoque)
		values (	nr_devolucao_p,
			nr_sequencia_w,
			cd_material_w,
			dt_atendimento_w,
			cd_local_estoque_ww,
			cd_unidade_medida_w,
			cd_motivo_devolucao_p,
			clock_timestamp(),
			nm_usuario_p,
			qt_material_w,
			CASE WHEN nr_prescricao_w=0 THEN null  ELSE nr_prescricao_w END ,
			CASE WHEN nr_sequencia_prescricao_w=0 THEN null  ELSE nr_sequencia_prescricao_w END ,
			0,
			dt_entrada_unidade_w,
			nr_seq_atendimento_w,
			nm_usuario_p,
			nr_seq_kit_estoque_p);
		
		exception
			when 	others then
			begin
			ds_erro_w  := substr(sqlerrm,1,255);
			nr_sequencia_w := 0;
			end;
		end;
		end;
	end if;
	end;
end loop;
close c01;

/* colocado por fabio e jonas, estorna o lancamento dos itens, caso em que o altimo item nao tenha estoque, por exemplo*/

if (coalesce(ds_erro_w, 'X') <> 'X') then
	rollback;
end if;

<<final>>

if (coalesce(qt_existe_w,0) = 0) then
	ds_retorno_p := Wheb_mensagem_pck.get_Texto(306006); /*'Este kit de estoque nao esta sendo utilizado neste atendimento !';*/
elsif (coalesce(ds_erro_w, 'X') <> 'X') then
	ds_retorno_p	:= substr(ds_erro_w,1,255);
elsif (coalesce(nr_sequencia_w,0)	> 0) then
	ds_retorno_p	:= Wheb_mensagem_pck.get_Texto(306008); /*'Kit de estoque devolvido com sucesso!!';*/
else
	ds_retorno_p	:= Wheb_mensagem_pck.get_Texto(306010); /*'Kit de estoque ja foi devolvido!!';*/
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_dev_kit_estoque ( nr_devolucao_p bigint, cd_motivo_devolucao_p bigint, nr_seq_kit_estoque_p bigint, nr_atendimento_p bigint, nr_seq_atepacu_p bigint, nm_usuario_p text, cd_local_estoque_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;
