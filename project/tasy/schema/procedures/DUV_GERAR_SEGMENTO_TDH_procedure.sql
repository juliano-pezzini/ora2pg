-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_tdh (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


nr_atendimento_w		bigint;
cd_evolucao_w			bigint;
nr_seq_laudo_w			bigint;
ds_sintoma_paciente_w		varchar(255);
ds_resultados_clinicos_w	varchar(3000);
ds_resultado_imagem_w		varchar(3000);
ds_impedimentos_w		varchar(3000);


BEGIN

begin
select	nr_atendimento,
	ds_sintoma_paciente
into STRICT	nr_atendimento_w,
	ds_sintoma_paciente_w
from	atendimento_paciente
where	nr_seq_episodio	= nr_seq_episodio_p  LIMIT 1;
exception
when others then
	nr_atendimento_w := null;
end;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

	--Evoluções
	begin
		select	cd_evolucao
		into STRICT	cd_evolucao_w
		from	evolucao_paciente
		where	nr_atendimento	= nr_atendimento_w
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	coalesce(dt_inativacao::text, '') = ''  LIMIT 1;

		select	substr(convert_long_to_varchar2('DS_EVOLUCAO', 'EVOLUCAO_PACIENTE', ' CD_EVOLUCAO = '|| cd_evolucao_w ),1,3000)
		into STRICT	ds_resultados_clinicos_w
		;

		ds_resultados_clinicos_w := duv_obter_texto_html(ds_resultados_clinicos_w);

	exception
	when others then
		ds_resultados_clinicos_w := null;
	end;

	--Exames não lab
	begin
		select	nr_sequencia
		into STRICT	nr_seq_laudo_w
		from	laudo_paciente
		where	nr_atendimento	= nr_atendimento_w
		and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '')
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')  LIMIT 1;

		select	substr(convert_long_to_varchar2('DS_LAUDO', 'LAUDO_PACIENTE', 'NR_SEQUENCIA = '|| nr_seq_laudo_w ),1,3000)
		into STRICT	ds_resultado_imagem_w
		;

		ds_resultado_imagem_w := duv_obter_texto_html(ds_resultado_imagem_w);
	exception
	when others then
		ds_resultado_imagem_w := null;
	end;

	--Doenças prévias e atuais
	begin
		select	substr(ds_observacao,1,3000)
		into STRICT	ds_impedimentos_w
		from	paciente_antec_clinico
		where	nr_atendimento	= nr_atendimento_w
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	coalesce(dt_inativacao::text, '') = ''  LIMIT 1;
	exception
	when others then
		ds_impedimentos_w := null;
	end;

end if;

--alguns campos estão como null, pois ainda não há definição dos campos onde estas informações serão preenchidas pelo usuário.
insert into duv_tdh(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_mensagem,
	ds_acidente,
	ds_resistencia,
	ds_resultados_clinicos,
	ds_resultado_imagem,
	ds_primeiros_socorros,
	ds_atencao_primaria,
	ds_impedimentos,
	ds_reclamacoes,
	ds_diagnostico_livre,
	ds_observacao)
values (nextval('duv_tdh_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_mensagem_p,
	ds_sintoma_paciente_w,
	null,
	ds_resultados_clinicos_w,
	ds_resultado_imagem_w,
	null,
	null,
	ds_impedimentos_w,
	null,
	null,
	null);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_tdh (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;

