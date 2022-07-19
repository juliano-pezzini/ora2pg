-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recalcular_repasse_periodo ( nr_interno_conta_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, nr_seq_terceiro_p bigint, cd_procedimento_p bigint, nr_Seq_protocolo_p bigint, ie_origem_proced_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, ie_proc_sem_repasse_p text, ie_tipo_proc_lab_p text, cd_medico_executor_p text, ie_protocolo_fechado_p text, nr_seq_criterio_p bigint, cd_tipo_procedimento_p bigint, ie_somente_laudo_lib_p text, cd_estabelecimento_p bigint default null) AS $body$
DECLARE


ie_repasse_mat_w		varchar(1);
ie_repasse_proc_w		varchar(1);
nr_seq_procedimento_w		bigint;
nr_seq_material_w		bigint;
nr_lote_repasse_w		bigint;
nr_atendimento_w		bigint;
vl_material_w			double precision;
cd_estabelecimento_w		smallint;
cd_medico_resp_w		varchar(255);
ie_contabilizado_w		varchar(255);
cd_convenio_w			integer;
cd_edicao_amb_w			integer;
ie_tipo_atendimento_w		smallint;
ie_tipo_convenio_w		integer;
cd_categoria_w			varchar(10);
nr_interno_conta_w		bigint;
dt_entrada_w			timestamp;
ie_recalcular_conta_prov_w	varchar(10);
ie_status_conta_w		bigint;
ie_gerar_w			varchar(1)	:= 'S';
ie_repasse_mat_conv_w		varchar(1);
ie_repasse_proc_conv_w		varchar(1);
qt_repasse_gerado_w		bigint;
ie_repasse_gerado_w		varchar(255);

ds_sql_w			varchar(4000)	:= '';
ds_sql_union_w			varchar(4000)	:= '';
ds_from_w			varchar(4000)	:= '';
ds_from_union_w			varchar(4000)	:= '';
ds_sql_restricao_w		varchar(4000)	:= '';
ds_sql_restricao_union_w	varchar(4000)	:= '';
ds_sql_filtro_w			varchar(4000)	:= '';
ds_sql_filtro_union_w		varchar(4000)	:= '';
ds_sql_filtro_sup_w		varchar(4000)	:= '';

var_proc_cur_w			integer;
var_proc_exec_w			integer;
var_proc_retorno_w		integer;

var_mat_cur_w			integer;
var_mat_exec_w			integer;
var_mat_retorno_w		integer;

nr_seq_partic_w			procedimento_repasse.nr_seq_partic%type;

nr_interno_conta_proc_w		conta_paciente.nr_interno_conta%type;
nr_interno_conta_mat_w		conta_paciente.nr_interno_conta%type;

type v_nr_interno_conta is table of conta_paciente%rowtype index by integer;
a_nr_interno_conta v_nr_interno_conta;
i bigint := 1;

ie_atual_res_conta_rec_rep_w	parametro_faturamento.ie_atual_res_conta_rec_rep%type;


BEGIN

ie_gerar_w	:= 'S';
nr_interno_conta_proc_w	:= 0;

ie_repasse_gerado_w := obter_Param_Usuario(89, 40, obter_perfil_ativo, nm_usuario_p, 0, ie_repasse_gerado_w);

ie_repasse_gerado_w	:= coalesce(ie_repasse_gerado_w, 'S');


--C01
ds_sql_w	:=	'select	a.nr_sequencia, ' ||
			'	a.nr_interno_conta, ' ||
			'	0 nr_seq_partic ';
			
ds_sql_union_w	:= 	'union	all '||
			'select	a.nr_sequencia, ' ||
			'	a.nr_interno_conta, ' ||
			'	c.nr_seq_partic ';
