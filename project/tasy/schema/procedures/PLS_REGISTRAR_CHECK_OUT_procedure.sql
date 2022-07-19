-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_registrar_check_out ( nr_seq_atendimento_p pls_atendimento.nr_sequencia%type, cd_medico_p medico.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ds_retorno_p INOUT text) AS $body$
DECLARE



nm_medico_w			varchar(255);
nr_seq_tipo_historico_w		pls_tipo_historico_atend.nr_sequencia%type;
nr_seq_exec_cirurgica_w		varchar(255);
nr_seq_controle_w		pls_controle_biometria_med.nr_sequencia%type;
ie_check_out_w			varchar(1) := 'N';
ds_historico_w			varchar(4000);

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_exec_cirurg_bio,
		b.nr_sequencia nr_seq_cirurg_bio_partic,
		a.nr_seq_exec_cirurgica nr_seq_exec_cirurgica
	from	pls_exec_cirurg_biometria a,
		pls_exec_cirurg_bio_partic b,
		pls_exec_cirurgica_proc c
	where	b.nr_seq_exec_cirurg_bio	= a.nr_sequencia
	and	b.nr_seq_exec_cirurg_proc	= c.nr_sequencia
	and	c.ie_finalizado			= 'N'
	and	a.ie_situacao			= 'A'
	and	c.ie_situacao_item		in ('A', 'G')
	and	b.ie_status			= 'E'
	and	(a.dt_check_in IS NOT NULL AND a.dt_check_in::text <> '')
	and	coalesce(a.dt_check_out::text, '') = ''
	and	a.cd_medico			= cd_medico_p;

BEGIN

select	substr(obter_nome_medico(cd_medico_p,'N'),1,255)
into STRICT	nm_medico_w
;

for C01_w in C01 loop
	begin
		update	pls_exec_cirurg_biometria
		set	dt_check_out			= clock_timestamp(),
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_sequencia			= C01_w.nr_seq_exec_cirurg_bio;
		
		update	pls_exec_cirurg_bio_partic
		set	ie_status			= 'F',
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_sequencia			= C01_w.nr_seq_cirurg_bio_partic;

		CALL pls_execucao_cirurgica_pck.gerar_log_exec_cirurgica(	C01_w.nr_seq_exec_cirurgica,
									--Realizado o check-out do medico #@NM_MEDICO#@ na participacao #@NR_SEQ_CIRURG_BIO_PARTIC#@ atraves do atendimento (Call Center) n #@NR_SEQ_ATENDIMENTO#@
									wheb_mensagem_pck.get_texto(1159387,'NM_MEDICO=' || nm_medico_w || ';' || 'NR_SEQ_CIRURG_BIO_PARTIC=' || C01_w.nr_seq_cirurg_bio_partic || ';' || 'NR_SEQ_ATENDIMENTO=' || nr_seq_atendimento_p),
									cd_estabelecimento_p,
									nm_usuario_p);

		nr_seq_exec_cirurgica_w	:= nr_seq_exec_cirurgica_w || C01_w.nr_seq_exec_cirurgica || ', ';
		ie_check_out_w	:= 'S';
	end;
end loop;


if (nr_seq_exec_cirurgica_w IS NOT NULL AND nr_seq_exec_cirurgica_w::text <> '') then
	--Realizado o check-out do medico #@NM_MEDICO#@ na(s) seguinte(s) execucoes cirurgicas:  #@NR_SEQ_EXEC_CIRURGICA#@ atraves do atendimento (Call Center) n #@NR_SEQ_ATENDIMENTO#@
	ds_historico_w		:= wheb_mensagem_pck.get_texto(1159382,'NM_MEDICO=' || nm_medico_w || ';' || 'NR_SEQ_EXEC_CIRURGICA=' || nr_seq_exec_cirurgica_w || ';' || 'NR_SEQ_ATENDIMENTO=' || nr_seq_atendimento_p);
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_controle_w
	from	pls_controle_biometria_med
	where	cd_medico	= cd_medico_p
	and	(dt_check_in IS NOT NULL AND dt_check_in::text <> '')
	and	coalesce(dt_check_out::text, '') = '';

	if (nr_seq_controle_w IS NOT NULL AND nr_seq_controle_w::text <> '') then
		--Realizado o check-out do medico #@NM_MEDICO#@ no consultorio.
		ds_historico_w		:= wheb_mensagem_pck.get_texto(1159385,'NM_MEDICO=' || nm_medico_w);

		ie_check_out_w	:= 'S';

		update	pls_controle_biometria_med
		set	dt_check_out	= clock_timestamp(),
			--Realizado o check-out do medico #@NM_MEDICO#@ atraves do atendimento (Call Center) n #@NR_SEQ_ATENDIMENTO#@
			ds_observacao	= wheb_mensagem_pck.get_texto(1159386,'NM_MEDICO=' || nm_medico_w || ';' || 'NR_SEQ_ATENDIMENTO=' || nr_seq_atendimento_p),
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_controle_w;
	end if;
end if;

if (ie_check_out_w = 'S') then
	if (pls_obter_se_controle_estab('GA') = 'S') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_tipo_historico_w
		from	pls_tipo_historico_atend
		where	ie_gerado_sistema	= 'S'
		and	ie_situacao		= 'A'
		and (cd_estabelecimento 	= cd_estabelecimento_p);
	else
		select	max(nr_sequencia)
		into STRICT	nr_seq_tipo_historico_w
		from	pls_tipo_historico_atend
		where	ie_gerado_sistema	= 'S'
		and	ie_situacao		= 'A';
	end if;

	if (coalesce(nr_seq_tipo_historico_w,0)	= 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(261833,'');
	end if;

	insert into pls_atendimento_historico(nr_sequencia, nr_seq_atendimento, ds_historico_long,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_seq_tipo_historico, dt_historico,
		ie_origem_historico, ie_gerado_sistema)	
	values (nextval('pls_atendimento_historico_seq'), nr_seq_atendimento_p, ds_historico_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, nr_seq_tipo_historico_w, clock_timestamp(),
		null, 'S');

	commit;

	ds_retorno_p	:= ds_historico_w;
else
	ds_retorno_p	:= obter_desc_expressao(1048362);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_registrar_check_out ( nr_seq_atendimento_p pls_atendimento.nr_sequencia%type, cd_medico_p medico.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ds_retorno_p INOUT text) FROM PUBLIC;

