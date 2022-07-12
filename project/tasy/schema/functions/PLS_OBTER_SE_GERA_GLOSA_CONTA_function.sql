-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_gera_glosa_conta (cd_motivo_tiss_p text, nr_seq_prestador_p bigint, ie_evento_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar se uma glosa de conta médica deve ou não ser lançada

Importante: Chamar somente para conta médica e quando tratar nova glosa, sempre verificar
primeiro através desta.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_gera_glosa_w		varchar(1)	:= 'S';
nr_seq_motivo_glosa_w		bigint;
qt_registro_w		bigint;
qt_consistir_w		bigint;
nr_seq_outorgante_w	bigint;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
ie_ocorrencia_w		pls_controle_estab.ie_ocorrencia%type := 'N';


BEGIN
ie_ocorrencia_w := pls_obter_se_controle_estab('GO');
cd_estabelecimento_w := coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento);

if (cd_motivo_tiss_p IS NOT NULL AND cd_motivo_tiss_p::text <> '') then
	begin
	select	nr_sequencia
	into STRICT	nr_seq_motivo_glosa_w
	from	tiss_motivo_glosa
	where	cd_motivo_tiss	= cd_motivo_tiss_p
	and	coalesce(cd_convenio::text, '') = '';
	exception
	when others then
		nr_seq_motivo_glosa_w	:= 0;
	end;

	if (ie_evento_p = 'SCE') then
		/* Verificar se a glosa está vinculada a uma ocorrência do tipo "Glosa interna" */

		select	count(1)
		into STRICT	qt_registro_w
		from	pls_ocorrencia
		where	nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w
		and	ie_glosa		= 'S'
		and	ie_situacao		= 'A'  LIMIT 1;

		if (qt_registro_w	> 0) then

			if (ie_ocorrencia_w = 'N') then
				select	count(1)
				into STRICT	qt_consistir_w
				from	pls_glosa_evento 	b,
					tiss_motivo_glosa 	a
				where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
				and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
				and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
				and	b.ie_plano		= 'S'  LIMIT 1;
			else
				select	count(1)
				into STRICT	qt_consistir_w
				from	pls_glosa_evento 	b,
					tiss_motivo_glosa 	a
				where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
				and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
				and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
				and	b.ie_plano		= 'S'
				and	b.cd_estabelecimento	= cd_estabelecimento_w  LIMIT 1;
			end if;

			if (qt_consistir_w > 0) then
				ie_gera_glosa_w	:= 'S';
			else
				ie_gera_glosa_w	:= 'N';
			end if;
		end if;
	else
		begin
		if (ie_ocorrencia_w = 'N') then
			select  c.ie_consistir
			into STRICT	ie_gera_glosa_w
			from	pls_glosa_evento 	b,
				pls_outorgante_glosa	d,
				pls_prestador_glosa 	c,
				tiss_motivo_glosa 	a
			where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
			and	d.nr_sequencia		= c.nr_seq_outorg_glosa
			and	d.nr_seq_evento_glosa	= b.nr_sequencia
			and	c.nr_seq_prestador	= nr_seq_prestador_p
			and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
			and	a.nr_sequencia 		= nr_seq_motivo_glosa_w
			and	b.ie_plano		= 'S';
		else
			select  c.ie_consistir
			into STRICT	ie_gera_glosa_w
			from	pls_glosa_evento 	b,
				pls_outorgante_glosa	d,
				pls_prestador_glosa 	c,
				tiss_motivo_glosa 	a
			where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
			and	d.nr_sequencia		= c.nr_seq_outorg_glosa
			and	d.nr_seq_evento_glosa	= b.nr_sequencia
			and	c.nr_seq_prestador	= nr_seq_prestador_p
			and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
			and	a.nr_sequencia 		= nr_seq_motivo_glosa_w
			and	b.ie_plano		= 'S'
			and	b.cd_estabelecimento	= cd_estabelecimento_w;
		end if;
		exception
		when others then
			begin
			if (ie_ocorrencia_w = 'N') then
				select  d.ie_consistir
				into STRICT	ie_gera_glosa_w
				from	pls_glosa_evento 	b,
					pls_outorgante_glosa	d,
					tiss_motivo_glosa 	a
				where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
				and	d.nr_seq_evento_glosa 	= b.nr_sequencia
				and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
				and	d.nr_seq_outorgante	= nr_seq_outorgante_w
				and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
				and	b.ie_plano		= 'S';
			else
				select  d.ie_consistir
				into STRICT	ie_gera_glosa_w
				from	pls_glosa_evento 	b,
					pls_outorgante_glosa	d,
					tiss_motivo_glosa 	a
				where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
				and	d.nr_seq_evento_glosa 	= b.nr_sequencia
				and	((b.ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
				and	d.nr_seq_outorgante	= nr_seq_outorgante_w
				and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
				and	b.ie_plano		= 'S'
				and	b.cd_estabelecimento	= cd_estabelecimento_w;
			end if;
			exception
			when others then
				begin
				if (ie_ocorrencia_w = 'N') then
					select  'S'
					into STRICT	ie_gera_glosa_w
					from	pls_glosa_evento 	b,
						tiss_motivo_glosa 	a
					where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
					and	((ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
					and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
					and	b.ie_plano		= 'S';
				else
					select  'S'
					into STRICT	ie_gera_glosa_w
					from	pls_glosa_evento 	b,
						tiss_motivo_glosa 	a
					where	a.nr_sequencia 		= b.nr_seq_motivo_glosa
					and	((ie_evento		= ie_evento_p) or (ie_evento_p = 'SCE'))
					and	a.nr_sequencia	 	= nr_seq_motivo_glosa_w
					and	b.ie_plano		= 'S'
					and	b.cd_estabelecimento	= cd_estabelecimento_w;
				end if;
				exception
				when others then
					ie_gera_glosa_w 		:= 'N';
				end;
			end;
		end;

		if (coalesce(ie_gera_glosa_w::text, '') = '') then
			ie_gera_glosa_w	:= 'S';
		end if;
	end if;
end if;

return	ie_gera_glosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_gera_glosa_conta (cd_motivo_tiss_p text, nr_seq_prestador_p bigint, ie_evento_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type default null) FROM PUBLIC;