if (coalesce(ie_protocolo_fechado_p,'N') = 'S') then
	ds_from_w	:=	'from	protocolo_convenio e, '		||
				'	conta_paciente b, '		||	
				'	procedimento_paciente a, '	||
				'	procedimento d ';
				
	ds_from_union_w	:=	'from	protocolo_convenio e, '		||
				'	conta_paciente b, '		||
				'	procedimento_participante c, '	||
				'	procedimento_paciente a, '	||
				'	procedimento d ';
			
	ds_sql_restricao_w :=	'where	b.nr_interno_conta	= a.nr_interno_conta '		||
				'and 	a.cd_motivo_exc_conta	is null '			||
				'and	a.dt_procedimento between :dt_inicial and :dt_final '	||
				'and	a.cd_procedimento	= d.cd_procedimento '		||
				'and	a.ie_origem_proced	= d.ie_origem_proced '		||
				'and	b.nr_seq_protocolo	= e.nr_seq_protocolo ';
				
	ds_sql_restricao_union_w	:=	'where	a.nr_sequencia		= c.nr_sequencia '		||
						'and	b.nr_interno_conta	= a.nr_interno_conta '		||
						'and 	a.cd_motivo_exc_conta	is null '			||
						'and	a.dt_procedimento between :dt_inicial and :dt_final '	||
						'and	a.cd_procedimento	= d.cd_procedimento '		||
						'and	a.ie_origem_proced	= d.ie_origem_proced '		||
						'and	b.nr_seq_protocolo	= e.nr_seq_protocolo ';
else			
	ds_from_w	:=	'from	conta_paciente b, '		||	
				'	procedimento_paciente a, '	||
				'	procedimento d ';
				
	ds_from_union_w	:=	'from	conta_paciente b, '||
				'	procedimento_participante c, ' ||
				'	procedimento_paciente a, ' ||
				'	procedimento d ';
			
	ds_sql_restricao_w :=	'where	b.nr_interno_conta	= a.nr_interno_conta '		||
				'and 	a.cd_motivo_exc_conta	is null '			||
				'and	a.dt_procedimento between :dt_inicial and :dt_final '	||
				'and	a.cd_procedimento	= d.cd_procedimento '		||
				'and	a.ie_origem_proced	= d.ie_origem_proced ';
				
	ds_sql_restricao_union_w	:=	'where	a.nr_sequencia		= c.nr_sequencia '	||
						'and	b.nr_interno_conta	= a.nr_interno_conta '		||
						'and 	a.cd_motivo_exc_conta	is null '			||
						'and	a.dt_procedimento between :dt_inicial and :dt_final '	||
						'and	a.cd_procedimento	= d.cd_procedimento '		||
						'and	a.ie_origem_proced	= d.ie_origem_proced ';
end if;						
			
ds_sql_filtro_w	:= '';
ds_sql_filtro_union_w	:= '';
ds_sql_filtro_sup_w	:= '';

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	a.nr_interno_conta	= :nr_interno_conta ';
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.nr_atendimento	= :nr_atendimento ';
end if;

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.cd_convenio_parametro	= :cd_convenio ';
end if;

if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
	ds_sql_filtro_sup_w	:= ds_sql_filtro_sup_w || 	'and	exists(	select	1 '||
						'		from	procedimento_repasse x '||
						'		where	x.nr_seq_procedimento = a.nr_sequencia '||
						'		and	x.nr_seq_partic is null ' ||
						'		and	x.nr_seq_terceiro = :nr_seq_terceiro) ';
						
	ds_sql_filtro_union_w	:= ds_sql_filtro_union_w ||	'and	exists(	select	1 '||
								'		from	procedimento_repasse x '||
								'		where	x.nr_seq_procedimento = a.nr_sequencia '||
								'		and	x.nr_seq_partic = c.nr_seq_partic ' ||
								'		and	x.nr_seq_terceiro = :nr_seq_terceiro) ';
end if;

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	a.cd_procedimento	= :cd_procedimento ';
end if;

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.nr_seq_protocolo	= :nr_seq_protocolo ';
end if;

if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	a.ie_origem_proced	= :ie_origem_proced ';
end if;

if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	a.cd_medico_executor	= :cd_medico_executor ';
end if;

if (nr_seq_criterio_p IS NOT NULL AND nr_seq_criterio_p::text <> '') then
	ds_sql_filtro_sup_w	:= ds_sql_filtro_sup_w ||	'and	exists(	select	1 ' ||
								'		from	procedimento_repasse x ' ||
								'		where	x.nr_seq_procedimento = a.nr_sequencia ' ||
								'		and	x.nr_seq_partic is null ' ||
								'		and	x.nr_seq_criterio = :nr_seq_criterio) ';
								
	ds_sql_filtro_union_w	:= ds_sql_filtro_union_w ||	'and	exists(	select	1 ' ||
								'		from	procedimento_repasse x ' ||
								'		where	x.nr_seq_procedimento = a.nr_sequencia ' ||
								'		and	x.nr_seq_partic = c.nr_seq_partic ' ||
								'		and	x.nr_seq_criterio = :nr_seq_criterio) ';
