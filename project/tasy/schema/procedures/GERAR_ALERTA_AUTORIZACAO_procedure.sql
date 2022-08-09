-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alerta_autorizacao ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_inicio_vigencia_w	timestamp;
dt_final_vigencia_w		timestamp;
ie_dia_util_autor_w		varchar(1)	:= 'N';
dt_antecipacao_w		timestamp;
cont_w			bigint;
qt_hora_antecedencia_w	bigint	:= 5;
cd_estabelecimento_w	smallint;
cd_convenio_atend_w	integer;
dt_retorno_dt_vigencia_w	timestamp;
ie_gerar_alerta_w		varchar(1)	:= 'N';
ds_alerta_w		varchar(2000);
ie_dados_ok_w		varchar(1)	:= 'S';
nr_seq_alerta_w		atendimento_alerta.nr_sequencia%type;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	begin
	select	b.cd_convenio,
		b.dt_final_vigencia,
		b.dt_inicio_vigencia,
		a.cd_estabelecimento
	into STRICT	cd_convenio_atend_w,
		dt_final_vigencia_w,
		dt_inicio_vigencia_w,
		cd_estabelecimento_w
	from	atend_categoria_convenio b,
		atendimento_paciente a
	where	a.nr_atendimento		= b.nr_atendimento
	and	b.nr_seq_interno		= obter_atecaco_atendimento(a.nr_atendimento)
	and	a.nr_atendimento		= nr_atendimento_p;
	exception
		when no_data_found then
		ie_dados_ok_w	:= 'N';
	end;

	select	coalesce(max(ie_dia_util_autor),'N')
	into STRICT	ie_dia_util_autor_w
	from	parametro_faturamento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	ie_dia_util_autor_w	:= 'N';

	if (ie_dia_util_autor_w = 'S') and (ie_dados_ok_w = 'S') then

		dt_antecipacao_w	:= dt_final_vigencia_w;

		if (dt_antecipacao_w IS NOT NULL AND dt_antecipacao_w::text <> '') then

			dt_antecipacao_w	:= dt_final_vigencia_w - qt_hora_antecedencia_w/24;

			while(obter_se_dia_util(dt_antecipacao_w,cd_estabelecimento_w) = 'N') loop
				dt_antecipacao_w	:= dt_antecipacao_w - 1;
			end loop;

			if (clock_timestamp() >= dt_antecipacao_w) then

				select	count(*)
				into STRICT	cont_w
				from	autorizacao_convenio a
				where	nr_atendimento	= nr_atendimento_p
				and	clock_timestamp()
					between obter_dia_util_anterior(cd_estabelecimento_w,coalesce(a.dt_inicio_vigencia,a.dt_autorizacao) - (qt_hora_antecedencia_w * 1/24))
					and coalesce(a.dt_fim_vigencia,to_date('31/12/2100','dd/mm/yyyy')) - (qt_hora_antecedencia_w * 1/24);

				if (cont_w = 0) then
								
					ie_gerar_alerta_w	:= 'S';
					dt_inicio_vigencia_w		:= coalesce(dt_final_vigencia_w ,dt_inicio_vigencia_w);

					dt_retorno_dt_vigencia_w := obter_fim_vigencia_autor(dt_inicio_vigencia_w, 1, cd_estabelecimento_w, cd_convenio_atend_w, 'U', dt_retorno_dt_vigencia_w);

					dt_inicio_vigencia_w	:= coalesce(dt_retorno_dt_vigencia_w, dt_inicio_vigencia_w);
				end if;
			end if;
		end if;
	elsif (ie_dados_ok_w = 'S') then
		select	count(*)
		into STRICT	cont_w
		from	autorizacao_convenio a
		where	nr_atendimento		= coalesce(nr_atendimento_p,0)
		and	clock_timestamp() between coalesce(a.dt_inicio_vigencia,a.dt_autorizacao) - (qt_hora_antecedencia_w * 1/24)  and
			coalesce(a.dt_fim_vigencia,to_date('31/12/2100','dd/mm/yyyy')) - (qt_hora_antecedencia_w * 1/24);

		if (cont_w = 0) and (dt_final_vigencia_w IS NOT NULL AND dt_final_vigencia_w::text <> '') and
			(((dt_final_vigencia_w - clock_timestamp()) * 24) <= qt_hora_antecedencia_w) then
				ie_gerar_alerta_w	:= 'S';
				dt_inicio_vigencia_w		:= coalesce(dt_final_vigencia_w ,dt_inicio_vigencia_w);

				dt_retorno_dt_vigencia_w := obter_fim_vigencia_autor(dt_inicio_vigencia_w, 1, cd_estabelecimento_w, cd_convenio_atend_w, 'U', dt_retorno_dt_vigencia_w);
				dt_inicio_vigencia_w	:= coalesce(dt_retorno_dt_vigencia_w, dt_inicio_vigencia_w);	

		end if;
	end if;

	if (ie_gerar_alerta_w = 'S') then
		
		ds_alerta_w	:= substr(wheb_mensagem_pck.get_texto(311200),1,2000);

		nr_seq_alerta_w := inserir_atendimento_alertas(nr_atendimento_p, ds_alerta_w, null, nm_usuario_p, null, nr_seq_alerta_w);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alerta_autorizacao ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
