-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_tipo_prest_gm ( tipo_prestador_p INOUT text, ie_tipo_p bigint, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_tipo_guia_p pls_tipo_guia_medico.nr_sequencia%type, nr_seq_plano_p pls_prestador_plano.nr_seq_plano%type, ie_origem_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


tipo_prestador_w	varchar(4000)	:= '';
nr_seq_tipo_prestador_w	varchar(10);
ie_insere_w		varchar(1)	:= 'S';
cd_estabelecimento_w	smallint;
contador_w		integer	:= 0;

C01 CURSOR FOR
	SELECT	distinct
		b.ds_tipo_prestador	ds_tipo_prestador,				-- CURSOR COPIADO DO CURSOR DA FUNCTION 'PLS_OBTER_DADOS_PRESTADOR'
		b.nr_sequencia		nr_seq_tp_prestador
	from	pls_tipo_prestador	b,
		pls_prestador_tipo	a
	where	a.nr_seq_tipo		= b.nr_sequencia
	and	a.nr_seq_prestador	= nr_seq_prestador_p
	and	b.cd_estabelecimento	= cd_estabelecimento_w
	and	clock_timestamp() between coalesce(a.dt_inicio_vigencia, clock_timestamp() - interval '1 days') and coalesce(a.dt_fim_vigencia, clock_timestamp() + interval '1 days')
	and	coalesce(b.ie_guia_medico_portal,'S') = 'S'
	and	coalesce(b.ie_situacao,'A')	= 'A';

C02 CURSOR FOR
	SELECT	distinct
		x.cd nr_seq_tp_prestador,
		substr(pls_obter_desc_tipo_prestador(x.cd),1,255) ds_tipo_prestador
	from (	SELECT	b.nr_seq_tipo cd
		from	pls_prestador_tipo	b,
			pls_tipo_prestador	a
		where	a.nr_sequencia		= b.nr_seq_tipo
		and	b.nr_seq_prestador	= nr_seq_prestador_p
		and	clock_timestamp() between coalesce(b.dt_inicio_vigencia, clock_timestamp() - interval '1 days') and coalesce(b.dt_fim_vigencia, clock_timestamp() + interval '1 days')
		and	coalesce(a.ie_guia_medico_portal,'S') = 'S'
		and	coalesce(a.ie_situacao,'A')	= 'A'
		
union

		select	b.nr_seq_tipo_prestador
		from	pls_prestador 		b,
			pls_tipo_prestador	a
		where	a.nr_sequencia		= b.nr_seq_tipo_prestador
		and	b.nr_sequencia 		= nr_seq_prestador_p
		and	coalesce(a.ie_guia_medico_portal,'S') = 'S'
		and	coalesce(a.ie_situacao,'A') = 'A') x
	where	exists (	select	1
			from	pls_prestador_plano a
			where	a.nr_seq_prestador = nr_seq_prestador_p
			and	a.nr_seq_plano = nr_seq_plano_p
			and (exists (	select	1
						from	pls_prest_plano_tipo_prest b
						where	b.nr_seq_prest_plano = a.nr_sequencia
						and	b.nr_seq_tipo = x.cd) or
				not exists (	select	1
						from	pls_prest_plano_tipo_prest b
						where	b.nr_seq_prest_plano = a.nr_sequencia)))
	order by 2;
BEGIN
if (ie_tipo_p = 1) then
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_p;

	select	max(a.nr_seq_tipo_prestador),
		max(b.ds_tipo_prestador)
	into STRICT	nr_seq_tipo_prestador_w,
		tipo_prestador_w
	from	pls_tipo_prestador 	b,
		pls_prestador 		a
	where	a.nr_seq_tipo_prestador	= b.nr_sequencia
	and	a.nr_sequencia 		= nr_seq_prestador_p
	and	coalesce(b.ie_guia_medico_portal,'S') = 'S'
	and	coalesce(b.ie_situacao,'A') = 'A';

	if (nr_seq_tipo_prestador_w IS NOT NULL AND nr_seq_tipo_prestador_w::text <> '') then
		if (nr_seq_tipo_guia_p IS NOT NULL AND nr_seq_tipo_guia_p::text <> '') then
			ie_insere_w := pls_obter_se_tp_pr_tipo_guia(nr_seq_tipo_guia_p, nr_seq_prestador_p, nr_seq_tipo_prestador_w, ie_origem_p);
		end if;
		if (ie_insere_w = 'S') and (tipo_prestador_w IS NOT NULL AND tipo_prestador_w::text <> '') then
			tipo_prestador_w := substr((tipo_prestador_w || ', '),1,4000);
		else
			tipo_prestador_w := '';
		end if;
		ie_insere_w := 'S';
	end if;

	for r_c01_w in C01() loop
		if (nr_seq_tipo_guia_p IS NOT NULL AND nr_seq_tipo_guia_p::text <> '') then
			ie_insere_w := pls_obter_se_tp_pr_tipo_guia(nr_seq_tipo_guia_p, nr_seq_prestador_p, r_c01_w.nr_seq_tp_prestador, ie_origem_p);
		end if;
		if (ie_insere_w = 'S') then
			tipo_prestador_w := substr((tipo_prestador_w || r_c01_w.ds_tipo_prestador || ', '),1,4000);
		end if;
	end loop;
elsif (ie_tipo_p = 2) then
	for r_c02_w in C02() loop
		if (nr_seq_tipo_guia_p IS NOT NULL AND nr_seq_tipo_guia_p::text <> '') then
			ie_insere_w := pls_obter_se_tp_pr_tipo_guia(nr_seq_tipo_guia_p, nr_seq_prestador_p, r_c02_w.nr_seq_tp_prestador, ie_origem_p);
		end if;
		if (ie_insere_w = 'S') then
			tipo_prestador_w := substr((tipo_prestador_w || r_c02_w.ds_tipo_prestador || ', '),1,4000);
		end if;
	end loop;
end if;

tipo_prestador_p := substr(tipo_prestador_w, 1, length(tipo_prestador_w) - 2);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_tipo_prest_gm ( tipo_prestador_p INOUT text, ie_tipo_p bigint, nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_tipo_guia_p pls_tipo_guia_medico.nr_sequencia%type, nr_seq_plano_p pls_prestador_plano.nr_seq_plano%type, ie_origem_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
