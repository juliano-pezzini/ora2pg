-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_conta_paciente ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_usuario_p text, dt_conta_p timestamp, dt_entrada_p timestamp, dt_alta_p timestamp, nr_doc_convenio_p text, cd_setor_atendimento_p bigint, nr_seq_pq_proc_p bigint, dt_acerto_conta_p INOUT timestamp, nr_interno_conta_p INOUT bigint, cd_convenio_calculo_p INOUT bigint, cd_categoria_calculo_p INOUT text) AS $body$
DECLARE


dt_acerto_conta_w         	timestamp	:= clock_timestamp();
dt_atualizacao_w          	timestamp       	:= clock_timestamp();
dt_referencia_w           	timestamp 	:= clock_timestamp();
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w		timestamp;
ie_nova_conta_w		varchar(1)	:= 'N';
nr_interno_conta_w		bigint;
cd_convenio_calculo_w     	integer;
cd_categoria_calculo_w    	varchar(10);
ie_separa_conta_w		varchar(1);
cd_autorizacao_w		varchar(20);
cd_estabelecimento_w	smallint;
ie_tipo_convenio_w		smallint;
ie_tipo_atendimento_w	smallint;
ie_separa_conta_setor_w	varchar(1);
qt_contas_setor_w		bigint;
nr_seq_pq_protocolo_w	bigint;
qt_dia_fim_conta_w		bigint;
varguiaatendimento_w	varchar(1);
cd_autorizacao_conta_w	varchar(20):=	null;
ie_grava_guia_conta_w	varchar(1);
ie_tipo_atend_conta_w	smallint;
ie_tipo_fatur_tiss_w		varchar(20);
ie_tipo_guia_w		varchar(5);
vartipoguiaregra_w		varchar(1);
ie_conta_atual_w		varchar(1) := 'N';
qt_contas_partic_w		bigint;
ie_periodo_inicial_seg_w	varchar(1) := 'N';
ds_log_w			varchar(2000);
nr_seq_episodio_w		bigint	:= 0;
ie_agrupa_conta_case_w	varchar(5)	:= 'N';
IE_GERAR_CTA_DIF_TISS_w	varchar(5);
nr_seq_categoria_iva_w  atend_categoria_convenio.nr_seq_categoria_iva%type;

c01 CURSOR FOR
	SELECT	/*+ index(a conpaci_atepaci_fk_i) */	 	a.dt_acerto_conta,
		a.nr_interno_conta,
		a.cd_convenio_calculo,
		a.cd_categoria_calculo,
		b.cd_autorizacao
	FROM convenio c, conta_paciente a
LEFT OUTER JOIN conta_paciente_guia b ON (a.nr_interno_conta = b.nr_interno_conta)
WHERE a.nr_atendimento		=  nr_atendimento_p and a.cd_convenio_calculo	= c.cd_convenio and a.cd_estabelecimento	= cd_estabelecimento_w and a.cd_convenio_parametro	= cd_convenio_p and a.cd_categoria_parametro	= cd_categoria_p and a.ie_status_acerto		= 1 and coalesce(a.nr_seq_protocolo::text, '') = '' 	--edilson em 06/08/05
  and dt_conta_p between	a.dt_periodo_inicial and a.dt_periodo_final  and ((c.ie_tipo_convenio <> 3) or ((c.ie_tipo_convenio = 3 and ie_tipo_atendimento_w
= 1) or (ie_separa_conta_setor_w = 'N'))) and ((nr_seq_pq_protocolo_w = 0) or (a.nr_seq_pq_protocolo = nr_seq_pq_protocolo_w)) order by a.nr_interno_conta;

c02 CURSOR FOR
	SELECT	/*+ index(a conpaci_atepaci_fk_i) */	 	a.dt_acerto_conta,
		a.nr_interno_conta,
		a.cd_convenio_calculo,
		a.cd_categoria_calculo,
		b.cd_autorizacao cd_autorizacao
	FROM conta_paciente_v4 d, conta_paciente a
LEFT OUTER JOIN conta_paciente_guia b ON (a.nr_interno_conta = b.nr_interno_conta)
WHERE a.nr_interno_conta		= d.nr_interno_conta  and a.nr_atendimento		= nr_atendimento_p and a.cd_estabelecimento	= cd_estabelecimento_w and a.cd_convenio_parametro	= cd_convenio_p and a.cd_categoria_parametro 	= cd_categoria_p and d.cd_setor_atendimento	= cd_setor_atendimento_p and a.ie_status_acerto		= 1 and coalesce(a.nr_seq_protocolo::text, '') = '' 	--edilson em 06/08/05
  and dt_conta_p between a.dt_periodo_inicial and a.dt_periodo_final order by a.nr_interno_conta;
	