end if;

if (coalesce(ie_protocolo_fechado_p,'N') = 'S') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	e.ie_status_protocolo	= 2';
end if;

if (coalesce(ie_proc_sem_repasse_p,'N') = 'S') then
	ds_sql_filtro_sup_w	:= ds_sql_filtro_sup_w ||	'and	not exists(	select	1 ' ||
								'			from	procedimento_repasse x ' ||
								' 			where	x.nr_seq_procedimento = a.nr_sequencia ' ||
								'			and	x.nr_repasse_terceiro is not null ' ||
								' 			and	x.nr_seq_partic is null) ';
								
	ds_sql_filtro_union_w	:= ds_sql_filtro_union_w ||	'and	not exists(	select	1 ' ||
								'			from	procedimento_repasse x ' ||
								' 			where	x.nr_seq_procedimento = a.nr_sequencia ' ||
								'			and	x.nr_repasse_terceiro is not null ' ||
								' 			and	x.nr_seq_partic = c.nr_seq_partic) ';
end if;

if (coalesce(ie_tipo_proc_lab_p,'S') = 'N') then
	ds_sql_filtro_w	:= ds_sql_filtro_w ||	'and	(exists(	select	1 '||
						'			from	procedimento x ' ||
						'			where	x.cd_procedimento 	= a.cd_procedimento ' ||
						'			and	x.ie_origem_proced	= a.ie_origem_proced ' ||
						'			and	x.cd_tipo_procedimento	<> 20) ' ||
						'	and	not exists	(select	1 ' ||
						'				from	exame_lab_result_item	z, ' ||
						'					exame_lab_resultado	y, ' ||
						'					prescr_procedimento	x ' ||
						'				WHERE   z.nr_seq_exame		= a.nr_seq_exame ' ||
						'				and	Y.nr_seq_resultado	= z.nr_seq_resultado ' ||
						'				and	x.nr_prescricao		= y.nr_prescricao ' ||
						'				and	x.nr_sequencia		= a.nr_sequencia_prescricao ' ||
						'				and	x.nr_prescricao		= a.nr_prescricao)) ';
end if;

if (cd_tipo_procedimento_p IS NOT NULL AND cd_tipo_procedimento_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	d.cd_tipo_procedimento		= :cd_tipo_procedimento ';
end if;

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.cd_estabelecimento	= :cd_estabelecimento ';
end if;

if (coalesce(ie_somente_laudo_lib_p,'N') = 'S') then
	ds_sql_filtro_w	:= ds_sql_filtro_w ||	'and	exists(	select	1 ' ||
						'		from	laudo_paciente x ' ||
						'		where	x.nr_seq_proc = a.nr_sequencia ' ||
						'		and	x.dt_liberacao is not null ' ||
						'		union ' ||
						'		select	1 ' ||
						'		from	laudo_paciente x ' ||
						'		where	x.nr_seq_proc = a.nr_seq_proc_princ ' ||
						'		and	x.dt_liberacao is not null) ';
end if;

ds_sql_w	:=	ds_sql_w ||
			ds_from_w ||
			ds_sql_restricao_w ||
			ds_sql_filtro_w||
			ds_sql_filtro_sup_w||
			ds_sql_union_w||
			ds_from_union_w||
			ds_sql_restricao_union_w||
			ds_sql_filtro_w ||
			ds_sql_filtro_union_w;

var_proc_cur_w	:=	dbms_sql.open_cursor;
			dbms_sql.parse(var_proc_cur_w,  ds_sql_w, 1);

dbms_sql.bind_variable(var_proc_cur_w, ':dt_inicial', dt_inicial_p);
dbms_sql.bind_variable(var_proc_cur_w, ':dt_final', dt_final_p);

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':nr_interno_conta' ,nr_interno_conta_p);
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':nr_atendimento' , nr_atendimento_p);
end if;

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':cd_convenio', cd_convenio_p);
end if;

if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':nr_seq_terceiro', nr_seq_terceiro_p);
end if;

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':cd_procedimento', cd_procedimento_p);
end if;

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':nr_seq_protocolo', nr_seq_protocolo_p);
end if;

if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':ie_origem_proced', ie_origem_proced_p);
end if;

if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':cd_medico_executor', cd_medico_executor_p);
end if;

