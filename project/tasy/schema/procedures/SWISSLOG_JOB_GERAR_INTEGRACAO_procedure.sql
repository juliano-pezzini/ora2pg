-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE swisslog_job_gerar_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_log_integracao_w		bigint;
ds_parametros_w			varchar(4000);
nr_seq_informacao_integracao_w	bigint;
nr_seq_mensagem_hl7_w		bigint;
nr_seq_hsl_sih_swisslog_w		bigint;
qt_registros_w			bigint;
ds_comando_w			varchar(1000);
c001				integer;
c002				integer;
retorno_w				integer;
vl_posicao1_w			integer;
vl_posicao2_w			integer;
vl_tamanho_w			integer;
nr_prescricao_w			prescr_medica.nr_prescricao%type;
nr_requisicao_w			requisicao_material.nr_requisicao%type;
nr_seq_w				bigint;
nr_seq_log_swisslog_w		log_swisslog.nr_sequencia%type;
ds_erro_w			varchar(4000);
qt_registros_ww		bigint;
ie_novo_registro_w	varchar(1);
ie_aprazamento_cancelar_w	varchar(1);


BEGIN
begin
/*ds_erro_w := substr(SQLERRM(sqlcode),1,2000);
insert into log_tasy values (sysdate, nm_usuario_p, -55, '1 SJGI - Ev='||nr_seq_evento_p||' | Parâmetros='||ds_parametros_p||' | Stack='||ds_erro_w);*/
-- Tratamento para impedir a geração duplicada da mensagem de prescrição, ao gerar a movimentação do paciente.
if (nr_seq_evento_p = 434) then
	select	instr(upper(ds_parametros_p),'NR_PRESCRICAO',1,1)
	into STRICT	vl_posicao1_w
	;

	if (vl_posicao1_w > 1) then
		select	instr(upper(ds_parametros_p),'#@#@',vl_posicao1_w,1)
		into STRICT	vl_posicao2_w
		;

		vl_posicao1_w := vl_posicao1_w + 14;
		vl_tamanho_w := vl_posicao2_w - vl_posicao1_w;

		select	somente_numero(substr(upper(ds_parametros_p),vl_posicao1_w,vl_tamanho_w))
		into STRICT	nr_seq_w
		;

		select	coalesce(max(1),0)
		into STRICT	vl_tamanho_w
		from	w_swisslog_mensagem
		where	nr_prescricao = nr_seq_w;

		-- Se existe a prescrição na tabela a execução é lançada para o final da rotina.
		if (vl_tamanho_w = 1) then

			-- Se for lote de aprazamento, vai gerar mensagem mesmo que o lote já esteja na tabela.
			select	instr(upper(ds_parametros_p),'AIP',1,1)
			into STRICT	vl_posicao1_w
			;

			-- Se for lote de aprazamento, vai gerar mensagem mesmo que o lote já esteja na tabela.
			if (vl_posicao1_w = 0) then
				select	instr(upper(ds_parametros_p),'AIS',1,1)
				into STRICT	vl_posicao1_w
				;
			end if;

			-- Se for lote de reaprazamento, vai gerar mensagem mesmo que o lote já esteja na tabela.
			/*if	(vl_posicao1_w = 0) then
				select	instr(upper(ds_parametros_p),'GLAP',1,1)
				into	vl_posicao1_w
				from	dual;
			end if;*/
			if (vl_posicao1_w = 0) then
				goto Final;
			end if;
		end if;
	-- Na movimentação, o primeiro parâmetro é o número da prescrição. Por isso posição 1 entra nessa rotina e seta data na tabela w_swisslog_mensagem.
	elsif (vl_posicao1_w = 1) then
		select	instr(upper(ds_parametros_p),'#@#@',vl_posicao1_w,1)
		into STRICT	vl_posicao2_w
		;

		vl_posicao1_w := vl_posicao1_w + 14;
		vl_tamanho_w := vl_posicao2_w - vl_posicao1_w;

		select	somente_numero(substr(upper(ds_parametros_p),vl_posicao1_w,vl_tamanho_w))
		into STRICT	nr_seq_w
		;

		select	coalesce(max(1),0)
		into STRICT	vl_tamanho_w
		from	w_swisslog_mensagem
		where	nr_prescricao = nr_seq_w
		and	coalesce(dt_atualizacao::text, '') = '';

		if (vl_tamanho_w = 1) then
			update	w_swisslog_mensagem
			set	dt_atualizacao = clock_timestamp()
			where	nr_prescricao = nr_seq_w;
		end if;
	end if;
