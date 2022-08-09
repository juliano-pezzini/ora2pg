-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos_audit_ant AS (nr_sequencia		bigint,
		dt_liberacao		timestamp,
		qt_itens_audit		bigint);


CREATE OR REPLACE PROCEDURE desdobrar_conta_paciente ( nr_interno_conta_p bigint, dt_referencia_p timestamp, nr_doc_convenio_p text, cd_setor_atendimento_p bigint, dt_periodo_final_p timestamp, nm_usuario_p text, nr_conta_retorno_p INOUT bigint, nr_seq_motivo_desdob_p bigint) AS $body$
DECLARE

			
--------------------------------------------------------------------------------------------------------
		
type Vetor_Audit_Ant is
	table of campos_audit_ant index by integer;
	
i				integer := 1;
j				integer := 1;
Vetor_Audit_Ant_w		Vetor_Audit_Ant;

--------------------------------------------------------------------------------------------------------
nr_interno_conta_w			bigint;
nr_atendimento_w			bigint;
dt_acerto_conta_w			timestamp		:= clock_timestamp();
nr_doc_convenio_w		varchar(20);
dt_inicial_w			timestamp;
dt_final_w			timestamp;
cd_estabelecimento_w		bigint;
nr_seq_etapa_w			bigint;
ie_data_final_conta_w		varchar(01)	:= 'N';
ie_bloquear_troca_conta_w   varchar(01);
dt_entrada_w			timestamp;
ie_dt_inicial_conta_w		varchar(10);
ie_proc_mat_w			smallint;
nr_sequencia_w			bigint;
ie_tipo_atendimento_w		varchar(10);
ie_guia_transf_conta_w		varchar(10);
cd_convenio_parametro_w		integer;
ie_guia_transf_conta_ww		varchar(1);
nr_fechamento_w			bigint;
qt_audit_antes_w		bigint;
qt_audit_depois_w		bigint;
nr_seq_audit_w			bigint;
ie_desdobra_audit_lib_conta_w	varchar(1);
dt_item_w			timestamp;
nr_seq_auditoria_w		bigint;
dt_liberacao_w			timestamp;
qt_itens_audit_w		bigint;
ie_ok_w				varchar(1);
ie_deletar_w			varchar(1);
qt_audit_periodo_w		bigint;
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
ie_vincular_laudos_aih_w	varchar(10)	:= 'N';
dt_periodo_inicial_ant_w 	timestamp;
dt_periodo_final_ant_w		timestamp;
vl_conta_origem_w		double precision;
ie_copiar_etapas_w		varchar(15) := 'N';
ie_copiar_etapas_ww     varchar(15) := 'N';
dt_lib_espelho_w		timestamp;
nr_seq_audit_espelho_w		bigint;
ie_gerar_seq_apres_sus_w	varchar(15) := 'N';
nr_interno_conta_c04_w		bigint;
qt_pendencia_w			bigint;
nr_seq_pend_nova_w		bigint;
nr_seq_pend_w			bigint;
ie_tipo_estagio_w		varchar(15);
vl_auditoria_w			double precision;
nr_seq_pendencia_hist_w		bigint;
vl_incluido_ant_w		double precision;
vl_excluido_ant_w		double precision;
vl_transferido_ant_w		double precision;
vl_incluido_w			double precision;
vl_excluido_w			double precision;
vl_transferido_w		double precision;
ie_Gerar_Pendencia_w		varchar(1);
qt_necessidade_w		bigint;
ie_autor_desdob_conta_w		convenio_estabelecimento.ie_autor_desdob_conta%type := 'N';
ie_copiar_etapa_desdob_w	convenio_estabelecimento.ie_autor_desdob_conta%type := 'N';
nr_seq_autor_w			autorizacao_convenio.nr_sequencia%type;
nr_seq_estagio_autor_w		parametro_faturamento.nr_seq_estagio_autor%type;	
qt_item_auditoria_w		bigint;									

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	fatur_etapa
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	ie_tipo_etapa		= 'D'
	and	coalesce(ie_situacao,'A')	= 'A';
	
C02 CURSOR FOR
	SELECT	ie_proc_mat,
		nr_sequencia,
		dt_item
	from	conta_paciente_v
	where	nr_interno_conta	= nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;
	
C03 CURSOR FOR
	SELECT	ie_proc_mat,
		nr_sequencia
	from	conta_paciente_v
	where	nr_interno_conta	= nr_interno_conta_w
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;
	
C04 CURSOR FOR
	SELECT 	coalesce(nr_sequencia,0) nr_sequencia,
		dt_liberacao,
		dt_periodo_inicial,
		dt_periodo_final,
		nr_interno_conta
	from 	auditoria_conta_paciente
	where 	((nr_interno_conta = nr_interno_conta_p) or (nr_interno_conta = nr_interno_conta_w))
	order by	1;

C05 CURSOR FOR
	SELECT 	nr_seq_estagio,
		ds_historico,
		nr_seq_estagio_ant,
		vl_conta_estagio,
		dt_inicio_estagio,
		dt_final_estagio,
		coalesce(obter_valor_auditoria(nr_seq_auditoria_w,nr_interno_conta_c04_w),0) vl_auditoria,
		vl_auditoria vl_audit_orig,
		nr_sequencia,
		vl_incluido,
		vl_excluido,
		vl_transferido
	from 	cta_pendencia_hist
	where 	nr_seq_pend = nr_seq_pend_w
	order by nr_sequencia;		
	
