-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_benef_partic ( nr_seq_participante_p bigint, cd_pessoa_fisica_p text default null) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter a sequência do beneficiário do participante da Medicina Preventiva
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_captacao_w	mprev_captacao.nr_sequencia%type;
nr_seq_busca_emp_w	mprev_busca_empresarial.nr_sequencia%type;
nr_seq_demanda_espont_w mprev_demanda_espont.nr_sequencia%type;
nr_seq_indicacao_w	mprev_indicacao_paciente.nr_sequencia%type;


BEGIN

if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	mprev_participante a
	where	a.nr_sequencia	= nr_seq_participante_p;
else
	cd_pessoa_fisica_w	:= cd_pessoa_fisica_p;
end if;

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

	select 	max(a.nr_sequencia)
	into STRICT	nr_seq_captacao_w
	from  	mprev_captacao a
	where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	and 	a.ie_status = 'A' -- Aceito
	and exists ( 	SELECT	1
			from	mprev_participante x
			where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);

	if (coalesce(nr_seq_captacao_w::text, '') = '') then
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from  	mprev_captacao a
		where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	a.ie_status = 'T' -- Triagem
		and exists ( 	SELECT	1
				from	mprev_participante x
				where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
	end if;

	if (coalesce(nr_seq_captacao_w::text, '') = '') then
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from  	mprev_captacao a
		where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	a.ie_status = 'P' -- Pendente
		and exists ( 	SELECT	1
				from	mprev_participante x
				where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
	end if;

	if (coalesce(nr_seq_captacao_w::text, '') = '') then
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from  	mprev_captacao a
		where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	a.ie_status = 'N' -- Negada
		and exists ( 	SELECT	1
				from	mprev_participante x
				where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
	end if;

	if (coalesce(nr_seq_captacao_w::text, '') = '') then
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from  	mprev_captacao a
		where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	a.ie_status = 'R' -- Regeitada
		and exists ( 	SELECT	1
				from	mprev_participante x
				where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
	end if;

	if (coalesce(nr_seq_captacao_w::text, '') = '') then
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from  	mprev_captacao a
		where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	a.ie_status = 'C' -- Cancelada
		and exists ( 	SELECT	1
				from	mprev_participante x
				where 	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
	end if;

	if (nr_seq_captacao_w IS NOT NULL AND nr_seq_captacao_w::text <> '') then
		select 	max(nr_seq_busca_emp),
				max(nr_seq_demanda_espont),
				max(nr_seq_indicacao)
		into STRICT	nr_seq_busca_emp_w,
				nr_seq_demanda_espont_w,
				nr_seq_indicacao_w
		from 	mprev_captacao
		where 	nr_sequencia = nr_seq_captacao_w;

		if (nr_seq_busca_emp_w IS NOT NULL AND nr_seq_busca_emp_w::text <> '') then
			select	max(nr_seq_segurado)
			into STRICT	nr_seq_segurado_w
			from	mprev_busca_empresarial
			where	nr_sequencia = nr_seq_busca_emp_w;
		elsif (nr_seq_demanda_espont_w IS NOT NULL AND nr_seq_demanda_espont_w::text <> '') then
			select	max(nr_seq_segurado)
			into STRICT	nr_seq_segurado_w
			from	mprev_demanda_espont
			where	nr_sequencia = nr_seq_demanda_espont_w;
		elsif (nr_seq_indicacao_w IS NOT NULL AND nr_seq_indicacao_w::text <> '') then
			select	max(nr_seq_segurado)
			into STRICT	nr_seq_segurado_w
			from	mprev_indicacao_paciente
			where	nr_sequencia = nr_seq_indicacao_w;
		end if;
	end if;

	if (coalesce(nr_seq_segurado_w::text, '') = '') then

		select 	max(nr_sequencia)
		into STRICT	nr_seq_segurado_w
		from	pls_segurado a
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	dt_contratacao <= clock_timestamp()
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
		and	ie_tipo_segurado in ('B','R');

		if (coalesce(nr_seq_segurado_w::text, '') = '') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_segurado_w
			from	pls_segurado a
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	dt_contratacao <= clock_timestamp()
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()));
		end if;

		if (coalesce(nr_seq_segurado_w::text, '') = '') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_segurado_w
			from	pls_segurado a
			where	cd_pessoa_fisica = cd_pessoa_fisica_w;
		end if;

	end if;

end if;

return	nr_seq_segurado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_benef_partic ( nr_seq_participante_p bigint, cd_pessoa_fisica_p text default null) FROM PUBLIC;

