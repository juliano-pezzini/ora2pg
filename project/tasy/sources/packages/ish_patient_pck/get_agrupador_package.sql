-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_patient_pck.get_agrupador ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, patientno_p hcm_patienten.patientno%type, caseno_p hcm_fall.caseno%type, nr_agrupador_p INOUT bigint) AS $body$
DECLARE


cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
patientno_w		hcm_patienten.patientno%type;
caseno_w		hcm_fall.caseno%type;
nr_seq_episodio_w	atendimento_paciente.nr_seq_episodio%type;
cd_estabelecimento_w	atendimento_paciente.cd_estabelecimento%type;

ish_agrupador_w		ish_agrupador%rowtype;


BEGIN
cd_pessoa_fisica_w	:=	cd_pessoa_fisica_p;
patientno_w			:=	patientno_p;

begin
	select	ap.cd_estabelecimento,
			ap.nr_seq_episodio,
			ep.nr_episodio
	into STRICT	cd_estabelecimento_w,
			nr_seq_episodio_w,
			caseno_w
	from	atendimento_paciente ap,
			episodio_paciente ep
	where	ep.nr_sequencia		= ap.nr_seq_episodio
	and		ap.nr_atendimento	= nr_atendimento_p;
exception
when others then
	cd_estabelecimento_w	:= null;
	nr_seq_episodio_w		:= null;
	caseno_w				:= caseno_p;
end;

if (coalesce(cd_pessoa_fisica_w,'X') = 'X') or (coalesce(patientno_w,'X') = 'X') then
	begin
		begin
			select	pf.cd_pessoa_fisica
			into STRICT	cd_pessoa_fisica_w
			from	pessoa_fisica pf
			where	pf.cd_pessoa_fisica = cd_pessoa_fisica_w;
		exception when no_data_found then
			begin
				select	cd_pessoa_fisica
				into STRICT	cd_pessoa_fisica_w
				from	atendimento_paciente
				where	nr_atendimento = nr_atendimento_p;
			exception when no_data_found then
				begin
					select	patientno_w
					into STRICT	patientno_w
					from	hcm_fall
					where	caseno = caseno_w;
				exception when no_data_found then
					null;
				end;
			end;
		end;

		if (coalesce(cd_pessoa_fisica_w,'X') = 'X') then
			begin
				select	cd_pessoa_fisica
				into STRICT	cd_pessoa_fisica_w
				from	pf_codigo_externo
				where	cd_pessoa_fisica_externo = patientno_w
				and		cd_estabelecimento = cd_estabelecimento_w
				and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
			exception when no_data_found then
				null;
			end;
		end if;

		if (coalesce(patientno_w,'X') = 'X') then
			begin
				select	cd_pessoa_fisica_externo
				into STRICT	patientno_w
				from	pf_codigo_externo
				where	cd_pessoa_fisica = cd_pessoa_fisica_w
				and		cd_estabelecimento = cd_estabelecimento_w
				and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
			exception when no_data_found then
				null;
			end;
		end if;
	end;
end if;