C06 CURSOR FOR
	SELECT 	cd_procedimento,
		ie_origem_proced,
		nr_atendimento
	from	procedimento_paciente
	where 	nr_interno_conta = nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w
	group by cd_procedimento,
		 ie_origem_proced,
		 nr_atendimento;	

C07 CURSOR FOR
	SELECT	nr_atendimento,
		cd_material
	from	material_atend_paciente
	where 	nr_interno_conta = nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w
	group by nr_atendimento,
		cd_material;	
	

c05_w	c05%rowtype;	
c04_w	c04%rowtype;

BEGIN

select 	coalesce(max(nr_atendimento),0),
	coalesce(max(cd_convenio_parametro),0),
	max(dt_periodo_inicial),
	max(dt_periodo_final),
	max(coalesce(obter_valor_conta(nr_interno_conta_p,0),0))
into STRICT	nr_atendimento_w,
	cd_convenio_parametro_w,
	dt_periodo_inicial_ant_w,
	dt_periodo_final_ant_w,
	vl_conta_origem_w
from 	conta_paciente
where 	nr_interno_conta = nr_interno_conta_p;

select	max(dt_entrada),
	max(ie_tipo_atendimento)
into STRICT	dt_entrada_w,
	ie_tipo_atendimento_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;

select nextval('conta_paciente_seq')
into STRICT nr_interno_conta_w
;
nr_conta_retorno_p			:= nr_interno_conta_w;
dt_inicial_w				:= dt_referencia_p;
dt_final_w				:= coalesce(dt_periodo_final_p, dt_referencia_p + 9999);

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	conta_paciente
where 	nr_interno_conta		= nr_interno_conta_p;

select	coalesce(max(ie_guia_transf_conta),'N'),
		coalesce(max(ie_autor_desdob_conta),'N'),
    	coalesce(max(ie_copiar_etapa_desdob),'N')
into STRICT	ie_guia_transf_conta_w,
		ie_autor_desdob_conta_w,
    	ie_copiar_etapa_desdob_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_parametro_w
and	cd_estabelecimento	= cd_estabelecimento_w;

select	coalesce(max(ie_guia_transf_conta),'R'),
	max(nr_seq_estagio_autor)
into STRICT	ie_guia_transf_conta_ww,
	nr_seq_estagio_autor_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_w;

