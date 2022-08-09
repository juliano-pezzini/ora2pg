-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confirmar_treinamento_phi ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_plataforma_w		qms_treinamento.nr_seq_plataforma%type;
ie_exige_anexo_w		tre_plataformas.ie_exigir_anexo%type;
ds_arquivo_certificado_w	qms_treinamento.ds_arquivo_certificado%type;
cd_pessoa_fisica_w		qms_treinamento.cd_pessoa_fisica%type;
cd_gerente_pessoa_w		qms_treinamento.cd_gerente_pessoa%type;
nm_usuario_gerente_w		qms_treinamento.nm_usuario%type;
cd_cargo_w			qms_treinamento_cargo.nr_seq_cargo%type;
cd_responsavel_w qms_treinamento.cd_responsavel%type;
qt_treinamento_pend_w		bigint;
ie_gera_analise_w		varchar(1);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	select	nr_seq_plataforma,
		ds_arquivo_certificado,
		cd_pessoa_fisica,
		cd_gerente_pessoa,
		coalesce(obter_usuario_pessoa(cd_gerente_pessoa),nm_usuario_p),
		cd_responsavel
	into STRICT	nr_seq_plataforma_w,
		ds_arquivo_certificado_w,
		cd_pessoa_fisica_w,
		cd_gerente_pessoa_w,
		nm_usuario_gerente_w,
		cd_responsavel_w
	from	qms_treinamento
	where	nr_sequencia = nr_sequencia_p;

	if (nr_seq_plataforma_w IS NOT NULL AND nr_seq_plataforma_w::text <> '') then

		select	coalesce(ie_exigir_anexo,'N')
		into STRICT	ie_exige_anexo_w
		from	tre_plataformas
		where	nr_sequencia = nr_seq_plataforma_w;

		if (ie_exige_anexo_w = 'S' and coalesce(ds_arquivo_certificado_w::text, '') = '') then
			--E obrigatorio anexar o certificado de conclusao para a plataforma de treinamento selecionada
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1037165);
		end if;

	end if;

	update	qms_treinamento
	set	dt_confirmacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;

	select	coalesce(max('S'), 'N')
	into STRICT	ie_gera_analise_w
	from	qms_treinamento
	where	nr_sequencia = nr_sequencia_p
	and	coalesce(ie_situacao, 'A') = 'A'
	and	coalesce(ie_analise_eficacia, 'N') = 'N';

	select  count(*)
	into STRICT	qt_treinamento_pend_w
	from    qms_treinamento
	where   cd_pessoa_fisica = cd_pessoa_fisica_w
	and     coalesce(dt_confirmacao::text, '') = ''
	and	coalesce(ie_situacao, 'A') = 'A'
	and     coalesce(ie_necessario,'S') = 'S';

	if (qt_treinamento_pend_w = 0) then
		begin

		select  max(nr_seq_cargo)
		into STRICT    cd_cargo_w
		from    qms_treinamento_cargo
		where   ds_treinamento like '%Effectiveness%';

		if (ie_gera_analise_w = 'S') then
			CALL phi_gerar_analise_eficacia(	nm_usuario_p		=> nm_usuario_p,
							cd_gerente_p		=> cd_gerente_pessoa_w,
							cd_pessoa_eficacia_p	=> cd_pessoa_fisica_w,
							cd_cargo_p		=> cd_cargo_w);
		end if;
		end;
	end if;


	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confirmar_treinamento_phi ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
