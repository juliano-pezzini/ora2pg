-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_audit_report_pck.get_integration_record ( dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS SETOF T_INTEGRATION_RECORD AS $body$
DECLARE


r_integration_record_w		r_integration_record;
dt_inicio_w		timestamp;
dt_fim_w		timestamp;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.dt_atualizacao_nrec,
	b.ds_action,
	a.ie_evento,
	a.ie_status,
	a.nr_seq_documento,
	a.nr_seq_agrupador,
	a.nr_seq_dependencia,
	c.patientno,
	null caseno,
	c.nr_seq_segmento
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b,
	hcm_patienten c
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_seq_documento = to_char(c.nr_sequencia)
and	a.ie_evento = '81'
and	a.dt_atualizacao_nrec between dt_inicio_w and dt_fim_w
and	exists (	select	1
		from	intpd_sistemas x
		where	x.nr_sequencia = b.nr_seq_sistema
		and 	x.ds_login like 'philips_webs')

union all

select	a.nr_sequencia,
	a.dt_atualizacao_nrec,
	b.ds_action,
	a.ie_evento,
	a.ie_status,
	a.nr_seq_documento,
	a.nr_seq_agrupador,
	a.nr_seq_dependencia,
	null patientno,
	c.caseno,
	c.nr_seq_segmento
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b,
	hcm_fall c
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_seq_documento = to_char(c.nr_sequencia)
and	a.ie_evento in ('104', '108', '84', '105', '110', '117', '130', '119')
and	a.dt_atualizacao_nrec between dt_inicio_w and dt_fim_w
and	exists (	select	1
		from	intpd_sistemas x
		where	x.nr_sequencia = b.nr_seq_sistema
		and	x.ds_login like 'philips_webs')

union all

select	a.nr_sequencia,
	a.dt_atualizacao_nrec,
	b.ds_action,
	a.ie_evento,
	a.ie_status,
	a.nr_seq_documento,
	a.nr_seq_agrupador,
	a.nr_seq_dependencia,
	null patientno,
	null caseno,
	null nr_seq_segmento
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.ie_evento in ('119', '117', '131', '84', '104', '130', '108', '81', '105', '110', '114', '120', '135', '82', '106', '118', '12', '54')
and	a.dt_atualizacao_nrec between dt_inicio_w and dt_fim_w
and	exists (	select	1
		from	intpd_sistemas x
		where	x.nr_sequencia = b.nr_seq_sistema
		and	x.ds_login like 'philips_webs')
and	not exists (	select	1
		from	hcm_fall x
		where	a.nr_seq_documento = to_char(x.nr_sequencia))
and	not exists (	select	1
		from	hcm_patienten x
		where	a.nr_seq_documento = to_char(x.nr_sequencia))

union all

select	null nr_sequencia,
	c.dt_atualizacao_nrec,
	null ds_action,
	null ie_evento,
	null ie_status,
	null nr_seq_documento,
	null nr_seq_agrupador,
	null nr_seq_dependencia,
	c.patientno,
	null caseno,
	c.nr_seq_segmento
from	hcm_patienten c
where	not exists (	select	1
		from	intpd_fila_transmissao a,
			intpd_eventos_sistema b
		where	a.nr_seq_evento_sistema = b.nr_sequencia
		and	a.ie_evento = '81'
		and	a.nr_seq_documento = to_char(c.nr_sequencia))
and	c.dt_atualizacao_nrec between dt_inicio_w and dt_fim_w

union all

select	null nr_sequencia,
	c.dt_atualizacao_nrec,
	null ds_action,
	null ie_evento,
	null ie_status,
	null nr_seq_documento,
	null nr_seq_agrupador,
	null nr_seq_dependencia,
	null patientno,
	c.caseno,
	c.nr_seq_segmento
from	hcm_fall c
where	not exists (	select	1
		from	intpd_fila_transmissao a,
			intpd_eventos_sistema b
		where	a.nr_seq_evento_sistema = b.nr_sequencia
		and	a.ie_evento in ('104', '108', '84', '105', '110', '117', '130', '119')
		and	a.nr_seq_documento = to_char(c.nr_sequencia))
and	c.dt_atualizacao_nrec between dt_inicio_w and dt_fim_w;

c01_w			c01%rowtype;

patientno_w		hcm_patienten.patientno%type;
caseno_w		hcm_fall.caseno%type;

nr_seq_mensagem_w	hcm_message.nr_sequencia%type;
nr_seq_segmento_w	hcm_segmento.nr_sequencia%type;

nr_atendimento_w		atendimento_paciente.nr_atendimento%type;


BEGIN
dt_inicio_w		:=	trunc(coalesce(dt_inicio_p, clock_timestamp() - interval '3 days'),'dd');
dt_fim_w		:=	fim_dia(coalesce(dt_fim_p, clock_timestamp()));

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	r_integration_record_w.sapevent		:=	null;
	r_integration_record_w.nr_seq_episodio		:=	null;
	r_integration_record_w.nr_seq_episodio		:=	null;
	r_integration_record_w.ds_arquivo		:=	null;
	r_integration_record_w.sapevent		:=	null;
	r_integration_record_w.cd_pessoa_fisica	:=	null;
	r_integration_record_w.nr_seq_episodio		:=	null;

	patientno_w	:=	c01_w.patientno;
	caseno_w	:=	c01_w.caseno;

	if (c01_w.nr_seq_segmento IS NOT NULL AND c01_w.nr_seq_segmento::text <> '') then
		begin
		select	nr_seq_mensagem
		into STRICT	nr_seq_mensagem_w
		from	hcm_segmento
		where	nr_sequencia = c01_w.nr_seq_segmento;

		select	ds_arquivo
		into STRICT	r_integration_record_w.ds_arquivo
		from	hcm_message
		where	nr_sequencia = nr_seq_mensagem_w;

		select	nr_sequencia
		into STRICT	nr_seq_segmento_w
		from	hcm_segmento
		where	nr_seq_mensagem = nr_seq_mensagem_w
		and	ie_tipo = 'HEA';

		select	sapevent
		into STRICT	r_integration_record_w.sapevent
		from	hcm_kopf
		where	nr_seq_segmento = nr_seq_segmento_w;

		if (somente_numero(patientno_w) > 0) and (coalesce(somente_numero(caseno_w),0) = 0) then
			begin
			select	nr_sequencia
			into STRICT	nr_seq_segmento_w
			from	hcm_segmento
			where	nr_seq_mensagem = nr_seq_mensagem_w
			and	ie_tipo = 'FAL';

			select	caseno
			into STRICT	caseno_w
			from	hcm_fall
			where	nr_seq_segmento = nr_seq_segmento_w;
			exception
			when others then
				null;
			end;
		elsif (somente_numero(caseno_w) > 0) and (coalesce(somente_numero(patientno_w),0) = 0) then
			begin
			select	nr_sequencia
			into STRICT	nr_seq_segmento_w
			from	hcm_segmento
			where	nr_seq_mensagem = nr_seq_mensagem_w
			and	ie_tipo = 'PAT';

			select	patientno
			into STRICT	patientno_w
			from	hcm_patienten
			where	nr_seq_segmento = nr_seq_segmento_w;
			exception
			when others then
				null;
			end;
		end if;

		exception
		when others then
			r_integration_record_w.sapevent	:=	null;
		end;
	end if;

	begin
	if (c01_w.ie_evento = '12') then	/*'Send person'*/
		r_integration_record_w.cd_pessoa_fisica	:=	c01_w.nr_seq_documento;
	elsif (c01_w.ie_evento = '54') then	/*'Send patient procedure'*/
		select	b.nr_seq_episodio,
			b.cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	procedimento_paciente a,
			atendimento_paciente b
		where	a.nr_atendimento = b.nr_atendimento
		and	a.nr_sequencia = c01_w.nr_seq_documento;
	elsif (c01_w.ie_evento = '82') then	/*'Send diagnosis'*/
		begin
		nr_atendimento_w	:=	obter_valor_campo_separador(c01_w.nr_seq_documento, 1, '¬');

		select	a.nr_seq_episodio,
			a.cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	atendimento_paciente a
		where	a.nr_atendimento = nr_atendimento_w;
		end;
	elsif (c01_w.ie_evento in ('106','120')) then	/*'Send patients case / Send outpatient appointment'*/
		select	nr_sequencia,
			cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	episodio_paciente a
		where	a.nr_sequencia = c01_w.nr_seq_documento;
	elsif (c01_w.ie_evento = '114') then	/*'Send patient discharge'*/
		select	a.nr_seq_episodio,
			a.cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	atendimento_paciente a
		where	a.nr_atendimento = c01_w.nr_seq_documento;
	elsif (c01_w.ie_evento = '118') then	/*'Send patient movement'*/
		select	a.nr_seq_episodio,
			a.cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	atendimento_paciente a,
			atend_paciente_unidade b
		where	a.nr_atendimento  = b.nr_atendimento
		and	b.nr_seq_interno = c01_w.nr_seq_documento;
	elsif (c01_w.ie_evento = '135') then	/*'Send insurance data of patients care'*/
		select	b.nr_seq_episodio,
			b.cd_pessoa_fisica
		into STRICT	r_integration_record_w.nr_seq_episodio,
			r_integration_record_w.cd_pessoa_fisica
		from	atend_categoria_convenio a,
			atendimento_paciente b
		where	a.nr_atendimento = b.nr_atendimento
		and	a.nr_seq_interno = c01_w.nr_seq_documento;
	end if;
	exception
	when others then
		null;
	end;

	if (coalesce(r_integration_record_w.nr_seq_episodio::text, '') = '') then
		begin
		select	nr_sequencia
		into STRICT	r_integration_record_w.nr_seq_episodio
		from	episodio_paciente
		where	nr_episodio = caseno_w  LIMIT 1;
		exception
		when others then
			null;
		end;
	end if;

	if (coalesce(somente_numero(caseno_w),0) = 0) then
		begin
		select	nr_episodio
		into STRICT	caseno_w
		from	episodio_paciente
		where	nr_sequencia = r_integration_record_w.nr_seq_episodio;
		exception
		when others then
			null;
		end;
	end if;


	if (coalesce(r_integration_record_w.cd_pessoa_fisica::text, '') = '') then
		begin
		select	cd_pessoa_fisica
		into STRICT	r_integration_record_w.cd_pessoa_fisica
		from	pf_codigo_externo
		where	cd_pessoa_fisica_externo = patientno_w
		and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
		exception
		when others then
			begin
			select	cd_pessoa_fisica
			into STRICT	r_integration_record_w.cd_pessoa_fisica
			from	episodio_paciente
			where	nr_sequencia = r_integration_record_w.nr_seq_episodio;
			exception
			when others then
				null;
			end;
		end;
	end if;

	if (coalesce(somente_numero(patientno_w),0) = 0) then
		begin
		select	cd_pessoa_fisica_externo
		into STRICT	patientno_w
		from	pf_codigo_externo
		where	cd_pessoa_fisica = r_integration_record_w.cd_pessoa_fisica
		and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
		exception
		when others then
			null;
		end;
	end if;



	r_integration_record_w.patientno		:=	patientno_w;
	r_integration_record_w.caseno		:=	caseno_w;

	r_integration_record_w.nr_seq_fila		:=	c01_w.nr_sequencia;
	r_integration_record_w.dt_atualizacao		:=	c01_w.dt_atualizacao_nrec;
	r_integration_record_w.ds_action		:=	c01_w.ds_action;
	r_integration_record_w.ie_evento		:=	c01_w.ie_evento;
	r_integration_record_w.ds_evento		:=	substr(obter_valor_dominio_idioma(8187, c01_w.ie_evento, 5),1,255);
	r_integration_record_w.ie_status		:=	c01_w.ie_status;
	r_integration_record_w.nr_seq_documento	:=	c01_w.nr_seq_documento;
	r_integration_record_w.nr_seq_agrupador	:=	c01_w.nr_seq_agrupador;
	r_integration_record_w.nr_seq_dependencia	:=	c01_w.nr_seq_dependencia;
	r_integration_record_w.nr_seq_segmento	:=	c01_w.nr_seq_segmento;

	RETURN NEXT r_integration_record_w;
	end;
end loop;
close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ish_audit_report_pck.get_integration_record ( dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;