if (obter_funcao_ativa = 99071 ) then
	ie_data_final_conta_w := coalesce(obter_valor_param_usuario(99071,19 , Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N');
	ie_bloquear_troca_conta_w  := coalesce(obter_valor_param_usuario(99071,20,obter_perfil_ativo, nm_usuario_p, 0),'N');
	ie_dt_inicial_conta_w := coalesce(obter_valor_param_usuario(99071, 21, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w),'N');
	ie_desdobra_audit_lib_conta_w := coalesce(obter_valor_param_usuario(99071, 22, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
	ie_copiar_etapas_w		:= coalesce(obter_valor_param_usuario(99071,23,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
else
	ie_data_final_conta_w:= coalesce(obter_valor_param_usuario(67, 189, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N');
	ie_dt_inicial_conta_w		:= coalesce(obter_valor_param_usuario(67, 288, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w),'N');
	ie_desdobra_audit_lib_conta_w	:= coalesce(obter_valor_param_usuario(67, 568, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
	ie_bloquear_troca_conta_w  := coalesce(obter_valor_param_usuario(67,269,obter_perfil_ativo, nm_usuario_p, 0),'N');
	ie_copiar_etapas_w		:= coalesce(obter_valor_param_usuario(67,673,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
end if;


ie_gerar_seq_apres_sus_w	:= coalesce(obter_valor_param_usuario(1123,221,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');
ie_Gerar_Pendencia_w 		:= obter_valor_param_usuario(1116, 136, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);
ie_vincular_laudos_aih_w	:= coalesce(obter_valor_param_usuario(1123,179,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');

if (dt_referencia_p	< dt_entrada_w )then
	-- O periodo inicial deve ser maior ou igual a data de entrada do paciente
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(182628);
end if;

if (ie_dt_inicial_conta_w	= 'N') and (dt_referencia_p	> clock_timestamp()) then
	-- O periodo inicial deve ser maior ou igual a data atual. Parametro 288
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(182629);
end if;


if (ie_bloquear_troca_conta_w = 'S') then
	begin
	
	select 	count(1)
	into STRICT	qt_item_auditoria_w
	from	conta_paciente_v a,
		auditoria_matpaci b,
		auditoria_conta_paciente c
	where	a.nr_interno_conta = nr_interno_conta_p
	and 	a.nr_sequencia = b.nr_seq_matpaci
	and	c.nr_sequencia = b.nr_seq_auditoria
	and	c.nr_interno_conta = a.nr_interno_conta
	and	coalesce(c.dt_liberacao::text, '') = ''
	and 	((coalesce(cd_setor_atendimento_p::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_p))
	and 	a.dt_conta between dt_inicial_w and dt_final_w;
	
	if qt_item_auditoria_w =  0 then
	
		select 	count(1)
		into STRICT	qt_item_auditoria_w
		from	conta_paciente_v a,
			auditoria_propaci b,
			auditoria_conta_paciente c
		where	a.nr_interno_conta = nr_interno_conta_p
		and 	a.nr_sequencia = b.nr_seq_propaci
		and	c.nr_sequencia = b.nr_seq_auditoria
		and	c.nr_interno_conta = a.nr_interno_conta
		and	coalesce(c.dt_liberacao::text, '') = ''
		and 	((coalesce(cd_setor_atendimento_p::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_p))
		and 	a.dt_conta between dt_inicial_w and dt_final_w;
	
	end if;
	
	if (qt_item_auditoria_w > 0) then
		/* Nao e possivel desdobrar a conta neste periodo, pois existem itens em auditoria. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(341070);
	end if;
	
	end;
end if;

insert into conta_paciente(nr_atendimento,
		dt_acerto_conta,
		ie_status_acerto,
		dt_periodo_inicial,
		dt_periodo_final,
		dt_atualizacao,
		nm_usuario,
		cd_convenio_parametro,
		cd_categoria_parametro,
		dt_mesano_referencia,
		dt_mesano_contabil,
		cd_convenio_calculo,
		cd_categoria_calculo,
		nr_interno_conta,
		cd_estabelecimento,
		nr_protocolo,
		vl_desconto,
		vl_conta,
		ie_tipo_atend_tiss,
		nr_seq_saida_consulta,
		nr_seq_saida_spsadt,
		nr_seq_saida_int,
		ie_tipo_atend_conta,
		ie_tipo_guia,
		nr_conta_orig_desdob,
		cd_responsavel)
SELECT
     	     	nr_atendimento,
		dt_acerto_conta_w,
		1,
		dt_referencia_p,
		CASE WHEN ie_data_final_conta_w='S' THEN  coalesce(dt_periodo_final_p, dt_referencia_p + 365)  ELSE dt_referencia_p + 365 END ,
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_parametro,
		cd_categoria_parametro,
		dt_mesano_referencia,
		dt_mesano_contabil,
		cd_convenio_calculo,
		cd_categoria_calculo,
		nr_interno_conta_w,
		cd_estabelecimento,
		'0',
		0,
		0,
		ie_tipo_atend_tiss,
		nr_seq_saida_consulta,
		nr_seq_saida_spsadt,
		nr_seq_saida_int,
		ie_tipo_atendimento_w,
		ie_tipo_guia,
		nr_interno_conta_p,
		cd_responsavel
from conta_paciente
where nr_interno_conta	= nr_interno_conta_p;

CALL GERAR_LANC_APOS_CONTA(nr_atendimento_w, null, 211, nm_usuario_p, null,null,null,null,null,nr_interno_conta_w);

CALL gerar_etapa_desdobrar_conta(nr_interno_conta_p, nr_atendimento_w, nm_usuario_p);
	
/*OS 200850 Fabricio em 19/04/2010 */

select 	coalesce(max(nr_fechamento),0) + 1
into STRICT	nr_fechamento_w
from 	conta_paciente
where 	nr_atendimento = nr_atendimento_w
and 	cd_convenio_parametro = cd_convenio_parametro_w;
	
update	conta_paciente
set	dt_periodo_final = dt_referencia_p - 86400/86399 + 1,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	nr_fechamento = nr_fechamento_w
where	nr_interno_conta	= nr_interno_conta_p;

if (nr_doc_convenio_p IS NOT NULL AND nr_doc_convenio_p::text <> '') then
	nr_doc_convenio_w	:=	nr_doc_convenio_p;
else
	begin
	select cd_autorizacao
	into STRICT	nr_doc_convenio_w
	from conta_paciente_guia
	where nr_interno_conta 	= nr_interno_conta_p
  	  and nr_seq_envio	= 0;
	exception
		when others then
			nr_doc_convenio_w	:= null;
	end;
end if;


if (nr_doc_convenio_w IS NOT NULL AND nr_doc_convenio_w::text <> '') then
	begin
	insert into conta_paciente_guia(nr_interno_conta      	,
		cd_autorizacao 		,
		nr_seq_envio           	,
		nr_atendimento         	,
		dt_acerto_conta        	,
		ie_situacao_guia       	,
		vl_guia                	,
		dt_atualizacao         	,
		nm_usuario             	)
	SELECT
		nr_interno_conta,
		nr_doc_convenio_w,
		0,
		nr_atendimento,
           	dt_acerto_conta,
           	'P',
           	0,
           	clock_timestamp(),
           	nm_usuario_p
	from  conta_paciente
	where nr_interno_conta = nr_interno_conta_w;
	exception
		when others then
			nr_doc_convenio_w	:= null;
	end;
end if;


if ie_autor_desdob_conta_w = 'S' then
	
	for r06 in c06 loop
		
		begin
			select	max(y.nr_sequencia)
			into STRICT	nr_seq_autor_w
			from	procedimento_autorizado x,
				autorizacao_convenio y,
				estagio_autorizacao z
			where	x.nr_sequencia_autor = y.nr_sequencia
			and	y.nr_seq_estagio = z.nr_sequencia
			and	z.ie_interno = '10'
			and	x.cd_procedimento = r06.cd_procedimento
			and	x.ie_origem_proced = r06.ie_origem_proced
			and	y.nr_atendimento = r06.nr_atendimento;	
		exception
			when others then
			nr_seq_autor_w:=null;
		end;			
		
				
		if (nr_seq_autor_w IS NOT NULL AND nr_seq_autor_w::text <> '') then
		
			select 	count(1)
			into STRICT	qt_necessidade_w
			from	procedimento_autorizado x,
				autorizacao_convenio y
			where	x.nr_sequencia_autor = y.nr_sequencia
			and	y.nr_seq_estagio = nr_seq_estagio_autor_w
			and	x.cd_procedimento = r06.cd_procedimento
			and	x.ie_origem_proced = r06.ie_origem_proced
			and	y.nr_atendimento = r06.nr_atendimento;	
			
			if (qt_necessidade_w = 0) then
			
				gerar_autor_desdobramento(nr_seq_autor_w,
						 	r06.cd_procedimento,
							r06.ie_origem_proced,
							null,
							nm_usuario_p,
							cd_estabelecimento_w);	
			end if;
			
		end if;
		
	end loop;

	for r07 in c07 loop

		select	max(y.nr_sequencia)
		into STRICT	nr_seq_autor_w
		from	material_autorizado x,
			autorizacao_convenio y,
			estagio_autorizacao z
		where	x.nr_sequencia_autor = y.nr_sequencia
		and	y.nr_seq_estagio = z.nr_sequencia
		and	z.ie_interno = '10'
		and	x.cd_material = r07.cd_material
		and	y.nr_atendimento = r07.nr_atendimento;
					
		if (nr_seq_autor_w IS NOT NULL AND nr_seq_autor_w::text <> '') then
				
			select	count(1)
			into STRICT	qt_necessidade_w
			from	material_autorizado x,
				autorizacao_convenio y
			where	x.nr_sequencia_autor = y.nr_sequencia
			and	y.nr_seq_estagio = nr_seq_estagio_autor_w
			and	x.cd_material = r07.cd_material
			and	y.nr_atendimento = r07.nr_atendimento;
			
			if qt_necessidade_w = 0 then
				gerar_autor_desdobramento(nr_seq_autor_w,
						 	null,
							null,
							r07.cd_material,
							nm_usuario_p,
							cd_estabelecimento_w);
			end if;
		end if;
							

				
	end loop;
end if;	

if (ie_guia_transf_conta_ww = 'R') then

	update 	procedimento_paciente
	set	nr_doc_convenio	= CASE WHEN ie_guia_transf_conta_w='S' THEN null  ELSE coalesce(nr_doc_convenio_w, nr_doc_convenio) END
	where 	nr_interno_conta	= nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;

	update 	Material_atend_paciente
	set	nr_doc_convenio	= CASE WHEN ie_guia_transf_conta_w='S' THEN null  ELSE coalesce(nr_doc_convenio_w, nr_doc_convenio) END
	where 	nr_interno_conta	= nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;

elsif (ie_guia_transf_conta_ww = 'T') then

	update 	procedimento_paciente
	set	nr_doc_convenio	 = NULL
	where 	nr_interno_conta	= nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;

	update 	Material_atend_paciente
	set	nr_doc_convenio	 = NULL
	where 	nr_interno_conta = nr_interno_conta_p
	and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
	and 	dt_conta between dt_inicial_w and dt_final_w;

end if;

if (ie_desdobra_audit_lib_conta_w = 'S') then

	delete	from auditoria_conta_espelho
	where	nr_atendimento = nr_atendimento_w;

	open C04;
	loop
	fetch C04 into	
		nr_seq_auditoria_w,
		dt_liberacao_w,
		dt_periodo_inicial_w,
		dt_periodo_final_w,
		nr_interno_conta_c04_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		select	sum(qt_itens_audit)
		into STRICT	qt_itens_audit_w
		from (
			SELECT	count(*) qt_itens_audit
			from	auditoria_propaci
			where	nr_seq_auditoria = nr_seq_auditoria_w
			
union all

			SELECT	count(*) qt_itens_audit
			from	auditoria_matpaci
			where	nr_seq_auditoria = nr_seq_auditoria_w
			
union all

			select	count(*) qt_itens_audit
			from	auditoria_externa
			where	nr_seq_auditoria = nr_seq_auditoria_w
			) alias4;
		
		i	:= coalesce(Vetor_Audit_Ant_w.Count,0) + 1;
		
		Vetor_Audit_Ant_w[i].nr_sequencia  	:= nr_seq_auditoria_w;
		Vetor_Audit_Ant_w[i].dt_liberacao  	:= dt_liberacao_w;
		Vetor_Audit_Ant_w[i].qt_itens_audit	:= qt_itens_audit_w;
		
		insert into auditoria_conta_espelho(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_atendimento,
			nr_interno_conta,
			nr_seq_auditoria,
			dt_periodo_inicial,
			dt_periodo_final,
			dt_liberacao,
			nr_seq_audit_nova
		) values (
			nextval('auditoria_conta_espelho_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_atendimento_w,
			nr_interno_conta_p,
			nr_seq_auditoria_w,
			dt_periodo_inicial_w,
			dt_periodo_final_w,
			dt_liberacao_w,
			null
		);
		
		end;
	end loop;
	close C04;

end if;

open C02;
loop
fetch C02 into	
	ie_proc_mat_w,
	nr_sequencia_w,
	dt_item_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	
	if (coalesce(nr_seq_auditoria_w,0) = 0) then
		select 	max(nr_sequencia)
		into STRICT	nr_seq_auditoria_w
		from 	auditoria_conta_paciente
		where 	nr_interno_conta = nr_interno_conta_p
		and 	dt_item_w between dt_periodo_inicial and dt_periodo_final;
	end if;
	
	CALL Trocar_Conta_Auditoria(nr_interno_conta_w, nr_sequencia_w, ie_proc_mat_w, nm_usuario_p, null,ie_desdobra_audit_lib_conta_w,
		ie_desdobra_audit_lib_conta_w);
	end;
end loop;
close C02;

if (ie_desdobra_audit_lib_conta_w = 'S') then

	open C04;
	loop
	fetch C04 into	
		nr_seq_auditoria_w,
		dt_liberacao_w,
		dt_periodo_inicial_w,
		dt_periodo_final_w,
		nr_interno_conta_c04_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		ie_ok_w		:= 'S';
		ie_deletar_w	:= 'N';
		
		if (Vetor_Audit_Ant_w.count > 0) then
			ie_ok_w	:= 'N';
			ie_deletar_w	:= 'N';
		
			for	j in 1..Vetor_Audit_Ant_w.count loop
			
				if (nr_seq_auditoria_w = Vetor_Audit_Ant_w[j].nr_sequencia) then
					ie_ok_w		:= 'S';
					ie_deletar_w	:= 'N';
					
					select	sum(qt_itens_audit)
					into STRICT	qt_itens_audit_w
					from (
						SELECT	count(*) qt_itens_audit
						from	auditoria_propaci
						where	nr_seq_auditoria = nr_seq_auditoria_w
						
union all

						SELECT	count(*) qt_itens_audit
						from	auditoria_matpaci
						where	nr_seq_auditoria = nr_seq_auditoria_w
						
union all

						select	count(*) qt_itens_audit
						from	auditoria_externa
						where	nr_seq_auditoria = nr_seq_auditoria_w
						) alias4;
						
					select	count(*)
					into STRICT	qt_audit_periodo_w
					from	auditoria_conta_paciente
					where	((nr_interno_conta = nr_interno_conta_p) or (nr_interno_conta = nr_interno_conta_w))
					and	dt_periodo_inicial = dt_periodo_inicial_w
					and	dt_periodo_final = dt_periodo_final_w;
						
					if (Vetor_Audit_Ant_w[j].qt_itens_audit <> qt_itens_audit_w) and (qt_itens_audit_w = 0) and (qt_audit_periodo_w > 1) then
						ie_deletar_w := 'S';
					end if;
				else
					dt_liberacao_w	:= Vetor_Audit_Ant_w[j].dt_liberacao;
				end if;
			end loop;
		end if;
		
		if (ie_ok_w = 'N') then
		
			select	max(dt_liberacao),
				max(nr_seq_auditoria)
			into STRICT	dt_lib_espelho_w,
				nr_seq_audit_espelho_w
			from	auditoria_conta_espelho
			where	nr_seq_audit_nova = nr_seq_auditoria_w;
		
			update	auditoria_conta_paciente
			set	dt_liberacao = coalesce(dt_lib_espelho_w, dt_liberacao_w),
				vl_auditoria_orig = CASE WHEN ie_Gerar_Pendencia_w='V' THEN  Obter_valor_Orig_Audit(nr_sequencia)  ELSE obter_valor_auditoria(nr_sequencia, nr_interno_conta) END ,
				vl_auditoria_lib = CASE WHEN coalesce(dt_lib_espelho_w, dt_liberacao_w) = NULL THEN  null  ELSE obter_valor_auditoria(nr_sequencia, nr_interno_conta) END
			where	nr_sequencia = nr_seq_auditoria_w;
			
			update	auditoria_conta_paciente
			set	vl_auditoria_lib = obter_valor_auditoria(nr_sequencia, nr_interno_conta),
				vl_auditoria_orig = CASE WHEN ie_Gerar_Pendencia_w='V' THEN  Obter_valor_Orig_Audit(nr_sequencia)  ELSE vl_auditoria_orig END
			where	nr_sequencia = nr_seq_audit_espelho_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			
			update	cta_pendencia
			set	nr_seq_auditoria = nr_seq_auditoria_w
			where	nr_seq_auditoria = nr_seq_audit_espelho_w;
		else
			if (ie_deletar_w = 'S') then				
				delete	from auditoria_conta_paciente
				where	nr_sequencia = nr_seq_auditoria_w;				
			end if;
		end if;
		
		end;
	end loop;
	close C04;

end if;

-- Inicio do processo Dedobramento Pendencia
if (ie_desdobra_audit_lib_conta_w = 'S') then

	open C04;
	loop
	fetch C04 into	
		nr_seq_auditoria_w,
		dt_liberacao_w,
		dt_periodo_inicial_w,
		dt_periodo_final_w,
		nr_interno_conta_c04_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		select 	count(*)
		into STRICT	qt_pendencia_w
		from 	cta_pendencia
		where 	nr_seq_auditoria = nr_seq_auditoria_w;
		
		if (qt_pendencia_w > 0) then
			
			update 	cta_pendencia
			set 	dt_inicio_auditoria = dt_periodo_inicial_w,
				dt_final_auditoria  = dt_periodo_final_w,
				nr_interno_conta    = nr_interno_conta_c04_w
			where 	nr_seq_auditoria    = nr_seq_auditoria_w;

			select 	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_pend_w
			from 	cta_pendencia
			where 	nr_seq_auditoria = nr_seq_auditoria_w;
						
			
			vl_incluido_ant_w 	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'I'),0);
			vl_excluido_ant_w 	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'E'),0);
			vl_transferido_ant_w	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'T'),0);
			vl_auditoria_w	 	:= 0;
			vl_incluido_w	  	:= 0;
			vl_excluido_w		:= 0;
			vl_transferido_w	:= 0;
			
			open C05;
			loop
			fetch C05 into	
				c05_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin

				
				select 	max(ie_tipo_estagio)
				into STRICT	ie_tipo_estagio_w
				from 	cta_estagio_pend
				where 	nr_sequencia = 	c05_w.nr_seq_estagio_ant;
				
				if (ie_tipo_estagio_w = 'A') then								
				
					select 	coalesce(sum(Obter_valor_Orig_Audit(nr_seq_auditoria_w)),0) + vl_transferido_ant_w
					into STRICT	vl_auditoria_w -- Valor original
					;					
				else
					vl_auditoria_w:= vl_auditoria_w + vl_incluido_w + vl_excluido_w - vl_transferido_w;															
				end if;
				
				select 	CASE WHEN coalesce(c05_w.vl_incluido,0)=0 THEN  0  ELSE vl_incluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_excluido,0)=0 THEN  0  ELSE vl_excluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_transferido,0)=0 THEN  0  ELSE vl_transferido_ant_w END  
				into STRICT	vl_incluido_w,
					vl_excluido_w,
					vl_transferido_w
				;
								
				update	cta_pendencia_hist
				set	vl_auditoria = vl_auditoria_w,
					vl_incluido = CASE WHEN coalesce(c05_w.vl_incluido,0)=0 THEN  0  ELSE vl_incluido_ant_w END ,
					vl_excluido = CASE WHEN coalesce(c05_w.vl_excluido,0)=0 THEN  0  ELSE vl_excluido_ant_w END ,
					vl_transferido = CASE WHEN coalesce(c05_w.vl_transferido,0)=0 THEN  0  ELSE vl_transferido_ant_w END
				where	nr_sequencia = c05_w.nr_sequencia;
				
				end;
			end loop;
			close C05;
			
		else			
		
			select	coalesce(max(nr_seq_audit_nova),0)
			into STRICT	nr_seq_audit_espelho_w
			from	auditoria_conta_espelho
			where	nr_seq_auditoria = nr_seq_auditoria_w;
			
			select 	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_pend_w
			from 	cta_pendencia
			where 	nr_seq_auditoria = nr_seq_audit_espelho_w;
			
			select 	nextval('cta_pendencia_seq')
			into STRICT	nr_seq_pend_nova_w
			;
			
			insert into cta_pendencia(			
				nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_pendencia, 
				nr_seq_tipo,
				nr_seq_estagio,
				ds_complemento,
				nr_interno_conta,
				dt_fechamento,
				cd_setor_atendimento,
				nr_seq_regra_resp,
				cd_medico,
				cd_especialidade,
				dt_inicio_auditoria,
				dt_final_auditoria,
				nr_seq_auditoria,
				cd_pessoa_resp,
				nr_seq_conta_orig,
				dt_desvinculacao,
				nm_usuario_desvinc,
				cd_setor_resp,
				nr_seq_etapa,
				nr_seq_conta_etapa)
			SELECT 	nr_seq_pend_nova_w,
				nr_atendimento,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(), 
				nm_usuario_p,
				dt_pendencia, 
				nr_seq_tipo,
				nr_seq_estagio,
				ds_complemento,
				nr_interno_conta_c04_w,
				dt_fechamento,
				cd_setor_atendimento,
				nr_seq_regra_resp,
				cd_medico,
				cd_especialidade,
				dt_periodo_inicial_w,
				dt_periodo_final_w,
				nr_seq_auditoria_w,
				cd_pessoa_resp,
				nr_seq_conta_orig,
				dt_desvinculacao,
				nm_usuario_desvinc,
				cd_setor_resp,
				nr_seq_etapa,
				nr_seq_conta_etapa
			from 	cta_pendencia
			where 	nr_sequencia = nr_seq_pend_w;
			
			vl_incluido_ant_w 	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'I'),0);
			vl_excluido_ant_w 	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'E'),0);
			vl_transferido_ant_w	:=  coalesce(obter_valor_audit_estagio(nr_seq_auditoria_w,nr_interno_conta_c04_w, 'T'),0);
			vl_auditoria_w	 	:= 0;
			vl_incluido_w	  	:= 0;
			vl_excluido_w		:= 0;
			vl_transferido_w	:= 0;
						
			open C05;
			loop
			fetch C05 into	
				c05_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				
				select 	max(ie_tipo_estagio)
				into STRICT	ie_tipo_estagio_w
				from 	cta_estagio_pend
				where 	nr_sequencia = 	c05_w.nr_seq_estagio_ant;
								
				
				if (ie_tipo_estagio_w = 'A') then								
				
					select 	coalesce(sum(Obter_valor_Orig_Audit(nr_seq_auditoria_w)),0) + vl_transferido_ant_w
					into STRICT	vl_auditoria_w -- Valor original
					;
					
				else
					vl_auditoria_w:= vl_auditoria_w + vl_incluido_w + vl_excluido_w - vl_transferido_w;															
				end if;
				
				select 	CASE WHEN coalesce(c05_w.vl_incluido,0)=0 THEN  0  ELSE vl_incluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_excluido,0)=0 THEN  0  ELSE vl_excluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_transferido,0)=0 THEN  0  ELSE vl_transferido_ant_w END 
				into STRICT	vl_incluido_w,
					vl_excluido_w,
					vl_transferido_w
				;
				
				select 	nextval('cta_pendencia_hist_seq')
				into STRICT	nr_seq_pendencia_hist_w
				;
				
				insert	into  cta_pendencia_hist(
					nr_sequencia,
					nr_seq_pend,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_estagio,
					ds_historico,
					nr_seq_estagio_ant,					
					dt_inicio_estagio,
					dt_final_estagio,
					vl_auditoria,
					vl_incluido,
					vl_excluido,
					vl_transferido,
					qt_horas_estagio,
					ie_tipo_meta)
				values 	(nr_seq_pendencia_hist_w,
					nr_seq_pend_nova_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					c05_w.nr_seq_estagio,
					c05_w.ds_historico,
					c05_w.nr_seq_estagio_ant,
					c05_w.dt_inicio_estagio,
					c05_w.dt_final_estagio,					
					vl_auditoria_w,  ----c05_w.vl_audit_orig, 
					CASE WHEN coalesce(c05_w.vl_incluido,0)=0 THEN  0  ELSE vl_incluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_excluido,0)=0 THEN  0  ELSE vl_excluido_ant_w END ,
					CASE WHEN coalesce(c05_w.vl_transferido,0)=0 THEN  0  ELSE vl_transferido_ant_w END ,
					CASE WHEN coalesce(c05_w.dt_final_estagio::text, '') = '' THEN  null  ELSE trunc((c05_w.dt_final_estagio - c05_w.dt_inicio_estagio) * 24) END ,
					CASE WHEN ie_Gerar_Pendencia_w='V' THEN  CASE WHEN coalesce(c05_w.dt_final_estagio::text, '') = '' THEN  null  ELSE Obter_Tipo_Meta_Estagio(c05_w.nr_seq_estagio, 0, trunc((c05_w.dt_final_estagio - c05_w.dt_inicio_estagio) * 24)) END   ELSE null END );
					

				-- Nao foi adicionado direto no Insert devido a trigger da tabela que busca o valor da function (Obter_valor_conta)
				update	cta_pendencia_hist
				set	vl_conta_estagio = c05_w.vl_conta_estagio
				where	nr_sequencia = nr_seq_pendencia_hist_w;
				
				end;
			end loop;
			close C05;			
			
		end if;
		
		end;
	end loop;
	close C04;

end if;
-- fim processo desdobramento auditoria.
select	count(*)
into STRICT	qt_audit_depois_w
from	auditoria_conta_paciente
where	nr_interno_conta = nr_interno_conta_w;

if (ie_desdobra_audit_lib_conta_w = 'S') and (qt_audit_antes_w <> qt_audit_depois_w) and (coalesce(nr_seq_auditoria_w,0) <> 0) then
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_audit_w
	from	auditoria_conta_paciente
	where	nr_interno_conta = nr_interno_conta_w;
	
	select  max(dt_liberacao)
	into STRICT	dt_liberacao_w
	from 	auditoria_conta_paciente
	where 	nr_sequencia = nr_seq_auditoria_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	
	update	auditoria_conta_paciente
	set	dt_liberacao = dt_liberacao_w
	where	nr_sequencia = nr_seq_audit_w;
end if;


update 	procedimento_paciente
set	nr_interno_conta	= nr_interno_conta_w,
	dt_acerto_conta	= dt_acerto_conta_w
	--nr_doc_convenio	= nvl(nr_doc_convenio_w, nr_doc_convenio)
where 	nr_interno_conta	= nr_interno_conta_p
and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
and 	dt_conta between dt_inicial_w and dt_final_w;

update 	Material_atend_paciente
set	nr_interno_conta	= nr_interno_conta_w,
	dt_acerto_conta	= dt_acerto_conta_w
	--nr_doc_convenio	= nvl(nr_doc_convenio_w, nr_doc_convenio)
where 	nr_interno_conta	= nr_interno_conta_p
and	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
and 	dt_conta between dt_inicial_w and dt_final_w;

open	c01;
loop
fetch	c01 into
	nr_seq_etapa_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	insert	into conta_paciente_etapa(nr_sequencia          ,
		nr_interno_conta       ,
		dt_atualizacao         ,
		nm_usuario             ,
		dt_etapa               ,
		nr_seq_etapa           ,
		cd_setor_atendimento   ,
		cd_pessoa_fisica       ,
		nr_seq_motivo_dev      ,
		ds_observacao          ,
		dt_atualizacao_nrec    ,
		nm_usuario_nrec        ,
		dt_fim_etapa)
	values (nextval('conta_paciente_etapa_seq'),
		nr_interno_conta_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_etapa_w,
		null, null,
		null, null, clock_timestamp(), nm_usuario_p,
		null);

	end;
end loop;
close c01;

if	((ie_guia_transf_conta_w	= 'S' AND ie_guia_transf_conta_ww = 'R') or (ie_guia_transf_conta_ww = 'T')) then
	open c03;
	loop
	fetch c03 into	
		ie_proc_mat_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		if (ie_proc_mat_w		= 1)  then
			CALL atualiza_preco_procedimento(nr_sequencia_w,cd_convenio_parametro_w,nm_usuario_p);
		else
			CALL atualiza_preco_material(nr_sequencia_w,nm_usuario_p);
		end if;
		end;
	end loop;
	close c03;
end if;

if (ie_vincular_laudos_aih_w = 'S') and (obter_tipo_convenio(cd_convenio_parametro_w) = 3) and (ie_tipo_atendimento_w = 1) then
	begin
	CALL sus_vincular_laudo_conta(nr_interno_conta_p,nm_usuario_p);
	CALL sus_vincular_laudo_conta(nr_interno_conta_w,nm_usuario_p);
	end;
end if;

if (coalesce(ie_copiar_etapas_w,'N') = 'S') or
    ((coalesce(ie_copiar_etapas_w,'N') = 'R') and (coalesce(ie_copiar_etapa_desdob_w, 'N') = 'S')) then
	begin
	insert	into conta_paciente_etapa(nr_sequencia,
		nr_interno_conta,
		dt_atualizacao,
		nm_usuario,
		dt_etapa,
		nr_seq_etapa,
		cd_setor_atendimento,
		cd_pessoa_fisica,
		nr_seq_motivo_dev,
		ds_observacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_fim_etapa)
	SELECT	nextval('conta_paciente_etapa_seq'),
		nr_interno_conta_w,
		clock_timestamp(),
		nm_usuario_p,
		dt_etapa,
		nr_seq_etapa,
		cd_setor_atendimento,
		cd_pessoa_fisica,
		nr_seq_motivo_dev,
		ds_observacao,
		clock_timestamp(),
		nm_usuario_p,
		dt_fim_etapa
	from	conta_paciente_etapa
	where	nr_interno_conta = nr_interno_conta_p;
	
	end;
end if;

insert into conta_paciente_desdob(
		DT_ATUALIZACAO,
		DT_ATUALIZACAO_NREC,
		DT_REF_DESDOBRAR,
		DT_PER_FIM_DESDOB_ANT,
		DT_PER_FIM_DESDOB_APOS,
		DT_PER_FIM_NOVA,
		DT_PER_INI_DESDOB_ANT,
		DT_PER_INI_DESDOB_APOS,
		DT_PER_INI_NOVA,
		IE_DESDOB_AUTO,
		NM_USUARIO,
		NM_USUARIO_NREC,
		NR_ATENDIMENTO,
		NR_CONTA_DESDOB,
		NR_CONTA_NOVA,
		NR_SEQUENCIA,
		VL_CONTA_DESDOB,
		VL_NOVA_CONTA,
		VL_ORIG_DESDOB,
		NR_SEQ_MOTIVO)
	values (	
		clock_timestamp(),
		clock_timestamp(),
		dt_referencia_p,
		dt_periodo_final_ant_w,
		dt_referencia_p - 86400/86399 + 1,
		CASE WHEN ie_data_final_conta_w='S' THEN  coalesce(dt_periodo_final_p, dt_referencia_p + 365)  ELSE dt_referencia_p + 365 END ,
		dt_periodo_inicial_ant_w,
		dt_periodo_inicial_ant_w,
		dt_referencia_p,
		'N',
		nm_usuario_p,
		nm_usuario_p,
		nr_atendimento_w,
		nr_interno_conta_p,
		nr_interno_conta_w,
		nextval('conta_paciente_desdob_seq'),
		coalesce(obter_valor_conta(nr_interno_conta_p,0),0),
		coalesce(obter_valor_conta(nr_interno_conta_w,0),0),
		vl_conta_origem_w,
		nr_seq_motivo_desdob_p);

if (coalesce(ie_gerar_seq_apres_sus_w,'N') = 'S') and (obter_tipo_convenio(cd_convenio_parametro_w) = 3) and (ie_tipo_atendimento_w = 1) then
	begin
	CALL sus_atualizar_nr_seq_apresent(nr_atendimento_w,nm_usuario_p);
	end;
end if;	

if (ie_Gerar_Pendencia_w = 'V') then
	
	open C04;
	loop
	fetch C04 into	
		c04_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		update 	auditoria_conta_paciente
		set 	vl_auditoria_orig = obter_valor_orig_audit(nr_sequencia) + coalesce(obter_valor_audit_estagio(nr_sequencia,nr_interno_conta, 'T'),0)
		where 	nr_sequencia = c04_w.nr_sequencia;
		
		end;
	end loop;
	close C04;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_conta_paciente ( nr_interno_conta_p bigint, dt_referencia_p timestamp, nr_doc_convenio_p text, cd_setor_atendimento_p bigint, dt_periodo_final_p timestamp, nm_usuario_p text, nr_conta_retorno_p INOUT bigint, nr_seq_motivo_desdob_p bigint) FROM PUBLIC;
