-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_gasto_atendimento ( nr_sequencia_p bigint, ie_proc_mat_p bigint, nr_atend_dest_p bigint, ie_prescricao_p text, ie_manter_data_unid_orig_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atepacu_w			bigint;
nr_seq_atepacu_ww		bigint;
nr_laudo_w			bigint;
cd_setor_atend_w			integer;
cd_convenio_w			integer;
dt_entrada_unidade_w		timestamp;
cd_procedimento_orig_w		bigint;
ie_origem_proced_orig_w		bigint;
ie_origem_proced_dest_w		bigint;
ie_tipo_conv_orig_w		smallint;
ie_tipo_conv_dest_w		smallint;
nr_laudo_orig_w			bigint;
cd_pessoa_fisica_w		varchar(10);
dt_entrada_w			timestamp;
dt_alta_w				timestamp;
dt_alta_orig_w			timestamp;
dt_alta_dest_w			timestamp;
dt_procedimento_w			timestamp;
dt_atendimento_w			timestamp;
nr_atend_origem_w			bigint;
cd_motivo_exc_conta_orig_w		varchar(10);
dt_passagem_w			timestamp;
cd_estabelecimento_w		bigint;
ie_gerar_passagem_alta_w		varchar(5);
nr_seq_atepacu_www		bigint;
qt_registro_w			bigint;
dt_fim_conta_w			timestamp;
nr_seq_proc_interno_w		bigint;
nr_interno_conta_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_convenio_sus_w		integer := null;
cd_categoria_sus_w		varchar(10) := '';
ie_transfere_gasto_sus_w		varchar(15) := 'N';
var_permite_maior_alta_w		varchar(1);
nr_cirurgia_w			bigint;
ie_tipo_atendimento_w		smallint;
cd_estab_usuario_w		bigint;
ie_transf_gastos_aih_w		varchar(15) := 'N';
dt_inicial_aih_w			timestamp;
dt_final_aih_w			timestamp;
qt_proc_dia_aih_w			bigint := 0;
ie_regra_usu_conv_w		varchar(15) := 'N';
cd_medico_executor_w		varchar(10);
cd_categoria_w			varchar(10);
ie_acao_excesso_w		varchar(14);
qt_excedida_w			double precision;
ds_erro_w			varchar(255);
cd_motivo_exc_conta_w		smallint;
cd_convenio_glosa_w		bigint;
cd_categoria_glosa_w		bigint;
ie_consiste_paciente_w		varchar(15) := 'N';
qt_reg_pac_w			bigint;
cd_convenio_excesso_w		integer;
cd_categoria_excesso_w		varchar(10);
nr_prescricao_w				bigint;

c01 CURSOR FOR
	SELECT	nr_laudo
	from	laudo_paciente
	where	nr_seq_proc	= nr_sequencia_p;


BEGIN

begin
cd_estab_usuario_w := wheb_usuario_pck.get_cd_estabelecimento;
exception
when others then
	cd_estab_usuario_w := 0;
end;

ie_transf_gastos_aih_w 		:= coalesce(obter_valor_param_usuario(1123,174,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_regra_usu_conv_w		:= coalesce(obter_valor_param_usuario(1123,175,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_consiste_paciente_w		:= coalesce(obter_valor_param_usuario(1123,192,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');


select	max(cd_pessoa_fisica),
	max(dt_entrada),
	max(cd_estabelecimento),
	max(dt_alta),
	max(dt_fim_conta),
	max(ie_tipo_atendimento)
into STRICT	cd_pessoa_fisica_w,
	dt_entrada_w,
	cd_estabelecimento_w,
	dt_alta_w,
	dt_fim_conta_w,
	ie_tipo_atendimento_w
from	atendimento_paciente
where	nr_atendimento	= nr_atend_dest_p;


if (dt_fim_conta_w IS NOT NULL AND dt_fim_conta_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182138,'DT_FIM_CONTA_P='||PKG_DATE_FORMATERS.TO_VARCHAR(dt_fim_conta_w, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p));
	/*O atendimento ja esta fechado (final atendimento = DT_FIM_CONTA_P), nao pode ser transferido!*/

end if;

select	coalesce(max(ie_gerar_passagem_alta), 'S')
into STRICT	ie_gerar_passagem_alta_w
from	parametro_atendimento
where	cd_estabelecimento		= cd_estabelecimento_w;

select	coalesce(max(ie_transfere_gasto_sus), 'N')
into STRICT	ie_transfere_gasto_sus_w
from	parametro_faturamento
where	cd_estabelecimento		= cd_estabelecimento_w;

if (ie_proc_mat_p = 1) then
	begin
	
	select 	max(a.cd_setor_atendimento),
		max(a.dt_entrada_unidade),
		max(a.cd_convenio),
		max(a.cd_procedimento),
		max(a.ie_origem_proced),
		max(b.ie_tipo_convenio),
		max(a.dt_procedimento),
		max(a.nr_atendimento),
		max(a.cd_motivo_exc_conta),
		max(a.nr_seq_atepacu),
		max(a.nr_seq_proc_interno),
		max(a.nr_interno_conta),
		max(a.nr_cirurgia),
		max(a.cd_medico_executor),
		max(a.cd_categoria)
	into STRICT	cd_setor_atend_w,
		dt_entrada_unidade_w,
		cd_convenio_w,
		cd_procedimento_orig_w,
		ie_origem_proced_orig_w,
		ie_tipo_conv_orig_w,
		dt_procedimento_w,
		nr_atend_origem_w,
		cd_motivo_exc_conta_orig_w,
		nr_seq_atepacu_www,
		nr_seq_proc_interno_w,
		nr_interno_conta_w,
		nr_cirurgia_w,
		cd_medico_executor_w,
		cd_categoria_w
	from	convenio b,
		procedimento_paciente a
	where	a.cd_convenio	= b.cd_convenio
	and	a.nr_sequencia 	= nr_sequencia_p;

	if (ie_tipo_conv_orig_w = 3) and (ie_tipo_atendimento_w = 1) and (coalesce(ie_transf_gastos_aih_w,'N') = 'S') then
		begin
		
		begin
		select	coalesce(max(dt_inicial),dt_entrada_w),
			coalesce(max(dt_final),dt_alta_w)
		into STRICT	dt_inicial_aih_w,
			dt_final_aih_w
		from	sus_aih_unif a
		where	nr_atendimento = nr_atend_dest_p;
		exception
		when others then
			dt_inicial_aih_w	:= dt_entrada_w;
			dt_final_aih_w		:= dt_alta_w;
		end;
		
		if	((establishment_timezone_utils.startofday(dt_inicial_aih_w) > establishment_timezone_utils.startofday(dt_procedimento_w)) or (establishment_timezone_utils.startofday(dt_final_aih_w) < establishment_timezone_utils.startofday(dt_procedimento_w))) then
			begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(182140,'DT_PROCEDIMENTO_P='|| dt_procedimento_w ||
								';DT_INICIAL_P='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_inicial_aih_w, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p) ||
								';DT_FINAL_P='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_final_aih_w, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p));
			/*A data do lancamento: DT_PROCEDIMENTO_W, e menor que DT_INICIAL_AIH_W, ou maior que DT_FINAL_AIH_W, que e o periodo da AIH do atendimento de destino.*/

			end;
		end if;
		
		end;				
	elsif (dt_procedimento_w < dt_entrada_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(182143,'DT_PROCEDIMENTO_P='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_procedimento_w, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p) ||
							';DT_ENTRADA_P='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_entrada_w, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p));
		/*A data do lancamento '||to_char(dt_procedimento_w,'dd/mm/yyyy hh24:mi:ss')||' e menor que a entrada do atendimento '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss')*/

	end if;
	
	if (ie_tipo_conv_orig_w = 3) and (ie_tipo_atendimento_w = 1) then
		begin
		if (coalesce(ie_regra_usu_conv_w,'N') = 'S') then
			begin
						
			SELECT * FROM obter_regra_qtde_proc_exec(nr_atend_dest_p, cd_procedimento_orig_w, ie_origem_proced_orig_w, 0, dt_procedimento_w, cd_medico_executor_w, ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w, nr_seq_proc_interno_w, cd_categoria_w, NULL, 0, nr_cirurgia_w, null, cd_setor_atend_w, null) INTO STRICT ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w;
			
			if (ie_acao_excesso_w = 'E') then
				if (qt_excedida_w   > 0) then			
					
					select	coalesce(max(cd_motivo_exc_conta),12)
					into STRICT	cd_motivo_exc_conta_w
					from	parametro_faturamento
					where	cd_estabelecimento	= cd_estabelecimento_w;
															--302543 - 'Excluido pela regra de uso da funcao Cadastro de Convenios'
					CALL excluir_matproc_conta(nr_sequencia_p, nr_interno_conta_w, cd_motivo_exc_conta_w, wheb_mensagem_pck.get_texto(302543), 'P', nm_usuario_p);				
						
				end if;
				
			elsif (ie_acao_excesso_w = 'P') then
				if (qt_excedida_w   > 0) then
					
					SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_w, cd_convenio_w, '', dt_procedimento_w, cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;
						
					cd_convenio_w := coalesce(cd_convenio_glosa_w,cd_convenio_w);
					cd_categoria_w:= coalesce(cd_categoria_glosa_w,cd_categoria_w);
					
				end if;
			elsif (ie_acao_excesso_w = 'C') then
				if (qt_excedida_w   > 0) and
					(cd_convenio_excesso_w IS NOT NULL AND cd_convenio_excesso_w::text <> '' AND cd_categoria_excesso_w IS NOT NULL AND cd_categoria_excesso_w::text <> '') then
					
					cd_convenio_w	:= coalesce(cd_convenio_excesso_w, cd_convenio_w);
					cd_categoria_w	:= coalesce(cd_categoria_excesso_w, cd_categoria_w);
					
				end if;
			end if;
				
			end;
		end if;
		if (coalesce(ie_consiste_paciente_w,'N') = 'S') then
			begin
			
			select	count(*)
			into STRICT	qt_reg_pac_w
			from	atendimento_paciente a
			where	a.nr_atendimento = nr_atend_origem_w
			and	a.cd_pessoa_fisica = cd_pessoa_fisica_w;
			
			if (qt_reg_pac_w = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(201032);
				/*O paciente do atendimento de destino e diferendo do paciente do atendimento de origem.*/

			end if;			
			end;
		end if;
		end;
	end if;
	
	end;
else
	select	max(a.cd_setor_atendimento),
		max(a.dt_entrada_unidade),
		max(a.cd_convenio),
		max(b.ie_tipo_convenio),
		max(a.dt_atendimento),
		max(a.nr_atendimento),
		max(a.nr_seq_atepacu),
		max(a.nr_cirurgia)
	into STRICT	cd_setor_atend_w,
		dt_entrada_unidade_w,
		cd_convenio_w,
		ie_tipo_conv_orig_w,
		dt_atendimento_w,
		nr_atend_origem_w,
		nr_seq_atepacu_www,
		nr_cirurgia_w
	from 	convenio b,
		material_atend_paciente a
	where	a.cd_convenio	= b.cd_convenio
	and 	a.nr_sequencia 	= nr_sequencia_p;

	/*if	(dt_atendimento_w < dt_entrada_w) then
		'A data do lancamento '||to_char(dt_atendimento_w,'dd/mm/yyyy hh24:mi:ss')||' e menor que a entrada do atendimento '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss');
	end if;*/
end if;

/* Obter tipo de convenio de destino */

select	coalesce(max(b.ie_tipo_convenio),0)
into STRICT	ie_tipo_conv_dest_w	
from	convenio b,
	atend_categoria_convenio a
where	a.cd_convenio	= b.cd_convenio
and	a.nr_seq_interno	=
	(SELECT	max(x.nr_seq_interno)
	from	atend_categoria_convenio x
	where	x.nr_atendimento = nr_atend_dest_p);

/* Valida se pode transferir para convenio de destino */

if	((ie_tipo_conv_orig_w		= 3 and
	ie_tipo_conv_dest_w 		<> 3) or (ie_tipo_conv_orig_w 		<> 3 and
	ie_tipo_conv_dest_w 		= 3)) and (coalesce(cd_motivo_exc_conta_orig_w::text, '') = '') and (coalesce(ie_transfere_gasto_sus_w,'N') = 'N')	then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182156);
	/*Transferencia entre atendimentos SUS e Convenios, nao e permitido !*/

end if;

if (ie_proc_mat_p 	= 1) and (ie_tipo_conv_orig_w	 = 3) and (ie_tipo_conv_dest_w =  3) and (ie_origem_proced_orig_w	<> 7) and (coalesce(cd_motivo_exc_conta_orig_w::text, '') = '') and (coalesce(ie_transfere_gasto_sus_w,'N') = 'N') then
	begin
	select	coalesce(max(b.ie_origem_proced),ie_origem_proced_orig_w)
	into STRICT	ie_origem_proced_dest_w
	from	procedimento_paciente b
	where	b.nr_sequencia	=
		(SELECT 	max(x.nr_sequencia)
			from 	procedimento_paciente x
			where 	x.nr_atendimento = nr_atend_dest_p
			and	coalesce(x.cd_motivo_exc_conta::text, '') = '')
	and	coalesce(b.cd_motivo_exc_conta::text, '') = '';
	if (ie_origem_proced_dest_w <> ie_origem_proced_orig_w) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(182157);
		/*Transferencia entre atendimentos nao permitida. Existe algum procedimento(s) que nao pertence a tabela do SUS no atendimento de origem!*/

	end if;
	end;
end if;

if (coalesce(nr_seq_atepacu_www,0)	<> 0) then /* OS101608 Buscar a dt entrada unidade pela atend_paciente_unidade*/
	select	dt_entrada_unidade
	into STRICT	dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_seq_interno	= nr_seq_atepacu_www;
	
end if;

if (dt_entrada_w > dt_entrada_unidade_w) then
	dt_entrada_unidade_w	:= dt_entrada_w;
end if;

if (dt_entrada_unidade_w > clock_timestamp()) or (ie_manter_data_unid_orig_p = 'S') then /* Rafael 1/3/8 -> Tratar prescrioes futuras */
	dt_passagem_w := dt_entrada_unidade_w;
else
	dt_passagem_w := clock_timestamp();
end if;
						
if (dt_entrada_unidade_w > clock_timestamp()) or 		/* Felipe Martini OS101608*/
	(ie_manter_data_unid_orig_p = 'S') then
	
	dt_passagem_w		:= dt_passagem_w - 1/86400;
	qt_registro_w		:= 1;
	while(qt_registro_w	> 0) loop
	
		dt_passagem_w	:= dt_passagem_w + 1/86400;
		
		select	count(*)
		into STRICT	qt_registro_w
		from	atend_paciente_unidade
		where	nr_atendimento		= nr_atend_dest_p
		and	cd_setor_atendimento	<> cd_setor_atend_w
		and	dt_entrada_unidade	= dt_passagem_w;
	end loop;

end if;

/* Rafael em 21/2/8 OS76992 */

begin
select	coalesce(max(nr_seq_interno),0)
into STRICT	nr_seq_atepacu_w
from 	atend_paciente_unidade
where 	cd_setor_atendimento	= cd_setor_atend_w
and	nr_atendimento 		= nr_atend_dest_p
--and	dt_entrada_unidade_w between dt_entrada_unidade and nvl(dt_saida_unidade, sysdate);

--and	dt_entrada_unidade_w between dt_entrada_unidade and nvl(dt_saida_unidade, dt_passagem_w);
and	dt_passagem_w between dt_entrada_unidade and coalesce(dt_saida_unidade, dt_passagem_w);
exception
when others then
	nr_seq_atepacu_w := 0;
end;		

if (coalesce(nr_seq_atepacu_w,0) = 0) then /* Rafael em 21/2/8 OS76992 incluido o if */

	/* Rafael em 3/4/8 OS80263;
	Gerar_Passagem_Setor_Atend(nr_atend_dest_p, cd_setor_atend_w, dt_entrada_unidade_w, 'S', nm_usuario_p);*/
	
	if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') 	 and /*Felipe Martini OS100814*/
		(ie_gerar_passagem_alta_w = 'N') and (dt_passagem_w	> dt_alta_w) then
		dt_passagem_w	:= dt_alta_w;
	end if;
	CALL Gerar_Passagem_Setor_Atend(nr_atend_dest_p, cd_setor_atend_w, dt_passagem_w, 'S', nm_usuario_p);
	
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_ww
	from	atend_paciente_unidade
	where	nr_atendimento 			= nr_atend_dest_p
	and	cd_setor_atendimento		= cd_setor_atend_w
	--and	establishment_timezone_utils.startofday(dt_entrada_unidade)	= establishment_timezone_utils.startofday(dt_entrada_unidade_w);
	and	establishment_timezone_utils.startofday(dt_entrada_unidade)	= establishment_timezone_utils.startofday(dt_passagem_w);	
	
end if;

if (nr_seq_atepacu_w = 0) and (nr_seq_atepacu_ww > 0) then
	
	select	dt_entrada_unidade
	into STRICT	dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_atepacu_ww;
	
	nr_seq_atepacu_w := nr_seq_atepacu_ww;
	
elsif (nr_seq_atepacu_w > 0) then

	select	dt_entrada_unidade
	into STRICT	dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_seq_interno = nr_seq_atepacu_w;

end if;
	
if (ie_proc_mat_p = 1) then

	Select	coalesce(max(b.nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	procedimento_paciente b
	where	b.nr_sequencia = nr_sequencia_p
	and		coalesce(b.nr_prescricao,0) <> 0;
	
	if (nr_prescricao_w > 0) and (ie_prescricao_p = 'S') then
		
		update	prescr_medica
		set		nr_atendimento		= nr_atend_dest_p,
				cd_pessoa_fisica	= cd_pessoa_fisica_w,
				IE_RECEM_NATO		= 'N',
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
		where	nr_prescricao	= nr_prescricao_w;
		
		update prescr_mat_alteracao
		set	   nr_atendimento = nr_atend_dest_p
		where  nr_prescricao  = nr_prescricao_w;
		
		
	end if;
		
	
	if (ie_prescricao_p = 'S') and (coalesce(nr_cirurgia_w,0) > 0) then
		insert into w_transf_cirurgia_atend(nr_seq_item,  ie_tipo_item, nr_atend_origem, nr_atend_destino, nr_cirurgia, dt_atualizacao, nm_usuario)
				values (nr_sequencia_p, 'P', nr_atend_origem_w, nr_atend_dest_p, nr_cirurgia_w , clock_timestamp(), nm_usuario_p);
	end if;
	
	if (coalesce(ie_transfere_gasto_sus_w,'N') = 'S') 	and (ie_tipo_conv_dest_w = 3)			and (ie_tipo_conv_orig_w <> 3) 			then
		begin
		
		select	coalesce(max(obter_convenio_atendimento(nr_atend_dest_p)),0),
			coalesce(max(Obter_Categoria_Atendimento(nr_atend_dest_p)),0)
		into STRICT	cd_convenio_sus_w,
			cd_categoria_sus_w
		;
		
		SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_w, null, nr_atend_dest_p, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
				
		if (coalesce(nr_seq_proc_interno_w,0) <> 0) 	and (coalesce(cd_procedimento_w,0) <> 0) 	then
			begin
			
			update	procedimento_paciente
			set	nr_atendimento 		= nr_atend_dest_p,
				nr_seq_atepacu 		= nr_seq_atepacu_w,
				dt_entrada_unidade 	= dt_entrada_unidade_w,
				cd_procedimento	   	= cd_procedimento_w,
				ie_origem_proced   	= ie_origem_proced_w,
				cd_convenio	   	= cd_convenio_sus_w,
				cd_categoria		= cd_categoria_sus_w,
			--	nr_prescricao = null,                 Edilson em 03/09/0a4 OS 10987 e 9889

			--	nr_sequencia_prescricao = null,		

			--	dt_prescricao = null,
				nr_cirurgia 		 = NULL,
				nr_interno_conta 	 = NULL,
				nr_laudo 		 = NULL,
				nr_seq_proc_princ 	 = NULL,
				nr_seq_proc_pacote 	 = NULL,
				ie_proc_princ_atend 	= 'N',
				nr_seq_autorizacao 	 = NULL,
				cd_procedimento_princ 	 = NULL,
				dt_procedimento_princ 	 = NULL,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia = nr_sequencia_p;
			
			update	prescr_procedimento
			set	cd_procedimento	= cd_procedimento_w,
				ie_origem_proced= ie_origem_proced_w,
				cd_convenio	= cd_convenio_sus_w,
				cd_categoria	= cd_categoria_sus_w,
				nm_usuario 	= nm_usuario_p,
				dt_atualizacao 	= clock_timestamp()
			where	nr_prescricao	= (	SELECT	coalesce(max(a.nr_prescricao),0)
							from	procedimento_paciente a
							where	a.nr_sequencia = nr_sequencia_p)
			and	nr_sequencia	= (	Select	coalesce(max(b.nr_sequencia_prescricao),0)
							from	procedimento_paciente b
							where	b.nr_sequencia = nr_sequencia_p)
			and	'S'		= ie_prescricao_p;
			
			/*insert 	into logxxxxxx_tasy
				(dt_atualizacao, nm_usuario, cd_log, ds_log)
			values	(sysdate, nm_usuario_p, 7002, ' Trasnf. Gastos. Seq Proc: ' || nr_sequencia_p || ' Atend. Dest: ' || nr_atend_dest_p ||
						'Atend. Orig: ' || nr_atend_origem_w || ' Transf. Prescr: ' || ie_prescricao_p);*/
						
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		
			CALL Atualiza_Preco_Procedimento(nr_sequencia_p, cd_convenio_sus_w, nm_usuario_p);
			
			end;
		end if;		
		end;
	else
		begin
		
		/*insert 	into logxxxxxx_tasy
			(dt_atualizacao, nm_usuario, cd_log, ds_log)
		values	(sysdate, nm_usuario_p, 7002, ' Trasnf. Gastos. Seq Proc: ' || nr_sequencia_p || ' Atend. Dest: ' || nr_atend_dest_p ||
					'Atend. Orig: ' || nr_atend_origem_w || ' Transf. Prescr: ' || ie_prescricao_p); */
		
		update	procedimento_paciente
		set	nr_atendimento = nr_atend_dest_p,
			nr_seq_atepacu = nr_seq_atepacu_w,
			dt_entrada_unidade = dt_entrada_unidade_w,
		--	nr_prescricao = null,                 Edilson em 03/09/04 OS 10987 e 9889

		--	nr_sequencia_prescricao = null,		

		--	dt_prescricao = null,
			nr_cirurgia  = NULL,
			nr_interno_conta  = NULL,
		--	nr_laudo = null,  OS 1158761
			nr_seq_proc_princ  = NULL,
			nr_seq_proc_pacote  = NULL,
			ie_proc_princ_atend = 'N',
			nr_seq_autorizacao  = NULL,
			cd_procedimento_princ  = NULL,
			dt_procedimento_princ  = NULL,
			cd_convenio = cd_convenio_w,
			cd_categoria = cd_categoria_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = nr_sequencia_p;
			
			/* Edgar 05/01/2004 - Alteracao para transferir o laudo_paciente OS 5306 */

		open	c01;
		loop
		fetch	c01 into nr_laudo_orig_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			select	coalesce(max(nr_laudo),0) + 1
			into STRICT	nr_laudo_w
			from	laudo_paciente
			where	nr_atendimento	= nr_atend_dest_p;

			update	laudo_paciente
			set	nr_atendimento	= nr_atend_dest_p,
				nr_laudo	= nr_laudo_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_proc	= nr_sequencia_p
			and	nr_laudo	= nr_laudo_orig_w;


			end;
		end loop;
		close c01;	

		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
		
		CALL Atualiza_Preco_Procedimento(nr_sequencia_p, cd_convenio_w, nm_usuario_p);
		
		end;
	end if;		
else

	Select	coalesce(max(b.nr_prescricao),0)
	into STRICT	nr_prescricao_w
	from	material_atend_paciente b
	where	b.nr_sequencia = nr_sequencia_p
	and		coalesce(b.nr_prescricao,0) <> 0;
	
	if (nr_prescricao_w > 0) and (ie_prescricao_p = 'S') then
	
		update	prescr_medica
		set		nr_atendimento 		= nr_atend_dest_p,
				cd_pessoa_fisica	= cd_pessoa_fisica_w,
				IE_RECEM_NATO		= 'N',
				dt_atualizacao		= clock_timestamp(),
				nm_usuario			= nm_usuario_p
		where	nr_prescricao		= nr_prescricao_w;
		

		update prescr_mat_alteracao
		set	   nr_atendimento = nr_atend_dest_p
		where  nr_prescricao  = nr_prescricao_w;
		
		CALL CPOE_Desvincular_atend_prescr(nr_prescricao_w, nm_usuario_p);
		CALL CPOE_VINCULAR_ATEND_PRESCR(nr_prescricao_w, nr_atend_dest_p, nm_usuario_p);
	end if;
	
	if (ie_prescricao_p = 'S') and (coalesce(nr_cirurgia_w,0) > 0) then
		insert into w_transf_cirurgia_atend(nr_seq_item,  ie_tipo_item, nr_atend_origem, nr_atend_destino, nr_cirurgia, dt_atualizacao, nm_usuario)
				values (nr_sequencia_p, 'M', nr_atend_origem_w, nr_atend_dest_p, nr_cirurgia_w , clock_timestamp(), nm_usuario_p);
	end if;

	/*insert 	into logxxxxx_tasy
		(dt_atualizacao, nm_usuario, cd_log, ds_log)
	values
		(sysdate, nm_usuario_p, 7002, ' Trasnf. Gastos. Seq Mat: ' || nr_sequencia_p || ' Atend. Dest: ' || nr_atend_dest_p ||
				'Atend. Orig: ' || nr_atend_origem_w || ' Transf. Prescr: ' || ie_prescricao_p);*/
	update	material_atend_paciente
	set	nr_atendimento = nr_atend_dest_p,
		nr_seq_atepacu = nr_seq_atepacu_w,
		dt_entrada_unidade = dt_entrada_unidade_w,
	--	nr_prescricao = null,

	--	nr_sequencia_prescricao = null,

	--	dt_prescricao = null,
		nr_cirurgia  = NULL,
		nr_interno_conta  = NULL,
		nr_seq_proc_princ  = NULL,
		nr_seq_proc_pacote  = NULL,
		nr_seq_autorizacao  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;
	
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

	CALL Atualiza_Preco_Material(nr_sequencia_p, nm_usuario_p);
end if;

var_permite_maior_alta_w	:= coalesce(obter_valor_param_usuario(-15,11,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');

if (var_permite_maior_alta_w = 'S') then
	select	max(dt_alta)
	into STRICT	dt_alta_orig_w
	from	atendimento_paciente
	where	nr_atendimento		= nr_atend_origem_w;
	
	select	max(dt_alta)
	into STRICT	dt_alta_dest_w
	from	atendimento_paciente
	where	nr_atendimento		= nr_atend_dest_p;
	
	if (dt_alta_orig_w IS NOT NULL AND dt_alta_orig_w::text <> '') and (dt_alta_dest_w IS NOT NULL AND dt_alta_dest_w::text <> '') then
		
		if (dt_alta_dest_w > dt_alta_orig_w) then
			update 	atendimento_paciente
			set	dt_alta 	= dt_alta_dest_w
			where	nr_atendimento 	= nr_atend_dest_p;
		end if;
		if (dt_alta_dest_w < dt_alta_orig_w) then
			update 	atendimento_paciente
			set	dt_alta 	= dt_alta_orig_w
			where	nr_atendimento 	= nr_atend_dest_p;
		end if;
	end if;	
	
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_gasto_atendimento ( nr_sequencia_p bigint, ie_proc_mat_p bigint, nr_atend_dest_p bigint, ie_prescricao_p text, ie_manter_data_unid_orig_p text, nm_usuario_p text) FROM PUBLIC;