if (nr_seq_criterio_p IS NOT NULL AND nr_seq_criterio_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':nr_seq_criterio', nr_seq_criterio_p);
end if;

if (cd_tipo_procedimento_p IS NOT NULL AND cd_tipo_procedimento_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':cd_tipo_procedimento', cd_tipo_procedimento_p);
end if;

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	dbms_sql.bind_variable(var_proc_cur_w, ':cd_estabelecimento', cd_estabelecimento_p);
end if;

dbms_sql.define_column(var_proc_cur_w, 1, nr_seq_procedimento_w);
dbms_sql.define_column(var_proc_cur_w, 2, nr_interno_conta_w);
dbms_sql.define_column(var_proc_cur_w, 3, nr_seq_partic_w);
var_proc_exec_w := dbms_sql.execute(var_proc_cur_w);

loop
var_proc_retorno_w := dbms_sql.fetch_rows(var_proc_cur_w);
exit when var_proc_retorno_w = 0;

	dbms_sql.column_value(var_proc_cur_w, 1, nr_seq_procedimento_w);
	dbms_sql.column_value(var_proc_cur_w, 2, nr_interno_conta_w);
	dbms_sql.column_value(var_proc_cur_w, 3, nr_seq_partic_w);
	
	if (ie_repasse_gerado_w = 'A') then
		select	count(1)
		into STRICT	qt_repasse_gerado_w
		from	procedimento_repasse	a
		where	a.nr_seq_procedimento	= nr_seq_procedimento_w
		and	(a.nr_repasse_terceiro IS NOT NULL AND a.nr_repasse_terceiro::text <> '')  LIMIT 1;
		
		if (qt_repasse_gerado_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(258469, 'NR_INTERNO_CONTA_W=' || nr_interno_conta_w);
		end if;
	end if;

	ie_gerar_w	:= 'S';
	
	select	coalesce(max(c.ie_repasse_mat),'N'),
		coalesce(max(c.ie_repasse_proc),'N'),
		max(a.cd_estabelecimento),
		max(b.cd_medico_resp),
		max(ie_tipo_atendimento),
		max(cd_convenio_parametro),
		max(cd_categoria_parametro),
		max(dt_entrada),
		max(OBTER_TIPO_CONVENIO(cd_convenio_parametro)),
		coalesce(max(ie_atual_res_conta_rec_rep),'N')
	into STRICT	ie_repasse_mat_w,
		ie_repasse_proc_w,
		cd_estabelecimento_w,
		cd_medico_resp_w,
		ie_tipo_atendimento_w,
		cd_convenio_w,
		cd_categoria_w,
		dt_entrada_w,
		ie_tipo_convenio_w,
		ie_atual_res_conta_rec_rep_w
	from	parametro_faturamento c,
		atendimento_paciente b,
		conta_paciente a
	where	a.nr_atendimento		= b.nr_atendimento
	and	a.cd_estabelecimento	= c.cd_estabelecimento
	and	a.nr_interno_conta		= nr_interno_conta_w;
	
	/*if	(nr_interno_conta_proc_w is null) and
		(ie_atual_res_conta_rec_rep_w = 'S') then
		nr_interno_conta_proc_w	:= nr_interno_conta_w;
		a_nr_interno_conta(i)	:= nr_interno_conta_proc_w;
		i	:= i + 1;
	end if;*/
	
	select	Obter_Valor_Conv_Estab(cd_convenio_w,cd_estabelecimento_w,'IE_REPASSE_PROC')
	into STRICT	ie_repasse_proc_conv_w
	;

	if (ie_repasse_proc_conv_w IS NOT NULL AND ie_repasse_proc_conv_w::text <> '') then
		ie_repasse_proc_w	:= ie_repasse_proc_conv_w;
	end if;
	
	
	if (ie_repasse_proc_w <> 'N') then
		ie_recalcular_conta_prov_w := obter_Param_Usuario(89, 80, obter_perfil_ativo, nm_usuario_p, 0, ie_recalcular_conta_prov_w);

		select	coalesce(max(nr_lote_repasse),0),
			max(nr_atendimento),
			max(ie_status_acerto)
		into STRICT	nr_lote_repasse_w,
			nr_atendimento_w,
			ie_status_conta_w
		from	conta_paciente
		where	nr_interno_conta	= nr_interno_conta_w;

		if (ie_status_conta_w = 1) then
			begin
			if (coalesce(ie_recalcular_conta_prov_w, 'S') = 'N') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(185898,'nr_interno_conta_w='||nr_interno_conta_w);
			elsif (coalesce(ie_recalcular_conta_prov_w, 'S') = 'C') then
				ie_gerar_w	:= 'N';
			end if;
			end;
		end if;
		
		if (ie_gerar_w = 'S') then
			begin
			insert into FIN_LOG_REPASSE(DT_ATUALIZACAO,
				NM_USUARIO,
				CD_LOG,
				DS_LOG)
			values (clock_timestamp(),
				nm_usuario_p,
				6040,
				wheb_mensagem_pck.get_texto(800060,'nr_interno_conta_p=' || nr_interno_conta_w));

			if (nr_lote_repasse_w > 0) then
				ie_contabilizado_w := obter_param_usuario(89, 59, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_contabilizado_w);
				if (coalesce(ie_contabilizado_w, 'N') = 'N') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(185901, 'nr_atendimento_w='|| nr_atendimento_w||';nr_interno_conta_w='||nr_interno_conta_w||';nr_lote_repasse_w='||nr_lote_repasse_w);
				end if;
			end if;

			-- Edgar 16/11/2006 OS 42066, utilizar regra de repasse de procedimentos do SUS
			if (ie_tipo_convenio_w = 3) then
				select	coalesce(max(ie_repasse_proc), ie_repasse_proc_w)
				into STRICT	ie_repasse_proc_w
				from	sus_parametros
				where	cd_estabelecimento	= cd_estabelecimento_w;
			end if;

			begin
			select	obter_edicao(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, dt_entrada_w, null)
			into STRICT	cd_edicao_amb_w
			;
			exception
			when others then
				select	max(cd_edicao_amb)
				into STRICT	cd_edicao_amb_w
				from	convenio_amb
				where	cd_estabelecimento	= cd_estabelecimento_w
				and	cd_convenio		= cd_convenio_w
				and	cd_categoria		= cd_categoria_w
				and (coalesce(ie_situacao,'A')	= 'A')
				and	dt_inicio_vigencia	= (	SELECT	max(dt_inicio_vigencia)
									from	convenio_amb a
									where	a.cd_estabelecimento 	= cd_estabelecimento_w
									and	a.cd_convenio         	= cd_convenio_w
									and	a.cd_categoria        	= cd_categoria_w
									and (coalesce(a.ie_situacao,'A')	= 'A')
									and	a.dt_inicio_vigencia 	<= dt_entrada_w);
			end;

			CALL gerar_procedimento_repasse(	nr_seq_procedimento_w, 
							cd_estabelecimento_w,
							cd_medico_resp_w,
							nm_usuario_p,
							cd_edicao_amb_w,
							cd_convenio_w,
							ie_tipo_atendimento_w,
							null,
							null,
							nr_seq_partic_w);
			
			if (nr_interno_conta_proc_w <> nr_interno_conta_w) and (ie_atual_res_conta_rec_rep_w = 'S') then
				nr_interno_conta_proc_w	:= nr_interno_conta_w;
				a_nr_interno_conta[i].nr_interno_conta	:= nr_interno_conta_proc_w;
				a_nr_interno_conta[i].ie_status_acerto	:= ie_status_conta_w;
				i	:= i + 1;
			end if;	
			end;
		end if;
	end if;

--FIM C01
end loop;
dbms_sql.close_cursor(var_proc_cur_w);

ie_gerar_w	:= 'S';
nr_interno_conta_mat_w	:= 0;

if (coalesce(cd_procedimento_p::text, '') = '') then

	--C02
	ds_sql_w	:= 	'select	a.nr_sequencia, ' ||
				'	a.nr_interno_conta ';
	
	if	((nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') or (nr_seq_criterio_p IS NOT NULL AND nr_seq_criterio_p::text <> '') or (coalesce(ie_proc_sem_repasse_p,'N') = 'S')) then
		if (coalesce(ie_protocolo_fechado_p,'N') = 'S') then
			ds_from_w	:= 	'from	protocolo_convenio	e, ' ||
						'	atendimento_paciente	d, ' ||
						'	conta_paciente		b, ' ||
						'	material_repasse	c, ' ||
						'	material_atend_paciente	a ';	
			ds_sql_restricao_w :=	'where	a.nr_sequencia		= c.nr_seq_material(+) '		||
						'and	b.nr_atendimento	= d.nr_atendimento '			||
						'and	b.nr_interno_conta	= a.nr_interno_conta '			||
						'and	b.nr_seq_protocolo	= e.nr_seq_protocolo '			||
						'and 	a.cd_motivo_exc_conta	is null '				||
						'and 	a.dt_atendimento	between :dt_inicial and :dt_final ';
		else
			ds_from_w	:= 	'from	atendimento_paciente	d, ' ||
						'	conta_paciente		b, ' ||
						'	material_repasse	c, ' ||
						'	material_atend_paciente	a ';	
			ds_sql_restricao_w :=	'where	a.nr_sequencia		= c.nr_seq_material(+) '		||
						'and	b.nr_atendimento	= d.nr_atendimento '			||
						'and	b.nr_interno_conta	= a.nr_interno_conta '			||
						'and 	a.cd_motivo_exc_conta	is null '				||
						'and 	a.dt_atendimento	between :dt_inicial and :dt_final ';
		end if;
	else
		if (coalesce(ie_protocolo_fechado_p,'N') = 'S') then
			ds_from_w	:= 	'from	protocolo_convenio	e, ' ||
						'	atendimento_paciente	d, ' ||
						'	conta_paciente		b, ' ||
						'	material_atend_paciente	a ';	
			ds_sql_restricao_w :=	'where	b.nr_atendimento	= d.nr_atendimento '			||
						'and	b.nr_interno_conta	= a.nr_interno_conta '			||
						'and	b.nr_seq_protocolo	= e.nr_seq_protocolo '			||
						'and 	a.cd_motivo_exc_conta	is null '				||
						'and 	a.dt_atendimento	between :dt_inicial and :dt_final ';
		else
			ds_from_w	:= 	'from	atendimento_paciente	d, ' ||
						'	conta_paciente		b, ' ||
						'	material_atend_paciente	a ';	
			ds_sql_restricao_w :=	'where	b.nr_atendimento	= d.nr_atendimento '			||
						'and	b.nr_interno_conta	= a.nr_interno_conta '			||
						'and 	a.cd_motivo_exc_conta	is null '				||
						'and 	a.dt_atendimento	between :dt_inicial and :dt_final ';
		end if;
	end if;
	
	ds_sql_filtro_w	:= '';

	if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	a.nr_interno_conta	= :nr_interno_conta ';
	end if;			

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.nr_atendimento	= :nr_atendimento ';
	end if;

	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.cd_convenio_parametro	= :cd_convenio ';
	end if;

	if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	c.nr_seq_terceiro	= :nr_seq_terceiro ';
	end if;

	if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.nr_seq_protocolo	= :nr_seq_protocolo ';
	end if;

	if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	d.cd_medico_resp = :cd_medico_executor ';
	end if;

	if (nr_seq_criterio_p IS NOT NULL AND nr_seq_criterio_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	c.nr_seq_criterio	= :nr_seq_criterio ';
	end if;

	if (coalesce(ie_protocolo_fechado_p,'N') = 'S') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	e.ie_status_protocolo	= 2 ';
	end if;
	
	if (coalesce(ie_proc_sem_repasse_p,'N') = 'S') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	c.nr_repasse_terceiro	is null ';
	end if;

	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ds_sql_filtro_w	:= ds_sql_filtro_w || 'and	b.cd_estabelecimento	= :cd_estabelecimento ';
	end if;

	ds_sql_w	:=	ds_sql_w ||
				ds_from_w ||
				ds_sql_restricao_w ||
				ds_sql_filtro_w;
	
	var_mat_cur_w	:=	dbms_sql.open_cursor;
				dbms_sql.parse(var_mat_cur_w,  ds_sql_w, 1);
	
	dbms_sql.bind_variable(var_mat_cur_w, ':dt_inicial', dt_inicial_p);
	dbms_sql.bind_variable(var_mat_cur_w, ':dt_final', dt_final_p);

	if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':nr_interno_conta' ,nr_interno_conta_p);
	end if;

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':nr_atendimento' , nr_atendimento_p);
	end if;

	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':cd_convenio', cd_convenio_p);
	end if;

	if (nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':nr_seq_terceiro', nr_seq_terceiro_p);
	end if;

	if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':nr_seq_protocolo', nr_seq_protocolo_p);
	end if;

	if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':cd_medico_executor', cd_medico_executor_p);
	end if;

	if (nr_seq_criterio_p IS NOT NULL AND nr_seq_criterio_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':nr_seq_criterio', nr_seq_criterio_p);
	end if;

	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		dbms_sql.bind_variable(var_mat_cur_w, ':cd_estabelecimento', cd_estabelecimento_p);
	end if;

	dbms_sql.define_column(var_mat_cur_w, 1, nr_seq_material_w);
	dbms_sql.define_column(var_mat_cur_w, 2, nr_interno_conta_w);
	var_mat_exec_w := dbms_sql.execute(var_mat_cur_w);

	loop
	var_mat_retorno_w := dbms_sql.fetch_rows(var_mat_cur_w);
	exit when var_mat_retorno_w = 0;
		
		dbms_sql.column_value(var_mat_cur_w, 1, nr_seq_material_w);
		dbms_sql.column_value(var_mat_cur_w, 2, nr_interno_conta_w);
		
		if (ie_repasse_gerado_w = 'A') then
			select	count(1)
			into STRICT	qt_repasse_gerado_w
			from	material_repasse	a
			where	a.nr_seq_material	= nr_seq_material_w
			and	(a.nr_repasse_terceiro IS NOT NULL AND a.nr_repasse_terceiro::text <> '')  LIMIT 1;
			
			if (qt_repasse_gerado_w > 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(258469,'NR_INTERNO_CONTA_W=' || nr_interno_conta_w);
			end if;
		end if;

		ie_gerar_w	:= 'S';
		
		select	coalesce(max(c.ie_repasse_mat),'N'),
			coalesce(max(c.ie_repasse_proc),'N'),
			max(a.cd_estabelecimento),
			max(b.cd_medico_resp),
			max(ie_tipo_atendimento),
			max(cd_convenio_parametro),
			max(cd_categoria_parametro),
			max(dt_entrada),
			max(OBTER_TIPO_CONVENIO(cd_convenio_parametro)),
			coalesce(max(ie_atual_res_conta_rec_rep),'N')
		into STRICT	ie_repasse_mat_w,
			ie_repasse_proc_w,
			cd_estabelecimento_w,
			cd_medico_resp_w,
			ie_tipo_atendimento_w,
			cd_convenio_w,
			cd_categoria_w,
			dt_entrada_w,
			ie_tipo_convenio_w,
			ie_atual_res_conta_rec_rep_w
		from	parametro_faturamento c,
			atendimento_paciente b,
			conta_paciente a
		where	a.nr_atendimento	= b.nr_atendimento
		and	a.cd_estabelecimento	= c.cd_estabelecimento
		and	a.nr_interno_conta	= nr_interno_conta_w;
		
		/*if	(nr_interno_conta_mat_w is null) and
			(ie_atual_res_conta_rec_rep_w = 'S') then
			nr_interno_conta_mat_w	:= nr_interno_conta_w;
			a_nr_interno_conta(i)	:= nr_interno_conta_mat_w;
			i	:= i + 1;
		end if;*/
		
		select	Obter_Valor_Conv_Estab(cd_convenio_w,cd_estabelecimento_w,'IE_REPASSE_MAT')
		into STRICT	ie_repasse_mat_conv_w
		;
		
		if (ie_repasse_mat_conv_w IS NOT NULL AND ie_repasse_mat_conv_w::text <> '') then
			ie_repasse_mat_w	:= ie_repasse_mat_conv_w;
		end if;
		
		if (ie_repasse_mat_w <> 'N') then
			ie_recalcular_conta_prov_w := obter_Param_Usuario(89, 80, obter_perfil_ativo, nm_usuario_p, 0, ie_recalcular_conta_prov_w);

			select	coalesce(max(nr_lote_repasse),0),
				max(nr_atendimento),
				max(ie_status_acerto)
			into STRICT	nr_lote_repasse_w,
				nr_atendimento_w,
				ie_status_conta_w
			from	conta_paciente
			where	nr_interno_conta	= nr_interno_conta_w;
			
			if (ie_status_conta_w = 1) then
				begin
				if (coalesce(ie_recalcular_conta_prov_w, 'S') = 'N') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(185906);
				elsif (coalesce(ie_recalcular_conta_prov_w, 'S') = 'C') then
					ie_gerar_w	:= 'N';
				end if;
				end;
			end if;
			
			if (ie_gerar_w = 'S') then
				begin
				insert into FIN_LOG_REPASSE(DT_ATUALIZACAO,
					NM_USUARIO,
					CD_LOG,
					DS_LOG)
				values (clock_timestamp(),
					nm_usuario_p,
					6040,
					wheb_mensagem_pck.get_texto(800060,'nr_interno_conta_p=' || nr_interno_conta_w));

				if (nr_lote_repasse_w > 0) then
					ie_contabilizado_w := obter_param_usuario(89, 59, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_contabilizado_w);
					
					if (coalesce(ie_contabilizado_w, 'N') = 'N') then
						--Não é possível recalcular o repasse de uma conta que já esteja contabilizada em um lote de repasse!
						CALL wheb_mensagem_pck.exibir_mensagem_abort(185901, 'nr_atendimento_w='|| nr_atendimento_w||';nr_interno_conta_w='||nr_interno_conta_w||';nr_lote_repasse_w='||nr_lote_repasse_w);
					end if;
				end if;


				-- Edgar 16/11/2006 OS 42066, utilizar regra de repasse de procedimentos do SUS
				if (ie_tipo_convenio_w = 3) then
					select	coalesce(max(ie_repasse_proc), ie_repasse_proc_w)
					into STRICT	ie_repasse_proc_w
					from	sus_parametros
					where	cd_estabelecimento	= cd_estabelecimento_w;
				end if;

				begin
				select	obter_edicao(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, dt_entrada_w, null)
				into STRICT	cd_edicao_amb_w
				;
				exception
				when others then
					select	max(cd_edicao_amb)
					into STRICT	cd_edicao_amb_w
					from	convenio_amb
					where	cd_estabelecimento	= cd_estabelecimento_w
					and	cd_convenio		= cd_convenio_w
					and	cd_categoria		= cd_categoria_w
					and (coalesce(ie_situacao,'A')	= 'A')
					and	dt_inicio_vigencia	= (	SELECT	max(dt_inicio_vigencia)
										from	convenio_amb a
										where	a.cd_estabelecimento 	= cd_estabelecimento_w
										and	a.cd_convenio         	= cd_convenio_w
										and	a.cd_categoria        	= cd_categoria_w
										and (coalesce(a.ie_situacao,'A')	= 'A')
										and	a.dt_inicio_vigencia 	<= dt_entrada_w);
				end;

				CALL gerar_material_repasse(	nr_seq_material_w,
								cd_estabelecimento_w,
								cd_medico_resp_w,
								nm_usuario_p,
								cd_edicao_amb_w,
								cd_convenio_w,
								ie_tipo_atendimento_w,
								null,
								null);
								
				if (nr_interno_conta_mat_w <> nr_interno_conta_w) and (ie_atual_res_conta_rec_rep_w = 'S') then
					nr_interno_conta_mat_w	:= nr_interno_conta_w;
					a_nr_interno_conta[i].nr_interno_conta	:= nr_interno_conta_mat_w;
					a_nr_interno_conta[i].ie_status_acerto	:= ie_status_conta_w;
					i	:= i + 1;
				end if;
				end;
			end if;			
		end if;
	--FIM C02
	end loop;
	dbms_sql.close_cursor(var_mat_cur_w);

end if;

if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (coalesce(ie_repasse_mat_w,'N') <> 'N') and (coalesce(ie_repasse_proc_w,'N') <> 'N') then
	CALL gerar_procmat_repasse_nf(nr_interno_conta_w, nm_usuario_p, 'S');
end if;

i := a_nr_interno_conta.first;

for i in 1..a_nr_interno_conta.count loop
	begin
	CALL atualizar_resumo_conta(a_nr_interno_conta[i].nr_interno_conta,a_nr_interno_conta[i].ie_status_acerto);
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recalcular_repasse_periodo ( nr_interno_conta_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, nr_seq_terceiro_p bigint, cd_procedimento_p bigint, nr_Seq_protocolo_p bigint, ie_origem_proced_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, ie_proc_sem_repasse_p text, ie_tipo_proc_lab_p text, cd_medico_executor_p text, ie_protocolo_fechado_p text, nr_seq_criterio_p bigint, cd_tipo_procedimento_p bigint, ie_somente_laudo_lib_p text, cd_estabelecimento_p bigint default null) FROM PUBLIC;

