-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ger_carga_pck.proc_impncir ( nr_seq_carga_p bigint, nr_sequencia_p bigint, ie_tipo_proc_p text) AS $body$
DECLARE


_ora2pg_r RECORD;
reg_proc_w			r_reg_proc;
atend_categoria_convenio_w	atend_categoria_convenio%rowtype;
pessoa_titular_convenio_w	pessoa_titular_convenio%rowtype;
pessoa_fisica_taxa_w		pessoa_fisica_taxa%rowtype;

ds_erro_w			varchar(4000);
dt_atualizacao_w		timestamp;
nm_usuario_w			varchar(15);
dt_atualizacao_nrec_w		timestamp;
nm_usuario_nrec_w		varchar(15);
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_episodio_w		episodio_paciente.nr_sequencia%type;
current_setting('ger_carga_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%TYPE		atendimento_paciente.nr_atendimento%type;
current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE			convenio.cd_convenio%type;
current_setting('ger_carga_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%TYPE		estabelecimento.cd_estabelecimento%type;
current_setting('ger_carga_pck.cd_categoria_w')::atend_categoria_convenio.cd_convenio%TYPE			categoria_convenio.cd_categoria%type;
falnr_w				impncir.falnr%type;

current_setting('ger_carga_pck.c01')::CURSOR CURSOR FOR
SELECT	*
from	impncir
where	nr_seq_carga 	= nr_seq_carga_p
and	nr_sequencia 	= coalesce(nr_sequencia_p, nr_sequencia)
and	((ie_status 	= 'V' and ie_tipo_proc_p = 'IMP') or (ie_status 	in ('L','E') and ie_tipo_proc_p = 'VAL'));

impncir_w		current_setting('ger_carga_pck.c01')::CURSOR%rowtype;


BEGIN

reg_proc_w.ie_tipo_proc	:=	ie_tipo_proc_p;

open current_setting('ger_carga_pck.c01')::CURSOR;
loop
fetch current_setting('ger_carga_pck.c01')::into CURSOR
	impncir_w;
EXIT WHEN NOT FOUND; /* apply on current_setting('ger_carga_pck.c01')::CURSOR */
	begin

	reg_proc_w := ger_carga_pck.set_carga_arq(reg_proc_w, impncir_w.nr_seq_carga_arq, impncir_w.nr_linha, impncir_w.nr_sequencia, 'S');
	CALL ger_carga_pck.atualizar_processamento('IMPNCIR',impncir_w.nr_sequencia);

	PERFORM set_config('ger_carga_pck.ie_update_w', null, false);
	PERFORM set_config('ger_carga_pck.cd_convenio_w', null, false);
	pessoa_fisica_taxa_w		:= null;
	PERFORM set_config('ger_carga_pck.cd_categoria_w', null, false);
	atend_categoria_convenio_w	:= null;
	reg_proc_w.nm_tabela		:= 'ATEND_CATEGORIA_CONVENIO';
	nm_usuario_w			:= reg_proc_w.usernametasy;
	dt_atualizacao_w		:= clock_timestamp();
	nm_usuario_nrec_w		:= reg_proc_w.usernametasy;
	dt_atualizacao_nrec_w		:= clock_timestamp();

	select	ltrim( impncir_w.falnr ,'0')
	into STRICT	falnr_w
	;

	begin
	select	a.cd_pessoa_fisica,
		a.nr_seq_episodio,
		a.nr_atendimento,
		a.cd_estabelecimento
	into STRICT	cd_pessoa_fisica_w,
		nr_seq_episodio_w,
		current_setting('ger_carga_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%TYPE,
		current_setting('ger_carga_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%TYPE
	from	atendimento_paciente a,
		episodio_paciente b
	where	a.nr_seq_episodio		= b.nr_sequencia
	and	b.nr_episodio			= falnr_w  LIMIT 1;
	exception
	when others then
		nr_seq_episodio_w	:= null;
		PERFORM set_config('ger_carga_pck.nr_atendimento_w', null, false);
	end;

	if (coalesce(nr_seq_episodio_w::text, '') = '') or (current_setting('ger_carga_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%coalesce(TYPE::text, '') = '') then
			reg_proc_w := ger_carga_pck.incluir_ger_carga_log_import(	reg_proc_w, '9', substr(	wheb_mensagem_pck.get_texto(736986,
							'DS_ELEMENTO=IMPNCIR' ||
							';DS_ATRIBUTO=FALNR'||
							';NR_SEQ_REGRA='|| reg_proc_w.nr_seq_regra_conv ||
							';NM_TABELA=EPISODIO_PACIENTE' ||
							';NM_ATRIBUTO=NR_EPISODIO' ||
							';DS_VALOR='|| impncir_w.falnr),1,4000));
	else

		if (impncir_w.patkz = 'X') then --Particular
			select	max(cd_convenio_partic),
				max(cd_categoria_partic)
			into STRICT	current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE,
				current_setting('ger_carga_pck.cd_categoria_w')::atend_categoria_convenio.cd_convenio%TYPE
			from	parametro_faturamento
			where	cd_estabelecimento = current_setting('ger_carga_pck.cd_estabelecimento_w')::estabelecimento.cd_estabelecimento%TYPE;

			if (current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%coalesce(TYPE::text, '') = '') then
				select	min(cd_convenio)
				into STRICT	current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE
				from	convenio
				where	ie_tipo_convenio = 1
				and	ie_situacao = 'A';
			end if;
		else
			begin
			select	cd_convenio
			into STRICT	current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE
			from	convenio
			where	cd_convenio	= impncir_w.KOSTR
			and	ie_situacao 	= 'A'  LIMIT 1;
			exception
			when others then
				begin
				select	cd_convenio
				into STRICT	current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE
				from	convenio
				where	ltrim(cd_cgc,'0') = ltrim(impncir_w.KOSTR,'0')
				and	ie_situacao 	= 'A'  LIMIT 1;
				exception
				when others then
					PERFORM set_config('ger_carga_pck.cd_convenio_w', null, false);
				end;
			end;

		end if;

		if (current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%coalesce(TYPE::text, '') = '') then
			SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'KOSTR', 'CD_CONVENIO', impncir_w.KOSTR, current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE := _ora2pg_r.ds_valor_retorno_p;
		end if;

		if (current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%(TYPE IS NOT NULL AND TYPE::text <> '')) then

			atend_categoria_convenio_w.dt_inicio_vigencia	:= to_date(impncir_w.verab||' 00:00:01',current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type||' hh24:mi:ss');
			atend_categoria_convenio_w.dt_final_vigencia	:= to_date(impncir_w.verbi||' 23:59:59',current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type||' hh24:mi:ss');

			begin
			select	*
			into STRICT	atend_categoria_convenio_w
			from	atend_categoria_convenio
			where	nr_atendimento	= current_setting('ger_carga_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%TYPE
			and	trunc(dt_inicio_vigencia,'dd') = trunc(atend_categoria_convenio_w.dt_inicio_vigencia,'dd')
			and	cd_convenio	= current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE  LIMIT 1;
			exception
			when others then
				atend_categoria_convenio_w.nr_seq_interno	:=	null;
			end;

			atend_categoria_convenio_w.dt_atualizacao	:= clock_timestamp();
			atend_categoria_convenio_w.nm_usuario		:= nm_usuario_w;
			atend_categoria_convenio_w.nr_atendimento	:= current_setting('ger_carga_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%TYPE;
			atend_categoria_convenio_w.cd_convenio		:= current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE;
			atend_categoria_convenio_w.cd_usuario_convenio	:= impncir_w.vernr;

			SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'VTRTY', 'CD_PLANO_CONVENIO', impncir_w.vtrty, atend_categoria_convenio_w.cd_plano_convenio) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; atend_categoria_convenio_w.cd_plano_convenio := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'MGART', 'IE_TIPO_CONVENIADO', impncir_w.mgart, atend_categoria_convenio_w.ie_tipo_conveniado) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; atend_categoria_convenio_w.ie_tipo_conveniado := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'RANGF', 'NR_PRIORIDADE', impncir_w.RANGF, atend_categoria_convenio_w.NR_PRIORIDADE) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; atend_categoria_convenio_w.NR_PRIORIDADE := _ora2pg_r.ds_valor_retorno_p;

			if (ie_tipo_proc_p = 'IMP') and (reg_proc_w.qt_reg_log = 0) and (coalesce(impncir_w.storn::text, '') = '') then
				begin
				if (atend_categoria_convenio_w.nr_seq_interno IS NOT NULL AND atend_categoria_convenio_w.nr_seq_interno::text <> '') then
					begin
					update	atend_categoria_convenio
					set	row = atend_categoria_convenio_w
					where	nr_seq_interno = atend_categoria_convenio_w.nr_seq_interno
					and	current_setting('ger_carga_pck.ie_atualizar_w')::varchar(1) = 'S';

					PERFORM set_config('ger_carga_pck.ie_update_w', 'S;', false);
					end;
				else
					begin
					if (current_setting('ger_carga_pck.cd_categoria_w')::atend_categoria_convenio.cd_convenio%coalesce(TYPE::text, '') = '') then
						select	max(cd_categoria)
						into STRICT	atend_categoria_convenio_w.cd_categoria
						from	categoria_convenio
						where	cd_convenio = current_setting('ger_carga_pck.cd_convenio_w')::atend_categoria_convenio.cd_convenio%TYPE
						and	ie_situacao = 'A';
					else
						atend_categoria_convenio_w.cd_categoria := current_setting('ger_carga_pck.cd_categoria_w')::atend_categoria_convenio.cd_convenio%TYPE;
					end if;

					select	nextval('atend_categoria_convenio_seq')
					into STRICT	atend_categoria_convenio_w.nr_seq_interno
					;

					insert into atend_categoria_convenio values (atend_categoria_convenio_w.*);

					CALL ish_rzv_insurance_pck.replicar_convenios_atend(nr_seq_episodio_w, atend_categoria_convenio_w.nr_atendimento, null);
					end;
				end if;

				begin
				select	nr_sequencia
				into STRICT	pessoa_fisica_taxa_w.nr_sequencia
				from	pessoa_fisica_taxa
				where	nr_atendimento	= atend_categoria_convenio_w.nr_atendimento
				and	nr_seq_atecaco	= atend_categoria_convenio_w.nr_seq_interno  LIMIT 1;
				exception
				when others then
					pessoa_fisica_taxa_w.nr_sequencia	:= null;
				end;

				if (coalesce(pessoa_fisica_taxa_w.nr_sequencia::text, '') = '') then

					reg_proc_w.nm_tabela 		:= 'PESSOA_FISICA_TAXA';
					SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'VTAGE', 'QT_DIAS_PAGAMENTO', impncir_w.VTAGE, pessoa_fisica_taxa_w.QT_DIAS_PAGAMENTO) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; pessoa_fisica_taxa_w.QT_DIAS_PAGAMENTO := _ora2pg_r.ds_valor_retorno_p;
					SELECT * FROM ger_carga_pck.proc_val( reg_proc_w, 'NZZGR', 'NR_SEQ_JUSTIFICATIVA', impncir_w.NZZGR, pessoa_fisica_taxa_w.NR_SEQ_JUSTIFICATIVA) INTO STRICT _ora2pg_r;
  reg_proc_w := _ora2pg_r.reg_proc_p; pessoa_fisica_taxa_w.NR_SEQ_JUSTIFICATIVA := _ora2pg_r.ds_valor_retorno_p;

					if (impncir_w.PFLZZ = 'X') then
						pessoa_fisica_taxa_w.ie_obriga_pag_adicional	:= 'S';
					end if;

					begin
					pessoa_fisica_taxa_w.dt_pagamento	:= to_date(impncir_w.VTDAT,current_setting('ger_carga_pck.ds_mascara_date_w')::ger_carga_arq.ds_mascara_date%type);
					exception
					when others then
						pessoa_fisica_taxa_w.dt_pagamento	:= null;
					end;

					select	nextval('pessoa_fisica_taxa_seq')
					into STRICT	pessoa_fisica_taxa_w.nr_sequencia
					;

					pessoa_fisica_taxa_w.dt_atualizacao		:= clock_timestamp();
					pessoa_fisica_taxa_w.nm_usuario			:= nm_usuario_w;
					pessoa_fisica_taxa_w.dt_atualizacao_nrec	:= clock_timestamp();
					pessoa_fisica_taxa_w.nm_usuario_nrec		:= nm_usuario_w;
					pessoa_fisica_taxa_w.cd_pessoa_fisica		:= cd_pessoa_fisica_w;
					pessoa_fisica_taxa_w.nr_atendimento		:= atend_categoria_convenio_w.nr_atendimento;
					pessoa_fisica_taxa_w.nr_seq_atecaco		:= atend_categoria_convenio_w.nr_seq_interno;

					insert into pessoa_fisica_taxa values (pessoa_fisica_taxa_w.*);
				end if;

				--grava a conversao
				CALL gerar_conv_meio_externo(null,
							'ATEND_CATEGORIA_CONVENIO',
							'NR_SEQ_INTERNO',
							atend_categoria_convenio_w.nr_seq_interno,
							substr( atend_categoria_convenio_w.nr_seq_interno|| current_setting('ger_carga_pck.ds_separador_w')::varchar(10) || lpad(impncir_w.lfdnr,3,'0') || current_setting('ger_carga_pck.ds_separador_w')::varchar(10) || lpad(impncir_w.rangf,2,'0') ,1,40),
							null,
							reg_proc_w.nr_seq_regra_conv,
							'A',
							nm_usuario_w);

				/* REMOVIDO POIS e FEITO PELA TRIGGER ATEND_CATEG_CONVENIO_INSERT
				begin
				select	*
				into	pessoa_titular_convenio_w
				from	pessoa_titular_convenio
				where	cd_pessoa_fisica = cd_pessoa_fisica_w
				and	cd_convenio = atend_categoria_convenio_w.cd_convenio
				and	cd_categoria = atend_categoria_convenio_w.cd_categoria
				and	dt_inicio_vigencia = atend_categoria_convenio_w.dt_inicio_vigencia;
				exception
				when others then
					pessoa_titular_convenio_w.nr_sequencia	:=	null;
				end;

				pessoa_titular_convenio_w.cd_pessoa_fisica		:=	cd_pessoa_fisica_w;
				pessoa_titular_convenio_w.cd_convenio			:=	atend_categoria_convenio_w.cd_convenio;
				pessoa_titular_convenio_w.cd_categoria			:=	atend_categoria_convenio_w.cd_categoria;
				pessoa_titular_convenio_w.dt_inicio_vigencia		:=	atend_categoria_convenio_w.dt_inicio_vigencia;
				pessoa_titular_convenio_w.dt_fim_vigencia		:=	atend_categoria_convenio_w.dt_final_vigencia;
				pessoa_titular_convenio_w.cd_usuario_convenio		:=	atend_categoria_convenio_w.cd_usuario_convenio;
				pessoa_titular_convenio_w.dt_atualizacao		:=	atend_categoria_convenio_w.dt_atualizacao;
				pessoa_titular_convenio_w.nm_usuario			:=	atend_categoria_convenio_w.nm_usuario;
				pessoa_titular_convenio_w.ie_tipo_conveniado		:= 	atend_categoria_convenio_w.ie_tipo_conveniado;

				if	(pessoa_titular_convenio_w.nr_sequencia is null) then
					begin
					select	pessoa_titular_convenio_seq.nextval
					into	pessoa_titular_convenio_w.nr_sequencia
					from	dual;

					insert into pessoa_titular_convenio values pessoa_titular_convenio_w;
					end;
				else
					begin
					update	pessoa_titular_convenio
					set	row = pessoa_titular_convenio_w
					where	nr_sequencia = pessoa_titular_convenio_w.nr_sequencia;
					end;
				end if; */
				end;
			end if;
		end if;
	end if;

	if (reg_proc_w.qt_reg_log > 0) then
		begin
		/*'Em caso de qualquer consistencia o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistencia'*/

		rollback;
		update	impncir
		set	ie_status 	= 'E',
			dt_fim_proc	= clock_timestamp()
		where	nr_sequencia 	= impncir_w.nr_sequencia;
		end;
	elsif (ie_tipo_proc_p = 'IMP') then
		update	impncir
		set	ie_status 	= 'I',
			ds_chave_tasy	= current_setting('ger_carga_pck.ie_update_w')::varchar(2)||atend_categoria_convenio_w.nr_seq_interno,
			dt_fim_proc	= clock_timestamp()
		where	nr_sequencia 	= impncir_w.nr_sequencia;
	else
		update	impncir
		set	ie_status 	= 'V',
			dt_fim_proc	= clock_timestamp()
		where	nr_sequencia 	= impncir_w.nr_sequencia;
	end if;
	exception
	when others then
		begin
		ds_erro_w := substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);

		rollback;

		reg_proc_w := ger_carga_pck.incluir_ger_carga_log_import(reg_proc_w, '4', ds_erro_w);

		update	impncir
		set	ie_status 	= 'E',
			dt_fim_proc	= clock_timestamp()
		where	nr_sequencia 	= impncir_w.nr_sequencia;
		end;
	end;

	commit;

end loop;
close current_setting('ger_carga_pck.c01')::CURSOR;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_carga_pck.proc_impncir ( nr_seq_carga_p bigint, nr_sequencia_p bigint, ie_tipo_proc_p text) FROM PUBLIC;