c03 CURSOR FOR
	SELECT	/*+ index(a conpaci_atepaci_fk_i) */			a.dt_acerto_conta,
			a.nr_interno_conta,
			a.cd_convenio_calculo,
			a.cd_categoria_calculo,
			b.cd_autorizacao
	FROM atendimento_paciente p, convenio c, conta_paciente a
LEFT OUTER JOIN conta_paciente_guia b ON (a.nr_interno_conta = b.nr_interno_conta)
WHERE p.nr_seq_episodio			=  nr_seq_episodio_w and a.cd_convenio_calculo		= c.cd_convenio and a.cd_estabelecimento		= cd_estabelecimento_w and a.cd_convenio_parametro		= cd_convenio_p and a.cd_categoria_parametro	= cd_categoria_p and a.ie_status_acerto			= 1 and coalesce(a.nr_seq_protocolo::text, '') = '' and dt_conta_p between a.dt_periodo_inicial and a.dt_periodo_final  and p.nr_atendimento	= a.nr_atendimento and ((c.ie_tipo_convenio <> 3) or ((c.ie_tipo_convenio = 3 and ie_tipo_atendimento_w = 1) or (ie_separa_conta_setor_w = 'N'))) and ((nr_seq_pq_protocolo_w = 0) or (a.nr_seq_pq_protocolo = nr_seq_pq_protocolo_w)) order by a.nr_interno_conta;


BEGIN

varguiaatendimento_w := obter_param_usuario(67, 210, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, varguiaatendimento_w);

vartipoguiaregra_w := obter_param_usuario(67, 359, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, vartipoguiaregra_w);

begin
select	coalesce(max(nr_seq_protocolo), 0)
into STRICT	nr_seq_pq_protocolo_w
from	pq_procedimento
where	nr_sequencia	= nr_seq_pq_proc_p;
exception
	when others then
	begin
	nr_seq_pq_protocolo_w	:= 0;
	end;
end;

nr_interno_conta_w	:= 0;

select	coalesce(max(ie_tipo_atendimento),0),
		coalesce(max(nr_seq_episodio),0)
into STRICT	ie_tipo_atendimento_w,
		nr_seq_episodio_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_p;

/* obter estabelecimento */

cd_estabelecimento_w 		:= 0;
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_estabelecimento_p > 0)		 then
	cd_estabelecimento_w := cd_estabelecimento_p;
else
	begin
	select cd_estabelecimento
	into STRICT cd_estabelecimento_w
	from atendimento_paciente
	where nr_atendimento = nr_atendimento_p;
	exception
		when others then
			cd_estabelecimento_w := 0;
	end;
end if;

begin
select	dt_ref_valida,
	coalesce(obter_valor_conv_estab(cd_convenio, cd_estabelecimento_w, 'IE_SEPARA_CONTA'),'N')
ie_separa_conta,
	coalesce(ie_tipo_convenio,0)
into STRICT	dt_referencia_w,
	ie_separa_conta_w,
	ie_tipo_convenio_w
from	convenio
where	cd_convenio = cd_convenio_p;
exception
	when others then
		begin
		dt_referencia_w  	:= dt_periodo_final_w;
		ie_separa_conta_w	:= 'N';
		end;
end;

select	coalesce(max(ie_separa_conta_setor),'N'),
		coalesce(max(ie_agrupa_conta_case),'N')
into STRICT	ie_separa_conta_setor_w,
		ie_agrupa_conta_case_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_w;

/* Se o atendimento nao possui CASE deve seguir o processo normal */

if (nr_seq_episodio_w = 0) then
		ie_agrupa_conta_case_w	:= 'N';
end if;

select	coalesce(max(ie_grava_guia_conta),'N')	
into STRICT	ie_grava_guia_conta_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento 	= cd_estabelecimento_w;

select	coalesce(max(ie_conta_atual),'N')
into STRICT	ie_conta_atual_w
from	convenio_estabelecimento
where	cd_convenio		= Obter_Convenio_Atendimento(nr_atendimento_p)
and	cd_estabelecimento 	= cd_estabelecimento_w;

select	coalesce(max(ie_periodo_inicial_seg),'N')
into STRICT	ie_periodo_inicial_seg_w
from	convenio_estabelecimento
where	cd_convenio = cd_convenio_p
and	cd_estabelecimento = cd_estabelecimento_p;

select	coalesce(max(ie_tipo_fatur_tiss), 'N')
into STRICT	ie_tipo_fatur_tiss_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_p
and	cd_estabelecimento	= cd_estabelecimento_w;