if (coalesce(caseno_w,'X') <> 'X') or (coalesce(nr_seq_episodio_w, 0) <> 0) then
	begin
		begin
			select	*
			into STRICT	ish_agrupador_w
			from	ish_agrupador
			where	caseno = caseno_w;
		exception
		when others then
			null;
		end;

		if (coalesce(ish_agrupador_w.nr_sequencia::text, '') = '') then
			begin
				select	*
				into STRICT	ish_agrupador_w
				from	ish_agrupador
				where	nr_seq_episodio = nr_seq_episodio_w;
			exception
			when others then
				null;
			end;
		end if;

		if (coalesce(ish_agrupador_w.nr_sequencia::text, '') = '') then
			begin
				select	nextval('intpd_fila_transmissao_seq')
				into STRICT	nr_agrupador_p
				;

				select	nextval('ish_agrupador_seq')
				into STRICT	ish_agrupador_w.nr_sequencia
				;

				ish_agrupador_w.dt_atualizacao		:=	clock_timestamp();
				ish_agrupador_w.dt_atualizacao_nrec	:=	clock_timestamp();
				ish_agrupador_w.nm_usuario			:=	'Tasy';
				ish_agrupador_w.nm_usuario_nrec		:=	'Tasy';
				ish_agrupador_w.caseno				:=	caseno_w;
				ish_agrupador_w.nr_seq_episodio		:=	nr_seq_episodio_w;
				ish_agrupador_w.nr_agrupador		:=	nr_agrupador_p;			

				insert into ish_agrupador values (ish_agrupador_w.*);
			end;
		else
			begin
				ish_agrupador_w.caseno				:=	coalesce(ish_agrupador_w.caseno, caseno_w);
				ish_agrupador_w.nr_seq_episodio		:=	coalesce(ish_agrupador_w.nr_seq_episodio, nr_seq_episodio_w);	
				ish_agrupador_w.dt_atualizacao		:=	clock_timestamp();
				ish_agrupador_w.nm_usuario			:=	'Tasy';

				update	ish_agrupador
				set	row = ish_agrupador_w
				where	nr_sequencia = ish_agrupador_w.nr_sequencia;
			end;
		end if;

		nr_agrupador_p	:=	ish_agrupador_w.nr_agrupador;
	end;
elsif (coalesce(cd_pessoa_fisica_w,'X') <> 'X') or (coalesce(patientno_w,'X') <> 'X') then
	begin
		begin
			select	*
			into STRICT	ish_agrupador_w
			from	ish_agrupador
			where	patientno = patientno_w;
		exception
		when others then
			null;
		end;

		if (coalesce(ish_agrupador_w.nr_sequencia::text, '') = '') then
			begin
				select	*
				into STRICT	ish_agrupador_w
				from	ish_agrupador
				where	cd_pessoa_fisica = cd_pessoa_fisica_w;
			exception
			when others then
				null;
			end;
		end if;

		if (coalesce(ish_agrupador_w.nr_sequencia::text, '') = '') then
			begin
				select	nextval('intpd_fila_transmissao_seq')
				into STRICT	nr_agrupador_p
				;

				select	nextval('ish_agrupador_seq')
				into STRICT	ish_agrupador_w.nr_sequencia
				;

				ish_agrupador_w.dt_atualizacao		:=	clock_timestamp();
				ish_agrupador_w.dt_atualizacao_nrec	:=	clock_timestamp();
				ish_agrupador_w.nm_usuario			:=	'Tasy';
				ish_agrupador_w.nm_usuario_nrec		:=	'Tasy';
				ish_agrupador_w.cd_pessoa_fisica	:=	cd_pessoa_fisica_w;
				ish_agrupador_w.patientno			:=	patientno_w;
				ish_agrupador_w.nr_agrupador		:=	nr_agrupador_p;

				insert into ish_agrupador values (ish_agrupador_w.*);
			end;
		else
			begin
				ish_agrupador_w.cd_pessoa_fisica	:=	coalesce(ish_agrupador_w.cd_pessoa_fisica, cd_pessoa_fisica_w);
				ish_agrupador_w.patientno		:=	coalesce(ish_agrupador_w.patientno, patientno_w);
				ish_agrupador_w.dt_atualizacao		:=	clock_timestamp();
				ish_agrupador_w.nm_usuario		:=	'Tasy';

				update	ish_agrupador
				set	row = ish_agrupador_w
				where	nr_sequencia = ish_agrupador_w.nr_sequencia;
			end;
		end if;

		nr_agrupador_p	:=	ish_agrupador_w.nr_agrupador;
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_patient_pck.get_agrupador ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, patientno_p hcm_patienten.patientno%type, caseno_p hcm_fall.caseno%type, nr_agrupador_p INOUT bigint) FROM PUBLIC;