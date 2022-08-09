-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_conv_ultima_agenda_data (cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_convenio_p text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_plano_p INOUT text, cd_tipo_acomodacao_p INOUT bigint) AS $body$
DECLARE


dt_agenda_w			timestamp;
nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;
cd_convenio_w			integer;
cd_categoria_w		varchar(10);
cd_usuario_convenio_w	varchar(30);
dt_validade_w			timestamp;
nr_doc_convenio_w		varchar(20);
cd_tipo_acomodacao_w		smallint;
cd_plano_w		varchar(10);


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	/* obter ultimo agendamento */

	select	coalesce(max(b.nr_sequencia),0)
	into STRICT	nr_seq_agenda_w
	from	agenda a,
		agenda_paciente b
	where	a.cd_agenda = b.cd_agenda
	and	a.cd_tipo_agenda in (1,2)
	and	((ie_forma_convenio_p	= 'A') or (b.ie_status_agenda = 'E'))
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	trunc(hr_inicio) <= dt_agenda_p;

	/* obter convenio */

	if (nr_seq_agenda_w > 0) then
		select	cd_convenio,
			cd_categoria,
			cd_usuario_convenio,
			dt_validade_carteira,
			nr_doc_convenio,
			cd_tipo_acomodacao,
			cd_plano
		into STRICT	cd_convenio_w,
			cd_categoria_w,
			cd_usuario_convenio_w,
			dt_validade_w,
			nr_doc_convenio_w,
			cd_tipo_acomodacao_w,
			cd_plano_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_w;
	end if;	
end if;

cd_convenio_p			:= cd_convenio_w;
cd_categoria_p		:= cd_categoria_w;
cd_usuario_convenio_p	:= cd_usuario_convenio_w;
dt_validade_carteira_p	:= dt_validade_w;
nr_doc_convenio_p		:= nr_doc_convenio_w;
cd_tipo_acomodacao_p		:= cd_tipo_acomodacao_w;
cd_plano_p		:= cd_plano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_conv_ultima_agenda_data (cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_convenio_p text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_plano_p INOUT text, cd_tipo_acomodacao_p INOUT bigint) FROM PUBLIC;