if (ie_tipo_fatur_tiss_w = 'N') then
	ie_tipo_fatur_tiss_w	:= null;
end if;

if (varguiaatendimento_w = 'S') then
	select 	max(nr_doc_convenio)
	into STRICT	cd_autorizacao_conta_w
	from 	atend_categoria_convenio
	where 	nr_atendimento = nr_atendimento_p
	and 	cd_convenio = cd_convenio_p;
elsif (ie_grava_guia_conta_w	= 'S') then

	cd_autorizacao_conta_w	:= nr_doc_convenio_p;
end if;


/* identificar se ja existe conta aberta para o atendimento particular ou convenio */

ie_nova_conta_w 		:= 'S';

if (ie_agrupa_conta_case_w = 'N') then
	open c01;
			loop
			fetch c01 into
				dt_acerto_conta_w,
				nr_interno_conta_w,
				cd_convenio_calculo_w,
				cd_categoria_calculo_w,
				cd_autorizacao_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				RAISE NOTICE 'nr_interno_conta_w=%', nr_interno_conta_w;
				RAISE NOTICE 'ie_separa_conta_w=%', ie_separa_conta_w;
				RAISE NOTICE 'nr_doc_convenio_p=%', nr_doc_convenio_p;
				RAISE NOTICE 'cd_autorizacao_w=%', cd_autorizacao_w;
				RAISE NOTICE 'ie_separa_conta_w=%', ie_separa_conta_w;
				if (ie_separa_conta_w = 'N') then
					ie_nova_conta_w	:= 'N';
				end if;
				if (nr_doc_convenio_p	= cd_autorizacao_w) then
					ie_nova_conta_w	:= 'N';
				end if;
				
				if 	coalesce(nr_doc_convenio_p::text, '') = ''
					and (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') then

					select	coalesce(max(IE_GERAR_CTA_DIF_TISS), 'N') gerar_dif
					into STRICT 	IE_GERAR_CTA_DIF_TISS_w
					from	tiss_parametros_convenio
					where	cd_estabelecimento	= cd_estabelecimento_w
					and	cd_convenio		= cd_convenio_p;

					if (IE_GERAR_CTA_DIF_TISS_w = 'S') then
						ie_nova_conta_w	:= 'N';
					end if;

				end if;

				if (coalesce(nr_doc_convenio_p::text, '') = '') and
					((cd_autorizacao_w	= wheb_mensagem_pck.get_texto(305913)) or (cd_autorizacao_w	= 'N?o Informada') or (cd_autorizacao_w	= wheb_mensagem_pck.get_texto(305913,null))) then
					ie_nova_conta_w	:= 'N';
				end if;

				if (coalesce(nr_doc_convenio_p::text, '') = '') and (coalesce(cd_autorizacao_w::text, '') = '') then
					ie_nova_conta_w	:= 'N';
				end if;
				RAISE NOTICE 'ie_nova_conta_w=%', ie_nova_conta_w;
				if (ie_nova_conta_w = 'N') then
					exit;
				end if;
				end;
		end loop;
	close c01;
else
	open c03;
		loop
      	fetch c03 into
			dt_acerto_conta_w,
			nr_interno_conta_w,
			cd_convenio_calculo_w,
			cd_categoria_calculo_w,
			cd_autorizacao_w;
        	EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			RAISE NOTICE 'nr_interno_conta_w=%', nr_interno_conta_w;
			RAISE NOTICE 'ie_separa_conta_w=%', ie_separa_conta_w;
			RAISE NOTICE 'nr_doc_convenio_p=%', nr_doc_convenio_p;
			RAISE NOTICE 'cd_autorizacao_w=%', cd_autorizacao_w;
			RAISE NOTICE 'ie_separa_conta_w=%', ie_separa_conta_w;
			if (ie_separa_conta_w = 'N') then
				ie_nova_conta_w	:= 'N';
			end if;
			
			RAISE NOTICE 'ie_nova_conta_w=%', ie_nova_conta_w;
			if (ie_nova_conta_w = 'N') then
				exit;
			end if;
			end;
		end loop;
	close c03;
end if;

/* identificar se ja existe conta aberta para a conta sus bpa ou apac */

if (ie_tipo_atendimento_w		<> 1) and (ie_separa_conta_setor_w	= 'S') and (ie_tipo_convenio_w		= 3) then
	open c02;
	loop
	fetch c02 into
			dt_acerto_conta_w,
			nr_interno_conta_w,
			cd_convenio_calculo_w,
			cd_categoria_calculo_w,
			cd_autorizacao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			if (ie_separa_conta_w = 'N') then
				ie_nova_conta_w	:= 'N';
			end if;
			if (nr_doc_convenio_p	= cd_autorizacao_w) then
				ie_nova_conta_w	:= 'N';
			end if;
			if (coalesce(nr_doc_convenio_p::text, '') = '') and (coalesce(cd_autorizacao_w::text, '') = '') then
				ie_nova_conta_w	:= 'N';
			end if;
			if (ie_nova_conta_w = 'N') then
				exit;
			end if;
			end;
	end loop;
	close c02;
end if;

/* gerar nova conta */

if (ie_nova_conta_w = 'S') then
	begin
/* definir periodo da conta */

	dt_acerto_conta_w 	:= dt_atualizacao_w;

	select	coalesce(max(obter_valor_conv_estab(cd_convenio, cd_estabelecimento_p,
'QT_DIA_FIM_CONTA')), 0)
	into STRICT	qt_dia_fim_conta_w
	from	convenio
	where	cd_convenio	= cd_convenio_p;

	if (qt_dia_fim_conta_w = 0) then
		dt_periodo_inicial_w 	:= dt_entrada_p;
		
		if (ie_periodo_inicial_seg_w = 'X') then
		
			select 	coalesce(max(dt_periodo_final) + 1/86400, dt_entrada_p)
			into STRICT	dt_periodo_inicial_w
			from 	conta_paciente
			where 	nr_atendimento 		= nr_atendimento_p
			and	cd_convenio_parametro	= cd_convenio_p
			and	cd_estabelecimento	= cd_estabelecimento_p
			and	cd_categoria_parametro	= cd_categoria_p;
			
		end if;

	else
		select 	CASE WHEN ie_periodo_inicial_seg_w='S' THEN  coalesce(max(dt_periodo_final) + 1/86400, dt_entrada_p) WHEN ie_periodo_inicial_seg_w='X' THEN  coalesce(max(dt_periodo_final) + 1/86400, dt_entrada_p)  ELSE coalesce(max(dt_periodo_final), dt_entrada_p) END
		into STRICT	dt_periodo_inicial_w
		from 	conta_paciente
        where 	nr_atendimento 		= nr_atendimento_p
		and	cd_convenio_parametro	= cd_convenio_p
		and	cd_estabelecimento	= cd_estabelecimento_p
		and	cd_categoria_parametro	= cd_categoria_p
		and	((ie_separa_conta_w	= 'N') or (coalesce(nr_doc_convenio_p::text, '') = '')	
			or ( not exists (	SELECT	1
						from	conta_paciente_guia b
						where	b.nr_atendimento	= nr_atendimento_p
						and	b.cd_autorizacao	= nr_doc_convenio_p)));
	end if;

	select	count(*)
	into STRICT	qt_contas_partic_w
	from	conta_paciente
	where	cd_convenio_parametro 	= cd_convenio_p
	and	nr_atendimento 		= nr_atendimento_p
	and	ie_status_acerto 	= 1;
	
	
	if (ie_conta_atual_w = 'S') and (cd_convenio_p <> Obter_Convenio_Atendimento(nr_atendimento_p)) and (qt_contas_partic_w = 0) then
		dt_periodo_inicial_w := dt_conta_p;
		
	end if;
	
	
	begin
	select	obter_data_final_conta(dt_periodo_inicial_w, dt_alta_p, cd_convenio_p,
cd_estabelecimento_p)
	into STRICT	dt_periodo_final_w
	;
	exception
     		when others then
			begin
			dt_periodo_final_w	:= dt_periodo_inicial_w + 365;
			end;
	end;

	if (dt_periodo_final_w < clock_timestamp()) then
		dt_periodo_final_w:= clock_timestamp() + interval '365 days';
	end if;

/* gerar conta paciente */

	cd_convenio_calculo_w	:= cd_convenio_p;
	cd_categoria_calculo_w	:= cd_categoria_p;

	/* dsantos em 24/06/2009, OS149569 - para gravar o tipo do atendimento informado na EUP, na conta */

	select	max(ie_tipo_atendimento)
	into STRICT	ie_tipo_atend_conta_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;

	/*lhalves em 26/05/2010, OS218532 - Gravar tipo de guia da conta conforme regra. */
	
	if (coalesce(vartipoguiaregra_w,'N') in ('S','C')) then		
		select	max(ie_tipo_guia)
		into STRICT	ie_tipo_guia_w
		from 	tipo_guia_conta
		where 	ie_tipo_atendimento	= ie_tipo_atend_conta_w;	
	end if;
	
		select  get_atend_vat_category(nr_atendimento_p, cd_convenio_p, cd_categoria_p)
        into STRICT    nr_seq_categoria_iva_w
;

    	select 	nextval('conta_paciente_seq')
     	into STRICT 	nr_interno_conta_w
     	;

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
		vl_conta,
		vl_desconto,
		nr_seq_pq_protocolo,
		cd_autorizacao,
		ie_tipo_atend_conta,
		ie_tipo_fatur_tiss,
		ie_tipo_guia,
		nr_seq_categoria_iva)
	values (nr_atendimento_p,
            	dt_acerto_conta_w,
            	1,
            	dt_periodo_inicial_w,
            	dt_periodo_final_w,
            	dt_atualizacao_w,
            	'Tasy',
            	cd_convenio_p,
            	cd_categoria_p,
            	dt_referencia_w,
		dt_referencia_w,
		cd_convenio_p,
		cd_categoria_p,
		nr_interno_conta_w,
		cd_estabelecimento_w,
		'0', 0, 0, CASE WHEN nr_seq_pq_protocolo_w=0 THEN  null  ELSE nr_seq_pq_protocolo_w END ,
		cd_autorizacao_conta_w,
		ie_tipo_atend_conta_w,
		ie_tipo_fatur_tiss_w,
		ie_tipo_guia_w,
		nr_seq_categoria_iva_w);
				
	ds_log_w:= substr(dbms_utility.format_call_stack,1,1800);
		
	insert into conpaci_log(nr_sequencia,
		nr_interno_conta,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_periodo_inicial,
		dt_periodo_final,
		cd_convenio,
		cd_categoria,
		cd_estabelecimento,
		ds_log,
		ie_acao,
		cd_funcao,
		nr_atendimento,
		dt_mesano_referencia
		)
	values (nextval('conpaci_log_seq'),
		nr_interno_conta_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		dt_periodo_inicial_w,		
		dt_periodo_final_w,
		cd_convenio_p,
		cd_categoria_p,
		cd_estabelecimento_w,
		ds_log_w,
		'I',
		obter_funcao_ativa,
		nr_atendimento_p,
		dt_referencia_w);
			
	CALL GERAR_LANC_APOS_CONTA(nr_atendimento_p, null, 211, nm_usuario_p, null, null, null, null, null, nr_interno_conta_w);

