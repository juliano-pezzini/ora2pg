-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_mat_med_proc ( nr_sequencia_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w		bigint;
cd_procedimento_w	bigint;
cd_setor_atendimento_w	integer;
cd_material_w		bigint;
cd_medico_req_w		bigint;
cd_unidade_medida_w	varchar(30);
qt_material_w		double precision;
ie_atualiza_estoque_w	varchar(1);
cd_local_estoque_w	smallint;
nr_seq_tipo_baixa_w	bigint;
nr_seq_mat_atend_w	bigint;
nr_seq_atepacu_w		bigint;
dt_entrada_unidade_w	timestamp;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
nr_doc_convenio_w	varchar(20);
ie_tipo_guia_w		varchar(2);
qt_procedimento_w		double precision;
dt_procedimento_w		timestamp;
nr_interno_conta_w		bigint;
nr_sequencia_w		bigint;
cd_senha_w		varchar(20);
ie_origem_proced_w	bigint;
ie_param34_w	varchar(1);
ie_param36_w    varchar(1);
ie_gerar_conta	varchar(1);
ie_status_acerto_w  bigint;
nr_seq_lote_w	 material_atend_paciente.nr_seq_lote_fornec%type;

C01 CURSOR FOR
	SELECT	cd_material,
		cd_unidade_medida,
		qt_dose,
		null nr_seq_lote
	from	procedimento_mat_prescr
	where	cd_procedimento	= cd_procedimento_w
	
union all

	SELECT	cd_material,
		cd_unidade_medida,
		qt_material,
		nr_seq_lote
	from	vacina_paciente_material
	where	nr_seq_vacina = nr_sequencia_p;


BEGIN

ie_param34_w := obter_param_usuario(903, 34, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param34_w);
ie_param36_w := obter_param_usuario(903, 36, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param36_w);

if (ie_param36_w = 'L')then
	select	nr_atendimento,
		cd_procedimento,
		coalesce(cd_setor_atendimento,0),
		qt_dose,
		trunc(dt_liberacao,'hh24'),
		ie_origem_proced,
		cd_medico_resp
	into STRICT
		nr_atendimento_w,
		cd_procedimento_w,
		cd_setor_atendimento_w,
		qt_procedimento_w,
		dt_procedimento_w,
		ie_origem_proced_w,
		cd_medico_req_w
	from	paciente_vacina
	where	nr_sequencia	= nr_sequencia_p;
else
	select	nr_atendimento,
		cd_procedimento,
		coalesce(cd_setor_atendimento,0),
		qt_dose,
		trunc(dt_vacina,'hh24'),
		ie_origem_proced,
		cd_medico_resp
	into STRICT
		nr_atendimento_w,
		cd_procedimento_w,
		cd_setor_atendimento_w,
		qt_procedimento_w,
		dt_procedimento_w,
		ie_origem_proced_w,
		cd_medico_req_w
	from	paciente_vacina
	where	nr_sequencia	= nr_sequencia_p;
end if;

if (coalesce(nr_atendimento_w::text, '') = '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262656);
end if;

if (coalesce(dt_procedimento_w::text, '') = '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262657);
end if;

if (cd_setor_atendimento_w = 0) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262658);
end if;

SELECT * FROM obter_convenio_execucao(nr_atendimento_w, clock_timestamp(), cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;
nr_interno_conta_w := 0;

-- Recupera o status da conta
ie_status_acerto_w := coalesce(obter_status_conta_atend_cod(nr_atendimento_w), 0);

if (ie_param34_w = 'S') and (ie_status_acerto_w = 1) then
	select	coalesce(max(nr_interno_conta), 0)
	into STRICT nr_interno_conta_w
	from conta_paciente where nr_atendimento = nr_atendimento_w;
end if;

if (nr_interno_conta_w = 0) then
	select	nextval('conta_paciente_seq')
	into STRICT	nr_interno_conta_w
	;

	insert into conta_paciente(
		nr_atendimento,
		dt_acerto_conta,
		dt_periodo_inicial,
		dt_periodo_final,
		dt_mesano_referencia,
		ie_status_acerto,
		dt_atualizacao,
		nm_usuario,
		cd_convenio_parametro,
		cd_categoria_parametro,
		cd_convenio_calculo,
		cd_categoria_calculo,
		nr_interno_conta,
		cd_estabelecimento,
		nr_protocolo,
		vl_conta,
		vl_desconto)
	Values(	nr_atendimento_w,
		clock_timestamp() + (1/86400),
		clock_timestamp(),
		clock_timestamp() + interval '365 days',
		pkg_date_utils.start_of(clock_timestamp(), 'MONTH', 0),
		1,
		clock_timestamp(),
		'Tasy',
		cd_convenio_w,
		cd_categoria_w,
		cd_convenio_w,
		cd_categoria_w,
		nr_interno_conta_w,
		cd_estabelecimento_p,
		'0',
		0,
		0);
end if;

begin
select	nr_seq_interno,
	dt_entrada_unidade
into STRICT	nr_seq_atepacu_w,
	dt_entrada_unidade_w
from 	atend_paciente_unidade
where 	cd_setor_atendimento = cd_setor_atendimento_w
and 	nr_atendimento = nr_atendimento_w
and 	trunc(dt_procedimento_w,'hh24') between dt_entrada_unidade and coalesce(dt_saida_unidade, clock_timestamp());
exception
when others then
	nr_seq_atepacu_w:= 0;
end;

select 	nextval('procedimento_paciente_seq')
into STRICT	nr_sequencia_w
;

if (nr_seq_atepacu_w = 0) then
	begin
	CALL GERAR_PASSAGEM_SETOR_ATEND(nr_atendimento_w,cd_setor_atendimento_w,clock_timestamp(),'S',nm_usuario_p);

	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from	atend_paciente_unidade
	where	nr_atendimento		= nr_atendimento_w
	and	cd_setor_atendimento	= cd_setor_atendimento_w;

	select	max(dt_entrada_unidade)
	into STRICT	dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_atepacu_w;
	end;
end if;

insert into procedimento_paciente(
	nr_sequencia,
	nr_atendimento,
	dt_entrada_unidade,
	cd_procedimento,
	dt_procedimento,
	qt_procedimento,
	dt_atualizacao,
	nm_usuario,
	cd_setor_atendimento,
	ie_origem_proced,
	nr_seq_atepacu,
	cd_medico_req,
	nr_doc_convenio,
	cd_convenio,
	cd_categoria,
	nr_interno_conta,
	cd_senha)
values (	nr_sequencia_w,
	nr_atendimento_w,
	dt_entrada_unidade_w,
	cd_procedimento_w,
	clock_timestamp(),
	qt_procedimento_w,
	clock_timestamp(),
	nm_usuario_p,
	cd_setor_atendimento_w,
	ie_origem_proced_w,
	nr_seq_atepacu_w,
	cd_medico_req_w,
	nr_doc_convenio_w,
	cd_convenio_w,
	cd_categoria_w,
	nr_interno_conta_w,
	cd_senha_w);

CALL Atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);

/* Lancar a quantidade de materiais associados, conforme a quantidade dos procedimentos lancados */

OPEN	C01;
LOOP
FETCH	C01 into
	cd_material_w,
	cd_unidade_medida_w,
	qt_material_w,
	nr_seq_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (cd_tipo_baixa_p = 0) then
			cd_local_estoque_w	:= null;
		elsif (cd_tipo_baixa_p > 0) then
			begin
			select	max(nr_sequencia),
			max(ie_atualiza_estoque)
			into STRICT	nr_seq_tipo_baixa_w,
				ie_atualiza_estoque_w
			from	tipo_baixa_prescricao
			where	ie_prescricao_devolucao = 'P'
			and	cd_tipo_baixa = cd_tipo_baixa_p;

			if (ie_atualiza_estoque_w = 'N') then
				cd_local_estoque_w	:= null;
			elsif (ie_atualiza_estoque_w = 'S') then
				begin
				select	max(a.cd_local_estoque)
				into STRICT	cd_local_estoque_w
				from	local_estoque a,
					setor_atendimento b
				where	a.cd_local_estoque	= b.cd_local_estoque
				and	b.cd_setor_atendimento	= cd_setor_atendimento_w;

				if (coalesce(cd_local_estoque_w::text, '') = '') then
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(262660);
				end if;
				end;
			end if;

			select	nextval('material_atend_paciente_seq')
			into STRICT	nr_seq_mat_atend_w
			;

			qt_material_w	:= qt_material_w * qt_procedimento_w;

			insert	into material_atend_paciente(
					nr_sequencia,
					nr_atendimento,
					dt_entrada_unidade,
					cd_material,
					dt_atendimento,
					dt_conta,
					cd_unidade_medida,
					qt_material,
					dt_atualizacao,
					nm_usuario,
					cd_convenio,
					cd_categoria,
					nr_doc_convenio,
					ie_tipo_guia,
					dt_prescricao,
					cd_material_prescricao,
					cd_material_exec,
					nr_prescricao,
					nr_sequencia_prescricao,
					cd_acao,
					cd_setor_atendimento,
					qt_executada,
					vl_unitario,
					qt_ajuste_conta,
					ie_valor_informado,
					ie_guia_informada,
					ie_auditoria,
					nm_usuario_original,
					cd_situacao_glosa,
					nr_seq_atepacu,
					nr_seq_cor_exec,
					cd_local_estoque,
					nr_seq_tipo_baixa,
					nr_interno_conta,
					cd_senha,
					nr_seq_lote_fornec)
			values (
					nr_seq_mat_atend_w,
					nr_atendimento_w,
					dt_entrada_unidade_w,
					cd_material_w,
					clock_timestamp(),
					clock_timestamp(),
					cd_unidade_medida_w,
					qt_material_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_convenio_w,
					cd_categoria_w,
					nr_doc_convenio_w,
					ie_tipo_guia_w,
					null,
					cd_material_w,
					cd_material_w,
					null,
					null,
					'1',
					cd_setor_atendimento_w,
					qt_material_w,
					0,
					0,
					'N',
					'N',
					'N',
					nm_usuario_p,
					0,
					nr_seq_atepacu_w,
					231,
					cd_local_estoque_w,
					nr_seq_tipo_baixa_w,
					nr_interno_conta_w,
					cd_senha_w,
					nr_seq_lote_w
					);

			CALL Atualiza_Preco_Material(nr_seq_mat_atend_w, nm_usuario_p);
			end;
		end if;
		end;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_mat_med_proc ( nr_sequencia_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