end if;

vl_posicao1_w := 0;
vl_posicao2_w := 0;
vl_tamanho_w := 0;
nr_seq_w := 0;

select  coalesce(max(nr_sequencia), 0),
	coalesce(max(nr_seq_mens_hl7), 0)
into STRICT	nr_seq_informacao_integracao_w,
	nr_seq_mensagem_hl7_w
from    informacao_integracao
where   nr_seq_sistema_destino = 85
and	nr_seq_evento = nr_seq_evento_p;

if (coalesce(nr_seq_informacao_integracao_w,0) > 0) then

	select  nextval('log_integracao_seq')
	into STRICT	nr_seq_log_integracao_w
	;

	insert 	into log_integracao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_sistema_origem,
		nr_seq_sistema_destino,
		ie_status,
		dt_geracao,
		dt_liberacao,
		dt_retorno,
		nr_seq_informacao)
	values (	nr_seq_log_integracao_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		null,
		'P',
		clock_timestamp(),
		null,
		null,
		nr_seq_informacao_integracao_w);

	CALL wheb_exportar_hl7_pck.exportar(nr_seq_mensagem_hl7_w, nr_seq_log_integracao_w, ds_parametros_p);

	select  substr(obter_select_concatenado_bv('select hsl_sih_swisslog_seq.nextval from dual','',''),1,10)
	into STRICT	nr_seq_hsl_sih_swisslog_w
	;

	if (coalesce(nr_seq_hsl_sih_swisslog_w,0) > 0) then
		begin
		--  Rotina para identificar número de prescrição/requisição informado junto ao parâmetro.
		select	instr(upper(ds_parametros_p),'NR_PRESCRICAO',1,1)
		into STRICT	vl_posicao1_w
		;

		if (vl_posicao1_w = 0) then
			select	instr(upper(ds_parametros_p),'NR_REQUISICAO',1,1)
			into STRICT	vl_posicao1_w
			;

			nr_requisicao_w := 1;
		end if;

		if (vl_posicao1_w > 0) then

			select	instr(upper(ds_parametros_p),'#@#@',vl_posicao1_w,1)
			into STRICT	vl_posicao2_w
			;

			vl_posicao1_w := vl_posicao1_w + 14;
			vl_tamanho_w := vl_posicao2_w - vl_posicao1_w;

			select	somente_numero(substr(upper(ds_parametros_p),vl_posicao1_w,vl_tamanho_w))
			into STRICT	nr_seq_w
			;

			if (coalesce(nr_requisicao_w,0) = 1) then
				nr_requisicao_w := nr_seq_w;
			else
				nr_prescricao_w := nr_seq_w;
			end if;
		end if;

		select	instr(upper(ds_parametros_p),'NR_PRESCRICAO',1,1)
		into STRICT	vl_posicao1_w
		;

		ie_aprazamento_cancelar_w := 'N';

		if (instr(upper(ds_parametros_p),'GPMH',1,1) = 0) or (instr(upper(ds_parametros_p),'MVP',1,1) > 0) then
			ie_aprazamento_cancelar_w := 'S';
		end if;

		ie_novo_registro_w := 'S';

		if (vl_posicao1_w > 0) and (ie_aprazamento_cancelar_w = 'N') then
			begin
			commit;
			select	obter_select_concatenado_bv('select count(1) from hsl_sih_swisslog where nr_prescricao = :nr_prescricao_w','nr_prescricao_w='||nr_prescricao_w||';',';')
			into STRICT	qt_registros_ww
			;

			if (qt_registros_ww > 0) then

				select	obter_select_concatenado_bv(' select nvl(max(nr_sequencia),0) from hsl_sih_swisslog where nr_prescricao = :nr_prescricao_w','nr_prescricao_w='||nr_prescricao_w||';',';')
				into STRICT	nr_seq_hsl_sih_swisslog_w
				;

				ie_novo_registro_w := 'N';
			end if;

			exception
			when others then
				ie_novo_registro_w := 'S';
			end;
		end if;

		if (ie_novo_registro_w = 'S') then

			ds_comando_w := ' insert into hsl_sih_swisslog (
					nr_sequencia,
					ordem_mensagem,
					versao_mensagem,
					dt_atualizacao,
					nm_usuario,
					nr_prescricao,
					nr_requisicao)
				  values(:nr_sequencia,
					:ordem_mensagem,
					''2.5'',
					sysdate,
					:nm_usuario,
					decode(nvl(:nr_prescricao,0),0,null,:nr_prescricao),
					decode(nvl(:nr_requisicao,0),0,null,:nr_requisicao)) ';

			c001 := dbms_sql.open_cursor;
			dbms_sql.parse(c001, ds_comando_w, dbms_sql.native);

			dbms_sql.bind_variable(c001, 'nr_sequencia', nr_seq_hsl_sih_swisslog_w);
			dbms_sql.bind_variable(c001, 'ordem_mensagem', nr_seq_hsl_sih_swisslog_w);
			dbms_sql.bind_variable(c001, 'nm_usuario', nm_usuario_p);
			dbms_sql.bind_variable(c001, 'nr_prescricao', nr_prescricao_w);
			dbms_sql.bind_variable(c001, 'nr_requisicao', nr_requisicao_w);

			retorno_w := dbms_sql.execute(c001);
			dbms_sql.close_cursor(c001);

			commit;

		end if;

		ds_comando_w := ' update hsl_sih_swisslog
				  set	 ds_mensagem = (
						select 	to_lob(ds_hl7)
						from 	log_integracao_hl7
						where   nr_seq_log = :nr_seq_log_integracao
						and	rownum <= 1)
				  where	 nr_sequencia = :nr_seq_hsl_sih_swisslog ';


		c002 := dbms_sql.open_cursor;
		dbms_sql.parse(c002, ds_comando_w, dbms_sql.native);
		dbms_sql.bind_variable(c002, 'nr_seq_hsl_sih_swisslog', nr_seq_hsl_sih_swisslog_w );
		dbms_sql.bind_variable(c002, 'nr_seq_log_integracao', nr_seq_log_integracao_w );
		retorno_w := dbms_sql.execute(c002);
		dbms_sql.close_cursor(c002);

		if (coalesce(nr_seq_hsl_sih_swisslog_w,0) > 0) then
			select	obter_select_concatenado_bv('select count(1) from hsl_sih_swisslog where nr_sequencia = :nr_seq_hsl_sih_swisslog_w','nr_seq_hsl_sih_swisslog_w='||nr_seq_hsl_sih_swisslog_w||';',';')
			into STRICT	qt_registros_w
			;

			if (qt_registros_w = 0) then
				select	coalesce(max(nr_sequencia),0)+1
				into STRICT	nr_seq_log_swisslog_w
				from	log_swisslog;

				insert into log_swisslog(nr_sequencia, dt_atualizacao, nm_usuario, nr_documento, ds_log)
				values (nr_seq_log_swisslog_w, clock_timestamp(), nm_usuario_p, coalesce(nr_prescricao_w, nr_requisicao_w),
					wheb_mensagem_pck.get_texto(800063) || chr(10) ||
					wheb_mensagem_pck.get_texto(790876, 'NR_SEQUENCIA='||nr_seq_hsl_sih_swisslog_w));
			end if;
		end if;
		exception
		when others then
			begin
			ds_erro_w	:= substr(sqlerrm,1,2000);

			select	coalesce(max(nr_sequencia),0)+1
			into STRICT	nr_seq_log_swisslog_w
			from	log_swisslog;

			insert into log_swisslog(nr_sequencia, dt_atualizacao, nm_usuario, ds_log)
			values (nr_seq_log_swisslog_w, clock_timestamp(), nm_usuario_p,
				substr(wheb_mensagem_pck.get_texto(800063) || ds_erro_w,1,4000));
			end;
		end;
	end if;
end if;

commit;

exception
when others then
	begin
	--gravar_log_cdi(45999, 'Erro job swisslog ' || substr(sqlerrm(sqlcode),1,1950), nm_usuario_p);
	--commit;
	null;
	end;
end;

<<Final>>
nr_seq_w := 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE swisslog_job_gerar_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, nm_usuario_p text) FROM PUBLIC;