/*     gerar conta paciente guia*/

	if (nr_doc_convenio_p IS NOT NULL AND nr_doc_convenio_p::text <> '') then
		insert into conta_paciente_guia(nr_interno_conta      	,
			cd_autorizacao 		,
			nr_seq_envio           	,
			nr_atendimento         	,
			dt_acerto_conta        	,
			ie_situacao_guia       	,
			vl_guia                	,
			dt_atualizacao         	,
			nm_usuario             	)
		values (nr_interno_conta_w,
			nr_doc_convenio_p,
			0,
			nr_atendimento_p,
            		dt_acerto_conta_w,
	            	'P',
        	    	0,
            		dt_atualizacao_w,
	            	'Tasy');
	end if;

/*	atualiza aih com a conta nos casos de sus */

	if (ie_tipo_convenio_w	= 3) 	and (ie_tipo_atendimento_w	= 1)	then
		begin
		update sus_aih
		set	 nr_interno_conta	= nr_interno_conta_w
		where	 nr_atendimento	= nr_atendimento_p
		and	 coalesce(nr_interno_conta::text, '') = '';
		exception
			when others then
			nr_interno_conta_w := nr_interno_conta_w;
		end;
	end if;

    	end;
end if;

if (coalesce(nr_seq_pq_protocolo_w,0) <> 0) then
	update	conta_paciente
	set	nr_seq_pq_protocolo	= nr_seq_pq_protocolo_w
	where	nr_interno_conta 	= nr_interno_conta_w;
end if;

dt_acerto_conta_p		:= dt_acerto_conta_w;
nr_interno_conta_p		:= nr_interno_conta_w;
cd_convenio_calculo_p	:= cd_convenio_calculo_w;
cd_categoria_calculo_p	:= cd_categoria_calculo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_conta_paciente ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, nm_usuario_p text, dt_conta_p timestamp, dt_entrada_p timestamp, dt_alta_p timestamp, nr_doc_convenio_p text, cd_setor_atendimento_p bigint, nr_seq_pq_proc_p bigint, dt_acerto_conta_p INOUT timestamp, nr_interno_conta_p INOUT bigint, cd_convenio_calculo_p INOUT bigint, cd_categoria_calculo_p INOUT text) FROM PUBLIC;
