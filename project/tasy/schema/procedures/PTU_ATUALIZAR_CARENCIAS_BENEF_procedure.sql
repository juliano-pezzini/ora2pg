-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualizar_carencias_benef (nr_seq_beneficiario_p ptu_beneficiario_carencia.nr_seq_beneficiario%type, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Atualizar as carências dos beneficiários importados com tipo "Alteração" no A100,
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_carencias_w		integer;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
ie_gerar_historico_w	boolean := false;

C01 CURSOR(	nr_seq_beneficiario_pc	pls_segurado.nr_sequencia%type) FOR
	SELECT	c.nr_sequencia nr_seq_carencia,
		a.dt_fim_carencia,
		c.dt_fim_vigencia
	from	pls_carencia			c,
		pls_tipo_carencia		b,
		ptu_beneficiario_carencia	a,
		ptu_intercambio_benef		d
	where	c.nr_seq_tipo_carencia 	= b.nr_sequencia
	and	b.ie_tipo_operacao	= 'I'
	and	b.cd_ptu 		= a.cd_tipo_cobertura
	and	c.nr_seq_segurado	= d.nr_seq_benef_encontrado
	and	d.nr_sequencia		= a.nr_seq_beneficiario
	and	d.nr_sequencia		= nr_seq_beneficiario_pc;

BEGIN
if (nr_seq_beneficiario_p IS NOT NULL AND nr_seq_beneficiario_p::text <> '') then
	select	count(1)
	into STRICT	qt_carencias_w
	
	where	exists (SELECT	1
			from	ptu_beneficiario_carencia
			where	nr_seq_beneficiario = nr_seq_beneficiario_p);

	select	x.nr_seq_benef_encontrado
	into STRICT	nr_seq_segurado_w
	from	ptu_intercambio_benef x
	where	x.nr_sequencia = nr_seq_beneficiario_p;

	/* Se o arquivo possui carências, verificar se deve atualizar informações das mesmas. */

	if (qt_carencias_w > 0) then
		select	count(1)
		into STRICT	qt_carencias_w
		from	pls_carencia			c,
			pls_tipo_carencia		b,
			ptu_beneficiario_carencia	a,
			ptu_intercambio_benef		d
		where	c.nr_seq_tipo_carencia 	= b.nr_sequencia
		and	b.ie_tipo_operacao	= 'I'
		and	b.cd_ptu 		= a.cd_tipo_cobertura
		and	c.nr_seq_segurado	= d.nr_seq_benef_encontrado
		and	d.nr_sequencia		= a.nr_seq_beneficiario
		and	d.nr_sequencia		= nr_seq_beneficiario_p;

		for r_c01_w in C01(nr_seq_beneficiario_p) loop
			/* Se o fim de carência do arquivo for diferente do fim de carência do beneficiário, atualiza a carência do beneficiário */

			if (coalesce(r_c01_w.dt_fim_vigencia, clock_timestamp()) <> coalesce(r_c01_w.dt_fim_carencia, clock_timestamp())) then
				update	pls_carencia
				set	dt_fim_vigencia = r_c01_w.dt_fim_carencia,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
				where	nr_sequencia 	= r_c01_w.nr_seq_carencia;

				ie_gerar_historico_w := true;
			end if;
		end loop;
	else
		/* Se o arquivo não possui carências,  isentar as carências do beneficiário */

		update	pls_carencia
		set	qt_dias			= 0,
			dt_fim_vigencia		= dt_inicio_vigencia,
			ds_observacao		= 'Carência isenta via arquivo A100.',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_segurado 	= nr_seq_segurado_w;

		ie_gerar_historico_w := true;
	end if;

	if (ie_gerar_historico_w) then
		CALL pls_gerar_segurado_historico(	nr_seq_segurado_w, '78', clock_timestamp(), 'Carência alterada via arquivo A100.',
						'ptu_atualizar_carencias_benef', null, null, null,
						null, null, null, null,
						null, null, null, null,
						nm_usuario_p, 'N');
	end if;
end if;

/* Sem commit. */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualizar_carencias_benef (nr_seq_beneficiario_p ptu_beneficiario_carencia.nr_seq_beneficiario%type, nm_usuario_p text) FROM PUBLIC;

